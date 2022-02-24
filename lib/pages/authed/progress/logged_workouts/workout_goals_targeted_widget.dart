import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:supercharged/supercharged.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';

class WorkoutGoalsTargetedWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const WorkoutGoalsTargetedWidget({Key? key, required this.loggedWorkouts})
      : super(key: key);

  String _percentageFromFraction(double fraction) =>
      '${(fraction * 100).round()}%';

  @override
  Widget build(BuildContext context) {
    final totalLoggedGoals = loggedWorkouts.fold<int>(
        0, (acum, next) => acum + next.workoutGoals.length);

    final counts = loggedWorkouts.fold<Map<WorkoutGoal, int>>({}, (acum, next) {
      for (final goal in next.workoutGoals) {
        if (acum[goal] == null) {
          acum[goal] = 1;
        } else {
          acum[goal] = acum[goal]! + 1;
        }
      }
      return acum;
    });

    final chartData =
        counts.entries.map((e) => _WorkoutGoalCount(e.key, e.value)).toList();

    final highestCount = chartData.map((d) => d.count).max() ?? 0;
    final highestPercentage = highestCount / totalLoggedGoals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8, right: 8, top: 16),
          child: MyText(
            'Goals Targeted',
            size: FONTSIZE.four,
            weight: FontWeight.bold,
          ),
        ),
        Card(
          padding: EdgeInsets.zero,
          child: Center(
            child: SizedBox(
              height: 200,
              child: SfTreemap(
                key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                dataCount: chartData.length,
                weightValueMapper: (int index) {
                  return chartData[index].count / totalLoggedGoals;
                },
                levels: [
                  TreemapLevel(
                    colorValueMapper: (tile) => Styles.primaryAccent
                        .withOpacity(tile.weight / highestPercentage),
                    border: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    labelBuilder: (BuildContext context, TreemapTile tile) {
                      return Container(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              '${tile.group} (${_percentageFromFraction(tile.weight)}) ',
                              size: FONTSIZE.one,
                              weight: FontWeight.bold,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      );
                    },
                    color: Styles.primaryAccent,
                    groupMapper: (int index) {
                      return chartData[index].goal.name;
                    },
                    padding: const EdgeInsets.all(1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkoutGoalCount {
  final WorkoutGoal goal;
  final int count;
  _WorkoutGoalCount(this.goal, this.count);
}
