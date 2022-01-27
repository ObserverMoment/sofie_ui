import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/timeline_and_feed_archived.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';

/// Followers of the currently logged in User.
/// i.e Details of other users [user_timelines] which are following this users [user_feed]
class AuthedUserFollowers extends StatefulWidget {
  final FlatFeed userFeed;
  const AuthedUserFollowers({
    Key? key,
    required this.userFeed,
  }) : super(key: key);

  @override
  _AuthedUserFollowersState createState() => _AuthedUserFollowersState();
}

class _AuthedUserFollowersState extends State<AuthedUserFollowers> {
  bool _isLoading = true;

  // /// List of followers [user_timelines] which are following this [user_feed]
  List<FollowWithUserAvatarData> _followers = <FollowWithUserAvatarData>[];

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

  @override
  void dispose() {
    _pollingTimer.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final followers = await widget.userFeed.followers();
      final userIds = followers.map((f) => f.feedId.split(':')[1]).toList();

      _followers =
          await FeedUtils.getFollowsWithUserData(context, followers, userIds);
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
  Widget build(BuildContext context) {
    final filteredFollowers = Utils.textNotNull(_searchString)
        ? _followers
            .where((f) =>
                f.userAvatarData != null &&
                f.userAvatarData!.displayName
                    .toLowerCase()
                    .contains(_searchString.toLowerCase()))
            .toList()
        : _followers;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MyCupertinoSearchTextField(
              placeholder: 'Search your followers',
              onChanged: (t) => setState(() => _searchString = t)),
        ),
        _isLoading
            ? const ShimmerCirclesGrid()
            : _followers.isEmpty
                ? const YourContentEmptyPlaceholder(
                    message: 'No followers yet',
                    explainer:
                        'Anyone who subscribes to your feed will show here. Easily keep in touch with your friends and fans!',
                    actions: [])
                : GridView.count(
                    padding: const EdgeInsets.all(8),
                    childAspectRatio: 0.9,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 20,
                    children: [
                      FollowTotalAvatar(
                        total: filteredFollowers.length,
                        label: Utils.textNotNull(_searchString)
                            ? 'Found'
                            : 'Followers',
                      ),
                      ...filteredFollowers
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
