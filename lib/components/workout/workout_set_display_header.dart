import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/workout_set_creator/workout_set_definition.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Builds a header for instructions for the set based on the section type and attributes.
class WorkoutSetDisplayHeader extends StatelessWidget {
  final WorkoutSectionType workoutSectionType;
  final WorkoutSet workoutSet;
  const WorkoutSetDisplayHeader(
      {Key? key, required this.workoutSet, required this.workoutSectionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMultiMoveSet = workoutSet.isMultiMoveSet;

    final showRoundOrTimeInfo =
        workoutSet.isRestSet || workoutSectionType.isTimed;

    final bool definitionRequired = workoutSet.isRestSet ||
        (isMultiMoveSet && workoutSet.workoutMoves.length > 1);

    return showRoundOrTimeInfo || definitionRequired
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                if (showRoundOrTimeInfo)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: MyText(
                      'For ${workoutSet.duration.secondsToTimeDisplay}',
                      lineHeight: 1,
                    ),
                  ),
                if (definitionRequired)
                  WorkoutSetDefinition(workoutSet: workoutSet)
              ],
            ),
          )
        : Container();
  }
}
