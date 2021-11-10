import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feeds_and_follows.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
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

  @override
  void initState() {
    super.initState();
    _loadInitialData();
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
    return _isLoading
        ? const ShimmerCirclesGrid()
        : _followers.isEmpty
            ? ListView(
                shrinkWrap: true,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: MyText(
                        'No followers yet..',
                        size: FONTSIZE.four,
                        subtext: true,
                      ),
                    ),
                  )
                ],
              )
            : GridView.count(
                padding: const EdgeInsets.all(8),
                childAspectRatio: 0.9,
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 20,
                children: [
                  FollowTotalAvatar(
                    total: _followers.length,
                    label: 'Followers',
                  ),
                  ..._followers
                      .map((f) => UserFollow(
                            follow: f,
                          ))
                      .toList()
                ],
              );
  }
}
