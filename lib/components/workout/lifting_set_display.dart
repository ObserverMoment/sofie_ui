import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:collection/collection.dart';

/// [LiftingSetHeaderDisplay] and [LiftingSetDetailsDisplay] for each of [workoutSet.workoutMoves].
class LiftingSetDisplay extends StatelessWidget {
  final WorkoutSet workoutSet;
  const LiftingSetDisplay({Key? key, required this.workoutSet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          workoutSet.workoutMoves.isNotEmpty
              ? LiftingSetHeaderDisplay(
                  workoutMove: workoutSet.workoutMoves[0],
                )
              : const MyText(' - '),
          LiftingSetDetailsDisplay(
            workoutSet: workoutSet,
          ),
        ],
      ),
    );
  }
}

/// Displays just the move name and equipment.
class LiftingSetHeaderDisplay extends StatelessWidget {
  final WorkoutMove workoutMove;
  const LiftingSetHeaderDisplay({Key? key, required this.workoutMove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyText(
          workoutMove.move.name,
        ),
        if (workoutMove.equipment != null)
          MyText(
            workoutMove.equipment!.name,
            color: Styles.primaryAccent,
            lineHeight: 1.5,
          ),
      ],
    );
  }
}

class LiftingSetDetailsDisplay extends StatelessWidget {
  final WorkoutSet workoutSet;
  const LiftingSetDetailsDisplay({Key? key, required this.workoutSet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedWorkoutMoves =
        workoutSet.workoutMoves.sortedBy<num>((wm) => wm.sortPosition);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4),
      child: Column(
        children: sortedWorkoutMoves
            .mapIndexed((i, wm) => Column(
                  children: [
                    LiftingWorkoutMoveDetailsDisplay(
                      workoutMove: wm,
                    ),
                    if (i != sortedWorkoutMoves.length - 1)
                      const HorizontalLine()
                  ],
                ))
            .toList(),
      ),
    );
  }
}

/// Displays reps and load for a workout move within a [Lifting] set.
class LiftingWorkoutMoveDetailsDisplay extends StatelessWidget {
  final WorkoutMove workoutMove;
  const LiftingWorkoutMoveDetailsDisplay({Key? key, required this.workoutMove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: context.theme.primary.withOpacity(0.3)))),
            child: MyText(
              '${workoutMove.sortPosition + 1}',
              size: FONTSIZE.two,
              subtext: true,
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyText(
                  workoutMove.reps.round().toString(),
                  size: FONTSIZE.four,
                ),
                const SizedBox(width: 4),
                const MyText(
                  'reps',
                  size: FONTSIZE.two,
                ),
              ],
            ),
          ),
          if (workoutMove.equipment != null &&
              !workoutMove.equipment!.isBodyweight)
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyText(
                    workoutMove.loadAmount.stringMyDouble(),
                    size: FONTSIZE.four,
                  ),
                  const SizedBox(width: 4),
                  MyText(
                    workoutMove.loadUnit.display,
                    size: FONTSIZE.two,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
