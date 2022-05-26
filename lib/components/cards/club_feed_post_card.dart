import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/inline_audio_player.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/media/video/video_thumbnail_image.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_post_card_ellipsis_menu.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_post_reactions.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/link_preview_display.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ClubFeedPostCard extends StatelessWidget {
  final StreamEnrichedActivity activity;

  // Removes interactivity when [true].
  final bool isPreview;
  // When displaying in the user's timeline we show a small icon to indicate that it is a Club post.
  // Which enables them to click through to the club.
  final bool showClubIcon;
  final VoidCallback? likeUnlikePost;
  final bool userHasLiked;

  /// Only pass this when the user is an owner or admin of the club and they are in the Club details area.
  final VoidCallback? deleteActivity;

  /// Removes the activity from the users timeline only.
  /// Does not delete anything.
  final VoidCallback? removeActivityFromTimeline;

  /// Should only be true when the user is NOT already in the club!
  final bool enableViewClubOption;

  const ClubFeedPostCard({
    Key? key,
    required this.activity,
    this.isPreview = false,
    this.likeUnlikePost,
    this.userHasLiked = false,
    this.showClubIcon = false,
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
            'ClubFeedPostCard._openDetailsPageByType: No method defined for $type.');
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

  Widget _buildClubIcon() => ContentBox(
        borderRadius: 40,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          children: [
            const Icon(
              MyCustomIcons.clubsIcon,
              size: 22,
              color: Styles.primaryAccent,
            ),
            const SizedBox(width: 6),
            MyText(
              activity.extraData.club!.data.name ?? '',
              color: Styles.primaryAccent,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser?.id;

    final userIsPoster = authedUserId == activity.actor.id;

    final userIsCreator = authedUserId == activity.extraData.creator?.id;

    final originalPostId = activity.extraData.originalPostId;

    final postType = kStreamNameToFeedPostType[
        FeedUtils.getObjectTypeFromRef(activity.object)];

    final isSharedContent = [
      FeedPostType.workout,
      FeedPostType.workoutPlan,
      FeedPostType.loggedWorkout
    ].contains(postType);

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
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
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
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyHeaderText(
                              activity.extraData.title ?? 'Post',
                              size: FONTSIZE.two,
                              lineHeight: 1.3,
                              maxLines: 2,
                              weight: FontWeight.normal,
                            ),
                            const SizedBox(height: 4),
                            MyText(
                              activity.actor.data.name ?? '',
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
                        userIsCreator: userIsCreator,
                        userIsPoster: userIsPoster,
                        deleteActivity: deleteActivity,
                        removeActivityFromTimeline: removeActivityFromTimeline,
                        activity: activity,
                        feedPostType: postType,
                        objectId: objectId,
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
            if (Utils.textNotNull(activity.extraData.articleUrl))
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 2),
                child: LinkPreviewDisplay(
                  url: activity.extraData.articleUrl!,
                ),
              ),
            if (!isSharedContent &&
                Utils.textNotNull(activity.extraData.imageUrl))
              Padding(
                padding: const EdgeInsets.all(4.0),
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
            if (Utils.textNotNull(activity.extraData.audioUrl))
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ContentBox(
                  child: InlineAudioPlayer(
                    audioUrl: activity.extraData.audioUrl!,
                  ),
                ),
              ),
            if (Utils.textNotNull(activity.extraData.videoUrl))
              Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: _FeedPostInlineVideo(
                        videoUrl: activity.extraData.videoUrl!)),
              ),
            if (isSharedContent && postType != null && objectId != null)
              GestureDetector(
                  onTap: () =>
                      _openDetailsPageByType(context, postType, objectId),
                  child: _SharedContentDisplay(
                    feedPostType: postType,
                    activityExtraData: activity.extraData,
                  )),
            const SizedBox(height: 4),
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
                    if (showClubIcon && activity.extraData.club?.data != null)
                      GestureDetector(
                        onTap: () => context.navigateTo(
                            ClubDetailsRoute(id: activity.extraData.club!.id)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6.0, bottom: 3),
                          child: _buildClubIcon(),
                        ),
                      ),
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

/// Duplicated in [ClubFeedCard]
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

class _FeedPostInlineVideo extends StatelessWidget {
  final String videoUrl;
  const _FeedPostInlineVideo({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => VideoSetupManager.openFullScreenVideoFromUrl(
          context: context, videoUrl: videoUrl, autoPlay: true),
      child: VideoThumbnailImage(
        videoUrl: videoUrl,
        showPlayIcon: true,
        width: double.infinity,
      ),
    );
  }
}
