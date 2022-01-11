import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/workout_card.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:auto_route/auto_route.dart';

/// A standard card if [selectWorkout] is not provided.
/// A [WorkoutCard ContextMenus] if it is.
class SelectableWorkoutCard extends StatelessWidget {
  final int index;
  final WorkoutSummary workout;
  final void Function(WorkoutSummary workout)? selectWorkout;
  final String? heroTagKey;
  const SelectableWorkoutCard(
      {Key? key,
      this.heroTagKey,
      required this.workout,
      required this.selectWorkout,
      required this.index})
      : super(key: key);

  void _openWorkoutDetailsPage(BuildContext context, WorkoutSummary workout) =>
      context.navigateTo(WorkoutDetailsRoute(id: workout.id));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectWorkout != null
          ? () => openBottomSheetMenu(
              context: context,
              child: BottomSheetMenu(
                  header: BottomSheetMenuHeader(
                    imageUri: workout.coverImageUri,
                    name: workout.name,
                    subtitle: 'WORKOUT',
                  ),
                  items: [
                    if (selectWorkout != null)
                      BottomSheetMenuItem(
                          text: 'Select',
                          icon: CupertinoIcons.add,
                          onPressed: () => selectWorkout!(workout)),
                    BottomSheetMenuItem(
                        text: 'View',
                        icon: CupertinoIcons.eye,
                        onPressed: () => context
                            .navigateTo(WorkoutDetailsRoute(id: workout.id))),
                  ]))
          : () => _openWorkoutDetailsPage(context, workout),
      child: WorkoutCard(workout),
    );
  }
}
