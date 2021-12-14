import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';

class TimelinePostCard extends StatelessWidget {
  final ActivityWithObjectData activityWithObjectData;
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
  const TimelinePostCard({
    Key? key,
    required this.activityWithObjectData,
    this.isPreview = false,
    this.deleteActivityById,
    this.likeUnlikePost,
    this.sharePost,
    this.userHasLiked = false,
    this.userHasShared = false,
  }) : super(key: key);

  void _openDetailsPageByType(BuildContext context) {
    final object = activityWithObjectData.objectData!.object;
    switch (object.type) {
      case TimelinePostType.workout:
        context.navigateTo(WorkoutDetailsRoute(id: object.id));
        break;
      case TimelinePostType.workoutplan:
        context.navigateTo(WorkoutPlanDetailsRoute(id: object.id));
        break;
      default:
        throw Exception(
            'TimelinePostCard._TimelinePostEllipsisMenu: No method defined for ${object.type}.');
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
                  CupertinoIcons.hand_thumbsup_fill,
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
                    inactiveIconData: CupertinoIcons.hand_thumbsup,
                    activeIconData: CupertinoIcons.hand_thumbsup_fill,
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

  Widget _buildTitleCaptionAndTags(
          EnrichedActivity activity, TimelinePostObjectData objectData) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyHeaderText(
                    objectData.object.name,
                    size: FONTSIZE.four,
                    lineHeight: 1.2,
                  ),
                  const SizedBox(height: 4),
                  if (activity.extraData?['caption'] is String)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MyText(
                        activity.extraData?['caption'] as String? ?? '',
                        lineHeight: 1.4,
                        maxLines: 6,
                      ),
                    ),
                  // There are no type checks on the getStream side so we need to defend against anything weird being in this field.
                  if (activity.extraData?['tags'] is List)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: (activity.extraData?['tags'] as List? ?? [])
                            // Ensure we only render strings.
                            .whereType<String>()
                            .map((tag) => MyText(
                                  '#$tag',
                                  color: Styles.primaryAccent,
                                  weight: FontWeight.bold,
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
    final activity = activityWithObjectData.activity;
    final objectData = activityWithObjectData.objectData;
    final authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
    final userIsPoster = authedUserId == objectData?.poster.id;
    final userIsCreator = authedUserId == objectData?.creator.id;
    final originalPostId = activity.extraData?['original_post_id'] as String?;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openDetailsPageByType(context),
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
                    avatarUri: objectData?.creator.avatarUri,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyHeaderText(
                        objectData != null
                            ? objectData.object.type.display
                            : '',
                        size: FONTSIZE.two,
                        lineHeight: 1.3,
                      ),
                      MyText(
                        objectData != null
                            ? 'By ${objectData.creator.displayName}'
                            : '',
                        lineHeight: 1.4,
                        size: FONTSIZE.two,
                      ),
                    ],
                  ),
                ],
              ),
              _TimelinePostEllipsisMenu(
                userIsCreator: userIsCreator,
                userIsPoster: userIsPoster,
                object: objectData!.object,
                poster: objectData.poster,
                creator: objectData.creator,
                handleDeletePost:
                    deleteActivityById != null && activity.id != null
                        ? () => deleteActivityById!(activity.id!)
                        : null,
                openDetailsPage: () => _openDetailsPageByType(context),
              )
            ],
          ),
        ),
        const SizedBox(height: 4),
        if (objectData.object.coverImageUri != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
                height: 200,
                child: SizedUploadcareImage(objectData.object.coverImageUri!)),
          ),
        SizedBox(
          height: 60,
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
                                '${originalPostId != null ? "Re-posted" : "Posted"} by ${objectData.poster.displayName}',
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
        Flexible(child: _buildTitleCaptionAndTags(activity, objectData)),
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
  final TimelinePostObjectDataObject object;
  final TimelinePostObjectDataUser creator;
  final TimelinePostObjectDataUser poster;
  final VoidCallback? handleDeletePost;
  final VoidCallback? openEditPost;
  final VoidCallback openDetailsPage;

  const _TimelinePostEllipsisMenu({
    Key? key,
    required this.object,
    required this.openDetailsPage,
    required this.poster,
    required this.creator,
    this.openEditPost,
    this.handleDeletePost,
    required this.userIsPoster,
    required this.userIsCreator,
  }) : super(key: key);

  void _openUserProfile(BuildContext context, String userId) {
    context.navigateTo(UserPublicProfileDetailsRoute(userId: userId));
  }

  String _genLinkText() {
    switch (object.type) {
      case TimelinePostType.workout:
        return 'workout/${object.id}';

      case TimelinePostType.workoutplan:
        return 'workout-plan/${object.id}';
      default:
        throw Exception(
            'TimelinePostCard._TimelinePostEllipsisMenu._genLinkText: Cannot form alink text for ${object.type}');
    }
  }

  Future<void> _shareObject() async {
    await SharingAndLinking.shareLink(
        _genLinkText(), 'Check out this ${object.type.display}');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: const Icon(CupertinoIcons.ellipsis),
      onPressed: () => openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(
              header: BottomSheetMenuHeader(
                  name: '${object.name} by ${creator.displayName}',
                  subtitle: 'Posted by ${poster.displayName}',
                  imageUri: object.coverImageUri),
              items: [
                BottomSheetMenuItem(
                    text: 'View ${object.type.display}',
                    icon: const Icon(CupertinoIcons.eye),
                    onPressed: openDetailsPage),
                if (!userIsCreator)
                  BottomSheetMenuItem(
                      text: 'View Creator',
                      icon: const Icon(CupertinoIcons.person_crop_rectangle),
                      onPressed: () => _openUserProfile(context, creator.id)),
                if (!userIsPoster)
                  BottomSheetMenuItem(
                      text: 'View Poster',
                      icon: const Icon(CupertinoIcons.person_crop_rectangle),
                      onPressed: () => _openUserProfile(context, poster.id)),
                BottomSheetMenuItem(
                    text: 'Share ${object.type.display} to...',
                    icon: const Icon(CupertinoIcons.paperplane),
                    onPressed: _shareObject),
                if (userIsPoster && handleDeletePost != null)
                  BottomSheetMenuItem(
                      text: 'Delete Post',
                      icon: const Icon(
                        CupertinoIcons.delete_simple,
                        color: Styles.errorRed,
                      ),
                      onPressed: handleDeletePost!,
                      isDestructive: true),
                if (!userIsPoster)
                  BottomSheetMenuItem(
                      text: 'Report',
                      icon: const Icon(
                        CupertinoIcons.exclamationmark_circle,
                        color: Styles.errorRed,
                      ),
                      isDestructive: true,
                      onPressed: () => printLog('report this post')),
              ])),
    );
  }
}
