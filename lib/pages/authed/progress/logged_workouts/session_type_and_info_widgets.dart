import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';

class SessionTypeAndInfoWidgets extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const SessionTypeAndInfoWidgets({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        _AvgSessionLength(
          loggedWorkouts: loggedWorkouts,
        ),
        _WorkoutSectionTypes(
          loggedWorkouts: loggedWorkouts,
        ),
        _WorkoutGoalsTargeted(
          loggedWorkouts: loggedWorkouts,
        ),
        _MoveTypes(
          loggedWorkouts: loggedWorkouts,
        ),
      ],
    );
  }
}

class _AvgSessionLength extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const _AvgSessionLength({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionTimes =
        loggedWorkouts.map((l) => l.totalSessionTime.inSeconds);

    final average = sessionTimes.average;
    final sum = sessionTimes.sum;

    final avgDuration = Duration(seconds: average.round());
    final sumDuration = Duration(seconds: sum.round());

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              MyHeaderText(
                loggedWorkouts.length.toString(),
                size: FONTSIZE.two,
              ),
              MyHeaderText(
                'sessions',
                size: FONTSIZE.two,
              ),
            ],
          ),
          Column(
            children: [
              MyHeaderText(
                sumDuration.displayString,
                size: FONTSIZE.two,
              ),
              MyHeaderText(
                'minutes',
                size: FONTSIZE.two,
              ),
            ],
          ),
          Column(
            children: [
              MyHeaderText(
                avgDuration.displayString,
                size: FONTSIZE.two,
              ),
              MyHeaderText(
                'Per Session',
                size: FONTSIZE.two,
              ),
            ],
          ),
        ],
      ),
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

    return LayoutBuilder(
        builder: (context, constraints) => Card(
              padding: const EdgeInsets.all(0),
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

class _WorkoutGoalsTargeted extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const _WorkoutGoalsTargeted({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          MyHeaderText(
            'Overview',
            size: FONTSIZE.two,
          ),
          MyHeaderText(
            'Average Session Length',
            size: FONTSIZE.two,
          ),
          MyHeaderText(
            'Total Sessions',
            size: FONTSIZE.two,
          ),
          MyHeaderText(
            'Total Minutes',
            size: FONTSIZE.two,
          ),
        ],
      ),
    );
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
