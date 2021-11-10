import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout/workout_set_minimal_display.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class NowAndNextMoves extends StatelessWidget {
  final WorkoutSection workoutSection;

  /// How many moves do you want to display.
  final int qty;

  final bool center;

  const NowAndNextMoves({
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
        ImplicitlyAnimatedList<WorkoutSet>(
            shrinkWrap: true,
            items: nowAndNextSets.whereType<WorkoutSet>().toList(),
            itemBuilder: (context, animation, workoutSet, index) =>
                SizeFadeTransition(
                  animation: animation,
                  sizeFraction: 0.7,
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: center
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        WorkoutSetMinimalDisplay(
                          backgroundColor:
                              context.theme.cardBackground.withOpacity(0.65),
                          workoutSet: workoutSet,
                          workoutSectionType: workoutSection.workoutSectionType,
                          elevation: 1,
                          displayLoad: false,
                          textSize: FONTSIZE.four,
                        ),
                      ],
                    ),
                  ),
                ),
            areItemsTheSame: (a, b) => a == b),
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

    // return Wrap(
    //   spacing: 12,
    //   runSpacing: 12,
    //   alignment: WrapAlignment.spaceBetween,
    //   children: [
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const Padding(
    //           padding: EdgeInsets.only(left: 3.0, bottom: 6),
    //           child: MyText('Now'),
    //         ),
    //         ActiveSetDisplay(
    //           offset: 0,
    //           sectionIndex: workoutSection.sortPosition,
    //           workoutSectionType: workoutSection.workoutSectionType,
    //         ),
    //       ],
    //     ),
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const Padding(
    //           padding: EdgeInsets.only(left: 3.0, bottom: 6),
    //           child: MyText('Next'),
    //         ),
    //         ActiveSetDisplay(
    //           offset: 1,
    //           sectionIndex: workoutSection.sortPosition,
    //           workoutSectionType: workoutSection.workoutSectionType,
    //         ),
    //       ],
    //     )
    //   ],
    // );
  }
}
