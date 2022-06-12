import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout/workout_set_display.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:provider/provider.dart';

class NowAndNextMovesTimer extends StatelessWidget {
  final WorkoutSection workoutSection;

  /// How many moves do you want to display.
  final int qty;

  final bool center;

  const NowAndNextMovesTimer({
    Key? key,
    required this.workoutSection,
    this.qty = 3,
    this.center = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nowAndNextSets = context.select<DoWorkoutBloc, List<WorkoutSet?>>(
        (b) => b.getNowAndNextSetsForSection(workoutSection.sortPosition, qty));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ImplicitlyAnimatedList<WorkoutSet>(
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     items: nowAndNextSets.whereType<WorkoutSet>().toList(),
        //     itemBuilder: (context, animation, workoutSet, index) =>
        //         SizeFadeTransition(
        //           animation: animation,
        //           sizeFraction: 0.7,
        //           curve: Curves.easeInOut,
        //           child: Padding(
        //             padding: const EdgeInsets.only(bottom: 4.0),
        //             child: WorkoutSetDisplay(
        //               workoutSet: workoutSet,
        //               workoutSectionType: workoutSection.workoutSectionType,
        //             ),
        //           ),
        //         ),
        //     areItemsTheSame: (a, b) => a == b),
        if (nowAndNextSets.contains(null))
          Padding(
            padding:
                EdgeInsets.only(top: 8.0, bottom: 6, left: !center ? 10 : 0),
            child: Row(
              mainAxisAlignment:
                  center ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: const [
                MyHeaderText(
                  'Finish',
                  size: FONTSIZE.seven,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
