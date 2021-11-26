import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/workout_plan_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/screens/workout_plan_filters_screen.dart';
import 'package:sofie_ui/components/workout_plan/selectable_workout_plan_card.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_finder/public/public_plans_text_search.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';

class PublicWorkoutPlanFinderPage extends StatefulWidget {
  final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;

  const PublicWorkoutPlanFinderPage({
    Key? key,
    this.selectWorkoutPlan,
  }) : super(key: key);

  @override
  _PublicWorkoutPlanFinderPageState createState() =>
      _PublicWorkoutPlanFinderPageState();
}

class _PublicWorkoutPlanFinderPageState
    extends State<PublicWorkoutPlanFinderPage> {
  late WorkoutPlanFiltersBloc _bloc;
  late WorkoutPlanFilters _lastUsedFilters;

  /// For inifinite scroll / pagination of public plans from the network.
  static const kfilterResultsPageSize = 20;

  /// Cursor for public plans pagination. The id of the last retrieved plan.
  String? _cursor;

  final PagingController<int, WorkoutPlanSummary> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 5);

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WorkoutPlanFiltersBloc>();

    _updateLastUsedFilters();

    /// [nextPageKey] will be zero when the filters are refreshed. This means no cursor should be passed.
    /// Any other number for the pageKey causes this function to look up the [_cursor] from state.
    /// To standardize, we pass pageKey as [1] whenever a page is appended to the list.
    _pagingController.addPageRequestListener((nextPageKey) {
      _fetchPublicWorkoutPlans(nextPageKey);
    });
  }

  void _updateLastUsedFilters() {
    _lastUsedFilters = WorkoutPlanFilters.fromJson(_bloc.filters.json);
  }

  Future<List<WorkoutPlanSummary>> _executePublicWorkoutPlansQuery(
      {String? cursor}) async {
    final variables = PublicWorkoutPlansArguments(
        take: kfilterResultsPageSize,
        cursor: cursor,
        filters: WorkoutPlanFiltersInput.fromJson(_bloc.filters.apiJson));

    final query = PublicWorkoutPlansQuery(variables: variables);
    final response = await context.graphQLStore.execute(query);

    if ((response.errors != null && response.errors!.isNotEmpty) ||
        response.data == null) {
      throw Exception(
          'Sorry, something went wrong!: ${response.errors != null ? response.errors!.join(',') : ''}');
    }

    return query.parse(response.data ?? {}).publicWorkoutPlans;
  }

  Future<void> _fetchPublicWorkoutPlans(int nextPageKey) async {
    try {
      /// [nextPageKey] aka cursor defaults to 0 when [_pagingController] is initialised.
      final workoutPlans = await _executePublicWorkoutPlansQuery(
          cursor: nextPageKey == 0 ? null : _cursor);

      final isLastPage = workoutPlans.length < kfilterResultsPageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(workoutPlans);
      } else {
        _cursor = workoutPlans.last.id;

        /// Pass nextPageKey as 1. Acts like a boolean to tell future fetch calls to get the _[cursor] from local state.
        _pagingController.appendPage(workoutPlans, 1);
      }
    } catch (error) {
      if (mounted) {
        _pagingController.error = error;
      }
    }

    setState(() {});
  }

  Future<void> _openFilters() async {
    await context.push(
        fullscreenDialog: true, child: const WorkoutPlanFiltersScreen());
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
  /// Then passes the selected workoutPlan to the parent.
  void _selectWorkoutPlan(WorkoutPlanSummary workoutPlan) {
    if (widget.selectWorkoutPlan != null) {
      // If open - pop the text search route.
      context.router.popUntilRouteWithName(PublicWorkoutPlanFinderRoute.name);
      // Then pop itself.
      context.pop();
      widget.selectWorkoutPlan!(workoutPlan);
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
          middle: const NavBarTitle('Find Plans'),
          trailing: NavBarTrailingRow(children: [
            CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.push(
                        child: PublicPlansTextSearch(
                      selectWorkoutPlan: widget.selectWorkoutPlan != null
                          ? _selectWorkoutPlan
                          : null,
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
              child: PagedListView<int, WorkoutPlanSummary>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<WorkoutPlanSummary>(
                  itemBuilder: (context, workoutPlan, index) => SizeFadeIn(
                    duration: 20,
                    delay: index,
                    delayBasis: 15,
                    child: SelectableWorkoutPlanCard(
                      index: index,
                      selectWorkoutPlan: widget.selectWorkoutPlan != null
                          ? _selectWorkoutPlan
                          : null,
                      workoutPlan: workoutPlan,
                    ),
                  ),
                  firstPageProgressIndicatorBuilder: (c) =>
                      const LoadingCircle(),
                  newPageProgressIndicatorBuilder: (c) => const LoadingCircle(),
                  noItemsFoundIndicatorBuilder: (c) =>
                      const Center(child: MyText('No results...')),
                ),
              ),
            ),
          ],
        ));
  }
}
