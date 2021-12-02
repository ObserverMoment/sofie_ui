// import 'package:collection/collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:json_annotation/json_annotation.dart' as json;
// import 'package:sofie_ui/components/animated/loading_shimmers.dart';
// import 'package:sofie_ui/components/buttons.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
// import 'package:sofie_ui/components/workout_plan/vertical_workout_plans_list.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/services/store/graphql_store.dart';
// import 'package:sofie_ui/services/store/query_observer.dart';
// import 'package:sofie_ui/services/text_search_filters.dart';

// /// Text search (client side only) your created, joined and saved plans.
// class YourPlansTextSearch extends StatefulWidget {
//   const YourPlansTextSearch({Key? key}) : super(key: key);

//   @override
//   _YourPlansTextSearchState createState() => _YourPlansTextSearchState();
// }

// class _YourPlansTextSearchState extends State<YourPlansTextSearch> {
//   String _searchString = '';

//   @override
//   Widget build(BuildContext context) {
//     /// Nested query observers a good idea? (x 3 - may need to build a way to combine streams in the query observer widget). All have a [storeFirst] fetch policy to avoid pummeling the api with requests.
//     /// Created Workout Plans
//     return QueryObserver<UserWorkoutPlans$Query, json.JsonSerializable>(
//         key: Key(
//             'YourPlansTextSearch - ${UserWorkoutPlansQuery().operationName}'),
//         query: UserWorkoutPlansQuery(),
//         fetchPolicy: QueryFetchPolicy.storeFirst,
//         loadingIndicator: const ShimmerCardList(itemCount: 20),
//         builder: (createdPlansData) {
//           /// Enrolled Workout Plans
//           return QueryObserver<WorkoutPlanEnrolments$Query,
//                   json.JsonSerializable>(
//               key: Key(
//                   'YourPlansTextSearch - ${WorkoutPlanEnrolmentsQuery().operationName}'),
//               query: WorkoutPlanEnrolmentsQuery(),
//               fetchPolicy: QueryFetchPolicy.storeFirst,
//               loadingIndicator: const ShimmerListPage(),
//               builder: (enrolmentsData) {
//                 /// Saved Workout Plans
//                 return QueryObserver<UserCollections$Query,
//                         json.JsonSerializable>(
//                     key: Key(
//                         'YourPlansTextSearch - ${UserCollectionsQuery().operationName}'),
//                     query: UserCollectionsQuery(),
//                     fetchPolicy: QueryFetchPolicy.storeFirst,
//                     loadingIndicator: const ShimmerCardList(itemCount: 20),
//                     builder: (collectionsData) {
//                       final enrolledPlans = enrolmentsData.workoutPlanEnrolments
//                           .map((e) => e.workoutPlan)
//                           .toList();

//                       final createdPlans = createdPlansData.userWorkoutPlans;
//                       final collections = collectionsData.userCollections;

//                       final allPlans = <WorkoutPlanSummary>{
//                         ...enrolledPlans,
//                         ...createdPlans,
//                         ...collections.fold<List<WorkoutPlanSummary>>(
//                             [], (acum, next) => [...acum, ...next.workoutPlans])
//                       }.toList();

//                       final List<WorkoutPlanSummary> filteredWorkoutPlans =
//                           _searchString.length < 3
//                               ? <WorkoutPlanSummary>[]
//                               : TextSearchFilters.workoutPlansBySearchString(
//                                       allPlans, _searchString)
//                                   .sortedBy<String>(
//                                       (workoutPlan) => workoutPlan.name);

//                       return MyPageScaffold(
//                         navigationBar: MyNavBar(
//                           withoutLeading: true,
//                           middle: Padding(
//                             padding:
//                                 const EdgeInsets.only(left: 2.0, right: 10),
//                             child: MyCupertinoSearchTextField(
//                               placeholder: 'Search your plans',
//                               autofocus: true,
//                               onChanged: (value) => setState(
//                                   () => _searchString = value.toLowerCase()),
//                             ),
//                           ),
//                           trailing: NavBarTextButton(context.pop, 'Cancel'),
//                         ),
//                         child: AnimatedSwitcher(
//                           duration: kStandardAnimationDuration,
//                           child: _searchString.length < 3
//                               ? Padding(
//                                   padding: const EdgeInsets.all(24),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: const [
//                                       MyText('Type at least 3 characters',
//                                           subtext: true),
//                                     ],
//                                   ),
//                                 )
//                               : VerticalWorkoutPlansList(
//                                   workoutPlans: filteredWorkoutPlans,
//                                 ),
//                         ),
//                       );
//                     });
//               });
//         });
//   }
// }
