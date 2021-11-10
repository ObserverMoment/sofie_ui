import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout/workout_set_display_header.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_model_converters/workout_to_logged_workout.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';

/// Details of a workout set in a compact a format as possible.
class WorkoutSetMinimalDisplay extends StatelessWidget {
  final WorkoutSet workoutSet;
  final WorkoutSectionType workoutSectionType;
  final Color? backgroundColor;
  final int? elevation;
  final bool displayEquipment;
  final bool displayLoad;
  final FONTSIZE textSize;
  const WorkoutSetMinimalDisplay(
      {Key? key,
      required this.workoutSet,
      required this.workoutSectionType,
      this.backgroundColor,
      this.elevation = 1,
      this.displayEquipment = true,
      this.displayLoad = true,
      this.textSize = FONTSIZE.three})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              WorkoutSetDisplayHeader(
                workoutSectionType: workoutSectionType,
                workoutSet: workoutSet,
              ),
            ],
          ),
          if (!workoutSet.isRestSet)
            ...workoutSet.workoutMoves
                .map((wm) => MyText(
                    generateWorkoutMoveString(
                        workoutSet: workoutSet,
                        workoutMove: wm,
                        workoutSectionType: workoutSectionType,
                        displayEquipment: displayEquipment,
                        displayLoad: displayLoad),
                    lineHeight: 1.4,
                    size: textSize))
                .toList()
        ],
      ),
    );
  }
}
