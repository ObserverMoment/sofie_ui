// import 'package:collection/collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:json_annotation/json_annotation.dart' as json;
// import 'package:sofie_ui/components/animated/loading_shimmers.dart';
// import 'package:sofie_ui/components/tags.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/workout/vertical_workouts_list.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/services/store/graphql_store.dart';
// import 'package:sofie_ui/services/store/query_observer.dart';

// class YourSavedWorkouts extends StatelessWidget {
//   final void Function(WorkoutSummary workout)? selectWorkout;
//   const YourSavedWorkouts({Key? key, this.selectWorkout}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return QueryObserver<UserCollections$Query, json.JsonSerializable>(
//         key: Key('YourSavedWorkouts - ${UserCollectionsQuery().operationName}'),
//         query: UserCollectionsQuery(),
//         fetchPolicy: QueryFetchPolicy.storeFirst,
//         fullScreenError: false,
//         loadingIndicator: const ShimmerCardList(itemCount: 20),
//         builder: (data) {
//           final collections = data.userCollections;

//           return FilterableSavedWorkouts(
//             selectWorkout: selectWorkout,
//             allCollections: collections,
//           );
//         });
//   }
// }

// class FilterableSavedWorkouts extends StatefulWidget {
//   final void Function(WorkoutSummary workout)? selectWorkout;
//   final List<Collection> allCollections;
//   const FilterableSavedWorkouts(
//       {Key? key, required this.selectWorkout, required this.allCollections})
//       : super(key: key);

//   @override
//   _FilterableSavedWorkoutsState createState() =>
//       _FilterableSavedWorkoutsState();
// }

// class _FilterableSavedWorkoutsState extends State<FilterableSavedWorkouts> {
//   Collection? _selectedCollection;

//   @override
//   Widget build(BuildContext context) {
//     final selectedCollections = _selectedCollection == null
//         ? widget.allCollections
//         : [
//             widget.allCollections
//                 .firstWhere((c) => c.id == _selectedCollection!.id)
//           ];

//     final workouts = selectedCollections
//         .fold<List<WorkoutSummary>>(
//             [], (acum, next) => [...acum, ...next.workouts])
//         .sortedBy<DateTime>((w) => w.createdAt)
//         .reversed
//         .toList();

//     final collectionsWithWorkouts =
//         widget.allCollections.where((c) => c.workouts.isNotEmpty).toList();

//     return ListView(
//       shrinkWrap: true,
//       padding: EdgeInsets.zero,
//       children: [
//         if (collectionsWithWorkouts.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               alignment: WrapAlignment.center,
//               children: collectionsWithWorkouts
//                   .map((c) => SelectableTag(
//                         fontSize: FONTSIZE.two,
//                         text: c.name,
//                         isSelected: c == _selectedCollection,
//                         onPressed: () => setState(() => _selectedCollection =
//                             c == _selectedCollection ? null : c),
//                       ))
//                   .toList(),
//             ),
//           ),
//         VerticalWorkoutsList(
//           workouts: workouts,
//           selectWorkout: widget.selectWorkout,
//           scrollable: false,
//           avoidBottomNavBar: true,
//           heroTagKey: 'FilterableSavedWorkouts',
//         ),
//       ],
//     );
//   }
// }
