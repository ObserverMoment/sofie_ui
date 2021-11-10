import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/data_vis/percentage_bar_chart.dart';
import 'package:sofie_ui/components/data_vis/waffle_chart.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:supercharged/supercharged.dart';

class WorkoutPlanGoals extends StatelessWidget {
  final WorkoutPlan workoutPlan;
  const WorkoutPlanGoals({Key? key, required this.workoutPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Zero index - week '1' is at daysByWeek[0].
    final daysByWeek = workoutPlan.workoutPlanDays
        .groupBy<int, WorkoutPlanDay>((day) => (day.dayNumber / 7).floor());

    return ListView(
      children: [
        ...daysByWeek.keys
            .map((i) => WorkoutPlanWeekGoals(
                  workoutPlanDays: daysByWeek[i] ?? [],
                  weekNumber: i + 1,
                ))
            .toList(),
        const SizedBox(height: kAssumedFloatingButtonHeight)
      ],
    );
  }
}

class WorkoutPlanWeekGoals extends StatelessWidget {
  final int weekNumber;
  final List<WorkoutPlanDay> workoutPlanDays;
  const WorkoutPlanWeekGoals(
      {Key? key, required this.workoutPlanDays, required this.weekNumber})
      : super(key: key);

  List<WaffleChartInput> calcInputs(List<WorkoutGoal> goals) {
    final data = goals.fold<Map<WorkoutGoal, int>>({}, (acum, next) {
      if (acum[next] != null) {
        acum[next] = acum[next]! + 1;
      } else {
        acum[next] = 1;
      }
      return acum;
    });

    return data.entries
        .map((e) => WaffleChartInput(
            fraction: e.value / goals.length,
            color: HexColor.fromHex(e.key.hexColor),
            name: e.key.name))
        .toList();
  }

  List<WorkoutGoal> getAllGoals() {
    return workoutPlanDays.fold<List<WorkoutGoal>>(
        [],
        (acum1, nextDay) => [
              ...acum1,
              ...nextDay.workoutPlanDayWorkouts.fold(
                  [],
                  (acum2, nextDayWorkout) =>
                      nextDayWorkout.workout.workoutGoals)
            ]);
  }

  List<WorkoutTag> getAllTags() {
    return workoutPlanDays
        .fold<List<WorkoutTag>>(
            [],
            (acum1, nextDay) => [
                  ...acum1,
                  ...nextDay.workoutPlanDayWorkouts.fold(
                      [],
                      (acum2, nextDayWorkout) =>
                          nextDayWorkout.workout.workoutTags)
                ])
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final allGoals = getAllGoals();
    final allTags = getAllTags();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                MyHeaderText(
                  'Week $weekNumber',
                  size: FONTSIZE.two,
                ),
              ],
            ),
          ),
          if (allTags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    const Icon(CupertinoIcons.tag, size: 18),
                    ...allTags
                        .map(
                          (tag) => Tag(
                            tag: tag.tag,
                          ),
                        )
                        .toList(),
                  ]),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 4),
            child: allGoals.isEmpty
                ? const Center(
                    child: MyText(
                    'No goals specified',
                    subtext: true,
                  ))
                : PercentageBarChartSingle(
                    inputs: calcInputs(allGoals),
                    barHeight: 6,
                  ),
          ),
        ],
      ),
    );
  }
}
