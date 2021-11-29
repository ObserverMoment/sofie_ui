import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/data_vis/percentage_bar_chart.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_reviews_summary.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class WorkoutPlanCard extends StatelessWidget {
  final WorkoutPlanSummary workoutPlan;
  final Color? backgroundColor;
  final int? elevation;

  const WorkoutPlanCard(
    this.workoutPlan, {
    Key? key,
    this.backgroundColor,
    this.elevation,
  }) : super(key: key);

  Widget _buildContentSummary(
          BuildContext context, Color contentOverlayColor) =>
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: contentOverlayColor),
        child: Row(
          children: [
            MyText(
              '${workoutPlan.lengthWeeks} weeks',
              size: FONTSIZE.two,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Dot(
                diameter: 4,
              ),
            ),
            MyText(
              '${workoutPlan.daysPerWeek} days / week',
              size: FONTSIZE.two,
            ),
          ],
        ),
      );

  Widget _buildEnrolledCount(BuildContext context, Color contentOverlayColor) =>
      workoutPlan.enrolmentsCount > 0
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: contentOverlayColor),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.person_add, size: 14),
                      const SizedBox(width: 2),
                      MyText(
                        workoutPlan.enrolmentsCount.displayLong,
                      ),
                    ],
                  ),
                  const MyText(
                    'enrolled',
                    size: FONTSIZE.one,
                  ),
                ],
              ),
            )
          : Container();

  @override
  Widget build(BuildContext context) {
    // Calc the ideal image size based on the display size.
    // Cards usually take up the full width.
    // // Making the raw requested image larger than the display space - otherwise it seems to appear blurred. More investigation required.
    final double width = MediaQuery.of(context).size.width;
    Dimensions dimensions = Dimensions.square((width * 1.5).toInt());

    // final planDifficulty = workoutPlan.calcDifficulty;
    const overlayContentPadding =
        EdgeInsets.symmetric(vertical: 4, horizontal: 8);
    final Color contentOverlayColor =
        Styles.black.withOpacity(kImageOverlayOpacity);

    /// The lower section seems to need to have a border radius of one lower than that of the whole card to avoid a small peak of the underlying image - why does the corner get cut by 1 px?
    const borderRadius = 8.0;
    const infoFontColor = Styles.white;

    return Card(
        backgroundColor: backgroundColor,
        elevation: 2,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(borderRadius),
        backgroundImage: DecorationImage(
            fit: BoxFit.cover,
            image: Utils.textNotNull(workoutPlan.coverImageUri)
                ? UploadcareImageProvider(workoutPlan.coverImageUri!,
                    transformations: [PreviewTransformation(dimensions)])
                : const AssetImage(
                    'assets/placeholder_images/plan.jpg',
                  ) as ImageProvider),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 130,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContentSummary(context, contentOverlayColor),
                      if (workoutPlan.enrolmentsCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child:
                              _buildEnrolledCount(context, contentOverlayColor),
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (workoutPlan.reviewCount > 0)
                        ContentBox(
                          backgroundColor: contentOverlayColor,
                          padding: overlayContentPadding,
                          borderRadius: 4,
                          child: WorkoutPlanReviewsSummary(
                            starSize: 14,
                            textColor: infoFontColor,
                            reviewCount: workoutPlan.reviewCount,
                            reviewScore: workoutPlan.reviewScore ?? 0,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  color: Styles.black.withOpacity(kImageOverlayOpacity),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius))),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyHeaderText(
                            workoutPlan.name,
                            lineHeight: 1.3,
                            color: infoFontColor,
                          ),
                          const SizedBox(height: 3),
                          MyText(
                            workoutPlan.user.displayName.toUpperCase(),
                            size: FONTSIZE.two,
                            lineHeight: 1.4,
                            color: infoFontColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (Utils.textNotNull(workoutPlan.description))
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: MyText(
                        workoutPlan.description!,
                        subtext: true,
                      ),
                    ),
                  if (workoutPlan.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CommaSeparatedList(workoutPlan.tags,
                          textColor: Styles.secondaryAccent),
                    ),
                  if (workoutPlan.goals.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: PercentageBarChartSingle(
                        inputs: DataUtils.waffleChartInputsFromGoals(
                            workoutPlan.goals),
                        barHeight: 4,
                        textColor: infoFontColor,
                      ),
                    ),
                ],
              ))
        ]));
  }
}
