import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
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
    return GestureDetector(
      onTap: selectWorkoutPlan != null
          ? () => openBottomSheetMenu(
              context: context,
              child: BottomSheetMenu(
                  header: BottomSheetMenuHeader(
                    imageUri: workoutPlan.coverImageUri,
                    name: workoutPlan.name,
                    subtitle: 'PLAN',
                  ),
                  items: [
                    if (selectWorkoutPlan != null)
                      BottomSheetMenuItem(
                          text: 'Select',
                          icon: CupertinoIcons.add,
                          onPressed: () => selectWorkoutPlan!(workoutPlan)),
                    BottomSheetMenuItem(
                        text: 'View',
                        icon: CupertinoIcons.eye,
                        onPressed: () => context.navigateTo(
                            WorkoutPlanDetailsRoute(id: workoutPlan.id))),
                  ]))
          : () => _openWorkoutPlanDetailsPage(context, workoutPlan),
      child: WorkoutPlanCard(workoutPlan),
    );
  }
}
