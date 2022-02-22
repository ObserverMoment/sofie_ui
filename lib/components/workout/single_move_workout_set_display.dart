import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/utils.dart';

/// A more compact workout set display UI for when the user is doing multiple repeats of the same workoutMove.
/// Based on DoWorkout Lifting session moves list design.
class SingleMoveWorkoutSetDisplay extends StatelessWidget {
  final WorkoutSet workoutSet;
  final WorkoutSectionType workoutSectionType;
  final bool scrollable;
  final EdgeInsets padding;
  const SingleMoveWorkoutSetDisplay(
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

    /// All workout moves should be the same so just use the first one.
    final templateWorkoutMove = sortedMoves.isNotEmpty ? sortedMoves[0] : null;

    return ContentBox(
      padding: padding,
      child: templateWorkoutMove == null
          ? const MyText('No sets specified...')
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push(
                  fullscreenDialog: true,
                  child: MoveDetails(templateWorkoutMove.move)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          MyText(
                            templateWorkoutMove.move.name,
                          ),
                          if (workoutSectionType.isCustom)
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: MyText(
                                  '(${templateWorkoutMove.repDisplay.capitalize})'),
                            )
                        ],
                      ),
                      if (templateWorkoutMove.equipment != null)
                        MyText(
                          templateWorkoutMove.equipment!.name,
                          color: Styles.primaryAccent,
                          lineHeight: 1.2,
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: sortedMoves
                          .map((wm) => _WorkoutMoveInSingleMoveSet(
                                workoutMove: wm,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _WorkoutMoveInSingleMoveSet extends StatelessWidget {
  final WorkoutMove workoutMove;

  const _WorkoutMoveInSingleMoveSet({
    Key? key,
    required this.workoutMove,
  }) : super(key: key);

  /// Copied from [WorkoutMoveDisplay].
  Widget _buildRepDisplay() {
    return Row(
      children: [
        MyText(
          workoutMove.reps.stringMyDouble(),
          lineHeight: 1.1,
          size: FONTSIZE.four,
        ),
        const SizedBox(width: 3),
        MyText(
          workoutMove.repDisplay,
          size: FONTSIZE.three,
        ),
      ],
    );
  }

  Widget _buildLoadDisplay() {
    return Row(
      children: [
        MyText(
          workoutMove.loadAmount.stringMyDouble(),
          lineHeight: 1.1,
          size: FONTSIZE.four,
        ),
        const SizedBox(width: 3),
        MyText(
          workoutMove.loadUnit.display,
          size: FONTSIZE.three,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showLoad = Utils.hasLoad(workoutMove.loadAmount) &&
        (workoutMove.equipment != null &&
                workoutMove.equipment!.loadAdjustable ||
            workoutMove.move.requiredEquipments.isNotEmpty &&
                workoutMove.move.requiredEquipments
                    .any((e) => e.loadAdjustable));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.only(right: 8),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      color: context.theme.primary.withOpacity(0.3)))),
          child: MyText(
            '${workoutMove.sortPosition + 1}',
            size: FONTSIZE.one,
            subtext: true,
          ),
        ),
        ContentBox(
          backgroundColor: context.theme.background.withOpacity(0.6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRepDisplay(),
              if (showLoad)
                const MyText(
                  ' @ ',
                  size: FONTSIZE.two,
                  subtext: true,
                ),
              if (showLoad) _buildLoadDisplay(),
            ],
          ),
        ),
      ],
    );
  }
}
