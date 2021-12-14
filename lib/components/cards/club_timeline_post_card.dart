import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
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
    final object = postData.object;
    switch (object.type) {
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

  Widget _buildTitleCaptionAndTags() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  MyHeaderText(
                    postData.object.name,
                    lineHeight: 1.2,
                  ),
                  const SizedBox(height: 4),
                  if (Utils.textNotNull(postData.caption))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MyText(
                        postData.caption!,
                        lineHeight: 1.4,
                        maxLines: 6,
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
    final authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
    final userIsPoster = authedUserId == postData.poster.id;
    final userIsCreator = authedUserId == postData.creator.id;

    return GestureDetector(
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
                    avatarUri: postData.creator.avatarUri,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
        if (postData.object.coverImageUri != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
                height: 200,
                child: SizedUploadcareImage(postData.object.coverImageUri!)),
          ),
        const SizedBox(height: 6),
        Flexible(child: _buildTitleCaptionAndTags()),
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
                  imageUri: object.coverImageUri),
              items: [
                BottomSheetMenuItem(
                    text: 'View ${object.type.display}',
                    icon: const Icon(CupertinoIcons.eye),
                    onPressed: openDetailsPage),
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
