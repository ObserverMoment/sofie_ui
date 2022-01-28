import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/schedule/coming_up_list.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/authed_user_timeline.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/pages/authed/feed/announcements_updates.dart';
import 'package:sofie_ui/pages/authed/feed/followers_following.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/stream.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late AuthedUser _authedUser;
  late StreamFeedClient _streamFeedClient;

  /// Timeline - activities from feeds the users timeline is following.
  late FlatFeed _timelineFeed;

  /// Feed - posts the user has made themselves.
  late FlatFeed _userFeed;

  @override
  void initState() {
    super.initState();

    _authedUser = GetIt.I<AuthBloc>().authedUser!;
    _streamFeedClient = context.streamFeedClient;
    _timelineFeed =
        _streamFeedClient.flatFeed(kUserTimelineName, _authedUser.id);
    _userFeed = _streamFeedClient.flatFeed(kUserFeedName, _authedUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
        backgroundColor: context.theme.modalBackground,
        withoutLeading: true,
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                iconData: CupertinoIcons.plus_circle,
                onPressed: () =>
                    context.navigateTo(const FeedPostCreatorRoute())),
            IconButton(
                iconData: CupertinoIcons.person_2,
                onPressed: () => context.push(
                        child: FollowersFollowing(
                      userId: _authedUser.id,
                    ))),
            const ChatsIconButton(),
            const NotificationsIconButton(),
            IconButton(
                iconData: CupertinoIcons.tray_full,
                onPressed: () => context.navigateTo(const YourPostsRoute())),
            IconButton(
                iconData: CupertinoIcons.gear,
                onPressed: () => context.navigateTo(const SettingsRoute())),
          ],
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AnnouncementsUpdates(),
          ),
          const ComingUpList(),
          Expanded(
            child: AuthedUserTimeline(
                userFeed: _userFeed,
                timelineFeed: _timelineFeed,
                streamFeedClient: _streamFeedClient),
          ),
        ],
      ),
    );
  }
}
