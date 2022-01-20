import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';

class FeedPostCard extends StatelessWidget {
  final EnrichedActivity activity;
  // Pass as client side model to ensure extra data and required fields are present.
  final ActivityExtraData activityExtraData;
  // Removes interactivity when [true].
  final bool isPreview;
  final void Function(String activityId)? deleteActivityById;
  final VoidCallback? likeUnlikePost;
  final bool userHasLiked;

  /// When true we don't display share count or display UI to allow the user to share.
  /// Used for post types which should not be freely shared - i.e. posts within clubs / private challenges etc.
  // final bool disableSharing;
  final VoidCallback? sharePost;
  final bool userHasShared;
  const FeedPostCard({
    Key? key,
    required this.activity,
    required this.activityExtraData,
    this.isPreview = false,
    this.deleteActivityById,
    this.likeUnlikePost,
    this.sharePost,
    this.userHasLiked = false,
    this.userHasShared = false,
  }) : super(key: key);

  void _openDetailsPageByType(BuildContext context) {
    final type = kStreamNameToFeedPostType[activity.object];
    final objectId = activityExtraData.objectId;

    if (type != null && objectId != null) {
      switch (type) {
        case FeedPostType.workout:
          context.navigateTo(WorkoutDetailsRoute(id: objectId));
          break;
        case FeedPostType.workoutPlan:
          context.navigateTo(WorkoutPlanDetailsRoute(id: objectId));
          break;
        case FeedPostType.loggedWorkout:
          context.navigateTo(WorkoutPlanDetailsRoute(id: objectId));
          break;
        default:
          throw Exception(
              'FeedPostCard._openDetailsPageByType: No method defined for $type.');
      }
    }
  }

  Widget _buildReactionButtonsOrDisplay(
      BuildContext context, EnrichedActivity activity, bool userIsPoster) {
    final likesCount = activity.reactionCounts?[kLikeReactionName] ?? 0;
    final sharesCount = activity.reactionCounts?[kShareReactionName] ?? 0;

    return userIsPoster
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.heart_fill,
                  color: context.theme.primary.withOpacity(0.4),
                  size: 16,
                ),
                const SizedBox(width: 4),
                MyText('$likesCount'),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      CupertinoIcons.paperplane_fill,
                      color: context.theme.primary.withOpacity(0.4),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    MyText('$sharesCount'),
                  ],
                )
              ],
            ),
          )
        : Row(
            children: [
              if (likeUnlikePost != null)
                _buildReactionButton(
                    inactiveIconData: CupertinoIcons.heart,
                    activeIconData: CupertinoIcons.heart_fill,
                    onPressed: likeUnlikePost!,
                    active: userHasLiked),
              if (sharePost != null)
                _buildReactionButton(
                    inactiveIconData: CupertinoIcons.paperplane,
                    activeIconData: CupertinoIcons.paperplane_fill,
                    onPressed: sharePost!,
                    active: userHasShared),
            ],
          );
  }

  Widget _buildReactionButton(
          {required IconData inactiveIconData,
          required IconData activeIconData,
          required VoidCallback onPressed,
          required bool active}) =>
      CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          onPressed: isPreview ? null : onPressed,
          child: AnimatedSwitcher(
            duration: kStandardAnimationDuration,
            child: active
                ? Icon(
                    activeIconData,
                    color: Styles.primaryAccent,
                  )
                : Opacity(
                    opacity: 0.6,
                    child: Icon(
                      inactiveIconData,
                    ),
                  ),
          ));

  Widget _buildTitleCaptionAndTags() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Utils.textNotNull(activityExtraData.objectName))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: MyHeaderText(
                        activityExtraData.objectName!,
                        lineHeight: 1.2,
                      ),
                    ),
                  if (Utils.textNotNull(activityExtraData.caption))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ReadMoreTextBlock(
                        title: activityExtraData.objectName ?? 'Post',
                        text: activityExtraData.caption!,
                        trimLines: 3,
                      ),
                    ),
                  // There are no type checks on the getStream side so we need to defend against anything weird being in this field.
                  if (activityExtraData.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: activityExtraData.tags
                            .map((tag) => MyText(
                                  '#$tag',
                                  weight: FontWeight.bold,
                                  color: Styles.primaryAccent,
                                ))
                            .toList(),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser?.id;

    final userIsPoster = authedUserId == activityExtraData.posterId;
    final posterName = activityExtraData.posterName;

    final userIsCreator = authedUserId == activityExtraData.creatorId;

    final originalPostId = activityExtraData.originalPostId;

    final feedPostType = kStreamNameToFeedPostType[activity.object];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isPreview ? null : () => _openDetailsPageByType(context),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  UserAvatar(
                    size: 40,
                    avatarUri: activityExtraData.avatarUri,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyHeaderText(
                        feedPostType != null
                            ? kFeedPostTypeToDisplay[feedPostType]!
                            : 'Post',
                        size: FONTSIZE.two,
                        lineHeight: 1.3,
                      ),
                      if (Utils.textNotNull(activityExtraData.creatorName))
                        MyText(
                          'By ${activityExtraData.creatorName}',
                          lineHeight: 1.4,
                          size: FONTSIZE.two,
                        ),
                    ],
                  ),
                ],
              ),
              isPreview
                  ? const Icon(CupertinoIcons.ellipsis)
                  : _TimelinePostEllipsisMenu(
                      userIsCreator: userIsCreator,
                      userIsPoster: userIsPoster,
                      handleDeletePost:
                          deleteActivityById != null && activity.id != null
                              ? () => deleteActivityById!(activity.id!)
                              : null,
                      openDetailsPage: () => _openDetailsPageByType(context),
                      activity: activity,
                      extraData: activityExtraData,
                    )
            ],
          ),
        ),
        const SizedBox(height: 4),
        if (Utils.textNotNull(activityExtraData.imageUrl))
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
                height: 200,
                child:
                    CachedNetworkImage(imageUrl: activityExtraData.imageUrl!)),
          ),
        SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildReactionButtonsOrDisplay(context, activity, userIsPoster),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: userIsPoster
                        ? Tag(
                            tag: originalPostId != null
                                ? 'Re-posted by you'
                                : 'Posted by you',
                            textColor: context.theme.primary,
                            color: context.theme.cardBackground,
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                          )
                        : Tag(
                            tag:
                                '${originalPostId != null ? "Re-posted" : "Posted"} by $posterName',
                            textColor: context.theme.primary,
                            color: context.theme.cardBackground,
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                          ),
                  ),
                  const SizedBox(height: 4),
                  Tag(
                    tag: activity.time?.daysAgo ?? 'Unknown',
                    textColor: context.theme.primary,
                    color: context.theme.cardBackground,
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  )
                ],
              )
            ],
          ),
        ),
        Flexible(child: _buildTitleCaptionAndTags()),
        const SizedBox(height: 10),
        HorizontalLine(
            verticalPadding: 0, color: context.theme.primary.withOpacity(0.2))
      ]),
    );
  }
}

