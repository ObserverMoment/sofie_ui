import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

/// No background image and more compact - for displaying in a plan schedule list.
/// Title and equipment are on the top - tags on the bottom.
class MinimalWorkoutCard extends StatelessWidget {
  final WorkoutSummary workout;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final bool showEquipment;

  const MinimalWorkoutCard(
    this.workout, {
    Key? key,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.showEquipment = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      padding: padding,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ClipRRect(
              borderRadius: kStandardCardBorderRadius,
              child: SizedBox(
                  height: 80,
                  width: 90,
                  child: Utils.textNotNull(workout.coverImageUri)
                      ? SizedUploadcareImage(workout.coverImageUri!)
                      : Image.asset(
                          'assets/placeholder_images/workout.jpg',
                          fit: BoxFit.cover,
                        )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (workout.lengthMinutes != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(CupertinoIcons.timer, size: 15),
                                const SizedBox(width: 4),
                                MyText(
                                  Duration(minutes: workout.lengthMinutes!)
                                      .displayString,
                                ),
                              ],
                            ),
                          ),
                        if (workout.difficultyLevel != null)
                          DifficultyLevelDot(
                              difficultyLevel: workout.difficultyLevel!,
                              size: 12),
                      ],
                    ),
                    const SizedBox(height: 8),
                    MyHeaderText(
                      workout.name,
                      size: FONTSIZE.two,
                    ),
                    if (workout.tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: CommaSeparatedList(
                          workout.tags,
                        ),
                      ),
                    if (showEquipment && workout.equipments.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: CommaSeparatedList(
                          workout.equipments,
                        ),
                      ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
