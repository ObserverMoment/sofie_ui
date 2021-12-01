import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/src/client/flat_feed.dart';
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/stream_feed.dart';

StreamChatThemeData generateStreamTheme(BuildContext context) {
  final bool isDark = context.theme.brightness == Brightness.dark;
  final primary = context.theme.primary;
  final background = context.theme.background;
  final cardBackground = context.theme.cardBackground;

  return StreamChatThemeData(
    brightness: context.theme.brightness,
    primaryIconTheme: IconThemeData(color: primary),
    colorTheme: isDark
        ? ColorTheme.dark(
            accentPrimary: primary,
          )
        : ColorTheme.light(accentPrimary: primary),
    messageInputTheme: MessageInputThemeData(
        inputTextStyle: GoogleFonts.sourceSansPro(),
        inputBackgroundColor: cardBackground),
    channelListViewTheme: ChannelListViewThemeData(backgroundColor: background),
    messageListViewTheme: MessageListViewThemeData(backgroundColor: background),
    channelHeaderTheme: ChannelHeaderThemeData(
      color: background,
      titleStyle: GoogleFonts.archivo(textStyle: TextStyle(color: primary)),
      subtitleStyle: GoogleFonts.sourceSansPro(),
    ),
  );
}

/// Notification bell icon that can be used anywhere in the app.
/// Displays a dot in top right (if there are unread notifications).
/// Requires [context.streamFeedClient] via Provider + context_extensions
/// Ontap open up the notifications overview page.
class NotificationsIconButton extends StatefulWidget {
  const NotificationsIconButton({Key? key}) : super(key: key);

  @override
  _NotificationsIconButtonState createState() =>
      _NotificationsIconButtonState();
}

class _NotificationsIconButtonState extends State<NotificationsIconButton> {
  int _unseenCount = 0;
  late NotificationFeed _notificationFeed;
  Subscription? _feedSubscription;

  @override
  void initState() {
    super.initState();
    _notificationFeed = context.notificationFeed;
    _initIndicator().then((_) => _subscribeToFeed());
  }

  Future<void> _initIndicator() async {
    /// We only need to know if there are unseen activities - so set limit to 1.
    final feedData = await _notificationFeed.getActivities();
    _unseenCount = feedData.fold(0, (unseenCount, next) {
      if (next.isSeen != true) {
        return unseenCount + 1;
      } else {
        return unseenCount;
      }
    });
    setState(() {});
  }

  Future<void> _subscribeToFeed() async {
    try {
      _feedSubscription = await _notificationFeed.subscribe(_updateIndicator);
    } catch (e) {
      printLog(e.toString());
      throw Exception(e);
    } finally {
      setState(() {});
    }
  }

  Future<void> _updateIndicator(RealtimeMessage? message) async {
    _initIndicator();
  }

  @override
  void dispose() {
    _feedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            onPressed: () => printLog('open notifications'),
            child: const Icon(CupertinoIcons.bell)),
        if (_unseenCount > 0)
          Positioned(
            top: 4,
            right: 8,
            child: SizeFadeIn(
                key: Key(_unseenCount.toString()),
                child: Dot(
                  diameter: 14,
                  border: Border.all(color: context.theme.background, width: 2),
                  color: Styles.infoBlue,
                )),
          ),
      ],
    );
  }
}

/// Chat bubble icon that can be used anywhere in the app.
/// Displays a dot in top right (if there are unread messages).
/// Requires [context.streamChatClient] via Provider + context_extensions
/// Ontap open up the chats overview page.
class ChatsIconButton extends StatefulWidget {
  const ChatsIconButton({Key? key}) : super(key: key);

  @override
  _ChatsIconButtonState createState() => _ChatsIconButtonState();
}

class _ChatsIconButtonState extends State<ChatsIconButton> {
  int _unreadCount = 0;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _unreadCount = context.streamChatClient.state.currentUser!.totalUnreadCount;

