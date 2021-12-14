import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/authed_user_followers.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/authed_user_following.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/authed_user_timeline.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';

/// Maintains subscriptions - also includes a list of auth user's clubs.
/// For You = the users timeline
/// Your Posts = the users own feed.
class TimelineAndFeed extends StatefulWidget {
  const TimelineAndFeed({Key? key}) : super(key: key);

  @override
  _TimelineAndFeedState createState() => _TimelineAndFeedState();
}

class _TimelineAndFeedState extends State<TimelineAndFeed> {
  int _activeTabIndex = 0;

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

  void _changeTab(int index) {
    setState(() => _activeTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        MySlidingSegmentedControl(
            value: _activeTabIndex,
            children: const {
              0: 'Activity',
              1: 'Following',
              2: 'Followers',
            },
            updateValue: _changeTab),
        const SizedBox(height: 8),
        Expanded(
          child: IndexedStack(
            index: _activeTabIndex,
            children: [
              AuthedUserTimeline(
                  userFeed: _userFeed,
                  timelineFeed: _timelineFeed,
                  streamFeedClient: _streamFeedClient),
              AuthedUserFollowing(
                timelineFeed: _timelineFeed,
              ),
              AuthedUserFollowers(
                userFeed: _userFeed,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class FollowTotalAvatar extends StatelessWidget {
  final int total;
  final String label;
  const FollowTotalAvatar({Key? key, required this.total, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyHeaderText(
            total.toString(),
            size: FONTSIZE.five,
          ),
          const SizedBox(height: 6),
          MyText(
            label.toUpperCase(),
            subtext: true,
            size: FONTSIZE.one,
          )
        ],
      ),
    ));
  }
}

class UserFollow extends StatelessWidget {
  final FollowWithUserAvatarData follow;
  const UserFollow({Key? key, required this.follow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: follow.userAvatarData != null
          ? () => context.navigateTo(
              UserPublicProfileDetailsRoute(userId: follow.userAvatarData!.id))
          : null,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: UserAvatar(
              size: 80,
              border: true,
              borderWidth: 1,
              avatarUri: follow.userAvatarData?.avatarUri,
            ),
          ),
          Positioned(
            bottom: 0,
            child: MyText(
              Utils.textNotNull(follow.userAvatarData?.displayName)
                  ? follow.userAvatarData!.displayName
                  : 'Unnamed',
              size: FONTSIZE.one,
            ),
          ),
        ],
      ),
    );
  }
}
