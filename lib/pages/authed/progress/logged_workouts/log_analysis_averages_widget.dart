// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/components/cards/card.dart';
// import 'package:sofie_ui/components/my_custom_icons.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/extensions/data_type_extensions.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
// import 'package:sofie_ui/pages/authed/progress/logged_workouts/widget_header.dart';

// class LogAnalysisAveragesWidget extends StatelessWidget {
//   /// These should be sorted by [completedOn] date.
//   final List<LoggedWorkout> loggedWorkouts;

//   const LogAnalysisAveragesWidget({
//     Key? key,
//     required this.loggedWorkouts,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final earliestDate = loggedWorkouts.first.completedOn;
//     final latestDate = loggedWorkouts.last.completedOn;
//     final numDays =
//         latestDate.roundedToDay.difference(earliestDate.roundedToDay).inDays;
//     final numWeeks = numDays / 7;

//     /// Assumes an average of 30.437 days per month.
//     final numMonths = numDays / 30.437;

//     final total = loggedWorkouts
//         .fold<_SessionsAndMinutes>(_SessionsAndMinutes(0, 0), (acum, next) {
//       acum.sessions++;
//       acum.minutes += next.totalSessionTime.inMinutes;
//       return acum;
//     });

//     /// Day Avg.
//     final daySessions = total.sessions / numDays;
//     final dayMinutes = total.minutes / numDays;

//     /// Week Avg.
//     final weekSessions = total.sessions / numWeeks;
//     final weekMinutes = total.minutes / numWeeks;

//     /// Month Avg.
//     final monthSessions = total.sessions / numMonths;
//     final monthMinutes = total.minutes / numMonths;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const LogAnalysisWidgetHeader(
//           heading: 'Sessions and Session Length',
//         ),
//         GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           padding: EdgeInsets.zero,
//           crossAxisCount: 3,
//           children: [
//             _AvgStatDisplay(
//               label: 'Daily Avg',
//               minutes: dayMinutes,
//               sessions: daySessions,
//             ),
//             _AvgStatDisplay(
//               label: 'Weekly Avg',
//               minutes: weekMinutes,
//               sessions: weekSessions,
//             ),
//             _AvgStatDisplay(
//               label: 'Monthly Avg',
//               minutes: monthMinutes,
//               sessions: monthSessions,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _AvgStatDisplay extends StatelessWidget {
//   final String label;
//   final double minutes;
//   final double sessions;
//   const _AvgStatDisplay(
//       {Key? key,
//       required this.label,
//       required this.minutes,
//       required this.sessions})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//         child: Column(
//           children: [
//             MyHeaderText(
//               label,
//               size: FONTSIZE.one,
//               weight: FontWeight.normal,
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _Stat(
//                     iconData: MyCustomIcons.dumbbell,
//                     count: sessions,
//                     label: 'Sessions',
//                   ),
//                   _Stat(
//                     iconData: CupertinoIcons.clock,
//                     count: minutes,
//                     label: 'Minutes',
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ));
//   }
// }

// class _Stat extends StatelessWidget {
//   final String label;
//   final IconData iconData;
//   final double count;
//   const _Stat(
//       {Key? key,
//       required this.label,
//       required this.count,
//       required this.iconData})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(3.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             iconData,
//             size: 18,
//           ),
//           const SizedBox(width: 5),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               MyText(
//                 count == 0 ? '-' : count.stringMyDouble(),
//                 size: FONTSIZE.four,
//                 weight: FontWeight.bold,
//               ),
//               const SizedBox(height: 2),
//               MyText(
//                 label.toUpperCase(),
//                 subtext: true,
//                 size: FONTSIZE.zero,
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SessionsAndMinutes {
//   int sessions;
//   int minutes;
//   _SessionsAndMinutes(this.sessions, this.minutes);
// }
