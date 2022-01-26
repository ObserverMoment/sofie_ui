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
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Card for displaying non club feed posts.
/// Only allowed feed types are those that share internal content (workouts, plans, logs etc).
/// Generic posts or media can only be shared within the club setting.
class FeedPostCard extends StatelessWidget {
  final FlatFeed userFeed;

  /// TimlineFeed can be null as it is not always needed - e.g. when this card is being displayed in the users 'Your Posts' archive.
  final FlatFeed? timelineFeed;

  final StreamEnrichedActivity activity;

  // Removes interactivity when [true].
  final bool isPreview;
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
    this.isPreview = false,
    this.likeUnlikePost,
    this.sharePost,
    this.userHasLiked = false,
    this.userHasShared = false,
    required this.userFeed,
    this.timelineFeed,
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
        context.navigateTo(LoggedWorkoutDetailsRoute(id: objectId));
        break;
      default:
        throw Exception(
            'FeedPostCard._openDetailsPageByType: No method defined for $type.');
    }
  }

  // https://support.getstream.io/hc/en-us/articles/4404359414551-Deleting-Activities-with-Stream-Feeds-API-
  // An activity explicitly added to a particular feed makes that feed the origin of the activity. An activity deleted from the origin is also deleted from all other feeds where it is found, either through fan-out or targeting. Deleting an activity from a feed that is not the origin of the activity, will delete it only from that feed.
  /// When the activity is owned by the authed user we can delete the activity from their own [user_feed] (i.e. the origin feed). This will also remove the post from all timeline_feeds that follow it.
  Future<void> _confirmDeleteActivity(
      BuildContext context, String activityId) async {
    context.showConfirmDeleteDialog(
        itemType: 'Post',
        message: 'This will delete the post from all timelines.',
        onConfirm: () async {
          await userFeed.removeActivityById(activityId);
        });
  }

  /// A non owner can still remove a post from their own feed if they want.
  /// TODO: This action needs to be tracked by the feed algos as this indicates that it should not have been there ion the first place.
  Future<void> _confirmRemoveActivityFromFeed(
      BuildContext context, String activityId) async {
    if (timelineFeed != null) {
      context.showConfirmDeleteDialog(
          verb: 'Remove',
          itemType: 'Post',
          message: 'This will remove the post from your timeline.',
          onConfirm: () async {
            await timelineFeed!.removeActivityById(activityId);
          });
    }
  }

  Widget _buildReactionButtonsOrDisplay(BuildContext context,
      StreamEnrichedActivity activity, bool userIsPoster) {
    final likesCount = activity.reactionCounts?.likes ?? 0;
    final sharesCount = activity.reactionCounts?.shares ?? 0;

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
            title: activity.extraData.title ?? 'Post',
            text: activity.extraData.caption!,
            trimLines: 3,
          ),
        ),
      );

  Widget _buildInfoTag(BuildContext context, String tag) => Tag(
        tag: tag,
        textColor: context.theme.primary,
        color: context.theme.cardBackground,
        padding: const EdgeInsets.symmetric(horizontal: 10),
      );

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser?.id;

    final userIsPoster = authedUserId == activity.actor.id;

    final userIsCreator = authedUserId == activity.extraData.creator?.id;

    final originalPostId = activity.extraData.originalPostId;

    final postType = kStreamNameToFeedPostType[
        FeedUtils.getObjectTypeFromRef(activity.object)];

    final objectId = FeedUtils.getObjectIdFromRef(activity.object);

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
                      avatarUri: activity.actor.data.image,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyHeaderText(
                          activity.extraData.title ?? 'Post',
                          size: FONTSIZE.two,
                          lineHeight: 1.3,
                        ),
                        MyText(
                          activity.actor.data.name ?? '',
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
                        handleDeletePost: userIsPoster
                            ? () => _confirmDeleteActivity(context, activity.id)
                            : () => _confirmRemoveActivityFromFeed(
                                context, activity.id),
                        openDetailsPage: postType != null && objectId != null
                            ? () => _openDetailsPageByType(
                                context, postType, objectId)
                            : null,
                        activity: activity,
                      )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
              child: _buildCaption,
            ),
            if (postType != null && objectId != null)
              GestureDetector(
                  onTap: () =>
                      _openDetailsPageByType(context, postType, objectId),
                  child: _SharedContentDisplay(
                    feedPostType: postType,
                    activityExtraData: activity.extraData,
                  )),
            const SizedBox(height: 4),
            if (Utils.textNotNull(activity.extraData.imageUrl))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: activity.extraData.imageUrl!)),
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
                      child: _buildInfoTag(context, activity.time.daysAgo),
                    )
                  ],
                )
              ],
            ),
            if (activity.extraData.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: activity.extraData.tags
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

class _SharedContentDisplay extends StatelessWidget {
  final FeedPostType feedPostType;
  final StreamActivityExtraData activityExtraData;
  const _SharedContentDisplay(
      {Key? key, required this.feedPostType, required this.activityExtraData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final creatorName = activityExtraData.creator?.data.name;

    return Padding(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                                FeedUtils.getFeedSharedContentIcon(
                                    feedPostType),
                                size: 19),
                            const SizedBox(width: 8),
                            MyHeaderText(
                              kFeedPostTypeToDisplay[feedPostType]!,
                            ),
                          ],
                        ),
                      ),
                      if (creatorName != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: MyText(
                            'By $creatorName',
                            weight: FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const Icon(CupertinoIcons.chevron_right)
            ],
          )),
    );
  }
}

class _TimelinePostEllipsisMenu extends StatelessWidget {
  final bool userIsPoster;
  final bool userIsCreator;
  final StreamEnrichedActivity activity;
  final VoidCallback? handleDeletePost;
  final VoidCallback? openDetailsPage;

  const _TimelinePostEllipsisMenu({
    Key? key,
    required this.activity,
    required this.openDetailsPage,
    this.handleDeletePost,
    required this.userIsPoster,
    required this.userIsCreator,
  }) : super(key: key);

  void _openUserProfile(BuildContext context, String userId) {
    context.navigateTo(UserPublicProfileDetailsRoute(userId: userId));
  }

  String _genLinkText(FeedPostType type) {
    final objectId = FeedUtils.getObjectIdFromRef(activity.object);

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

    final creatorId = activity.extraData.creator?.id;

    final posterId = activity.actor.id;
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
                if (!userIsPoster)
                  BottomSheetMenuItem(
                      text: 'View Poster',
                      icon: CupertinoIcons.person_crop_rectangle,
                      onPressed: () => _openUserProfile(context, posterId)),
                if (feedPostType != null)
                  BottomSheetMenuItem(
                      text: 'Share $typeDisplay to...',
                      icon: CupertinoIcons.paperplane,
                      onPressed: () => _shareObject(feedPostType, typeDisplay)),
                if (handleDeletePost != null)
                  BottomSheetMenuItem(
                      text: userIsPoster ? 'Delete Post' : 'Remove Post',
                      icon: CupertinoIcons.delete_simple,
                      onPressed: handleDeletePost!,
                      isDestructive: true),
              ])),
    );
  }
}
