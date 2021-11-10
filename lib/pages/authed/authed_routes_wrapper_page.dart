import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/stream_feed.dart' as feed;
import 'package:stream_feed/stream_feed.dart';
import 'package:uni_links/uni_links.dart';

/// https://github.com/Milad-Akarie/auto_route_library/issues/418
/// Creates and provides all the global objects required on a user is logged in.
class AuthedRoutesWrapperPage extends StatefulWidget {
  const AuthedRoutesWrapperPage({Key? key}) : super(key: key);

  @override
  _AuthedRoutesWrapperPageState createState() =>
      _AuthedRoutesWrapperPageState();
}

class _AuthedRoutesWrapperPageState extends State<AuthedRoutesWrapperPage> {
  late AuthedUser _authedUser;
  late chat.StreamChatClient _streamChatClient;
  late chat.OwnUser _streamChatUser;
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
    _connectUserToChat().then((_) => _initFeeds().then((_) {
          /// Setup [uni_links]
          /// https://pub.dev/packages/uni_links
          _handleIncomingLinks();
        }));
  }

  chat.StreamChatClient get _createStreamChatClient =>
      chat.StreamChatClient(EnvironmentConfig.getStreamPublicKey,
          location: chat.Location.euWest, logLevel: feed.Level.WARNING);

  Future<void> _connectUserToChat() async {
    try {
      _streamChatUser = await _streamChatClient.connectUser(
        chat.User(id: _authedUser.id),
        _authedUser.streamChatToken,
      );

      /// Add the users device to Stream backend.
      /// https://getstream.io/chat/docs/sdk/flutter/guides/adding_push_notifications/#registering-a-device-at-stream-backend
      // FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      //   _streamChatClient.addDevice(token, PushProvider.firebase);
      // });

      setState(() {
        _chatInitialized = true;
      });
    } catch (e) {
      printLog(e.toString());
      context.showToast(message: e.toString());
      context.showToast(message: "Oops, couldn't initialize chat! $e");
    }
  }

  feed.StreamFeedClient get _createStreamFeedClient => feed.StreamFeedClient(
        EnvironmentConfig.getStreamPublicKey,
        appId: EnvironmentConfig.getStreamAppId,
        logLevel: feed.Level.WARNING,
        token: feed.Token(
          _authedUser.streamFeedToken,
        ),
      );

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

      _feedSubscription =
          await _notificationFeed.subscribe(_handleNotification);

      setState(() {
        _feedsInitialized = true;
      });
    } catch (e) {
      printLog(e.toString());
      context.showToast(message: e.toString());
      context.showToast(message: "Oops, couldn't initialize notifications! $e");
    }
  }

  Future<void> _handleNotification(feed.RealtimeMessage? message) async {
    final _message =
        message?.newActivities?[0].object?.data.toString() ?? 'No message';
    context.showNotification(
        title: 'Notification',
        onPressed: () => printLog('printLog a test'),
        message: _message);
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _linkStreamSub = uriLinkStream.listen((Uri? uri) {
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

  void _extractRouterPathNameAndPush(Uri uri) {
    /// Slash is required before the uri because we are above the top level authed routes router.
    context.navigateNamedTo(
        '/${uri.toString().replaceFirst(kDeepLinkSchema, '')}');
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
    return _chatInitialized &&
            _feedsInitialized &&
            _incomingLinkStreamInitialized
        ? MultiProvider(
            providers: [
              Provider<chat.StreamChatClient>.value(
                value: _streamChatClient,
              ),
              Provider<chat.OwnUser>.value(
                value: _streamChatUser,
              ),
              Provider<feed.StreamFeedClient>.value(
                value: _streamFeedClient,
              ),
              Provider<NotificationFeed>.value(
                value: _notificationFeed,
              ),
            ],
            child: const AutoRouter(),
          )
        : const _LoadingPage();
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
          SvgPicture.asset('assets/logos/sofie_logo.svg',
              width: 50, color: context.theme.primary),
          const SizedBox(height: 8),
          Text('Sofie',
              style: GoogleFonts.voces(
                fontSize: 40,
                color: context.theme.primary,
              )),
          const SizedBox(height: 8),
          LoadingDots(
            color: context.theme.primary,
            size: 12,
          ),
        ]));
  }
}
