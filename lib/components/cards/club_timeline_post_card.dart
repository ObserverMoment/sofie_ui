import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';

class ClubTimelinePostCard extends StatelessWidget {
  final TimelinePostFullData postData;
  // Removes interactivity when [true].
  final bool isPreview;

  /// Ensure this is null if the user is NOT a owner or an admin.
  final void Function(TimelinePostFullData post)? deletePost;

  const ClubTimelinePostCard({
    Key? key,
    required this.postData,
    this.isPreview = false,
    this.deletePost,
  }) : super(key: key);

  void _openDetailsPageByType(BuildContext context) {
    if (isPreview) return;

    final object = postData.object;
    switch (object.type) {
      case TimelinePostType.announcement:

        /// Only one of these should ever be present.
        if (Utils.textNotNull(postData.object.videoUri)) {
          VideoSetupManager.openFullScreenVideoPlayer(
              context: context,
              videoUri: postData.object.videoUri!,
              autoPlay: true,
              autoLoop: true,
              title: postData.caption);
        } else if (Utils.textNotNull(postData.object.audioUri)) {
          AudioPlayerController.openAudioPlayer(
              context: context,
              autoPlay: true,
              audioUri: postData.object.audioUri!,
              audioTitle: postData.postedAt.dateAndTime,
              pageTitle: postData.caption ?? 'Announcement');
        } else if (Utils.textNotNull(postData.object.imageUri)) {
          openFullScreenImageViewer(context, postData.object.imageUri!,
              title: postData.caption);
        }

        break;
      case TimelinePostType.workout:
        context.navigateTo(WorkoutDetailsRoute(id: object.id));
        break;
      case TimelinePostType.workoutplan:
        context.navigateTo(WorkoutPlanDetailsRoute(id: object.id));
        break;
      default:
        throw Exception(
            'ClubTimelinePostCard._ClubTimelinePostEllipsisMenu: No method defined for ${postData.object.type}.');
    }
  }

  Widget get _buildMediaDisplay {
    if (postData.object.type == TimelinePostType.announcement) {
      /// Announcement type can display any of the three media types - tapping on an announcement post will open up the media to via - or the description if it is longer than x lines (via [ReadMoreTextBlock])
      if (Utils.textNotNull(postData.object.imageUri)) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
              height: 200,
              child: SizedUploadcareImage(postData.object.imageUri!)),
        );
      }
      if (Utils.textNotNull(postData.object.videoUri) &&
          Utils.textNotNull(postData.object.videoThumbUri)) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                  height: 200,
                  child: SizedUploadcareImage(postData.object.videoThumbUri!)),
            ),
            const Icon(CupertinoIcons.play_fill, size: 60)
          ],
        );
      }
      if (Utils.textNotNull(postData.object.audioUri)) {
        return Column(
          children: const [
            Icon(CupertinoIcons.headphones, size: 60),
            SizedBox(height: 12),
            MyText('Listen')
          ],
        );
      }
    } else {
      /// Other post types only ever show an image - never a video / audio. For these types tapping the post opens up the object details page within the app.
      if (Utils.textNotNull(postData.object.imageUri)) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
              height: 200,
              child: SizedUploadcareImage(postData.object.imageUri!)),
        );
      }
    }

    /// If no valid media is present then return empty container.
    return Container();
  }

  Widget get _buildTitleCaptionAndTags => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  if (postData.object.type != TimelinePostType.announcement)
                    MyHeaderText(
                      postData.object.name,
                      lineHeight: 1.2,
                    ),
                  const SizedBox(height: 4),
                  if (Utils.textNotNull(postData.caption))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child:
                          postData.object.type == TimelinePostType.announcement
                              ? MyHeaderText(postData.caption!, lineHeight: 1.4)
                              : MyText(
                                  postData.caption!,
                                  lineHeight: 1.4,
                                ),
                    ),
                  if (postData.object.type == TimelinePostType.announcement)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ReadMoreTextBlock(
                        text: postData.object.name,
                        trimLines: 6,
                        title: 'Announcement',
                      ),
                    ),
                  if (postData.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: postData.tags
                            .map((tag) => MyText(
                                  '#$tag',
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
    final authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
    final userIsPoster = authedUserId == postData.poster.id;
    final userIsCreator = authedUserId == postData.creator.id;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openDetailsPageByType(context),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserAvatar(
                    size: 40,
                    avatarUri: postData.creator.avatarUri,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          MyHeaderText(
                            postData.object.type.display,
                            size: FONTSIZE.two,
                            lineHeight: 1.3,
                          ),
                          const SizedBox(width: 10),
                          Tag(
                            tag: postData.postedAt.daysAgo,
                            textColor: context.theme.primary,
                            color: context.theme.cardBackground,
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                          )
                        ],
                      ),
                      MyText(
                        'By ${postData.creator.displayName}',
                        lineHeight: 1.4,
                        size: FONTSIZE.two,
                      ),
                    ],
                  ),
                ],
              ),
              if (!isPreview &&
                  postData.object.type != TimelinePostType.announcement)
                _ClubTimelinePostEllipsisMenu(
                  userIsCreator: userIsCreator,
                  userIsPoster: userIsPoster,
                  object: postData.object,
                  poster: postData.poster,
                  creator: postData.creator,
                  handleDeletePost: () => deletePost?.call(postData),
                  openDetailsPage: () => _openDetailsPageByType(context),
                )
            ],
          ),
        ),
        const SizedBox(height: 6),
        _buildMediaDisplay,
        const SizedBox(height: 6),
        Flexible(child: _buildTitleCaptionAndTags),
        HorizontalLine(
            verticalPadding: 0, color: context.theme.primary.withOpacity(0.2))
      ]),
    );
  }
}

class _ClubTimelinePostEllipsisMenu extends StatelessWidget {
  final bool userIsPoster;
  final bool userIsCreator;
  final TimelinePostObjectDataUser poster;
  final TimelinePostObjectDataUser creator;
  final TimelinePostObjectDataObject object;
  final VoidCallback? handleDeletePost;
  final VoidCallback openDetailsPage;
  const _ClubTimelinePostEllipsisMenu({
    Key? key,
    required this.object,
    required this.openDetailsPage,
    required this.poster,
    required this.creator,
    this.handleDeletePost,
    required this.userIsPoster,
    required this.userIsCreator,
  }) : super(key: key);

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
                  imageUri: object.imageUri),
              items: [
                BottomSheetMenuItem(
                    text: 'View ${object.type.display}',
                    icon: CupertinoIcons.eye,
                    onPressed: openDetailsPage),
                if (userIsPoster && handleDeletePost != null)
                  BottomSheetMenuItem(
                      text: 'Delete Post',
                      icon: CupertinoIcons.delete_simple,
                      onPressed: handleDeletePost!,
                      isDestructive: true),
                // if (!userIsPoster)
                //   BottomSheetMenuItem(
                //       text: 'Report',
                //       icon: const Icon(
                //         CupertinoIcons.exclamationmark_circle,
                //         color: Styles.errorRed,
                //       ),
                //       isDestructive: true,
                //       onPressed: () => printLog('report this post')),
              ])),
    );
  }
}
