import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/loading_spinners.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:sofie_ui/services/stream.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/stream_feed.dart' as feed;
import 'package:stream_feed/stream_feed.dart';
import 'package:uni_links/uni_links.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// https://github.com/Milad-Akarie/auto_route_library/issues/418
/// Creates and provides all the global objects required on a user is logged in.
class AuthedRoutesWrapperPage extends StatefulWidget {
  const AuthedRoutesWrapperPage({Key? key}) : super(key: key);

  @override
  AuthedRoutesWrapperPageState createState() => AuthedRoutesWrapperPageState();
}

class AuthedRoutesWrapperPageState extends State<AuthedRoutesWrapperPage> {
  late AuthedUser _authedUser;

  bool _coreAppDataInitialized = false;

  late chat.StreamChatClient _streamChatClient;
  bool _chatInitialized = false;

  late feed.StreamFeedClient _streamFeedClient;
  late NotificationFeed _notificationFeed;
  late Subscription _feedSubscription;
  bool _feedsInitialized = false;

  late StreamSubscription _linkStreamSub;
  bool _incomingLinkStreamInitialized = false;

  @override
  void initState() {
    super.initState();
    _authedUser = GetIt.I<AuthBloc>().authedUser!;
    _streamChatClient = _createStreamChatClient;
    _streamFeedClient = _createStreamFeedClient;

    asyncInit();
  }

  Future<void> asyncInit() async {
    await _initCoreAppData();
    await _connectUserToChat();
    await _initFeeds();
    await _handleIncomingLinks();
    setState(() {});

    /// Wait until after the [AutoRoute] component has built before checking for an initialUri
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialUri();
    });
  }

  Future<void> _initCoreAppData() async {
    /// Core app data such as equipment, moves, body areas and other non user generated content.
    await CoreDataRepo.initCoreData(context);

    final userProfileQuery = UserProfileQuery(
        variables: UserProfileArguments(userId: _authedUser.id));
    final userLoggedWorkoutsQuery = UserLoggedWorkoutsQuery();
    final announcementUpdatesQuery = AnnouncementUpdatesQuery();
    final welcomeTodoItemsQuery = WelcomeTodoItemsQuery();
    final userScheduledWorkoutsQuery = UserScheduledWorkoutsQuery();

    Future.wait([
      context.graphQLStore.query(query: userProfileQuery),

      /// Get all the user logs - then we can always use [storeFirst] for these queries in the app. Removing this and not changing in app queries to [storeAndNetwork] will result in a query list of a single log in the case that the user logs a workout BEFORE downloading their full list of logs.
      context.graphQLStore.query(query: userLoggedWorkoutsQuery),

      /// Get data required to display the Feed page that the user lands on.
      context.graphQLStore.query(query: announcementUpdatesQuery),
      context.graphQLStore.query(query: welcomeTodoItemsQuery),
      context.graphQLStore.query(query: userScheduledWorkoutsQuery),
    ]);

    _coreAppDataInitialized = true;
  }

  chat.StreamChatClient get _createStreamChatClient =>
      chat.StreamChatClient(EnvironmentConfig.getStreamPublicKey,
          logLevel: feed.Level.WARNING);

  feed.StreamFeedClient get _createStreamFeedClient => feed.StreamFeedClient(
        EnvironmentConfig.getStreamPublicKey,
        appId: EnvironmentConfig.getStreamAppId,
        logLevel: feed.Level.WARNING,
      );

  Future<void> _connectUserToChat() async {
    try {
      await _streamChatClient.connectUser(
        chat.User(id: _authedUser.id),
        _authedUser.streamChatToken,
      );

      _chatInitialized = true;
    } catch (e) {
      printLog(e.toString());
      context.showToast(message: e.toString());
      context.showToast(message: "Oops, couldn't initialize chat! $e");
    }
  }

  Future<void> _initFeeds() async {
    try {
      /// Set the user on the feed client.
      await _streamFeedClient.setUser(
          feed.User(id: _authedUser.id),
          feed.Token(
            _authedUser.streamFeedToken,
          ));

      /// Set up the notification feed.
      _notificationFeed = _streamFeedClient.notificationFeed(
          kUserNotificationName, _authedUser.id);

      _feedSubscription = await _notificationFeed.subscribe((message) {
        handleIncomingFeedNotifications(context, message);
      });

      _feedsInitialized = true;
    } catch (e) {
      printLog(e.toString());
      context.showToast(message: e.toString());
      context.showToast(message: "Oops, couldn't initialize notifications! $e");
    }
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  Future<void> _handleIncomingLinks() async {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _linkStreamSub = uriLinkStream.listen((Uri? uri) {
        printLog('Uni_links._handleIncomingLinks: Incoming');
        printLog(uri?.toString() ?? 'null link received');
        if (!mounted) return;

        if (uri != null) {
          _extractRouterPathNameAndPush(uri);
        }
      }, onError: (Object err) {
        if (!mounted) return;
        printLog('Uni_links._handleIncomingLinks: got err: $err');
      });
      _incomingLinkStreamInitialized = true;
    }
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await getInitialUri();
      if (uri == null) {
        printLog('Uni_links: no initial uri');
      } else {
        _extractRouterPathNameAndPush(uri);
      }
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
      printLog('Uni_links: falied to get initial uri');
    } on FormatException catch (err) {
      printLog('Uni_links: malformed initial uri');
      printLog(err.toString());
    }
  }

  void _extractRouterPathNameAndPush(Uri uri) {
    printLog('Extracting and pushing uri');
    printLog(uri.toString());
    context.navigateNamedTo(uri.toString().replaceFirst(kDeepLinkSchema, ''));
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _feedSubscription.cancel();
    // Cancel listening to incoming links.
    _linkStreamSub.cancel();

    await _streamChatClient.disconnectUser();
    await _streamChatClient.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _coreAppDataInitialized &&
            _chatInitialized &&
            _feedsInitialized &&
            _incomingLinkStreamInitialized
        ? chat.StreamChatCore(
            client: _streamChatClient,
            child: MultiProvider(
              providers: [
                Provider<feed.StreamFeedClient>.value(
                  value: _streamFeedClient,
                ),
                Provider<NotificationFeed>.value(
                  value: _notificationFeed,
                ),
              ],
              child: const AutoRouter(),
            ),
          )
        : const LoadingPage();
  }
}
