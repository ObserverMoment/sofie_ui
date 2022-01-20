import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/authed_user_followers.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/authed_user_following.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:auto_route/auto_route.dart';

/// As is, this widget will only work for the authed user, i.e. the one who is linked to the feed token generated via the API when user logs in.
class FollowersFollowing extends StatefulWidget {
  final String userId;
  final String userDisplayName;
  const FollowersFollowing(
      {Key? key, required this.userId, required this.userDisplayName})
      : super(key: key);

  @override
  State<FollowersFollowing> createState() => _FollowersFollowingState();
}

class _FollowersFollowingState extends State<FollowersFollowing> {
  int _activeTabIndex = 0;

  late StreamFeedClient _streamFeedClient;

  /// Timeline - activities from feeds the users timeline is following.
  late FlatFeed _timelineFeed;

  /// Feed - posts the user has made themselves.
  late FlatFeed _userFeed;

  @override
  void initState() {
    super.initState();

    _streamFeedClient = context.streamFeedClient;
    _timelineFeed =
        _streamFeedClient.flatFeed(kUserTimelineName, widget.userId);
    _userFeed = _streamFeedClient.flatFeed(kUserFeedName, widget.userId);
  }

  void _changeTab(int index) {
    setState(() => _activeTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarTitle(widget.userDisplayName),
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            width: double.infinity,
            child: MySlidingSegmentedControl<int>(
                value: _activeTabIndex,
                children: const {
                  0: 'Followers',
                  1: 'Following',
                },
                updateValue: _changeTab),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: IndexedStack(
              index: _activeTabIndex,
              children: [
                AuthedUserFollowers(
                  userFeed: _userFeed,
                ),
                AuthedUserFollowing(
                  timelineFeed: _timelineFeed,
                ),
              ],
            ),
          )
        ],
      ),
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
