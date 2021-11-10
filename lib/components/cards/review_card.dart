import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutPlanReviewCard extends StatelessWidget {
  final WorkoutPlanReview review;
  const WorkoutPlanReviewCard({Key? key, required this.review})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    UserAvatar(
                      avatarUri: review.user.avatarUri,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MyText(review.user.displayName),
                  ],
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: review.score,
                      itemBuilder: (context, index) => const Icon(
                        CupertinoIcons.star_fill,
                        color: Styles.secondaryAccent,
                      ),
                      unratedColor: Styles.secondaryAccent.withOpacity(0.2),
                      itemSize: 20,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    CircularBox(
                      border: true,
                      padding: const EdgeInsets.all(7),
                      child: MyText(
                        review.score.stringMyDouble(),
                        color: context.theme.primary,
                        lineHeight: 1.05,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (Utils.textNotNull(review.comment))
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MyText(
                review.comment!,
                lineHeight: 1.4,
                maxLines: 5,
                textAlign: TextAlign.center,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyText(
                review.createdAt.compactDateString,
                size: FONTSIZE.one,
                subtext: true,
              )
            ],
          )
        ],
      ),
    );
  }
}
