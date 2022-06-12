// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:collection/collection.dart';
// import 'package:supercharged/supercharged.dart';

// class AllTimeStatsSummaryWidget extends StatelessWidget {
//   final List<LoggedWorkout> loggedWorkouts;
//   const AllTimeStatsSummaryWidget({Key? key, required this.loggedWorkouts})
//       : super(key: key);

//   int get _showNumMonths => 4;

//   @override
//   Widget build(BuildContext context) {
//     /// Get the date maximum of [_showNumMonths] months ago.
//     /// We want to show (max) [_showNumMonths - 1] previous months and this month.
//     final now = DateTime.now();
//     final startFrom = DateTime(now.year, now.month - (_showNumMonths - 1));

//     final sortedLoggedWorkouts =
//         loggedWorkouts.sortedBy<DateTime>((l) => l.completedOn);

//     /// Take a max of [_showNumMonths] months
//     final logsByMonth = sortedLoggedWorkouts
//         .fold<Map<DateTime, List<LoggedWorkout>>>({}, (acum, next) {
//       final dateAsMonth =
//           DateTime(next.completedOn.year, next.completedOn.month);

//       if (dateAsMonth.isBefore(startFrom)) {
//         return acum;
//       }

//       if (acum[dateAsMonth] == null) {
//         acum[dateAsMonth] = [];
//       }
//       acum[dateAsMonth]!.add(next);
//       return acum;
//     });

//     final data = logsByMonth.entries
//         .map((e) => LogsAndMinutesPerMonthData(
//               date: e.key,
//               logCount: e.value.length,
//               minutes: e.value.fold(
//                   0, (acum, next) => acum + next.totalSessionTime.inMinutes),
//             ))
//         .toList();

//     final maxLogs =
//         data.maxBy((a, b) => a.logCount.compareTo(b.logCount))?.logCount ?? 10;

//     final maxMinutes =
//         data.maxBy((a, b) => a.minutes.compareTo(b.minutes))?.minutes ?? 10;

//     final allTimeSessionCount = loggedWorkouts.length;

//     final allTimeMinutes = loggedWorkouts.fold<int>(0, (acum, nextLog) {
//           return acum +
//               nextLog.loggedWorkoutSections.fold<int>(0, (acum, nextSection) {
//                 return acum + nextSection.timeTakenSeconds;
//               });
//         }) ~/
//         60;

//     final backgroundColor = context.theme.background.withOpacity(0.45);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
//       child: Row(
//         children: [
//           ContentBox(
//               borderRadius: 20,
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
//               backgroundColor: backgroundColor,
//               child: Column(
//                 children: [
//                   const MyText(
//                     'ALL TIME',
//                     size: FONTSIZE.one,
//                     subtext: true,
//                   ),
//                   const SizedBox(height: 8),
//                   Column(
//                     children: [
//                       MyText(
//                         '$allTimeSessionCount',
//                         color: Styles.secondaryAccent,
//                         size: FONTSIZE.eight,
//                       ),
//                       const SizedBox(height: 3),
//                       const MyText(
//                         'WORKOUTS',
//                         size: FONTSIZE.zero,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Column(
//                     children: [
//                       MyText(
//                         allTimeMinutes.displayLong,
//                         size: FONTSIZE.five,
//                         color: Styles.primaryAccent,
//                       ),
//                       const SizedBox(height: 3),
//                       const MyText(
//                         'MINUTES',
//                         size: FONTSIZE.zero,
//                       ),
//                     ],
//                   ),
//                 ],
//               )),
//           Flexible(
//             child: Padding(
//                 padding: const EdgeInsets.only(left: 8.0, right: 2),
//                 child: Table(
//                   defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
//                   children: [
//                     TableRow(
//                       children: data
//                           .map((data) => SingleMonthColumns(
//                                 data: data,
//                                 maxLogs: maxLogs,
//                                 maxMinutes: maxMinutes,
//                               ))
//                           .toList(),
//                     ),
//                     TableRow(
//                       children: data
//                           .map((data) => Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: MyText(
//                                   data.date.monthAbbrev,
//                                   textAlign: TextAlign.center,
//                                   subtext: true,
//                                   size: FONTSIZE.one,
//                                 ),
//                               ))
//                           .toList(),
//                     )
//                   ],
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SingleMonthColumns extends StatelessWidget {
//   final int maxLogs;
//   final int maxMinutes;
//   final LogsAndMinutesPerMonthData data;
//   const SingleMonthColumns(
//       {Key? key,
//       required this.data,
//       required this.maxLogs,
//       required this.maxMinutes})
//       : super(key: key);

//   double get _columnMaxHeight => 94.0;

//   Widget _buildChartColumn({
//     required double height,
//     required Gradient gradient,
//     required int value,
//   }) =>
//       Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.bottomCenter,
//         children: [
//           Container(
//             padding: const EdgeInsets.only(top: 16),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30), gradient: gradient),
//             height: height,
//             width: 8,
//           ),
//           Positioned(
//             top: -15,
//             child: MyText(
//               value.toString(),
//               size: FONTSIZE.zero,
//             ),
//           )
//         ],
//       );

//   @override
//   Widget build(BuildContext context) {
//     final logsHeight = data.logCount / maxLogs * _columnMaxHeight;
//     final minsHeight = data.minutes / maxMinutes * _columnMaxHeight;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         _buildChartColumn(
//           height: logsHeight,
//           gradient: Styles.secondaryAccentGradientVertical,
//           value: data.logCount,
//         ),
//         const SizedBox(width: 8),
//         _buildChartColumn(
//           height: minsHeight,
//           gradient: Styles.primaryAccentGradientVertical,
//           value: data.minutes,
//         ),
//       ],
//     );
//   }
// }

// class LogsAndMinutesPerMonthData {
//   final DateTime date;
//   final int logCount;
//   final int minutes;
//   LogsAndMinutesPerMonthData(
//       {required this.date, required this.logCount, required this.minutes});
// }
