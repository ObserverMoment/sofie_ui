import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/workout_plan_day_card.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class WorkoutPlanWorkoutSchedule extends StatelessWidget {
  final WorkoutPlan workoutPlan;
  const WorkoutPlanWorkoutSchedule({Key? key, required this.workoutPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Zero index - week '1' is at daysByWeek[0].
    final daysByWeek = workoutPlan.workoutPlanDays
        .groupBy<int, WorkoutPlanDay>((day) => (day.dayNumber / 7).floor());

    return ListView(
      shrinkWrap: true,
      children: [
        ...daysByWeek.keys
            .map((i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: WorkoutPlanWeekWorkouts(
                    workoutPlanDays: daysByWeek[i] ?? [],
                    weekNumber: i,
                  ),
                ))
            .toList(),
        const SizedBox(height: kAssumedFloatingButtonHeight),
      ],
    );
  }
}

class WorkoutPlanWeekWorkouts extends StatelessWidget {
  final int weekNumber;
  final List<WorkoutPlanDay> workoutPlanDays;
  const WorkoutPlanWeekWorkouts(
      {Key? key, required this.weekNumber, required this.workoutPlanDays})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Must % 7 so that workouts in weeks higher than week 1 will get assigned to the correct day of that week.
    final byDayNumberInWeek =
        workoutPlanDays.fold<Map<int, WorkoutPlanDay>>({}, (acum, next) {
      acum[next.dayNumber % 7] = next;
      return acum;
    });

    final numWorkoutsInWeek = workoutPlanDays.fold<int>(
        0, (acum, next) => acum + next.workoutPlanDayWorkouts.length);

    return Column(
      children: [
        const SizedBox(height: 8),
        // https://stackoverflow.com/questions/51587003/how-to-center-only-one-element-in-a-row-of-2-elements-in-flutter
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyHeaderText('Week ${weekNumber + 1}', size: FONTSIZE.two),
              Row(
                children: [
                  MyText('${workoutPlanDays.length} days'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Dot(
                        diameter: 3,
                        color: context.theme.primary.withOpacity(0.5)),
                  ),
                  MyText('$numWorkoutsInWeek workouts'),
                ],
              )
            ],
          ),
        ),
        HorizontalLine(
            verticalPadding: 0, color: context.theme.primary.withOpacity(0.1)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (c, i) => byDayNumberInWeek[i] != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: WorkoutPlanDayCard(
                    workoutPlanDay: byDayNumberInWeek[i]!,
                    displayDayNumber: i,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Opacity(
                    opacity: 0.75,
                    child: WorkoutPlanRestDayCard(
                      dayNumber: i,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
