import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/workout/workout_finders/private/private_workout_text_search.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/home/your_workouts/your_created_workouts.dart';
import 'package:sofie_ui/pages/authed/home/your_workouts/your_saved_workouts.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:auto_route/auto_route.dart';

class PrivateWorkoutFinderPage extends StatefulWidget {
  final void Function(WorkoutSummary workout) selectWorkout;
  const PrivateWorkoutFinderPage({Key? key, required this.selectWorkout})
      : super(key: key);

  @override
  State<PrivateWorkoutFinderPage> createState() =>
      _PrivateWorkoutFinderPageState();
}

class _PrivateWorkoutFinderPageState extends State<PrivateWorkoutFinderPage> {
  int _activeTabIndex = 0;

  void _handleTabChange(int index) => setState(() => _activeTabIndex = index);

  /// Pops itself (and any stack items such as the text seach widget)
  /// Then passes the selected workout to the parent.
  void _selectWorkout(WorkoutSummary workout) {
    // If open - pop the text search route.
    context.router.popUntilRouteWithName(PrivateWorkoutFinderRoute.name);
    // Then pop this widget.
    context.pop();
    widget.selectWorkout(workout);
  }

  Widget get _loadingPage => const ShimmerListPage(
        cardHeight: 240,
      );

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserWorkouts$Query, json.JsonSerializable>(
        key: Key(
            'PrivateWorkoutFinderPage - ${UserWorkoutsQuery().operationName}'),
        query: UserWorkoutsQuery(),
        loadingIndicator: _loadingPage,
        builder: (createdWorkoutsData) {
          return QueryObserver<UserCollections$Query, json.JsonSerializable>(
              key: Key(
                  'PrivateWorkoutFinderPage - ${UserCollectionsQuery().operationName}'),
              query: UserCollectionsQuery(),
              loadingIndicator: _loadingPage,
              builder: (collectionsData) {
                final userWorkouts = createdWorkoutsData.userWorkouts;

                final savedWorkouts = collectionsData.userCollections
                    .fold<List<WorkoutSummary>>(
                        [], (acum, next) => [...acum, ...next.workouts]);

                return MyPageScaffold(
                  navigationBar: MyNavBar(
                    middle: SizedBox(
                      width: double.infinity,
                      child: SlidingSelect<int>(
                          itemPadding: const EdgeInsets.symmetric(vertical: 6),
                          value: _activeTabIndex,
                          updateValue: _handleTabChange,
                          children: const {
                            0: MyText('Created'),
                            1: MyText('Saved'),
                          }),
                    ),
                    trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.push(
                                child: PrivateWorkoutTextSearch(
                              selectWorkout: _selectWorkout,
                              // Combining created and saved workouts means there can be dupes.
                              // Remove them by building as a set.
                              userWorkouts: <WorkoutSummary>{
                                ...userWorkouts,
                                ...savedWorkouts
                              }.toList(),
                            )),
                        child: const Icon(CupertinoIcons.search)),
                  ),
                  child: IndexedStack(
                    index: _activeTabIndex,
                    children: [
                      FilterableCreatedWorkouts(
                          selectWorkout: _selectWorkout,
                          allWorkouts: userWorkouts),
                      FilterableSavedWorkouts(
                          selectWorkout: _selectWorkout,
                          allCollections: collectionsData.userCollections)
                    ],
                  ),
                );
              });
        });
  }
}
