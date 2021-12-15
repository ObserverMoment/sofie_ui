// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/components/animated/loading_shimmers.dart';
// import 'package:sofie_ui/components/animated/mounting.dart';
// import 'package:sofie_ui/components/fab_page.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/menus/popover.dart';
// import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
// import 'package:sofie_ui/components/workout/selectable_workout_card.dart';
// import 'package:sofie_ui/components/workout/workout_finders/private/private_workout_text_search.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/router.gr.dart';
// import 'package:sofie_ui/services/store/query_observer.dart';
// import 'package:json_annotation/json_annotation.dart' as json;
// import 'package:auto_route/auto_route.dart';
// import 'package:collection/collection.dart';

// /// Used for [your-workouts] route - don't pass [selectWorkout] and pass true for [showCreateButton].
// class PrivateWorkoutFinderPage extends StatefulWidget {
//   final void Function(WorkoutSummary workout)? selectWorkout;
//   final bool showCreateButton;
//   final bool openSavedTabFirst;
//   final String? pageTitle;
//   const PrivateWorkoutFinderPage(
//       {Key? key,
//       this.selectWorkout,
//       this.showCreateButton = false,
//       this.openSavedTabFirst = false,
//       this.pageTitle})
//       : super(key: key);

//   @override
//   State<PrivateWorkoutFinderPage> createState() =>
//       _PrivateWorkoutFinderPageState();
// }

// class _PrivateWorkoutFinderPageState extends State<PrivateWorkoutFinderPage> {
//   late int _activeTabIndex;

//   @override
//   void initState() {
//     super.initState();
//     _activeTabIndex = widget.openSavedTabFirst ? 1 : 0;
//   }

//   String? _selectedTag;
//   Collection? _selectedCollection;

//   void _handleTabChange(int index) => setState(() => _activeTabIndex = index);

//   /// Pops itself (and any stack items such as the text seach widget)
//   /// Then passes the selected workout to the parent.
//   void _selectWorkout(WorkoutSummary workout) {
//     /// If the text search is open then we pop back to the main widget.
//     context.router.popUntilRouteWithName(PrivateWorkoutFinderRoute.name);
//     context.pop();
//     widget.selectWorkout?.call(workout);
//   }

//   List<WorkoutSummary> _filteredWorkouts(
//       List<WorkoutSummary> userWorkouts, List<WorkoutSummary> savedWorkouts) {
//     if (_activeTabIndex == 0) {
//       return _selectedTag == null
//           ? userWorkouts
//           : userWorkouts.where((w) => w.tags.contains(_selectedTag)).toList();
//     } else {
//       return _selectedCollection == null
//           ? savedWorkouts
//           : _selectedCollection!.workouts;
//     }
//   }

//   Widget get _loadingPage => const ShimmerListPage(
//         cardHeight: 240,
//       );

//   @override
//   Widget build(BuildContext context) {
//     return QueryObserver<UserWorkouts$Query, json.JsonSerializable>(
//         key: Key(
//             'PrivateWorkoutFinderPage - ${UserWorkoutsQuery().operationName}'),
//         query: UserWorkoutsQuery(),
//         loadingIndicator: _loadingPage,
//         builder: (createdWorkoutsData) {
//           return QueryObserver<UserCollections$Query, json.JsonSerializable>(
//               key: Key(
//                   'PrivateWorkoutFinderPage - ${UserCollectionsQuery().operationName}'),
//               query: UserCollectionsQuery(),
//               loadingIndicator: _loadingPage,
//               builder: (collectionsData) {
//                 final userWorkouts = createdWorkoutsData.userWorkouts;

//                 final savedWorkouts = collectionsData.userCollections
//                     .fold<List<WorkoutSummary>>(
//                         [], (acum, next) => [...acum, ...next.workouts]);

//                 /// For filtering created workouts by tag.
//                 final allTags = userWorkouts
//                     .fold<List<String>>(
//                         [], (acum, next) => [...acum, ...next.tags])
//                     .toSet()
//                     .toList();

//                 /// For filtering saved workouts by collection.
//                 final collectionsWithWorkouts = collectionsData.userCollections
//                     .where((c) => c.workouts.isNotEmpty)
//                     .toList();

//                 final filteredWorkouts =
//                     _filteredWorkouts(userWorkouts, savedWorkouts)
//                         .sortedBy<DateTime>((w) => w.createdAt)
//                         .reversed
//                         .toList();