class _TimelinePostEllipsisMenu extends StatelessWidget {
  final bool userIsPoster;
  final bool userIsCreator;
  final EnrichedActivity activity;
  final ActivityExtraData extraData;
  final VoidCallback? handleDeletePost;

  /// TODO: This is not doing anything!
  final VoidCallback? openEditPost;
  final VoidCallback openDetailsPage;

  const _TimelinePostEllipsisMenu({
    Key? key,
    required this.activity,
    required this.extraData,
    required this.openDetailsPage,
    this.openEditPost,
    this.handleDeletePost,
    required this.userIsPoster,
    required this.userIsCreator,
  }) : super(key: key);

  void _openUserProfile(BuildContext context, String userId) {
    context.navigateTo(UserPublicProfileDetailsRoute(userId: userId));
  }

  String _genLinkText(FeedPostType type) {
    final objectId = extraData.objectId;

    switch (type) {
      case FeedPostType.workout:
        return 'workout/$objectId';
      case FeedPostType.workoutPlan:
        return 'workout-plan/$objectId';
      case FeedPostType.loggedWorkout:
        return 'logged-workout/$objectId';
      default:
        throw Exception(
            'FeedPostCard._genLinkText._genLinkText: Cannot form a link text for $type');
    }
  }

  Future<void> _shareObject(FeedPostType type, String display) async {
    await SharingAndLinking.shareLink(
        _genLinkText(type), 'Check out this $display');
  }

  @override
  Widget build(BuildContext context) {
    final feedPostType = kStreamNameToFeedPostType[activity.object];
    final typeDisplay = kFeedPostTypeToDisplay[feedPostType] ?? 'Post';

    final objectName = extraData.objectName;

    final creatorId = extraData.creatorId;
    final creatorName = extraData.creatorName;

    final posterId = extraData.posterId;
    final posterName = extraData.posterName;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: const Icon(CupertinoIcons.ellipsis),
      onPressed: () => openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(
              header: BottomSheetMenuHeader(
                name: '$objectName by $creatorName',
                subtitle: 'Posted by $posterName',
              ),
              items: [
                BottomSheetMenuItem(
                    text: 'View $typeDisplay',
                    icon: CupertinoIcons.eye,
                    onPressed: openDetailsPage),
                if (creatorId != null && !userIsCreator)
                  BottomSheetMenuItem(
                      text: 'View Creator',
                      icon: CupertinoIcons.person_crop_rectangle,
                      onPressed: () => _openUserProfile(context, creatorId)),
                if (posterId != null && !userIsPoster)
                  BottomSheetMenuItem(
                      text: 'View Poster',
                      icon: CupertinoIcons.person_crop_rectangle,
                      onPressed: () => _openUserProfile(context, posterId)),
                if (feedPostType != null)
                  BottomSheetMenuItem(
                      text: 'Share $typeDisplay to...',
                      icon: CupertinoIcons.paperplane,
                      onPressed: () => _shareObject(feedPostType, typeDisplay)),
                if (userIsPoster && handleDeletePost != null)
                  BottomSheetMenuItem(
                      text: 'Delete Post',
                      icon: CupertinoIcons.delete_simple,
                      onPressed: handleDeletePost!,
                      isDestructive: true),
                if (!userIsPoster)
                  BottomSheetMenuItem(
                      text: 'Report',
                      icon: CupertinoIcons.exclamationmark_circle,
                      isDestructive: true,
                      onPressed: () => printLog('report this post')),
              ])),
    );
  }
}
