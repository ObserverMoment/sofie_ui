import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_post_comments.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class FeedPostReactions extends StatelessWidget {
  final bool isPreview;
  final bool userIsPoster;
  final StreamEnrichedActivity activity;
  final VoidCallback? likeUnlikePost;
  final bool userHasLiked;
  const FeedPostReactions(
      {Key? key,
      required this.isPreview,
      required this.activity,
      this.likeUnlikePost,
      required this.userHasLiked,
      required this.userIsPoster})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentsCount = activity.reactionCounts?.comments ?? 0;
    final likesCount = activity.reactionCounts?.likes ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (!userIsPoster)
              LikeReactionButton(
                isActive: userHasLiked,
                isPreview: isPreview,
                inactiveIconData: CupertinoIcons.heart,
                activeIconData: CupertinoIcons.heart_fill,
                onPressed: likeUnlikePost,
              ),
            CommentReactionButton(
              isPreview: isPreview,
              iconData: CupertinoIcons.chat_bubble,
              onPressed: () => context.push(
                  child: FeedPostComments(
                activity: activity,
              )),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 4),
          child: MyText(
            '$likesCount likes',
            subtext: true,
            size: FONTSIZE.two,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 5),
          child: MyText(
            '$commentsCount comments',
            size: FONTSIZE.two,
            subtext: true,
          ),
        ),
      ],
    );
  }
}

class LikeReactionButton extends StatelessWidget {
  final IconData inactiveIconData;
  final IconData activeIconData;
  final VoidCallback? onPressed;
  final bool isPreview;
  final bool isActive;
  const LikeReactionButton({
    Key? key,
    required this.inactiveIconData,
    required this.activeIconData,
    required this.onPressed,
    required this.isPreview,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        onPressed: isPreview ? null : onPressed,
        child: AnimatedSwitcher(
          duration: kStandardAnimationDuration,
          child: isActive
              ? Icon(
                  activeIconData,
                  color: Styles.heartRed,
                )
              : Icon(
                  inactiveIconData,
                ),
        ));
  }
}

class CommentReactionButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  final bool isPreview;
  const CommentReactionButton({
    Key? key,
    required this.onPressed,
    required this.isPreview,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        onPressed: isPreview ? null : onPressed,
        child: Icon(
          iconData,
        ));
  }
}
