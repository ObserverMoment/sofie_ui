import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/workout_card.dart';
import 'package:sofie_ui/components/user_input/menus/context_menu.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:auto_route/auto_route.dart';

/// A standard card if [selectWorkout] is not provided.
/// A [WorkoutCard ContextMenus] if it is.
class SelectableWorkoutCard extends StatelessWidget {
  final int index;
  final Workout workout;
  final void Function(Workout workout)? selectWorkout;
  final String? heroTagKey;
  const SelectableWorkoutCard(
      {Key? key,
      this.heroTagKey,
      required this.workout,
      required this.selectWorkout,
      required this.index})
      : super(key: key);

  void _openWorkoutDetailsPage(BuildContext context, Workout workout) =>
      context.navigateTo(WorkoutDetailsRoute(id: workout.id));

  @override
  Widget build(BuildContext context) {
    return selectWorkout != null
        ? ContextMenu(
            key: Key(
                'SelectableWorkoutCard-$index-${heroTagKey ?? ""}-${workout.id}'),
            menuChild: WorkoutCard(
              workout,
            ),
            actions: [
              if (selectWorkout != null)
                ContextMenuAction(
                    text: 'Select',
                    iconData: CupertinoIcons.add,
                    onTap: () => selectWorkout!(workout)),
              ContextMenuAction(
                  text: 'View',
                  iconData: CupertinoIcons.eye,
                  onTap: () =>
                      context.navigateTo(WorkoutDetailsRoute(id: workout.id))),
            ],
            child: WorkoutCard(workout),
          )
        : GestureDetector(
            key: Key(workout.id),
            onTap: () => _openWorkoutDetailsPage(context, workout),
            child: WorkoutCard(workout),
          );
  }
}
