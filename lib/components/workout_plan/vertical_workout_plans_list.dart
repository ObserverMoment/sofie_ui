import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout_plan/selectable_workout_plan_card.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';

/// A list of standard cards if [selectWorkoutPlan] is not provided.
/// A list of [WorkoutPlanCard ContextMenus] if it is.
class VerticalWorkoutPlansList extends StatelessWidget {
  final List<WorkoutPlanSummary> workoutPlans;
  final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;
  final bool scrollable;
  final bool avoidBottomNavBar;

  /// If no specified one will be auto generated based on workoutPlan plan ID.
  /// If the same workoutPlan appears more than once in a list - or across an indexed stack then this
  /// will cause 'multiple heroes' exception. Use [heroTagKey] to ensure uniqueness.
  final String? heroTagKey;

  final Widget? emptyListPlaceholder;

  const VerticalWorkoutPlansList(
      {Key? key,
      required this.workoutPlans,
      this.selectWorkoutPlan,
      this.scrollable = true,
      this.heroTagKey,
      this.avoidBottomNavBar = false,
      this.emptyListPlaceholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return workoutPlans.isEmpty
        ? emptyListPlaceholder ??
            const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: MyText(
                    'No plans to display',
                    subtext: true,
                  ),
                ))
        : ImplicitlyAnimatedList<WorkoutPlanSummary>(
            padding: avoidBottomNavBar
                ? EdgeInsets.only(bottom: EnvironmentConfig.bottomNavBarHeight)
                : null,
            shrinkWrap: true,
            physics: scrollable ? null : const NeverScrollableScrollPhysics(),
            items: workoutPlans
                .sortedBy<DateTime>((w) => w.createdAt)
                .reversed
                .toList(),
            itemBuilder:
                (context, animation, WorkoutPlanSummary workoutPlan, i) =>
                    SizeFadeTransition(
                      sizeFraction: 0.7,
                      curve: Curves.easeInOut,
                      animation: animation,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: SelectableWorkoutPlanCard(
                          index: i,
                          workoutPlan: workoutPlan,
                          selectWorkoutPlan: selectWorkoutPlan,
                          heroTagKey: heroTagKey,
                        ),
                      ),
                    ),
            areItemsTheSame: (a, b) => a == b);
  }
}
