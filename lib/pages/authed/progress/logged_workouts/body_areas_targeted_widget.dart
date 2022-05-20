import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/data_vis/percentage_bar_chart.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts/widget_header.dart';
import 'package:sofie_ui/services/core_data_repo.dart';

class BodyAreasTargetedWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const BodyAreasTargetedWidget({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allMoves = loggedWorkouts.fold<List<Move>>(
        [], (acum, next) => [...acum, ...next.allMoves]).toList();

    final allBodyAreasMoveScores = allMoves.fold<List<BodyAreaMoveScore>>(
        [], (acum, next) => [...acum, ...next.bodyAreaMoveScores]);

    final totalPoints = allBodyAreasMoveScores.map((bams) => bams.score).sum;

    final countInit = <BodyArea, int>{
      for (final bodyArea in CoreDataRepo.bodyAreas) bodyArea: 0
    };

    final counts = allBodyAreasMoveScores.fold<Map<BodyArea, int>>(countInit,
        (acum, next) {
      acum[next.bodyArea] = acum[next.bodyArea]! + next.score;
      return acum;
    });

    final chartData = counts.entries
        .map((e) =>
            _TargetedBodyAreaCount(e.key, e.value, e.value / totalPoints))
        .sortedBy<num>((cd) => cd.count)
        .reversed
        .toList();

    final highestCount = chartData.map((d) => d.count).max;
    final highestFraction = highestCount / totalPoints;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LogAnalysisWidgetHeader(
          heading: 'Body Areas Targeted',
        ),
        Padding(
            padding: const EdgeInsets.all(4),
            child: PercentageBarChart(
              max: highestFraction,
              gradient: Styles.secondaryAccentGradient,
              barPadding: 2,
              itemHeight: 28,
              items: chartData
                  .map((d) => BarChartItem(d.bodyArea.name, d.fraction))
                  .toList(),
            ))
      ],
    );
  }
}

class _TargetedBodyAreaCount {
  final BodyArea bodyArea;
  final int count;
  final double fraction;
  _TargetedBodyAreaCount(this.bodyArea, this.count, this.fraction);
}
