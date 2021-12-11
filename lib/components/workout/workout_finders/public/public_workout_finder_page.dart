import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
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
  final void Function(WorkoutSummary workout)? selectWorkout;

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

  final PagingController<int, WorkoutSummary> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 10);

  void Function(WorkoutSummary)? _selectWorkout;

  /// Pops itself (and any stack items such as the text seach widget)
  /// Then passes the selected workout to the parent.
  void _handleWorkoutSelect(WorkoutSummary workout) {
    /// If the text search is open then we pop back to the main widget.
    context.router.popUntilRouteWithName(PublicWorkoutFinderRoute.name);
    context.pop();
    widget.selectWorkout?.call(workout);
  }

  @override
  void initState() {
    super.initState();

    _selectWorkout = widget.selectWorkout != null ? _handleWorkoutSelect : null;

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

  Future<List<WorkoutSummary>> _executePublicWorkoutsQuery(
      {String? cursor}) async {
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (c, i) =>
                [const MySliverNavbar(title: 'Discover Workouts')],
            body: FABPage(
                columnButtons: [
                  FloatingButton(
                      onTap: () => context.push(
                          fullscreenDialog: true,
                          child: PublicWorkoutTextSearch(
                            selectWorkout: widget.selectWorkout != null
                                ? _selectWorkout
                                : null,
                          )),
                      icon: CupertinoIcons.search),
                ],
                rowButtonsAlignment: MainAxisAlignment.end,
                rowButtons: [
                  if (_bloc.numActiveFilters > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: FadeInUp(
                        child: FloatingButton(
                            onTap: _clearAllFilters,
                            icon: CupertinoIcons.clear),
                      ),
                    ),
                  FloatingButton(
                      onTap: _openFilters,
                      text: _bloc.numActiveFilters == 0
                          ? null
                          : '${_bloc.numActiveFilters} ${_bloc.numActiveFilters == 1 ? "filter" : "filters"}',
                      contentColor: _bloc.numActiveFilters > 0
                          ? Styles.secondaryAccent
                          : null,
                      icon: CupertinoIcons.slider_horizontal_3),
                ],
                child: PagedListView<int, WorkoutSummary>(
                  padding: const EdgeInsets.only(
                      top: 8, left: 2, right: 2, bottom: 130),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<WorkoutSummary>(
                    itemBuilder: (context, workout, index) => FadeInUp(
                      key: Key(workout.id),
                      delay: 5,
                      delayBasis: 20,
                      duration: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SelectableWorkoutCard(
                          index: index,
                          workout: workout,
                          selectWorkout: widget.selectWorkout != null
                              ? _selectWorkout
                              : null,
                        ),
                      ),
                    ),
                    firstPageProgressIndicatorBuilder: (c) =>
                        const LoadingSpinningLines(),
                    newPageProgressIndicatorBuilder: (c) =>
                        const LoadingSpinningLines(),
                    noItemsFoundIndicatorBuilder: (c) => const Center(
                      child: NoResultsToDisplay(),
                    ),
                  ),
                ))));
  }
}
