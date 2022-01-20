import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/schedule/coming_up_list.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/authed_user_timeline.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/pages/authed/social/followers_following.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/stream.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
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

  Widget get _buttonSpacer => const SizedBox(width: 10);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        trailing: NavBarTrailingRow(
          children: [
            IconButton(
                iconData: CupertinoIcons.plus_rectangle,
                onPressed: () =>
                    context.navigateTo(const FeedPostCreatorRoute())),
            _buttonSpacer,
            const ChatsIconButton(),
            _buttonSpacer,
            IconButton(
                iconData: CupertinoIcons.person_2,
                onPressed: () => context.push(
                        child: FollowersFollowing(
                      userId: _authedUser.id,
                      userDisplayName: _authedUser.displayName,
                    ))),
            _buttonSpacer,
            IconButton(
                iconData: CupertinoIcons.tray_full,
                onPressed: () => context.navigateTo(const YourPostsRoute())),
          ],
        ),
      ),
      child: Column(
        children: [
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
