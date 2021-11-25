import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/workout/vertical_workouts_list.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/text_search_filters.dart';

/// Text search (client side only) your created and saved workouts.
class YourWorkoutsTextSearch extends StatefulWidget {
  const YourWorkoutsTextSearch({Key? key}) : super(key: key);

  @override
  _YourWorkoutsTextSearchState createState() => _YourWorkoutsTextSearchState();
}

class _YourWorkoutsTextSearchState extends State<YourWorkoutsTextSearch> {
  String _searchString = '';

  @override
  Widget build(BuildContext context) {
    /// Nested query observers a good idea? Both have a [storeFirst] fetch policy to avoid pummeling the api with requests.
    return QueryObserver<UserWorkouts$Query, json.JsonSerializable>(
        key: Key(
            'YourWorkoutsTextSearch - ${UserWorkoutsQuery().operationName}'),
        query: UserWorkoutsQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        loadingIndicator: const ShimmerListPage(),
        builder: (createdWorkoutsData) {
          return QueryObserver<UserCollections$Query, json.JsonSerializable>(
              key: Key(
                  'YourWorkoutsTextSearch - ${UserCollectionsQuery().operationName}'),
              query: UserCollectionsQuery(),
              fetchPolicy: QueryFetchPolicy.storeFirst,
              loadingIndicator: const ShimmerListPage(),
              builder: (savedWorkoutsData) {
                final collections = savedWorkoutsData.userCollections;

                /// Cast to Set: There can be duplicate workouts if the user has the same workout in multiple collections, and if they have added their own created workouts to one or more collections.
                final allWorkouts = <WorkoutSummary>{
                  ...createdWorkoutsData.userWorkouts,
                  ...collections.fold<List<WorkoutSummary>>(
                      [], (acum, next) => [...acum, ...next.workouts])
                }.toList();

                final List<WorkoutSummary> filteredWorkouts =
                    _searchString.length < 3
                        ? <WorkoutSummary>[]
                        : TextSearchFilters.workoutsBySearchString(
                                allWorkouts, _searchString)
                            .sortedBy<String>((workout) => workout.name);

                return MyPageScaffold(
                  navigationBar: MyNavBar(
                    withoutLeading: true,
                    middle: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 10),
                      child: MyCupertinoSearchTextField(
                        placeholder: 'Search your workouts',
                        autofocus: true,
                        onChanged: (value) =>
                            setState(() => _searchString = value.toLowerCase()),
                      ),
                    ),
                    trailing: NavBarTextButton(context.pop, 'Cancel'),
                  ),
                  child: AnimatedSwitcher(
                    duration: kStandardAnimationDuration,
                    child: _searchString.length < 3
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                MyText('Type at least 3 characters',
                                    subtext: true),
                              ],
                            ),
                          )
                        : VerticalWorkoutsList(
                            workouts: filteredWorkouts,
                          ),
                  ),
                );
              });
        });
  }
}
