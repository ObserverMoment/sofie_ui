import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/modules/home/notifications_page.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/stream_feed.dart';

Future<void> handleIncomingFeedNotifications(
    BuildContext context, RealtimeMessage? message) async {
  /// Only fairly serious messages should trigger a full notification.
  /// For now just [join-club], [leave-club], [join-plan], [leave-plan]
  final latest = message?.newActivities?[0];

  if (latest != null) {
    context.showNotification(
        title: 'Notification',
        content: NotificationActivity(
          activity: GenericEnrichedActivity<User, dynamic, String, String>(
              id: latest.id,
              actor: User.fromJson(latest.actor),
              verb: latest.verb,
              object: latest.object,
              foreignId: latest.foreignId),
        ));
  }
}

/// Notification bell icon that can be used anywhere in the app.
/// Displays a dot in top right (if there are unread notifications).
/// Requires [context.streamFeedClient] via Provider + context_extensions
/// Ontap open up the notifications overview page.
class NotificationsIconButton extends StatefulWidget {
  const NotificationsIconButton({Key? key}) : super(key: key);

  @override
  State<NotificationsIconButton> createState() =>
      _NotificationsIconButtonState();
}

class _NotificationsIconButtonState extends State<NotificationsIconButton> {
  int _unseenCount = 0;
  late NotificationFeed _notificationFeed;
  Subscription? _feedSubscription;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _notificationFeed = context.notificationFeed;
    _updateIndicator().then((_) => _subscribeToFeed().then((_) {
          /// TODO: Remove this polling once the stream feeds bug is fixed.
          /// https://github.com/GetStream/stream-feed-flutter/issues/193
          _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
            _updateIndicator();
          });
        }));
  }

  Future<void> _updateIndicator() async {
    /// We only need to know if there are unseen activities - so set limit to 1.
    final counts = await _notificationFeed.getUnreadUnseenCounts();
    if (mounted) {
      setState(() {
        _unseenCount = counts.unseenCount;
      });
    }
  }

  Future<void> _subscribeToFeed() async {
    try {
      _feedSubscription =
          await _notificationFeed.subscribe(_handleSubscriptionMessage);
    } catch (e) {
      printLog(e.toString());
      throw Exception(e);
    } finally {
      setState(() {});
    }
  }

  Future<void> _handleSubscriptionMessage(RealtimeMessage? message) async {
    _updateIndicator();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _feedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.navigateTo(const NotificationsRoute()),
      child: Stack(
        children: [
          const Icon(CupertinoIcons.bell),
          if (_unseenCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: FadeInUp(
                  key: Key(_unseenCount.toString()),
                  child: Dot(
                    diameter: 14,
                    border:
                        Border.all(color: context.theme.background, width: 2),
                    color: Styles.infoBlue,
                  )),
            ),
        ],
      ),
    );
  }
}

/// Chat bubble icon that can be used anywhere in the app.
/// Displays a dot in top right (if there are unread messages).
/// Ontap open up the chats overview page.
class ChatsIconButton extends StatelessWidget {
  const ChatsIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream:
            chat.StreamChatCore.of(context).client.state.totalUnreadCountStream,
        builder: (context, snapshot) {
          final unreadCount = snapshot.data;

          return CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.navigateTo(const ChatsOverviewRoute()),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(CupertinoIcons.chat_bubble_text),
                    SizedBox(height: 2),
                    MyText(
                      'Chat',
                      size: FONTSIZE.one,
                    )
                  ],
                ),
                if (unreadCount != null && unreadCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: FadeInUp(
                        key: Key(unreadCount.toString()),
                        child: Dot(
                          diameter: 14,
                          border: Border.all(
                              color: context.theme.background, width: 2),
                          color: Styles.infoBlue,
                        )),
                  ),
              ],
            ),
          );
        });
  }
}

/// Displays a button which updates depending on whether or not the authed users [user_timeline] feed is following the user with [otherUserId]s [user_feed].
/// Onpress it handles follow / unfollow functionality.
class UserFeedConnectionButton extends StatefulWidget {
  final String otherUserId;
  final double iconSize;
  final FONTSIZE fontSize;
  const UserFeedConnectionButton(
      {Key? key,
      required this.otherUserId,
      this.iconSize = 20,
      this.fontSize = FONTSIZE.three})
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
          height: 44,
          child: _authedUser.id == widget.otherUserId
              ? const Center(child: MyText('...'))
              : _isLoading
                  ? const Center(child: LoadingIndicator(size: 10))
                  : _isFollowing
                      ? TertiaryButton(
                          text: 'Following',
                          prefixIconData: CupertinoIcons.checkmark_alt,
                          onPressed: _unfollowOtherUser,
                          iconSize: widget.iconSize,
                          fontSize: widget.fontSize,
                          backgroundColor: Styles.primaryAccent,
                          textColor: Styles.white)
                      : TertiaryButton(
                          prefixIconData: CupertinoIcons.person,
                          iconSize: widget.iconSize,
                          fontSize: widget.fontSize,
                          text: 'Follow',
                          onPressed: _followOtherUser),
        ));
  }
}
