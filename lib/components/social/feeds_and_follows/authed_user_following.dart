import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/feed/followers_following.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:auto_route/auto_route.dart';

/// People that the current User is following.
/// i.e. Feeds that their [user_timeline] is following.
class AuthedUserFollowing extends StatefulWidget {
  final FlatFeed timelineFeed;
  const AuthedUserFollowing({
    Key? key,
    required this.timelineFeed,
  }) : super(key: key);

  @override
  _AuthedUserFollowingState createState() => _AuthedUserFollowingState();
}

class _AuthedUserFollowingState extends State<AuthedUserFollowing> {
  bool _isLoading = true;

  /// List of feeds [user_feeds] which are being followed by this [user_timeline]
  List<FollowWithUserAvatarData> _following = <FollowWithUserAvatarData>[];

  late Timer _pollingTimer;

  String _searchString = '';

  @override
  void initState() {
    super.initState();

    _pollingTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _loadInitialData();
    });

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final timelineFollowing = await widget.timelineFeed.following();
      final userIds =
          timelineFollowing.map((f) => f.targetId.split(':')[1]).toList();

      _following = await FeedUtils.getFollowsWithUserData(
          context, timelineFollowing, userIds);
    } catch (e) {
      printLog(e.toString());
      context.showToast(
          message: 'Sorry there was a problem loading your follows.',
          toastType: ToastType.destructive);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pollingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFollowing = Utils.textNotNull(_searchString)
        ? _following
            .where((f) =>
                f.userAvatarData != null &&
                f.userAvatarData!.displayName
                    .toLowerCase()
                    .contains(_searchString.toLowerCase()))
            .toList()
        : _following;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MyCupertinoSearchTextField(
              placeholder: 'Search your follows',
              onChanged: (t) => setState(() => _searchString = t)),
        ),
        _isLoading
            ? const ShimmerCirclesGrid()
            : _following.isEmpty
                ? YourContentEmptyPlaceholder(
                    message: 'Not following anyone yet',
                    explainer:
                        "Keep up with the latest news and fitness content by subscribing to people's feeds.",
                    actions: [
                        EmptyPlaceholderAction(
                            action: () =>
                                context.navigateTo(const DiscoverPeopleRoute()),
                            buttonIcon: CupertinoIcons.compass,
                            buttonText: 'Discover People'),
                      ])
                : GridView.count(
                    padding: const EdgeInsets.all(8),
                    childAspectRatio: 0.9,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 20,
                    children: [
                      FollowTotalAvatar(
                        total: filteredFollowing.length,
                        label: Utils.textNotNull(_searchString)
                            ? 'Found'
                            : 'Following',
                      ),
                      ...filteredFollowing
                          .map((f) => UserFollow(
                                follow: f,
                              ))
                          .toList()
                    ],
                  ),
      ],
    );
  }
}
