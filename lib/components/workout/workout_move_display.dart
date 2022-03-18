import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutMoveDisplay extends StatelessWidget {
  final WorkoutMove workoutMove;

  /// Don't show reps when the set is timed because the user just repeats the move for workoutSet.duration. UNLESS there are more than one move and then the user loops around these two moves for workoutSet.duration - which means you need to know how much of each move to do before moving onto the next.
  final bool showReps;
  final bool showMoveNumber;
  const WorkoutMoveDisplay(
    this.workoutMove, {
    Key? key,
    this.showReps = true,
    this.showMoveNumber = true,
  }) : super(key: key);

  Widget _buildRepDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MyText(
          workoutMove.reps.stringMyDouble(),
          lineHeight: 1.1,
          size: FONTSIZE.four,
        ),
        const SizedBox(width: 3),
        MyText(
          workoutMove.repDisplay,
          size: FONTSIZE.two,
        ),
      ],
    );
  }

  Widget _buildLoadDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MyText(
          workoutMove.loadAmount.stringMyDouble(),
          lineHeight: 1.1,
          size: FONTSIZE.four,
        ),
        const SizedBox(width: 3),
        MyText(
          workoutMove.loadUnit.display,
          size: FONTSIZE.two,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showLoad = workoutMove.loadAdjustable;
    final hasRepsOrLoad = showReps || showLoad;

    return SizedBox(
      height: 38,
      child: Row(
        mainAxisAlignment: hasRepsOrLoad
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          if (showMoveNumber)
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                workoutMove.move.name,
                size: FONTSIZE.two,
              ),
              if (Utils.textNotNull(workoutMove.equipment?.name))
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: MyText(workoutMove.equipment!.name,
                      size: FONTSIZE.one, color: Styles.primaryAccent),
                ),
            ],
          ),
          if (hasRepsOrLoad)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  showLoad ? _buildLoadDisplay() : Container(),
                  SizedBox(
                      width: 90,
                      child: showReps ? _buildRepDisplay() : Container()),
                ],
              ),
            )
        ],
      ),
    );
  }
}
