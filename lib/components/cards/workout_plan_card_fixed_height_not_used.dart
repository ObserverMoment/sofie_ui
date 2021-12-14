import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/data_vis/percentage_bar_chart.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class WorkoutPlanCardFixedHeight extends StatelessWidget {
  final WorkoutPlan workoutPlan;
  final Color? backgroundColor;
  final int? elevation;
  final double height;

  const WorkoutPlanCardFixedHeight(
    this.workoutPlan, {
    Key? key,
    this.backgroundColor,
    this.elevation,
    this.height = 250,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allTags = workoutPlan.workoutTags.map((t) => t.tag).toList();

    // Calc the ideal image size based on the display size.
    // Cards usually take up the full width.
    // // Making the raw requested image larger than the display space - otherwise it seems to appear blurred. More investigation required.
    final double width = MediaQuery.of(context).size.width;
    Dimensions dimensions = Dimensions.square((width * 1.5).toInt());

    final planDifficulty = workoutPlan.calcDifficulty;
    final Color contentOverlayColor =
        Styles.black.withOpacity(kImageOverlayOpacity);

    /// The lower section seems to need to have a border radius of one lower than that of the whole card to avoid a small peak of the underlying image - why does the corner get cut by 1 px?
    const borderRadius = 8.0;
    const infoFontColor = Styles.white;

    return Card(
        backgroundColor: backgroundColor,
        elevation: 2,
        height: height,
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (planDifficulty != null)
                          DifficultyLevelTag(
                            difficultyLevel: planDifficulty,
                            fontSize: FONTSIZE.one,
                            backgroundColor: contentOverlayColor,
                            textColor: infoFontColor,
                          ),
                        // if (workoutPlan.workoutPlanReviews.isNotEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 6.0),
                        //     child: ContentBox(
                        //       backgroundColor: contentOverlayColor,
                        //       padding: overlayContentPadding,
                        //       borderRadius: 4,
                        //       child: WorkoutPlanReviewsSummary(
                        //         reviews: workoutPlan.workoutPlanReviews,
                        //         itemSize: 14,
                        //         textColor: infoFontColor,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Styles.black.withOpacity(kImageOverlayOpacity),
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(borderRadius),
                          bottomLeft: Radius.circular(borderRadius))),
                  padding: const EdgeInsets.all(10),
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
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            MyText(
                              workoutPlan.lengthString.toUpperCase(),
                              size: FONTSIZE.two,
                              color: infoFontColor,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Dot(
                                diameter: 4,
                                color: infoFontColor,
                              ),
                            ),
                            MyText(
                              '${workoutPlan.workoutPlanDays.length} workouts'
                                  .toUpperCase(),
                              size: FONTSIZE.two,
                              color: infoFontColor,
                            ),
                          ],
                        ),
                      ),
                      if (allTags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CommaSeparatedList(allTags,
                              textColor: Styles.secondaryAccent),
                        ),
                      if (workoutPlan.workoutPlanDays.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: PercentageBarChartSingle(
                            inputs: workoutPlan.waffleChartInputs,
                            textColor: infoFontColor,
                            hideBar: true,
                            lengendAlignment: WrapAlignment.start,
                          ),
                        ),
                    ],
                  ))
            ]));
  }
}
