import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/components/workout/workout_move_display.dart';
import 'package:sofie_ui/components/workout/workout_set_display_header.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';

class WorkoutSetDisplay extends StatelessWidget {
  final WorkoutSet workoutSet;
  final WorkoutSectionType workoutSectionType;
  final bool scrollable;
  final EdgeInsets padding;
  const WorkoutSetDisplay(
      {Key? key,
      required this.workoutSet,
      required this.workoutSectionType,
      this.scrollable = false,
      this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 8)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<WorkoutMove> sortedMoves =
        workoutSet.workoutMoves.sortedBy<num>((wm) => wm.sortPosition);

    final showReps = workoutSectionType.showReps(workoutSet);

    return ContentBox(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutSetDisplayHeader(
            workoutSet: workoutSet,
            workoutSectionType: workoutSectionType,
          ),
          if (sortedMoves.isNotEmpty && !workoutSet.isRestSet)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: sortedMoves
                    .map((wm) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => context.push(
                              fullscreenDialog: true,
                              child: MoveDetails(wm.move)),
                          child: WorkoutMoveDisplay(
                            wm,
                            showReps: showReps,
                          ),
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
