// import 'package:collection/collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:json_annotation/json_annotation.dart' as json;
// import 'package:sofie_ui/components/animated/loading_shimmers.dart';
// import 'package:sofie_ui/components/animated/mounting.dart';
// import 'package:sofie_ui/components/fab_page.dart';
// import 'package:sofie_ui/components/workout_plan/selectable_workout_plan_card.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/components/user_input/filters/tags_collections_filter_menu.dart';
// import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
// import 'package:sofie_ui/services/store/graphql_store.dart';
// import 'package:sofie_ui/services/store/query_observer.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:sofie_ui/router.gr.dart';

// class YourCreatedPlans extends StatelessWidget {
//   final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;
//   final bool showDiscoverButton;
//   const YourCreatedPlans(
//       {Key? key, this.selectWorkoutPlan, required this.showDiscoverButton})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return QueryObserver<UserWorkoutPlans$Query, json.JsonSerializable>(
//         key: Key('YourCreatedPlans - ${UserWorkoutPlansQuery().operationName}'),
//         query: UserWorkoutPlansQuery(),
//         fullScreenError: false,
//         fetchPolicy: QueryFetchPolicy.storeFirst,
//         loadingIndicator: const ShimmerCardList(itemCount: 20),
//         builder: (data) {
//           final workoutPlans = data.userWorkoutPlans
//               .sortedBy<DateTime>((w) => w.createdAt)
//               .reversed
//               .toList();

//           return FilterableCreatedWorkoutPlans(
//             allWorkoutPlans: workoutPlans,
//             selectWorkoutPlan: selectWorkoutPlan,
//             showDiscoverButton: showDiscoverButton,
//           );
//         });
//   }
// }

// class FilterableCreatedWorkoutPlans extends StatefulWidget {
//   final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;
//   final List<WorkoutPlanSummary> allWorkoutPlans;
//   final bool showDiscoverButton;
//   const FilterableCreatedWorkoutPlans(
//       {Key? key,
//       this.selectWorkoutPlan,
//       required this.allWorkoutPlans,
//       required this.showDiscoverButton})
//       : super(key: key);

//   @override
//   _FilterableCreatedWorkoutPlansState createState() =>
//       _FilterableCreatedWorkoutPlansState();
// }

// class _FilterableCreatedWorkoutPlansState
//     extends State<FilterableCreatedWorkoutPlans> {
//   String? _workoutTagFilter;

//   @override
//   Widget build(BuildContext context) {
//     final allTags = widget.allWorkoutPlans
//         .fold<List<String>>([], (acum, next) => [...acum, ...next.tags])
//         .toSet()
//         .toList();

//     final filteredWorkoutPlans = _workoutTagFilter == null
//         ? widget.allWorkoutPlans
//         : widget.allWorkoutPlans
//             .where((w) => w.tags.contains(_workoutTagFilter));

//     final sortedPlans = filteredWorkoutPlans
//         .sortedBy<DateTime>((w) => w.createdAt)
//         .reversed
//         .toList();

//     return sortedPlans.isEmpty
//         ? Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ContentEmptyPlaceholder(
//                   message: 'No created plans',
//                   actions: [
//                     EmptyPlaceholderAction(
//                         action: () =>
//                             context.navigateTo(WorkoutPlanCreatorRoute()),
//                         buttonIcon: CupertinoIcons.add,
//                         buttonText: 'Create Plan'),
//                   ]),
//             ],
//           )
//         : FABPage(
//             rowButtonsAlignment: MainAxisAlignment.end,
//             columnButtons: [
//               if (widget.showDiscoverButton)
//                 FloatingTextButton(
//                     onTap: () =>
//                         context.navigateTo(PublicWorkoutPlanFinderRoute()),
//                     icon: CupertinoIcons.compass),
//             ],
//             rowButtons: [
//               if (allTags.isNotEmpty)
//                 TagsFilterMenu(
//                   allTags: allTags,
//                   selectedTag: _workoutTagFilter,
//                   updateSelectedTag: (t) =>
//                       setState(() => _workoutTagFilter = t),
//                 ),
//               const SizedBox(width: 10),
//               FloatingTextButton(
//                   icon: CupertinoIcons.add,
//                   iconSize: 19,
//                   text: 'Create Plan',
//                   onTap: () => context.navigateTo(WorkoutPlanCreatorRoute())),
//             ],
//             child: ListView.builder(
//                 cacheExtent: 3000,
//                 padding: const EdgeInsets.only(top: 6, bottom: 60),
//                 shrinkWrap: true,
//                 itemCount: sortedPlans.length,
//                 itemBuilder: (c, i) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: FadeInUp(
//                       key: Key(sortedPlans[i].id),
//                       delay: 5,
//                       delayBasis: 20,
//                       duration: 100,
//                       child: SelectableWorkoutPlanCard(
//                         index: i,
//                         selectWorkoutPlan: widget.selectWorkoutPlan,
//                         workoutPlan: sortedPlans[i],
//                       ),
//                     ),
//                   );
//                 }));
//   }
// }
