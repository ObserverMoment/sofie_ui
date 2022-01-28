import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class FeedPostCardEllipsisMenu extends StatelessWidget {
  final bool userIsPoster;
  final bool userIsCreator;
  final StreamEnrichedActivity activity;
  final FeedPostType? feedPostType;
  final String? objectId;

  /// Only pass this when the user is an owner or admin of the club and they are in the Club details area.
  final VoidCallback? deleteActivity;

  /// Removes the activity from the users timeline only.
  /// Does not delete anything.
  final VoidCallback? removeActivityFromTimeline;

  /// Should only be true when the user is NOT already in the club!
  final bool enableViewClubOption;

  const FeedPostCardEllipsisMenu(
      {Key? key,
      required this.userIsPoster,
      required this.userIsCreator,
      required this.activity,
      this.deleteActivity,
      this.removeActivityFromTimeline,
      required this.feedPostType,
      required this.objectId,
      required this.enableViewClubOption})
      : super(key: key);

  void _openUserProfile(BuildContext context, String userId) {
    context.navigateTo(UserPublicProfileDetailsRoute(userId: userId));
  }

  String _genLinkText(FeedPostType type, String objectId) {
    switch (type) {
      case FeedPostType.workout:
        return 'workout/$objectId';
      case FeedPostType.workoutPlan:
        return 'workout-plan/$objectId';
      case FeedPostType.loggedWorkout:
        return 'logged-workout/$objectId';
      default:
        throw Exception(
            'ClubFeedPostCard._genLinkText._genLinkText: Cannot form a link text for $type');
    }
  }

  Future<void> _shareObject(
      FeedPostType type, String objectId, String display) async {
    await SharingAndLinking.shareLink(
        _genLinkText(type, objectId), 'Check out this $display');
  }

  @override
  Widget build(BuildContext context) {
    final clubId = activity.extraData.club?.id;
    final clubName = activity.extraData.club?.data.name ?? '';

    /// Is this something that the user can share internally via a link.
    /// [workout], [plan], [log] etc.
    final hasShareableContent = feedPostType?.hasShareableContent ?? false;

    final typeDisplay = kFeedPostTypeToDisplay[feedPostType] ?? 'Post';

    final creatorId = activity.extraData.creator?.id;
    final creatorName = activity.extraData.creator?.data.name ?? 'Creator';

    final posterName = activity.actor.data.name;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: const Icon(CupertinoIcons.ellipsis),
      onPressed: () => openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(
              header: BottomSheetMenuHeader(
                name: activity.extraData.title ?? 'Post',
                subtitle: 'Posted by $posterName',
              ),
              items: [
                if (clubId != null && enableViewClubOption)
                  BottomSheetMenuItem(
                      text: 'View Club $clubName',
                      icon: MyCustomIcons.clubsIcon,
                      onPressed: () =>
                          context.navigateTo(ClubDetailsRoute(id: clubId))),
                if (creatorId != null)
                  BottomSheetMenuItem(
                      text: 'View $creatorName Profile',
                      icon: CupertinoIcons.person_crop_rectangle,
                      onPressed: () => _openUserProfile(context, creatorId)),
                if (feedPostType != null &&
                    objectId != null &&
                    hasShareableContent)
                  BottomSheetMenuItem(
                      text: 'Share $typeDisplay to...',
                      icon: CupertinoIcons.paperplane,
                      onPressed: () =>
                          _shareObject(feedPostType!, objectId!, typeDisplay)),
                if (removeActivityFromTimeline != null)
                  BottomSheetMenuItem(
                      text: 'Remove Post',
                      icon: CupertinoIcons.delete_simple,
                      onPressed: removeActivityFromTimeline!,
                      isDestructive: true),
                if (deleteActivity != null)
                  BottomSheetMenuItem(
                      text: 'Delete Post',
                      icon: CupertinoIcons.delete_simple,
                      onPressed: deleteActivity!,
                      isDestructive: true),
              ])),
    );
  }
}
