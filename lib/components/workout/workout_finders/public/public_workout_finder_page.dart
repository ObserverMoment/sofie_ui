import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/workout_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/screens/workout_filters_screen/workout_filters_screen.dart';
import 'package:sofie_ui/components/workout/selectable_workout_card.dart';
import 'package:sofie_ui/components/workout/workout_finders/public/public_workout_text_search.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:provider/provider.dart';

class PublicWorkoutFinderPage extends StatefulWidget {
  final void Function(Workout workout)? selectWorkout;

  const PublicWorkoutFinderPage({Key? key, this.selectWorkout})
      : super(key: key);

  @override
  State<PublicWorkoutFinderPage> createState() =>
      _PublicWorkoutFinderPageState();
}

class _PublicWorkoutFinderPageState extends State<PublicWorkoutFinderPage> {
  late WorkoutFiltersBloc _bloc;
  late WorkoutFilters _lastUsedFilters;

  /// For inifinite scroll / pagination of public workouts from the network.
  static const kfilterResultsPageSize = 20;

  /// Cursor for public workouts pagination. The id of the last retrieved workout.
  String? _cursor;

  final PagingController<int, Workout> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 10);

  @override
  void initState() {
    super.initState();

    _bloc = context.read<WorkoutFiltersBloc>();
    _updateLastUsedFilters();

    /// [nextPageKey] will be zero when the filters are refreshed. This means no cursor should be passed.
    /// Any other number for the pageKey causes this function to look up the [_cursor] from state.
    /// To standardize, we pass pageKey as [1] whenever a page is appended to the list.
    _pagingController.addPageRequestListener((nextPageKey) {
      _fetchPublicWorkouts(nextPageKey);
    });
  }

  void _updateLastUsedFilters() {
    _lastUsedFilters = WorkoutFilters.fromJson(_bloc.filters.json);
  }

  Future<List<Workout>> _executePublicWorkoutsQuery({String? cursor}) async {
    final variables = PublicWorkoutsArguments(
        take: kfilterResultsPageSize,
        cursor: cursor,
        filters: WorkoutFiltersInput.fromJson(_bloc.filters.apiJson));

    final query = PublicWorkoutsQuery(variables: variables);
    final response = await context.graphQLStore.execute(query);

    if ((response.errors != null && response.errors!.isNotEmpty) ||
        response.data == null) {
      throw Exception(
          'Sorry, something went wrong!: ${response.errors != null ? response.errors!.join(',') : ''}');
    }

    return query.parse(response.data ?? {}).publicWorkouts;
  }

  Future<void> _fetchPublicWorkouts(int nextPageKey) async {
    try {
      /// [nextPageKey] aka cursor defaults to 0 when [_pagingController] is initialised.
      final workouts = await _executePublicWorkoutsQuery(
          cursor: nextPageKey == 0 ? null : _cursor);

      final isLastPage = workouts.length < kfilterResultsPageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(workouts);
      } else {
        _cursor = workouts.last.id;

        /// Pass nextPageKey as 1. Acts like a boolean to tell future fetch calls to get the _[cursor] from local state.
        _pagingController.appendPage(workouts, 1);
      }
    } catch (error) {
      if (mounted) _pagingController.error = error;
    }

    setState(() {});
  }

  Future<void> _openFilters() async {
    await context.push(
        fullscreenDialog: true, child: const WorkoutFiltersScreen());
    _handleFiltersClose();
  }

  void _handleFiltersClose() {
    if (_bloc.filtersHaveChanged(_lastUsedFilters)) {
      _updateLastUsedFilters();
      _pagingController.refresh();
    }
  }

  Future<void> _clearAllFilters() async {
    await _bloc.clearAllFilters();
    _pagingController.refresh();

    setState(() {
      _updateLastUsedFilters();
    });
  }

  /// Pops itself (and any stack items such as the text seach widget)
  /// Then passes the selected workout to the parent.
  void _selectWorkout(Workout workout) {
    if (widget.selectWorkout != null) {
      // If open - pop the text search route.
      context.router.popUntilRouteWithName(PublicWorkoutFinderRoute.name);
      // Then pop this widget.
      context.pop();
      widget.selectWorkout!(workout);
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: const NavBarTitle('Find Workouts'),
        trailing: NavBarTrailingRow(children: [
          CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.push(
                      child: PublicWorkoutTextSearch(
                    selectWorkout:
                        widget.selectWorkout != null ? _selectWorkout : null,
                  )),
              child: const Icon(CupertinoIcons.search)),
          CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _openFilters,
              child: const Icon(material.Icons.filter_alt)),
        ]),
      ),
      child: Column(
        children: [
          GrowInOut(
              show: _bloc.activeFilters,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    '${_bloc.numActiveFilters} active ${_bloc.numActiveFilters == 1 ? "filter" : "filters"}',
                  ),
                  const SizedBox(width: 8),
                  TertiaryButton(
                    onPressed: _openFilters,
                    text: 'Update',
                  ),
                  const SizedBox(width: 8),
                  TertiaryButton(
                    onPressed: _clearAllFilters,
                    text: 'Clear',
                  ),
                ],
              )),
          Expanded(
            child: PagedListView<int, Workout>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Workout>(
                itemBuilder: (context, workout, index) => SizeFadeIn(
                  duration: 20,
                  delay: index,
                  delayBasis: 15,
                  child: SelectableWorkoutCard(
                    index: index,
                    workout: workout,
                    selectWorkout:
                        widget.selectWorkout != null ? _selectWorkout : null,
                  ),
                ),
                firstPageProgressIndicatorBuilder: (c) => const LoadingCircle(),
                newPageProgressIndicatorBuilder: (c) => const LoadingCircle(),
                noItemsFoundIndicatorBuilder: (c) =>
                    const Center(child: MyText('No results...')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
