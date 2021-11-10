import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/services/utils.dart';

enum AuthState { unauthed, authed, registering, validating, error, unknown }

class AuthedUser {
  String id;
  bool hasOnboarded;
  String streamChatToken;
  String streamFeedToken;

  AuthedUser(
      {required this.id,
      required this.hasOnboarded,
      required this.streamChatToken,
      required this.streamFeedToken});

  factory AuthedUser.fromJson(Map<String, dynamic> json) {
    return AuthedUser(
        id: json['id'] as String,
        hasOnboarded: json['hasOnboarded'] as bool,
        streamChatToken: json['streamChatToken'] as String,
        streamFeedToken: json['streamFeedToken'] as String);
  }
}

/// Only ever register this as a global singleton via Get.It. Do not instantiate multiple times.
class AuthBloc {
  final FirebaseAuth _firebaseClient = FirebaseAuth.instance;
  bool _firebaseAuthed = false;
  AuthedUser? _authedUser;
  int _validationAttempts = 0;
  final int _maxFailedAttempts = 10;

  AuthBloc() {
    _firebaseClient.authStateChanges().listen((User? user) async {
      if (user?.uid != null) {
        _firebaseAuthed = true;
        if (_authedUser?.id == null) {
          if (![AuthState.registering, AuthState.validating]
              .contains(authState.value)) {
            await validateUserAgainstFirebaseUid();
          }
        }
      } else {
        _firebaseAuthed = false;
        _authedUser = null;
        authState.value = AuthState.unauthed;
      }
    });
  }

  AuthedUser? get authedUser => _authedUser;

  ValueNotifier<AuthState> authState = ValueNotifier(AuthState.unknown);

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      authState.value = AuthState.registering;
      final UserCredential user = await _firebaseClient
          .createUserWithEmailAndPassword(email: email, password: password);

      if (user.user?.uid != null) {
        final token = await getIdToken();
        final endpoint = EnvironmentConfig.getRestApiEndpoint('user/register');

        final res = await http.post(
          endpoint,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        );

        final String body = res.body;
        final Map<String, dynamic> json =
            jsonDecode(body) as Map<String, dynamic>;

        if (json['id'] != null) {
          _authedUser = AuthedUser.fromJson(json);
        } else {
          printLog(
              'No valid user ID was returned when trying to register a new user.');
          _authedUser = null;
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
    authState.value = AuthState.validating;
    final token = await getIdToken();
    final endpoint = EnvironmentConfig.getRestApiEndpoint('user/current');

    final res = await http.post(
      endpoint,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    final String body = res.body;
    final Map<String, dynamic> json = jsonDecode(body) as Map<String, dynamic>;

    if (json['id'] != null) {
      _authedUser = AuthedUser.fromJson(json);
      await _checkAuthStatus();
    } else {
      printLog('No valid user ID was returned when trying to validate user.');
      _authedUser = null;
      await signOut();
    }
  }

  Future<void> _checkAuthStatus() async {
    if (_validationAttempts > _maxFailedAttempts) {
      printLog('Too many failed attempts to validate the user. Signing out.');
      await signOut();
      _validationAttempts = 0;
    } else if (_firebaseAuthed && _authedUser?.id != null) {
      authState.value = AuthState.authed;
      _validationAttempts = 0;
    } else if (!_firebaseAuthed && _authedUser?.id == null) {
      authState.value = AuthState.unauthed;
      _validationAttempts = 0;
    } else if (_firebaseAuthed && _authedUser?.id == null) {
      // Try and validate the user based on the firebase auth, if not already.
      if (![AuthState.registering, AuthState.validating]
          .contains(authState.value)) {
        authState.value = AuthState.validating;
        _validationAttempts++;
        await validateUserAgainstFirebaseUid();
      }
    } else if (!_firebaseAuthed && _authedUser?.id != null) {
      printLog(
          'Should not be possible for an AuthUser to be present when firebase is not authed. Signing out.');
      await signOut();
      _validationAttempts = 0;
    }
  }

  void dispose() {
    authState.dispose();
  }
}
