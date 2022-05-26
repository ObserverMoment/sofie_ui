import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_post_card_ellipsis_menu.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_post_reactions.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
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

  /// Only pass this when the user owns / posted the activity.
  final VoidCallback? deleteActivity;

  /// Removes the activity from the users timeline only.
  /// Does not delete anything.
  final VoidCallback? removeActivityFromTimeline;

  /// Should only be true when the user is NOT already in the club!
  final bool enableViewClubOption;

  const FeedPostCard({
    Key? key,
    required this.activity,
    this.isPreview = false,
    this.likeUnlikePost,
    this.userHasLiked = false,
    required this.userFeed,
    this.timelineFeed,
    this.deleteActivity,
    this.removeActivityFromTimeline,
    required this.enableViewClubOption,
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

    final feedPostType = kStreamNameToFeedPostType[
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
                Flexible(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.navigateTo(
                            UserPublicProfileDetailsRoute(
                                userId: activity.actor.id)),
                        child: UserAvatar(
                          size: 40,
                          avatarUri: activity.actor.data.image,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyHeaderText(
                              activity.extraData.title ?? 'Post',
                              size: FONTSIZE.two,
                              lineHeight: 1.3,
                              weight: FontWeight.normal,
                            ),
                            MyText(
                              activity.actor.data.name ?? '',
                              lineHeight: 1.4,
                              size: FONTSIZE.two,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                isPreview
                    ? const Icon(CupertinoIcons.ellipsis)
                    : FeedPostCardEllipsisMenu(
                        activity: activity,
                        feedPostType: feedPostType,
                        objectId: objectId,
                        userIsCreator: userIsCreator,
                        userIsPoster: userIsPoster,
                        removeActivityFromTimeline: removeActivityFromTimeline,
                        deleteActivity: deleteActivity,
                        enableViewClubOption: enableViewClubOption,
                      )
              ],
            ),
            if (Utils.textNotNull(activity.extraData.caption))
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                child: _buildCaption,
              ),
            if (feedPostType != null && objectId != null)
              GestureDetector(
                  onTap: () =>
                      _openDetailsPageByType(context, feedPostType, objectId),
                  child: _SharedContentDisplay(
                    feedPostType: feedPostType,
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
                FeedPostReactions(
                  userIsPoster: userIsPoster,
                  activity: activity,
                  isPreview: isPreview,
                  userHasLiked: userHasLiked,
                  likeUnlikePost: likeUnlikePost,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                    ),
                  ],
                )
              ],
            ),
            if (activity.extraData.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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

/// Duplicated in [ClubFeedPostCard]
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
                            height: 50,
                            width: 50,
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
                                size: 17),
                            const SizedBox(width: 8),
                            MyHeaderText(
                              kFeedPostTypeToDisplay[feedPostType]!,
                              size: FONTSIZE.two,
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
                            size: FONTSIZE.two,
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
