import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:supercharged/supercharged.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';

class SessionTypeAndMoveTypeWidgets extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const SessionTypeAndMoveTypeWidgets({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8, right: 8, top: 16),
          child: MyText(
            'Session Types and Move Types',
            size: FONTSIZE.four,
            weight: FontWeight.bold,
          ),
        ),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: [
            _WorkoutSectionTypes(
              loggedWorkouts: loggedWorkouts,
            ),
            _MoveTypes(
              loggedWorkouts: loggedWorkouts,
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
  _SectionTypeCount(this.type, this.count);
}

class _WorkoutSectionTypes extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const _WorkoutSectionTypes({Key? key, required this.loggedWorkouts})
      : super(key: key);

  String _percentageFromFraction(double fraction) =>
      '${(fraction * 100).round()}%';

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
        if (acum[section.workoutSectionType] != null) {
          acum[section.workoutSectionType] =
              acum[section.workoutSectionType]! + 1;
        }
      }

      return acum;
    });

    final chartData =
        counts.entries.map((e) => _SectionTypeCount(e.key, e.value)).toList();

    final highestCount = chartData.map((d) => d.count).max() ?? 0;
    final highestPercentage = highestCount / totalSections;

    return LayoutBuilder(
        builder: (context, constraints) => Card(
              padding: EdgeInsets.zero,
              child: Center(
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SfTreemap(
                      // key:
                      //     Key(DateTime.now().millisecondsSinceEpoch.toString()),
                      dataCount: chartData.length,
                      weightValueMapper: (int index) {
                        return chartData[index].count / totalSections;
                      },
                      levels: [
                        TreemapLevel(
                          colorValueMapper: (tile) => Styles.secondaryAccent
                              .withOpacity(tile.weight / highestPercentage),
                          border: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          labelBuilder:
                              (BuildContext context, TreemapTile tile) {
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
                                    color: Styles.white,
                                  ),
                                ],
                              ),
                            );
                          },
                          groupMapper: (int index) {
                            return chartData[index].type.name;
                          },
                          padding: const EdgeInsets.all(1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}

class _MoveTypes extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const _MoveTypes({Key? key, required this.loggedWorkouts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          MyHeaderText(
            'Session Length',
            size: FONTSIZE.two,
          ),
        ],
      ),
    );
  }
}