//                 return CupertinoPageScaffold(
//                     child: NestedScrollView(
//                   headerSliverBuilder: (c, i) => [
//                     CupertinoSliverNavigationBar(
//                         leading: const NavBarBackButton(),
//                         largeTitle: Text(widget.pageTitle ?? 'Select Workout'),
//                         border: null)
//                   ],
//                   body: FABPage(
//                       rowButtonsAlignment: MainAxisAlignment.end,
//                       columnButtons: [
//                         if (widget.showCreateButton)
//                           FloatingButton(
//                               gradient: Styles.primaryAccentGradient,
//                               contentColor: Styles.white,
//                               icon: CupertinoIcons.add,
//                               onTap: () =>
//                                   context.navigateTo(WorkoutCreatorRoute())),
//                         FloatingButton(
//                             onTap: () => context.push(
//                                     child: PrivateWorkoutTextSearch(
//                                   selectWorkout: _selectWorkout,
//                                   // Combining created and saved workouts means there can be dupes.
//                                   // Remove them by building as a set.
//                                   userWorkouts: <WorkoutSummary>{
//                                     ...userWorkouts,
//                                     ...savedWorkouts
//                                   }.toList(),
//                                 )),
//                             icon: CupertinoIcons.search)
//                       ],
//                       rowButtons: [
//                         _TagsCollectionsFilterMenu(
//                           activeTabIndex: _activeTabIndex,
//                           allCollections: collectionsWithWorkouts,
//                           allTags: allTags,
//                           selectedCollection: _selectedCollection,
//                           selectedTag: _selectedTag,
//                           updateSelectedCollection: (c) =>
//                               setState(() => _selectedCollection = c),
//                           updateSelectedTag: (t) =>
//                               setState(() => _selectedTag = t),
//                         ),
//                         const SizedBox(width: 12),
//                         FABPageButtonContainer(
//                           padding: EdgeInsets.zero,
//                           child: MySlidingSegmentedControl<int>(
//                               margin: EdgeInsets.zero,
//                               activeColor: Styles.primaryAccent,
//                               childPadding:
//                                   const EdgeInsets.symmetric(vertical: 7.5),
//                               value: _activeTabIndex,
//                               updateValue: _handleTabChange,
//                               children: const {
//                                 0: 'Created',
//                                 1: 'Saved',
//                               }),
//                         ),
//                       ],
//                       child: ListView.builder(
//                           padding: const EdgeInsets.only(
//                             top: 8,
//                             bottom: 120,
//                           ),
//                           itemCount: filteredWorkouts.length,
//                           itemBuilder: (c, i) => FadeInUp(
//                                 key: Key(filteredWorkouts[i].id),
//                                 delay: 5,
//                                 delayBasis: 20,
//                                 duration: 100,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 8.0),
//                                   child: SelectableWorkoutCard(
//                                     index: i,
//                                     selectWorkout: widget.selectWorkout != null
//                                         ? _selectWorkout
//                                         : null,
//                                     workout: filteredWorkouts[i],
//                                   ),
//                                 ),
//                               ))),
//                 ));
//               });
//         });
//   }
// }

// class _TagsCollectionsFilterMenu extends StatelessWidget {
//   final int activeTabIndex;
//   final List<String> allTags;
//   final String? selectedTag;
//   final void Function(String? tag) updateSelectedTag;
//   final Collection? selectedCollection;
//   final List<Collection> allCollections;
//   final void Function(Collection? collection) updateSelectedCollection;
//   const _TagsCollectionsFilterMenu(
//       {Key? key,
//       required this.activeTabIndex,
//       required this.selectedTag,
//       required this.selectedCollection,
//       required this.allTags,
//       required this.allCollections,
//       required this.updateSelectedTag,
//       required this.updateSelectedCollection})
//       : super(key: key);

//   List<PopoverMenuItem> get _buildMenuItems {
//     if (activeTabIndex == 0) {
//       return [
//         ...allTags
//             .map((t) => PopoverMenuItem(
//                   onTap: () => updateSelectedTag(t),
//                   text: t,
//                 ))
//             .toList(),
//         if (selectedTag != null)
//           PopoverMenuItem(
//             iconData: CupertinoIcons.clear,
//             onTap: () => updateSelectedTag(null),
//             text: 'Clear Filter',
//           )
//       ];
//     } else {
//       return [
//         ...allCollections
//             .map((c) => PopoverMenuItem(
//                   onTap: () => updateSelectedCollection(c),
//                   text: c.name,
//                 ))
//             .toList(),
//         if (selectedCollection != null)
//           PopoverMenuItem(
//             iconData: CupertinoIcons.clear,
//             onTap: () => updateSelectedCollection(null),
//             text: 'Clear Filter',
//           )
//       ];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopoverMenu(
//         button: FABPageButtonContainer(
//           child: Row(
//             children: [
//               GrowInOut(
//                 axis: Axis.horizontal,
//                 show: activeTabIndex == 0,
//                 child: AnimatedSwitcher(
//                     duration: kStandardAnimationDuration,
//                     child: selectedTag == null
//                         ? Row(
//                             children: const [
//                               MyText('Tags'),
//                               SizedBox(width: 8),
//                               Icon(
//                                 CupertinoIcons.tag,
//                                 size: 16,
//                               )
//                             ],
//                           )
//                         : Row(
//                             children: [
//                               MyText(selectedTag!,
//                                   weight: FontWeight.bold,
//                                   color: Styles.primaryAccent),
//                             ],
//                           )),
//               ),
//               GrowInOut(
//                 axis: Axis.horizontal,
//                 show: activeTabIndex == 1,
//                 child: AnimatedSwitcher(
//                     duration: kStandardAnimationDuration,
//                     child: selectedCollection == null
//                         ? Row(
//                             children: const [
//                               MyText('Collections'),
//                               SizedBox(width: 8),
//                               Icon(
//                                 CupertinoIcons.collections,
//                                 size: 16,
//                               )
//                             ],
//                           )
//                         : Row(
//                             children: [
//                               MyText(selectedCollection!.name,
//                                   weight: FontWeight.bold,
//                                   color: Styles.primaryAccent),
//                             ],
//                           )),
//               ),
//             ],
//           ),
//         ),
//         items: _buildMenuItems);
//   }
// }
