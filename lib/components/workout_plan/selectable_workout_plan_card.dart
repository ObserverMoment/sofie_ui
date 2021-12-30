import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/user_input/menus/context_menu.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:auto_route/auto_route.dart';

/// A standard card if [selectWorkoutPlan] is not provided.
/// A [WorkoutPlanCard ContextMenus] if it is.
class SelectableWorkoutPlanCard extends StatelessWidget {
  final int index;
  final WorkoutPlanSummary workoutPlan;
  final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;
  final String? heroTagKey;
  const SelectableWorkoutPlanCard(
      {Key? key,
      this.heroTagKey,
      required this.workoutPlan,
      required this.selectWorkoutPlan,
      required this.index})
      : super(key: key);

  void _openWorkoutPlanDetailsPage(
          BuildContext context, WorkoutPlanSummary workoutPlan) =>
      context.navigateTo(WorkoutPlanDetailsRoute(id: workoutPlan.id));

  @override
  Widget build(BuildContext context) {
    return selectWorkoutPlan != null
        ? ContextMenu(
            key: Key(
                'SelectableWorkoutPlanCard-$index-${heroTagKey ?? "hero"}-${workoutPlan.id}'),
            menuChild: WorkoutPlanCard(
              workoutPlan,
            ),
            actions: [
              if (selectWorkoutPlan != null)
                ContextMenuAction(
                    text: 'Select',
                    iconData: CupertinoIcons.add,
                    onTap: () => selectWorkoutPlan!(workoutPlan)),
              ContextMenuAction(
                  text: 'View',
                  iconData: CupertinoIcons.eye,
                  onTap: () => context
                      .navigateTo(WorkoutPlanDetailsRoute(id: workoutPlan.id))),
            ],
            child: WorkoutPlanCard(workoutPlan),
          )
        : GestureDetector(
            key: Key(workoutPlan.id),
            onTap: () => _openWorkoutPlanDetailsPage(context, workoutPlan),
            child: WorkoutPlanCard(workoutPlan),
          );
  }
}
