import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/workout/selectable_workout_card.dart';
import 'package:sofie_ui/components/workout/workout_finders/private/private_workout_text_search.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/components/user_input/filters/tags_collections_filter_menu.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';

enum WorkoutsPageTab { created, saved }

class YourWorkoutsPage extends StatefulWidget {
  final void Function(WorkoutSummary workout)? selectWorkout;
  final bool showCreateButton;
  final bool showDiscoverButton;
  final String pageTitle;
  final bool showSaved;
  const YourWorkoutsPage(
      {Key? key,
      this.selectWorkout,
      this.showCreateButton = false,
      this.showDiscoverButton = false,
      this.pageTitle = 'Your Workouts',
      this.showSaved = true})
      : super(key: key);

  @override
  State<YourWorkoutsPage> createState() => _YourWorkoutsPageState();
}

class _YourWorkoutsPageState extends State<YourWorkoutsPage> {
  /// Saved Workouts needs to always be 1 for this to work.
  int _activeTabIndex = 0;

  void Function(WorkoutSummary)? _selectWorkout;

  /// Pops itself (and any stack items such as the text seach widget)
  /// Then passes the selected workout to the parent.
  void _handleWorkoutSelect(WorkoutSummary workout) {
    /// If the text search is open then we pop back to the main widget.
    context.router.popUntilRouteWithName(YourWorkoutsRoute.name);
    context.pop();
    widget.selectWorkout?.call(workout);
  }

  final List<String> _displayTabStrings = [];
  final List<WorkoutsPageTab> _displayTabs = [];
  final Map<int, String> _segmentChildren = {};

  @override
  void initState() {
    super.initState();
    if (widget.showSaved) {
      _displayTabStrings.add('Saved');
      _displayTabs.add(WorkoutsPageTab.saved);
    }
    _displayTabStrings.add('Created');
    _displayTabs.add(WorkoutsPageTab.created);

    _displayTabStrings.forEachIndexed((i, t) {
      _segmentChildren[i] = t;
    });

    _selectWorkout = widget.selectWorkout != null ? _handleWorkoutSelect : null;
  }

  String? _selectedTag;
  Collection? _selectedCollection;

  void _handleTabChange(int index) => setState(() => _activeTabIndex = index);

  List<WorkoutSummary> _filteredWorkouts(
      List<WorkoutSummary> userWorkouts, List<WorkoutSummary> savedWorkouts) {
    if (_displayTabs[_activeTabIndex] == WorkoutsPageTab.created) {
      return _selectedTag == null
          ? userWorkouts
          : userWorkouts.where((w) => w.tags.contains(_selectedTag)).toList();
    } else {
      return _selectedCollection == null
          ? savedWorkouts
          : _selectedCollection!.workouts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserWorkouts$Query, json.JsonSerializable>(
        key: Key('YourWorkoutsPage - ${UserWorkoutsQuery().operationName}'),
        query: UserWorkoutsQuery(),
        builder: (createdWorkoutsData) {
          return QueryObserver<UserCollections$Query, json.JsonSerializable>(
              key: Key(
                  'YourWorkoutsPage - ${UserCollectionsQuery().operationName}'),
              query: UserCollectionsQuery(),
              builder: (collectionsData) {
                final userWorkouts = createdWorkoutsData.userWorkouts;

                final savedWorkouts = collectionsData.userCollections
                    .fold<List<WorkoutSummary>>(
                        [], (acum, next) => [...acum, ...next.workouts]);

                /// For filtering created workouts by tag.
                final allTags = userWorkouts
                    .fold<List<String>>(
                        [], (acum, next) => [...acum, ...next.tags])
                    .toSet()
                    .toList();

                /// For filtering saved workouts by collection.
                final collectionsWithWorkouts = collectionsData.userCollections
                    .where((c) => c.workouts.isNotEmpty)
                    .toList();

                final filteredWorkouts =
                    _filteredWorkouts(userWorkouts, savedWorkouts)
                        .sortedBy<DateTime>((w) => w.createdAt)
                        .reversed
                        .toList();

                return CupertinoPageScaffold(
                    child: NestedScrollView(
                  headerSliverBuilder: (c, i) =>
                      [MySliverNavbar(title: widget.pageTitle)],
                  body: FABPage(
                      rowButtonsAlignment: MainAxisAlignment.end,
                      columnButtons: [
                        if (widget.showCreateButton)
                          FloatingButton(
                              icon: CupertinoIcons.add,
                              onTap: () =>
                                  context.navigateTo(WorkoutCreatorRoute())),
                      ],
                      rowButtons: [
                        TagsCollectionsFilterMenu(
                          filterMenuType: _displayTabs[_activeTabIndex] ==
                                  WorkoutsPageTab.created
                              ? FilterMenuType.tag
                              : FilterMenuType.collection,
                          allCollections: collectionsWithWorkouts,
                          allTags: allTags,
                          selectedCollection: _selectedCollection,
                          selectedTag: _selectedTag,
                          updateSelectedCollection: (c) =>
                              setState(() => _selectedCollection = c),
                          updateSelectedTag: (t) =>
                              setState(() => _selectedTag = t),
                        ),
                        const SizedBox(width: 12),
                        FloatingButton(
                            onTap: () => context.push(
                                    child: PrivateWorkoutTextSearch(
                                  selectWorkout: _selectWorkout,
                                  // Combining created and saved workouts means there can be dupes.
                                  // Remove them by building as a set.
                                  userWorkouts: <WorkoutSummary>{
                                    ...userWorkouts,
                                    if (widget.showSaved) ...savedWorkouts
                                  }.toList(),
                                )),
                            icon: CupertinoIcons.search),
                        if (widget.showDiscoverButton)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: FloatingButton(
                                onTap: () =>
                                    context.navigateTo(PublicWorkoutFinderRoute(
                                      selectWorkout: _selectWorkout,
                                    )),
                                icon: CupertinoIcons.compass),
                          ),
                      ],
                      child: Column(
                        children: [
                          if (_displayTabs.length > 1)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: MySlidingSegmentedControl<int>(
                                    value: _activeTabIndex,
                                    updateValue: _handleTabChange,
                                    children: _segmentChildren),
                              ),
                            ),
                          filteredWorkouts.isEmpty
                              ? YourContentEmptyPlaceholder(
                                  message: 'No workouts to display',
                                  actions: [
                                      EmptyPlaceholderAction(
                                          action: () => context.navigateTo(
                                              WorkoutCreatorRoute()),
                                          buttonIcon: CupertinoIcons.add,
                                          buttonText: 'Create Workout'),
                                      EmptyPlaceholderAction(
                                          action: () => context.navigateTo(
                                              PublicWorkoutFinderRoute()),
                                          buttonIcon: CupertinoIcons.compass,
                                          buttonText: 'Find Workouts'),
                                    ])
                              : Expanded(
                                  child: ListView.builder(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 120,
                                      ),
                                      itemCount: filteredWorkouts.length,
                                      itemBuilder: (c, i) => FadeInUp(
                                            key: Key(filteredWorkouts[i].id),
                                            delay: 5,
                                            delayBasis: 20,
                                            duration: 100,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SelectableWorkoutCard(
                                                index: i,
                                                selectWorkout: _selectWorkout,
                                                workout: filteredWorkouts[i],
                                              ),
                                            ),
                                          )),
                                ),
                        ],
                      )),
                ));
              });
        });
  }
}
