import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/data_vis/percentage_bar_chart.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts/widget_header.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';

class SessionTypeAndMoveTypeWidgets extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const SessionTypeAndMoveTypeWidgets({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LogAnalysisWidgetHeader(
          heading: 'Session Types and Move Types',
        ),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: _WorkoutSectionTypes(
                loggedWorkouts: loggedWorkouts,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: _MoveTypes(
                loggedWorkouts: loggedWorkouts,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTypeCount {
  final WorkoutSectionType type;
  final int count;
  final double fraction;
  _SectionTypeCount(this.type, this.count, this.fraction);
}

class _WorkoutSectionTypes extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const _WorkoutSectionTypes({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalSections = loggedWorkouts.fold<int>(
        0, (acum, next) => acum + next.loggedWorkoutSections.length);

    final counterInit = <WorkoutSectionType, int>{
      for (final type in CoreDataRepo.workoutSectionTypes) type: 0
    };

    final counts = loggedWorkouts
        .fold<Map<WorkoutSectionType, int>>(counterInit, (acum, next) {
      for (final section in next.loggedWorkoutSections) {
        acum[section.workoutSectionType] =
            acum[section.workoutSectionType]! + 1;
      }

      return acum;
    });

    final chartData = counts.entries
        .map((e) => _SectionTypeCount(e.key, e.value, e.value / totalSections))
        .sortedBy<num>((cd) => cd.count)
        .reversed
        .toList();

    final highestCount = chartData.map((d) => d.count).max;
    final highestFraction = highestCount / totalSections;

    return PercentageBarChart(
      max: highestFraction,
      gradient: Styles.secondaryAccentGradient,
      fontSize: FONTSIZE.one,
      barPadding: 2,
      items:
          chartData.map((d) => BarChartItem(d.type.name, d.fraction)).toList(),
    );
  }
}

class _MoveTypeCount {
  final MoveType type;
  final int count;
  final double fraction;
  _MoveTypeCount(this.type, this.count, this.fraction);
}

class _MoveTypes extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const _MoveTypes({Key? key, required this.loggedWorkouts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allMoveTypes = loggedWorkouts
        .fold<List<Move>>([], (acum, next) => [...acum, ...next.allMoves])
        .map((m) => m.moveType)
        .toList();

    final counterInit = <MoveType, int>{
      for (final type in CoreDataRepo.moveTypes) type: 0
    };

    final counts =
        allMoveTypes.fold<Map<MoveType, int>>(counterInit, (acum, next) {
      acum[next] = acum[next]! + 1;
      return acum;
    });

    final chartData = counts.entries
        .map((e) =>
            _MoveTypeCount(e.key, e.value, e.value / allMoveTypes.length))
        .sortedBy<num>((cd) => cd.count)
        .reversed
        .toList();

    final highestCount = chartData.map((d) => d.count).max;
    final highestFraction = highestCount / allMoveTypes.length;

    return PercentageBarChart(
      max: highestFraction,
      gradient: Styles.secondaryAccentGradient,
      fontSize: FONTSIZE.one,
      barPadding: 2,
      items:
          chartData.map((d) => BarChartItem(d.type.name, d.fraction)).toList(),
    );
  }
}
