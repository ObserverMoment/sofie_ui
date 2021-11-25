import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/cards/workout_card_minimal.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutPlanDayCard extends StatelessWidget {
  /// Can be either the abolute day = i.e. day 15 of the workout, or the relative day, i.e. day 2 or of the week.
  /// Zero indexed.
  final int displayDayNumber;
  final WorkoutPlanDay workoutPlanDay;
  final bool openWorkoutDetailsOnTap;
  const WorkoutPlanDayCard(
      {Key? key,
      required this.workoutPlanDay,
      required this.displayDayNumber,
      this.openWorkoutDetailsOnTap = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedWorkoutPlanDayWorkouts = workoutPlanDay.workoutPlanDayWorkouts
        .sortedBy<num>((d) => d.sortPosition)
        .toList();

    return ContentBox(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyHeaderText(
                    'Day ${displayDayNumber + 1}',
                    size: FONTSIZE.two,
                  ),
                  if (Utils.textNotNull(workoutPlanDay.note))
                    NoteIconViewerButton(workoutPlanDay.note!)
                ],
              ),
            ),
          ),
          HorizontalLine(
              verticalPadding: 5,
              color: context.theme.primary.withOpacity(0.08)),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sortedWorkoutPlanDayWorkouts.length,
              separatorBuilder: (c, i) => HorizontalLine(
                  color: context.theme.primary.withOpacity(0.15)),
              itemBuilder: (c, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: GestureDetector(
                      onTap: openWorkoutDetailsOnTap
                          ? () => context.navigateTo(WorkoutDetailsRoute(
                              id: sortedWorkoutPlanDayWorkouts[i].workout.id))
                          : null,
                      child: MinimalWorkoutCard(
                        sortedWorkoutPlanDayWorkouts[i].workout.summary,
                        backgroundColor: context.theme.background,
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}

/// Allows the [workoutPlanDayWorkouts] within the [WorkoutPlanDay] to be edited.
/// They can be removed, reordered or have notes added to them.
/// Clicking a workout does not navigator or the [WorkoutDetailsRoute], unlike the standard [WorkoutPlanDayCard].
class EditableWorkoutPlanDayCard extends StatelessWidget {
  /// Can be either the abolute day = i.e. day 15 of the workout, or the relative day, i.e. day 2 or of the week.
  /// Zero indexed.
  final int displayDayNumber;
  final WorkoutPlanDay workoutPlanDay;
  final void Function(WorkoutPlanDayWorkout w) removeWorkoutPlanDayWorkout;
  final void Function(int from, int to) reorderWorkoutPlanDayWorkouts;
  final void Function(String note, WorkoutPlanDayWorkout w)
      addNoteToWorkoutPlanDayWorkout;

  const EditableWorkoutPlanDayCard(
      {Key? key,
      required this.workoutPlanDay,
      required this.displayDayNumber,
      required this.removeWorkoutPlanDayWorkout,
      required this.reorderWorkoutPlanDayWorkouts,
      required this.addNoteToWorkoutPlanDayWorkout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedWorkoutPlanDayWorkouts = workoutPlanDay.workoutPlanDayWorkouts
        .sortedBy<num>((d) => d.sortPosition)
        .toList();

    return Card(
      padding: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 9.0, right: 9, top: 9, bottom: 6),
            child: MyHeaderText('Day ${displayDayNumber + 1}'),
          ),
          if (Utils.textNotNull(workoutPlanDay.note))
            Padding(
              padding: const EdgeInsets.only(left: 9, right: 9, bottom: 3),
              child: MyText(
                workoutPlanDay.note!,
                lineHeight: 1.4,
                maxLines: 3,
                size: FONTSIZE.two,
              ),
            ),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sortedWorkoutPlanDayWorkouts.length,
              separatorBuilder: (c, i) => const HorizontalLine(),
              itemBuilder: (c, i) => AnimatedSlidable(
                    key: Key(
                        'EditableWorkoutPlanDayCard - ${sortedWorkoutPlanDayWorkouts[i].id}'),
                    index: i,
                    itemType: 'Workout',
                    verb: 'Remove',
                    removeItem: (removeAtIndex) => removeWorkoutPlanDayWorkout(
                        sortedWorkoutPlanDayWorkouts[removeAtIndex]),
                    secondaryActions: [
                      if (i != 0)
                        IconSlideAction(
                          caption: 'Move up',
                          color: Styles.primaryAccent,
                          foregroundColor: Styles.white,
                          icon: CupertinoIcons.arrow_up,
                          onTap: () => reorderWorkoutPlanDayWorkouts(i, i - 1),
                        ),
                      if (i != sortedWorkoutPlanDayWorkouts.length - 1)
                        IconSlideAction(
                          caption: 'Move down',
                          color: Styles.primaryAccent,
                          foregroundColor: Styles.white,
                          icon: CupertinoIcons.arrow_down,
                          onTap: () => reorderWorkoutPlanDayWorkouts(i, i + 1),
                        ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 6),
                      child: MinimalWorkoutCard(
                        sortedWorkoutPlanDayWorkouts[i].workout.summary,
                        backgroundColor: context.theme.background,
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}

class WorkoutPlanRestDayCard extends StatelessWidget {
  /// Zero indexed.
  final int dayNumber;
  const WorkoutPlanRestDayCard({Key? key, required this.dayNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            ' Day ${dayNumber + 1}',
            size: FONTSIZE.two,
          ),
          const MyText(
            'REST',
            size: FONTSIZE.two,
          ),
        ],
      ),
    );
  }
}
