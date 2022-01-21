import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
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
  final EnrichedActivityExtraData activityExtraData;
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

  void _openDetailsPageByType(
      BuildContext context, FeedPostType type, String objectId) {
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
                  size: 20,
                ),
                const SizedBox(width: 4),
                MyText('$likesCount'),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      CupertinoIcons.paperplane_fill,
                      color: context.theme.primary.withOpacity(0.4),
                      size: 20,
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

  Widget get _buildCaption => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ReadMoreTextBlock(
            title: activityExtraData.title ?? 'Post',
            text: activityExtraData.caption!,
            trimLines: 3,
          ),
        ),
      );

  Widget _buildSharedContent(FeedPostType type) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: ContentBox(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (Utils.textNotNull(activityExtraData.imageUrl))
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                              height: 60,
                              width: 60,
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: activityExtraData.imageUrl!)),
                        ),
                      ),
                    const SizedBox(
                      width: 4,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(FeedUtils.getFeedSharedContentIcon(type),
                                size: 16),
                            const SizedBox(width: 8),
                            MyText(
                              _generateCreatorString(type),
                              weight: FontWeight.normal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        if (Utils.textNotNull(activityExtraData.title))
                          MyText(
                            activityExtraData.title!,
                            maxLines: 2,
                            lineHeight: 1.3,
                          ),
                      ],
                    ),
                  ],
                ),
                const Icon(CupertinoIcons.chevron_right)
              ],
            )),
      );

  Widget _buildInfoTag(BuildContext context, String tag) => Tag(
        tag: tag,
        textColor: context.theme.primary,
        color: context.theme.cardBackground,
        padding: const EdgeInsets.symmetric(horizontal: 10),
      );

  String _generateCreatorString(FeedPostType type) {
    final typeDisplay = kFeedPostTypeToDisplay[type];

    if (typeDisplay == null) {
      return '';
    }

    if (activityExtraData.creator != null) {
      return '$typeDisplay by ${activityExtraData.creator!.data?['name']}';
    } else {
      return typeDisplay;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser?.id;

    final userIsPoster = authedUserId == activity.actor?.id;

    final userIsCreator =
        authedUserId == activityExtraData.creator?.data?['id'];

    final originalPostId = activityExtraData.originalPostId;

    final postType = kStreamNameToFeedPostType[
        FeedUtils.getObjectTypeFromRef(activity.object!)];

    final isSharedContent = [
      FeedPostType.workout,
      FeedPostType.workoutPlan,
      FeedPostType.loggedWorkout
    ].contains(postType);

    final objectId = FeedUtils.getObjectIdFromRef(activity.object!);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    UserAvatar(
                      size: 40,
                      avatarUri: activity.actor?.data?['image'] as String?,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyHeaderText(
                          activityExtraData.title ?? 'Post',
                          size: FONTSIZE.two,
                          lineHeight: 1.3,
                        ),
                        MyText(
                          activity.actor?.data?['name'] as String? ?? '',
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
                        openDetailsPage: postType != null
                            ? () => _openDetailsPageByType(
                                context, postType, objectId)
                            : null,
                        activity: activity,
                        extraData: activityExtraData,
                      )
              ],
            ),
            _buildCaption,
            if (isSharedContent && postType != null)
              GestureDetector(
                  onTap: () =>
                      _openDetailsPageByType(context, postType, objectId),
                  child: _buildSharedContent(postType)),
            const SizedBox(height: 4),
            if (!isSharedContent &&
                Utils.textNotNull(activityExtraData.imageUrl))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: activityExtraData.imageUrl!)),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildReactionButtonsOrDisplay(context, activity, userIsPoster),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (originalPostId != null)
                      Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: _buildInfoTag(
                            context,
                            'Re-Post',
                          )),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildInfoTag(
                        context,
                        activity.time?.daysAgo ?? 'Unknown',
                      ),
                    )
                  ],
                )
              ],
            ),
            if (activityExtraData.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
              ),
            const SizedBox(height: 10),
            HorizontalLine(
                verticalPadding: 0,
                color: context.theme.primary.withOpacity(0.2))
          ]),
    );
  }
}

class _TimelinePostEllipsisMenu extends StatelessWidget {
  final bool userIsPoster;
  final bool userIsCreator;
  final EnrichedActivity activity;
  final EnrichedActivityExtraData extraData;
  final VoidCallback? handleDeletePost;

  /// TODO: This is not doing anything!
  final VoidCallback? openEditPost;
  final VoidCallback? openDetailsPage;

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
    final objectId = FeedUtils.getObjectIdFromRef(activity.object!);

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

    final creatorId = extraData.creator?.data?['id'] as String?;

    final posterId = activity.actor?.id;
    final posterName = activity.actor?.data?['name'] as String?;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: const Icon(CupertinoIcons.ellipsis),
      onPressed: () => openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(
              header: BottomSheetMenuHeader(
                name: extraData.title ?? 'Post',
                subtitle: 'Posted by $posterName',
              ),
              items: [
                if (openDetailsPage != null)
                  BottomSheetMenuItem(
                      text: 'View $typeDisplay',
                      icon: CupertinoIcons.eye,
                      onPressed: openDetailsPage!),
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
