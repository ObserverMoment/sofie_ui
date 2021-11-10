import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/text_search_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/workout/vertical_workouts_list.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:substring_highlight/substring_highlight.dart';

class PublicWorkoutTextSearch extends StatefulWidget {
  final void Function(Workout workout)? selectWorkout;

  const PublicWorkoutTextSearch({
    Key? key,
    required this.selectWorkout,
  }) : super(key: key);

  @override
  _PublicWorkoutTextSearchState createState() =>
      _PublicWorkoutTextSearchState();
}

class _PublicWorkoutTextSearchState extends State<PublicWorkoutTextSearch> {
  String _searchString = '';

  /// Handles retrieving full workout objects from the API when the user presses submit (search) on the keyboard.
  late TextSearchBloc<Workout> _workoutsTextSearchBloc;

  /// Handles retrieving just workout names (similar to a suggestions list) as the user is typing their search query.
  late TextSearchBloc<TextSearchResult> _workoutNamesTextSearchBloc;

  @override
  void initState() {
    super.initState();
    _workoutsTextSearchBloc =
        TextSearchBloc<Workout>(context, TextSearchType.workout);
    _workoutNamesTextSearchBloc =
        TextSearchBloc<TextSearchResult>(context, TextSearchType.workoutName);
  }

  /// Search the API for workouts based on the search string.
  /// While user is typing a list of workout titles (only) will display.
  /// When they click on a text result this will trigger a full search via the API which will return full [Workout] objects.s
  void _handleSearchStringUpdate(String text) {
    setState(() => _searchString = text.toLowerCase());
    if (_searchString.length > 2) {
      // Clear the previous Workout list search results. We revert now to text list while user is inputting text.
      _workoutsTextSearchBloc.clear(gotoState: TextSearchState.loading);

      /// Call the api (debounced) and return a list of workout titles that match.
      _workoutNamesTextSearchBloc.search(_searchString);
    }
  }

  /// When user clicks submit on keyboard a full search will happen on the API, returning full workout objects displayed as cards.
  void _handleSearchSubmit(String text) {
    // Clear the text lists data so that when workout list data is returned is can be displayed.
    // Text name list data will always display if it is not empty.
    _workoutNamesTextSearchBloc.clear(gotoState: TextSearchState.loading);
    // handle the full api search (debounced) and return a list of full workouts that match.
    _workoutsTextSearchBloc.search(text.toLowerCase());
  }

  @override
  void dispose() {
    _workoutsTextSearchBloc.dispose();
    _workoutNamesTextSearchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 10),
          child: MyCupertinoSearchTextField(
            placeholder: 'Search all workouts',
            onChanged: _handleSearchStringUpdate,
            onSubmitted: _handleSearchSubmit,
            autofocus: true,
          ),
        ),
        trailing: NavBarTextButton(context.pop, 'Close'),
      ),
      child: _searchString.length > 2
          ? StreamBuilder<TextSearchState>(
              initialData: TextSearchState.empty,
              stream: StreamGroup.merge([
                _workoutsTextSearchBloc.state,
                _workoutNamesTextSearchBloc.state
              ]),
              builder: (context, stateSnapshot) {
                return StreamBuilder<List<Workout>>(
                    initialData: const <Workout>[],
                    stream: _workoutsTextSearchBloc.results,
                    builder: (context, workoutsSnapshot) {
                      return StreamBuilder<List<TextSearchResult>>(
                          initialData: const <TextSearchResult>[],
                          stream: _workoutNamesTextSearchBloc.results,
                          builder: (context, workoutNamesSnapshot) {
                            // Handle state.
                            if (stateSnapshot.data == TextSearchState.error) {
                              return const Center(
                                child: MyText(
                                  'Sorry, there was a problem getting results',
                                  color: Styles.errorRed,
                                ),
                              );
                            } else if (stateSnapshot.data ==
                                TextSearchState.loading) {
                              return const Center(child: LoadingCircle());
                            } else if (stateSnapshot.data ==
                                TextSearchState.empty) {
                              // Or show placeholder message.
                              return const Center(
                                  child: MyText(
                                'Enter at least 3 characters.',
                                subtext: true,
                              ));
                            } else {
                              // Handle data
                              // Always show names list if it is not empty
                              if (workoutNamesSnapshot.data!.isNotEmpty) {
                                return FadeIn(
                                  child: WorkoutFinderTextResultsNames(
                                    results: workoutNamesSnapshot.data!,
                                    searchString: _searchString,
                                    searchWorkoutName: _handleSearchSubmit,
                                  ),
                                );
                              } else if (workoutsSnapshot.data!.isNotEmpty) {
                                // Or show workouts list if not empty.
                                return FadeIn(
                                  child: VerticalWorkoutsList(
                                    workouts: workoutsSnapshot.data!,
                                    selectWorkout: widget.selectWorkout,
                                  ),
                                );
                              } else {
                                // Or show empty results message.
                                return const Center(
                                    child: MyText(
                                  'No results....',
                                  subtext: true,
                                ));
                              }
                            }
                          });
                    });
              })
          : const Center(
              child: MyText(
              'Enter at least 3 characters.',
              subtext: true,
            )),
    );
  }
}

/// Text only list of names being returned from the api based on the user input.
/// On press of the text result we set the search string to the exact name of the search string and then run a text search returning full workout objects.
class WorkoutFinderTextResultsNames extends StatelessWidget {
  final List<TextSearchResult> results;
  final String searchString;
  final void Function(String name) searchWorkoutName;
  const WorkoutFinderTextResultsNames(
      {Key? key,
      required this.results,
      required this.searchString,
      required this.searchWorkoutName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: results.length,
        itemBuilder: (c, i) => GestureDetector(
              onTap: () => searchWorkoutName(results[i].name),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: context.theme.primary.withOpacity(0.15),
                  ))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.search,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      SubstringHighlight(
                          textStyle: TextStyle(
                              fontSize: 16,
                              color: context.theme.primary.withOpacity(0.7)),
                          textStyleHighlight: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Styles.infoBlue),
                          text: results[i].name,
                          term: searchString),
                    ],
                  ),
                ),
              ),
            ));
  }
}
