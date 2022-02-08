import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/components/widget_header.dart';
import 'package:collection/collection.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:supercharged/supercharged.dart';

class AllTimeStatsSummaryWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const AllTimeStatsSummaryWidget({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Get the date maximum of 4 months ago.
    /// We want to show (max) 3 previous months and this month.
    final now = DateTime.now();
    final startFrom = DateTime(now.year, now.month - 3);

    final sortedLoggedWorkouts =
        loggedWorkouts.sortedBy<DateTime>((l) => l.completedOn);

    // final logsByMonth = sortedLoggedWorkouts.groupFoldBy<DateTime, int>((l) => DateTime(l.completedOn.year, l.completedOn.month), (acum, next) => ((acum ?? 0) + next.totalSessionTime.inMinutes).round());

    /// Take a max of 4 months
    final logsByMonth = sortedLoggedWorkouts
        .fold<Map<DateTime, List<LoggedWorkout>>>({}, (acum, next) {
      final dateAsMonth =
          DateTime(next.completedOn.year, next.completedOn.month);

      if (dateAsMonth.isBefore(startFrom)) {
        return acum;
      }

      if (acum[dateAsMonth] == null) {
        acum[dateAsMonth] = [];
      }
      acum[dateAsMonth]!.add(next);
      return acum;
    });

    final data = logsByMonth.entries
        .map((e) => LogsAndMinutesPerMonthData(
              date: e.key,
              logCount: e.value.length,
              minutes: e.value.fold(
                  0, (acum, next) => acum + next.totalSessionTime.inMinutes),
            ))
        .toList();

    final maxLogs =
        data.maxBy((a, b) => a.logCount.compareTo(b.logCount))?.logCount ?? 10;

    final maxMinutes =
        data.maxBy((a, b) => a.minutes.compareTo(b.minutes))?.minutes ?? 10;

    final allTimeSessionCount = loggedWorkouts.length;

    final allTimeMinutes = loggedWorkouts.fold<int>(0, (acum, nextLog) {
          return acum +
              nextLog.loggedWorkoutSections.fold<int>(0, (acum, nextSection) {
                return acum + nextSection.timeTakenSeconds;
              });
        }) ~/
        60;

    final backgroundColor = context.theme.background.withOpacity(0.45);

    return Column(
      children: [
        WidgetHeader(
          icon: CupertinoIcons.chart_bar,
          title: 'Summary',
          actions: [
            WidgetHeaderAction(
                icon: CupertinoIcons.settings,
                onPressed: () => print('open something'))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
          child: Row(
            children: [
              ContentBox(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  backgroundColor: backgroundColor,
                  child: Column(
                    children: [
                      const MyText(
                        'ALL TIME',
                        size: FONTSIZE.one,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          MyText(
                            '$allTimeSessionCount',
                            color: Styles.secondaryAccent,
                            size: FONTSIZE.seven,
                          ),
                          const SizedBox(width: 3),
                          const MyText(
                            'WORKOUTS',
                            subtext: true,
                            size: FONTSIZE.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          MyText(
                            allTimeMinutes.displayLong,
                            size: FONTSIZE.four,
                            color: Styles.primaryAccent,
                          ),
                          const SizedBox(width: 3),
                          const MyText(
                            'MINUTES',
                            subtext: true,
                            size: FONTSIZE.zero,
                          ),
                        ],
                      ),
                    ],
                  )),
              Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 2),
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.bottom,
                      children: [
                        TableRow(
                          children: data
                              .map((data) => SingleMonthColumns(
                                    data: data,
                                    maxLogs: maxLogs,
                                    maxMinutes: maxMinutes,
                                  ))
                              .toList(),
                        ),
                        TableRow(
                          children: data
                              .map((data) => Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: MyText(
                                      data.date.monthAbbrev,
                                      textAlign: TextAlign.center,
                                      subtext: true,
                                      size: FONTSIZE.one,
                                    ),
                                  ))
                              .toList(),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SingleMonthColumns extends StatelessWidget {
  final int maxLogs;
  final int maxMinutes;
  final LogsAndMinutesPerMonthData data;
  const SingleMonthColumns(
      {Key? key,
      required this.data,
      required this.maxLogs,
      required this.maxMinutes})
      : super(key: key);

  double get _columnMaxHeight => 70.0;

  Widget _buildChartColumn({
    required double height,
    required Gradient gradient,
    required int value,
  }) =>
      Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), gradient: gradient),
            height: height,
            width: 8,
          ),
          Positioned(
            top: -13,
            child: MyText(
              value.toString(),
              size: FONTSIZE.zero,
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    final logsHeight = data.logCount / maxLogs * _columnMaxHeight;
    final minsHeight = data.minutes / maxMinutes * _columnMaxHeight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildChartColumn(
          height: logsHeight,
          gradient: Styles.secondaryAccentGradient,
          value: data.logCount,
        ),
        const SizedBox(width: 7),
        _buildChartColumn(
          height: minsHeight,
          gradient: Styles.primaryAccentGradient,
          value: data.minutes,
        ),
      ],
    );
  }
}

class LogsAndMinutesPerMonthData {
  final DateTime date;
  final int logCount;
  final int minutes;
  LogsAndMinutesPerMonthData(
      {required this.date, required this.logCount, required this.minutes});
}
