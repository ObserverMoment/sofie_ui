import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';

class WorkoutPlanReviewsSummary extends StatelessWidget {
  final double starSize;
  final int starCount;
  final double reviewScore;
  final int reviewCount;
  final Color? textColor;
  const WorkoutPlanReviewsSummary(
      {Key? key,
      this.starSize = 18,
      this.starCount = 5,
      this.textColor,
      required this.reviewScore,
      required this.reviewCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reviewCount == 0
        ? MyText(
            'No reviews yet',
            subtext: true,
            size: FONTSIZE.two,
            color: textColor,
          )
        : Column(
            children: [
              Row(
                children: [
                  RatingBarIndicator(
                    rating: reviewScore,
                    itemBuilder: (context, index) => const Icon(
                      CupertinoIcons.star_fill,
                      color: Styles.secondaryAccent,
                    ),
                    unratedColor: Styles.secondaryAccent.withOpacity(0.15),
                    itemCount: starCount,
                    itemSize: starSize,
                  ),
                ],
              ),
              MyText('from $reviewCount reviews',
                  size: FONTSIZE.one, lineHeight: 1.5, color: textColor)
            ],
          );
  }
}
