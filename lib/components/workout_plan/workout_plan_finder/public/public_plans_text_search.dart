import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/text_search_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/workout_plan/vertical_workout_plans_list.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:substring_highlight/substring_highlight.dart';

class PublicPlansTextSearch extends StatefulWidget {
  final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;

  const PublicPlansTextSearch({Key? key, this.selectWorkoutPlan})
      : super(key: key);

  @override
  _PublicPlansTextSearchState createState() => _PublicPlansTextSearchState();
}

class _PublicPlansTextSearchState extends State<PublicPlansTextSearch> {
  String _searchString = '';

  /// Handles retrieving full workout objects from the API when the user presses submit (search) on the keyboard.
  late TextSearchBloc<WorkoutPlanSummary> _workoutPlansTextSearchBloc;

  /// Handles retrieving just workout names (similar to a suggestions list) as the user is typing their search query.
  late TextSearchBloc<TextSearchResult> _workoutPlanNamesTextSearchBloc;

  @override
  void initState() {
    super.initState();
    _workoutPlansTextSearchBloc =
        TextSearchBloc<WorkoutPlanSummary>(context, TextSearchType.workoutPlan);
    _workoutPlanNamesTextSearchBloc = TextSearchBloc<TextSearchResult>(
        context, TextSearchType.workoutPlanName);
  }

  /// Similar functionality to Apple Podcasts.
  /// Two responses.
  /// 1. For users own workoutPlans data is all client side so updates happen immediately on user input. Results displayed as cards.
  /// 2 For public workoutPlans. Search the API for workoutPlans based on the search string.
  /// While user is typing a list of workoutPlan titles (only) will display.
  void _handleSearchStringUpdate(String text) {
    setState(() => _searchString = text.toLowerCase());
    if (_searchString.length > 2) {
      // Clear the previous WorkoutPlan list search results. We revert now to text list while user is inputting text.
      _workoutPlansTextSearchBloc.clear(gotoState: TextSearchState.loading);

      /// Call the api (debounced) and return a list of workout titles that match.
      _workoutPlanNamesTextSearchBloc.search(_searchString);
    }
  }

  /// When user clicks submit on keyboard a full search will happen on the API, returning full workout plan objects displayed as cards.
  void _handleSearchSubmit(String text) {
    // Clear the text lists data so that when workout list data is returned is can be displayed.
    // Text name list data will always display if it is not empty.
    _workoutPlanNamesTextSearchBloc.clear(gotoState: TextSearchState.loading);
    // handle the full api search (debounced) and return a list of full workouts that match.
    _workoutPlansTextSearchBloc.search(text.toLowerCase());
  }

  @override
  void dispose() {
    _workoutPlansTextSearchBloc.dispose();
    _workoutPlanNamesTextSearchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          withoutLeading: true,
          middle: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: MyCupertinoSearchTextField(
              placeholder: 'Search all plans',
              onChanged: _handleSearchStringUpdate,
              onSubmitted: _handleSearchSubmit,
              autofocus: true,
            ),
          ),
          trailing: NavBarTextButton(context.pop, 'Close'),
        ),
        child: (_searchString.length > 2
            ? StreamBuilder<TextSearchState>(
                initialData: TextSearchState.empty,
                stream: StreamGroup.merge([
                  _workoutPlansTextSearchBloc.state,
                  _workoutPlanNamesTextSearchBloc.state
                ]),
                builder: (context, stateSnapshot) {
                  return StreamBuilder<List<WorkoutPlanSummary>>(
                      initialData: const <WorkoutPlanSummary>[],
                      stream: _workoutPlansTextSearchBloc.results,
                      builder: (context, workoutPlansSnapshot) {
                        return StreamBuilder<List<TextSearchResult>>(
                            initialData: const <TextSearchResult>[],
                            stream: _workoutPlanNamesTextSearchBloc.results,
                            builder: (context, workoutPlanNamesSnapshot) {
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
                                  'Enter at least 3 characters',
                                  subtext: true,
                                ));
                              } else {
                                // Handle data
                                // Always show names list if it is not empty
                                if (workoutPlanNamesSnapshot.data!.isNotEmpty) {
                                  return FadeIn(
                                    child: WorkoutFinderTextResultsNames(
                                      results: workoutPlanNamesSnapshot.data!,
                                      searchString: _searchString,
                                      searchWorkoutPlanName:
                                          _handleSearchSubmit,
                                    ),
                                  );
                                } else if (workoutPlansSnapshot
                                    .data!.isNotEmpty) {
                                  // Or show workouts list if not empty.
                                  return FadeIn(
                                    child: VerticalWorkoutPlansList(
                                      selectWorkoutPlan:
                                          widget.selectWorkoutPlan,
                                      workoutPlans: workoutPlansSnapshot.data!,
                                    ),
                                  );
                                } else {
                                  // Or show empty results message.
                                  return const Center(
                                      child: NoResultsToDisplay());
                                }
                              }
                            });
                      });
                })
            : const Center(
                child: MyText(
                'Enter at least 3 characters',
                subtext: true,
              ))));
  }
}

/// Text only list of names being returned from the api based on the user input.
/// On press of the text result we set the search string to the exact name of the search string and then run a text search returning full workout objects.
/// Same functionality as [PublicWorkoutTextSearch]
class WorkoutFinderTextResultsNames extends StatelessWidget {
  final List<TextSearchResult> results;
  final String searchString;
  final void Function(String name) searchWorkoutPlanName;
  const WorkoutFinderTextResultsNames(
      {Key? key,
      required this.results,
      required this.searchString,
      required this.searchWorkoutPlanName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: results.length,
        itemBuilder: (c, i) => GestureDetector(
              onTap: () => searchWorkoutPlanName(results[i].name),
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
                              color: Styles.secondaryAccent),
                          text: results[i].name,
                          term: searchString),
                    ],
                  ),
                ),
              ),
            ));
  }
}
