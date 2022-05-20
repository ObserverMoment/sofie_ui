import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/data_vis/percentage_bar_chart.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts/widget_header.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:collection/collection.dart';

class WorkoutGoalsTargetedWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const WorkoutGoalsTargetedWidget({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalLoggedGoals = loggedWorkouts.fold<int>(
        0, (acum, next) => acum + next.workoutGoals.length);

    final counterInit = <WorkoutGoal, int>{
      for (final goal in CoreDataRepo.workoutGoals) goal: 0
    };

    final counts =
        loggedWorkouts.fold<Map<WorkoutGoal, int>>(counterInit, (acum, next) {
      for (final goal in next.workoutGoals) {
        acum[goal] = acum[goal]! + 1;
      }
      return acum;
    });

    final chartData = counts.entries
        .map((e) =>
            _WorkoutGoalCount(e.key, e.value, e.value / totalLoggedGoals))
        .sortedBy<num>((cd) => cd.count)
        .reversed
        .toList();

    final highestCount = chartData.map((d) => d.count).max;
    final highestFraction = highestCount / totalLoggedGoals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LogAnalysisWidgetHeader(
          heading: 'Goals Targeted',
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: PercentageBarChart(
            max: highestFraction,
            gradient: Styles.primaryAccentGradient,
            itemHeight: 32,
            items: chartData
                .map((d) => BarChartItem(d.goal.name, d.fraction))
                .toList(),
          ),
        )
      ],
    );
  }
}

class _WorkoutGoalCount {
  final WorkoutGoal goal;
  final int count;
  final double fraction;
  _WorkoutGoalCount(this.goal, this.count, this.fraction);
}
