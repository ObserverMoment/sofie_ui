import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout/selectable_workout_card.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';

/// A list of standard cards if [selectWorkout] is not provided.
/// A list of [WorkoutCard ContextMenus] if it is.
class VerticalWorkoutsList extends StatelessWidget {
  final List<WorkoutSummary> workouts;
  final void Function(WorkoutSummary workout)? selectWorkout;
  final bool scrollable;
  final bool avoidBottomNavBar;

  /// If no specified one will be auto generated based on workout plan ID.
  /// If the same workout appears more than once in a list - or across an indexed stack then this
  /// will cause 'multiple heroes' exception. Use [heroTagKey] to ensure uniqueness.
  final String? heroTagKey;

  const VerticalWorkoutsList(
      {Key? key,
      required this.workouts,
      this.selectWorkout,
      this.scrollable = true,
      this.heroTagKey,
      this.avoidBottomNavBar = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return workouts.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: MyText(
                'No workouts to display',
                subtext: true,
              ),
            ))
        : ImplicitlyAnimatedList<WorkoutSummary>(
            padding: avoidBottomNavBar
                ? EdgeInsets.only(bottom: EnvironmentConfig.bottomNavBarHeight)
                : null,
            shrinkWrap: true,
            physics: scrollable ? null : const NeverScrollableScrollPhysics(),
            items: workouts
                .sortedBy<DateTime>((w) => w.createdAt)
                .reversed
                .toList(),
            itemBuilder: (context, animation, WorkoutSummary workout, i) =>
                SizeFadeTransition(
                  sizeFraction: 0.7,
                  curve: Curves.easeInOut,
                  animation: animation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: SelectableWorkoutCard(
                      index: i,
                      workout: workout,
                      selectWorkout: selectWorkout,
                      heroTagKey: heroTagKey,
                    ),
                  ),
                ),
            areItemsTheSame: (a, b) => a == b);
  }
}
