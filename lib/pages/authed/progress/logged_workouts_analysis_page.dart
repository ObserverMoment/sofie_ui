// import 'dart:io';

// import 'package:auto_route/auto_route.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:json_annotation/json_annotation.dart' as json;
// import 'package:sofie_ui/components/buttons.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/pickers/date_and_range_picker.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
// import 'package:sofie_ui/pages/authed/progress/logged_workouts/body_areas_targeted_widget.dart';
// import 'package:sofie_ui/pages/authed/progress/logged_workouts/logged_workouts_history_page.dart';
// import 'package:sofie_ui/pages/authed/progress/logged_workouts/log_analysis_averages_widget.dart';
// import 'package:sofie_ui/pages/authed/progress/logged_workouts/most_logged_moves.dart';
// import 'package:sofie_ui/pages/authed/progress/logged_workouts/most_logged_workouts.dart';
// import 'package:sofie_ui/pages/authed/progress/logged_workouts/session_type_and_move_type_widgets.dart';
// import 'package:sofie_ui/pages/authed/progress/logged_workouts/workout_goals_targeted_widget.dart';
// import 'package:sofie_ui/router.gr.dart';
// import 'package:sofie_ui/services/store/graphql_store.dart';
// import 'package:sofie_ui/services/store/query_observer.dart';

// class LoggedWorkoutsAnalysisPage extends StatefulWidget {
//   final String pageTitle;
//   const LoggedWorkoutsAnalysisPage(
//       {Key? key, this.pageTitle = 'Logs & Analysis'})
//       : super(key: key);

//   @override
//   State<LoggedWorkoutsAnalysisPage> createState() =>
//       _LoggedWorkoutsAnalysisPageState();
// }

// class _LoggedWorkoutsAnalysisPageState
//     extends State<LoggedWorkoutsAnalysisPage> {
//   DateTime? _from;
//   DateTime? _to;

//   void _updateDateRange(DateTime? from, DateTime? to) {
//     setState(() {
//       _from = from;
//       _to = to;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final query = UserLoggedWorkoutsQuery();
//     return QueryObserver<UserLoggedWorkouts$Query, json.JsonSerializable>(
//         key: Key('LoggedWorkoutsAnalysisPage - ${query.operationName}'),
//         query: query,
//         fetchPolicy: QueryFetchPolicy.storeFirst,
//         builder: (data) {
//           final allLogs = data.userLoggedWorkouts
//               .sortedBy<DateTime>((l) => l.completedOn)
//               .reversed
//               .toList();

//           final filteredSortedLogs = allLogs
//               .where((l) => l.completedOn.isBetweenDates(_from, _to))
//               .sortedBy<DateTime>((l) => l.completedOn)
//               .toList();

//           return CupertinoPageScaffold(
//               navigationBar: MyNavBar(
//                 middle: NavBarTitle(widget.pageTitle),
//                 trailing: allLogs.isEmpty
//                     ? null
//                     : NavBarTrailingRow(children: [
//                         IconButton(
//                             iconData: CupertinoIcons.list_bullet,
//                             onPressed: () => context.push(
//                                 child: const LoggedWorkoutsHistoryPage())),
//                       ]),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   filteredSortedLogs.isEmpty
//                       ? Expanded(
//                           child: ContentEmptyPlaceholder(
//                               message: 'No logs...',
//                               explainer:
//                                   'There is no workout log data available for the date range selected. ',
//                               actions: [
//                                 EmptyPlaceholderAction(
//                                     action: () => context
//                                         .navigateTo(PublicWorkoutFinderRoute()),
//                                     buttonIcon: CupertinoIcons.compass,
//                                     buttonText: 'Find a Workout'),
//                               ]),
//                         )
//                       : Expanded(
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 4, horizontal: 8),
//                               itemCount: 6,
//                               itemBuilder: (c, i) {
//                                 switch (i) {
//                                   case 0:
//                                     return LogAnalysisAveragesWidget(
//                                       loggedWorkouts: filteredSortedLogs,
//                                     );
//                                   case 1:
//                                     return WorkoutGoalsTargetedWidget(
//                                       loggedWorkouts: filteredSortedLogs,
//                                     );
//                                   // case 2:
//                                   //   return BodyAreasTargetedWidget(
//                                   //     loggedWorkouts: filteredSortedLogs,
//                                   //   );
//                                   case 3:
//                                     return MostLoggedWorkoutsWidget(
//                                       loggedWorkouts: filteredSortedLogs,
//                                     );
//                                   case 4:
//                                     return MostLoggedMovesWidget(
//                                       loggedWorkouts: filteredSortedLogs,
//                                     );
//                                   case 5:
//                                     return SessionTypeAndMoveTypeWidgets(
//                                       loggedWorkouts: filteredSortedLogs,
//                                     );
//                                   default:
//                                     throw Exception(
//                                         'LoggedWorkoutsAnalysisPage: Widget builder - no widget defined at this index - Index:$i');
//                                 }
//                               }),
//                         ),
//                   Container(
//                     color: context.theme.cardBackground,
//                     padding: EdgeInsets.only(bottom: Platform.isIOS ? 16 : 0),
//                     child: DateAndRangePickerDisplay(
//                       from: _from,
//                       to: _to,
//                       updateRange: _updateDateRange,
//                     ),
//                   )
//                 ],
//               ));
//         });
//   }
// }
