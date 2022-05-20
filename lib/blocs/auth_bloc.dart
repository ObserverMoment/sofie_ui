import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/services/utils.dart';

enum InternalAuthState {
  unauthed,
  authed,
  registering,
  validating,
  error,
  unknown
}

enum AuthState { unauthed, authed, loading }

class AuthedUser {
  String id;
  String streamChatToken;
  String streamFeedToken;

  AuthedUser(
      {required this.id,
      required this.streamChatToken,
      required this.streamFeedToken});

  factory AuthedUser.fromJson(Map<String, dynamic> json) {
    return AuthedUser(
        id: json['id'] as String,
        streamChatToken: json['streamChatToken'] as String,
        streamFeedToken: json['streamFeedToken'] as String);
  }
}

/// Only ever register this as a global singleton via Get.It. Do not instantiate multiple times.
class AuthBloc extends ChangeNotifier {
  final FirebaseAuth _firebaseClient = FirebaseAuth.instance;
  bool _firebaseAuthed = false;
  AuthedUser? authedUser;
  InternalAuthState internalState = InternalAuthState.unknown;
  AuthState authState = AuthState.loading;
  int _validationAttempts = 0;
  final int _maxFailedAttempts = 10;

  AuthBloc() {
    _firebaseClient.authStateChanges().listen((User? user) async {
      if (user?.uid != null) {
        _firebaseAuthed = true;
        if (authedUser?.id == null) {
          if (![InternalAuthState.registering, InternalAuthState.validating]
              .contains(internalState)) {
            await validateUserAgainstFirebaseUid();
          }
        } else {
          _checkAuthStatus();
        }
      } else {
        _firebaseAuthed = false;
        authedUser = null;
        internalState = InternalAuthState.unauthed;
        authState = AuthState.unauthed;
        _checkAuthStatus();
      }
    });
  }

  Future<void> registerWithEmailAndPassword(
      String displayName, String email, String password) async {
    try {
      internalState = InternalAuthState.registering;
      final UserCredential user = await _firebaseClient
          .createUserWithEmailAndPassword(email: email, password: password);

      if (user.user?.uid != null) {
        final token = await getIdToken();
        final endpoint = EnvironmentConfig.getRestApiEndpoint('user/register');

        // https://docs.flutter.dev/cookbook/networking/send-data
        final res = await http.post(endpoint,
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({'name': displayName}));

        final String body = res.body;
        final Map<String, dynamic> json =
            jsonDecode(body) as Map<String, dynamic>;

        if (json['id'] != null) {
          authedUser = AuthedUser.fromJson(json);
        } else {
          printLog(
              'No valid user ID was returned when trying to register a new user.');
          authedUser = null;
          throw Exception('Sorry, there was an issue registering.');
        }
      } else {
        printLog(
            'user?.uid was null - no user was returned by registerWithEmailAndPassword');
        throw Exception('Sorry, there was an issue registering.');
      }
    } on FirebaseAuthException catch (e) {
      printLog(e.toString());
      throw Exception(e.message);
    } catch (e) {
      printLog(e.toString());
      throw Exception(e);
    } finally {
      await _checkAuthStatus();
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseClient.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      printLog(e.toString());
      throw Exception(e.message);
    } catch (e) {
      printLog(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      printLog(e.toString());
      throw Exception(e.message);
    } catch (e) {
      printLog(e.toString());
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseClient.signOut();
    } on FirebaseAuthException catch (e) {
      printLog(e.toString());
      throw Exception(e.message);
    } catch (e) {
      printLog(e.toString());
      throw Exception(e);
    }
  }

  Future<String> getIdToken() async {
    if (_firebaseClient.currentUser != null) {
      try {
        final String token =
            await _firebaseClient.currentUser!.getIdToken(true);
        return token;
      } on FirebaseAuthException catch (e) {
        printLog(e.toString());
        throw Exception(e.message);
      } catch (e) {
        printLog(e.toString());
        throw Exception(e);
      }
    } else {
      // Force sign out to clear any stale user data or tokens. Necessary?
      await _firebaseClient.signOut();
      throw AssertionError(
          'There is no currently authed user, so a token was not able to be retrieved.');
    }
  }

  Future<void> validateUserAgainstFirebaseUid() async {
    internalState = InternalAuthState.validating;
    final token = await getIdToken();
    final endpoint = EnvironmentConfig.getRestApiEndpoint('user/current');

    final res = await http.get(
      endpoint,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    final String body = res.body;
    final Map<String, dynamic> json = jsonDecode(body) as Map<String, dynamic>;

    if (json['id'] != null) {
      authedUser = AuthedUser.fromJson(json);
      await _checkAuthStatus();
    } else {
      printLog('No valid user ID was returned when trying to validate user.');
      authedUser = null;
      await signOut();
    }
  }

  Future<void> _checkAuthStatus() async {
    if (_validationAttempts > _maxFailedAttempts) {
      printLog('Too many failed attempts to validate the user. Signing out.');
      authState = AuthState.unauthed;
      await signOut();
      _validationAttempts = 0;
    } else if (_firebaseAuthed && authedUser?.id != null) {
      authState = AuthState.authed;
      _validationAttempts = 0;
    } else if (!_firebaseAuthed && authedUser?.id == null) {
      authState = AuthState.unauthed;
      _validationAttempts = 0;
    } else if (_firebaseAuthed && authedUser?.id == null) {
      // Try and validate the user based on the firebase auth, if not already.
      if (![InternalAuthState.registering, InternalAuthState.validating]
          .contains(internalState)) {
        _validationAttempts++;
        await validateUserAgainstFirebaseUid();
      }
    } else if (!_firebaseAuthed && authedUser?.id != null) {
      printLog(
          'Should not be possible for an AuthUser to be present when firebase is not authed. Signing out.');
      authState = AuthState.unauthed;
      await signOut();
      _validationAttempts = 0;
    }

    notifyListeners();
  }

  static Future<bool> displayNameAvailableCheck(String name) async {
    final endpoint = EnvironmentConfig.getRestApiEndpoint('user/name-check',
        params: {'name': name});

    final res = await http.get(endpoint);

    final String body = res.body;
    final Map<String, dynamic> json = jsonDecode(body) as Map<String, dynamic>;

    return json['isAvailable'];
  }
}
