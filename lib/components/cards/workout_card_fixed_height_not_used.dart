import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

/// For use in horizontal scrolling lists.
class WorkoutCardFixedHeight extends StatelessWidget {
  final Workout workout;
  final int? elevation;
  final EdgeInsets padding;
  final double height;

  const WorkoutCardFixedHeight(
    this.workout, {
    Key? key,
    this.elevation,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    this.height = 230.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> allTags = [
      ...workout.workoutGoals.map((g) => g.name),
      ...workout.workoutTags.map((t) => t.tag)
    ];

    // Calc the ideal image size based on the display size.
    // Cards usually take up the full width.
    // // Making the raw requested image larger than the display space - otherwise it seems to appear blurred. More investigation required.
    final double width = MediaQuery.of(context).size.width;
    final Dimensions dimensions = Dimensions.square((width * 1.5).toInt());
    final Color contentOverlayColor =
        Styles.black.withOpacity(kImageOverlayOpacity);

    /// The lower section seems to need to have a border radius of one lower than that of the whole card to avoid a small peak of the underlying image - why does the corner get cut by 1 px?
    const borderRadius = 8.0;
    const infoFontColor = Styles.white;

    return Card(
      elevation: 2,
      height: height,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(borderRadius),
      backgroundImage: DecorationImage(
          fit: BoxFit.cover,
          image: Utils.textNotNull(workout.coverImageUri)
              ? UploadcareImageProvider(workout.coverImageUri!,
                  transformations: [PreviewTransformation(dimensions)])
              : const AssetImage(
                  'assets/placeholder_images/workout.jpg',
                ) as ImageProvider),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (workout.lengthMinutes != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: DurationTag(
                              duration:
                                  Duration(minutes: workout.lengthMinutes!),
                              backgroundColor: contentOverlayColor,
                              textColor: infoFontColor,
                            ),
                          ),
                        if (workout.difficultyLevel != null)
                          DifficultyLevelTag(
                            difficultyLevel: workout.difficultyLevel!,
                            fontSize: FONTSIZE.one,
                            backgroundColor: contentOverlayColor,
                            textColor: infoFontColor,
                          ),
                      ],
                    ),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyHeaderText(
                            workout.name,
                            lineHeight: 1.3,
                            color: infoFontColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (workout.workoutSections.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: workout.workoutSections
                          .sortedBy<num>((section) => section.sortPosition)
                          .mapIndexed((i, section) =>
                              i == workout.workoutSections.length - 1
                                  ? WorkoutSectionTypeTag(
                                      workoutSection: section,
                                      elevation: 0,
                                      withBackground: false,
                                      fontColor: infoFontColor,
                                      fontSize: FONTSIZE.three)
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WorkoutSectionTypeTag(
                                          workoutSection: section,
                                          elevation: 0,
                                          fontSize: FONTSIZE.three,
                                          fontColor: infoFontColor,
                                          withBackground: false,
                                        ),
                                        const MyText(' |', color: infoFontColor)
                                      ],
                                    ))
                          .toList(),
                    ),
                  ),
                if (allTags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CommaSeparatedList(
                      allTags,
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
