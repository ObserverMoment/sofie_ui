// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:json_annotation/json_annotation.dart' as json;
// import 'package:sofie_ui/components/animated/loading_shimmers.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
// import 'package:sofie_ui/components/workout_plan/workout_plan_finder/private/private_plans_text_search.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/pages/authed/home/your_plans/your_created_workout_plans.dart';
// import 'package:sofie_ui/pages/authed/home/your_plans/your_saved_workout_plans.dart';
// import 'package:sofie_ui/router.gr.dart';
// import 'package:sofie_ui/services/store/query_observer.dart';

// /// Widget that uses filters to find and view / save a workout plan.
// class PrivateWorkoutPlanFinderPage extends StatefulWidget {
//   final void Function(WorkoutPlanSummary workoutPlan) selectWorkoutPlan;
//   const PrivateWorkoutPlanFinderPage(
//       {Key? key, required this.selectWorkoutPlan})
//       : super(key: key);

//   @override
//   State<PrivateWorkoutPlanFinderPage> createState() =>
//       _PrivateWorkoutPlanFinderPageState();
// }

// class _PrivateWorkoutPlanFinderPageState
//     extends State<PrivateWorkoutPlanFinderPage> {
//   int _activeTabIndex = 0;

//   void _handleTabChange(int index) => setState(() => _activeTabIndex = index);

//   /// Pops itself (and any stack items such as the text seach widget)
//   /// Then passes the selected workout to the parent.
//   void _selectWorkoutPlan(WorkoutPlanSummary workoutPlan) {
//     // If open - pop the text search route.
//     context.router.popUntilRouteWithName(PrivateWorkoutPlanFinderRoute.name);
//     // Then pop this widget.
//     context.pop();
//     widget.selectWorkoutPlan(workoutPlan);
//   }

//   Widget get _loadingPage => const ShimmerListPage(
//         cardHeight: 240,
//       );

//   @override
//   Widget build(BuildContext context) {
//     return QueryObserver<UserWorkoutPlans$Query, json.JsonSerializable>(
//         key: Key(
//             'PrivateWorkoutPlanFinderPage - ${UserWorkoutPlansQuery().operationName}'),
//         query: UserWorkoutPlansQuery(),
//         loadingIndicator: _loadingPage,
//         builder: (createdPlansData) {
//           return QueryObserver<UserCollections$Query, json.JsonSerializable>(
//               key: Key(
//                   'PrivateWorkoutPlanFinderPage - ${UserCollectionsQuery().operationName}'),
//               query: UserCollectionsQuery(),
//               loadingIndicator: _loadingPage,
//               builder: (collectionsData) {
//                 final userPlans = createdPlansData.userWorkoutPlans;

//                 final savedPlans = collectionsData.userCollections
//                     .fold<List<WorkoutPlanSummary>>(
//                         [], (acum, next) => [...acum, ...next.workoutPlans]);

//                 return MyPageScaffold(
//                   navigationBar: MyNavBar(
//                     middle: SizedBox(
//                       width: double.infinity,
//                       child: MySlidingSegmentedControl<int>(
//                           childPadding: const EdgeInsets.symmetric(vertical: 6),
//                           value: _activeTabIndex,
//                           updateValue: _handleTabChange,
//                           children: const {
//                             0: 'Created',
//                             1: 'Saved',
//                           }),
//                     ),
//                     trailing: CupertinoButton(
//                         padding: EdgeInsets.zero,
//                         onPressed: () => context.push(
//                                 child: PrivatePlansTextSearch(
//                               selectWorkoutPlan: _selectWorkoutPlan,
//                               // Combining created and saved plans means there can be dupes.
//                               // Remove them by building as a set.
//                               userWorkoutPlans: <WorkoutPlanSummary>{
//                                 ...userPlans,
//                                 ...savedPlans
//                               }.toList(),
//                             )),
//                         child: const Icon(CupertinoIcons.search)),
//                   ),
//                   child: IndexedStack(
//                     index: _activeTabIndex,
//                     children: [
//                       FilterableCreatedWorkoutPlans(
//                           selectWorkoutPlan: _selectWorkoutPlan,
//                           allWorkoutPlans: userPlans),
//                       FilterableSavedWorkoutPlans(
//                           selectWorkoutPlan: _selectWorkoutPlan,
//                           allCollections: collectionsData.userCollections)
//                     ],
//                   ),
//                 );
//               });
//         });
//   }
// }