    /// Setup the listener for changes to the unread count.
    /// https://getstream.io/chat/docs/flutter-dart/unread/?language=dart&q=unread
    _subscription = context.streamChatClient
        .on()
        .where((Event event) => event.totalUnreadCount != null)
        .listen((Event event) {
      setState(() => _unreadCount = event.totalUnreadCount!);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onTap: () => context.pushRoute(const ChatsOverviewRoute()),
            child: const Icon(CupertinoIcons.chat_bubble, size: 26)),
        if (_unreadCount > 0)
          Positioned(
            top: 4,
            right: 8,
            child: FadeInUp(
                key: Key(_unreadCount.toString()),
                child: Dot(
                  diameter: 14,
                  border: Border.all(color: context.theme.background, width: 2),
                  color: Styles.primaryAccent,
                )),
          ),
      ],
    );
  }
}

/// Displays a button which updates depending on whether or not the authed users [user_timeline] feed is following the user with [otherUserId]s [user_feed].
/// Onpress it handles follow / unfollow functionality.
class UserFeedConnectionButton extends StatefulWidget {
  final String otherUserId;
  const UserFeedConnectionButton({Key? key, required this.otherUserId})
      : super(key: key);

  @override
  _UserFeedConnectionButtonState createState() =>
      _UserFeedConnectionButtonState();
}

class _UserFeedConnectionButtonState extends State<UserFeedConnectionButton> {
  late AuthedUser _authedUser;
  late StreamFeedClient _streamFeedClient;

  late FlatFeed _authedUserTimeline;
  late FlatFeed _otherUserFeed;

  bool _isFollowing = false;
  bool _isLoading = true;

  @override
  void initState() {
    _authedUser = GetIt.I<AuthBloc>().authedUser!;
    _streamFeedClient = context.streamFeedClient;

    _authedUserTimeline =
        _streamFeedClient.flatFeed(kUserTimelineName, _authedUser.id);
    _otherUserFeed =
        _streamFeedClient.flatFeed(kUserFeedName, widget.otherUserId);

    _checkUserConnection();

    super.initState();
  }

  /// Does [_authedUserTimeline] follow [_otherUserFeed]?
  Future<void> _checkUserConnection() async {
    // Check if authed user follows [user_feed] of otherUser.
    final feed = await _authedUserTimeline.following(
        offset: 0,
        limit: 1,
        filter: [FeedId.id('$kUserFeedName:${widget.otherUserId}')]);

    setState(() {
      _isFollowing = feed.isNotEmpty;
      _isLoading = false;
    });
  }

  Future<void> _followOtherUser() async {
    Vibrate.feedback(FeedbackType.selection);

    /// Optimistic: Assume succes and revert later if not.
    setState(() => _isFollowing = true);
    try {
      // Follow feed without copying the activities:
      await _authedUserTimeline.follow(_otherUserFeed, activityCopyLimit: 0);
    } catch (e) {
      setState(() => _isFollowing = false);
      context.showToast(
          toastType: ToastType.destructive,
          message: 'Sorry, there was a problem, please try again');
      printLog(e.toString());
    }
  }

  Future<void> _unfollowOtherUser() async {
    /// Optimistic: Assume succes and revert later if not.
    setState(() => _isFollowing = false);

    try {
      // Unfollow feed but do not purge already received activities.
      await _authedUserTimeline.unfollow(_otherUserFeed, keepHistory: true);
    } catch (e) {
      setState(() => _isFollowing = true);
      context.showToast(
          toastType: ToastType.destructive,
          message: 'Sorry, there was a problem, please try again');
      printLog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: kStandardAnimationDuration,
        child: SizedBox(
          width: 120,
          height: 42,
          child: _authedUser.id == widget.otherUserId
              ? const Center(child: MyText('...'))
              : _isLoading
                  ? const Center(child: LoadingDots(size: 10))
                  : _isFollowing
                      ? BorderButton(
                          text: 'Following',
                          onPressed: _unfollowOtherUser,
                          backgroundColor: Styles.infoBlue,
                          textColor: Styles.white)
                      : BorderButton(
                          prefix: const Icon(
                            CupertinoIcons.person_add,
                            size: 15,
                          ),
                          text: 'Follow',
                          onPressed: _followOtherUser),
        ));
  }
}
