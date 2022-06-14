import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/components/resistance_workout_card.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/resistance_workout_bloc.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

class ClubsResistanceWorkouts extends StatefulWidget {
  const ClubsResistanceWorkouts({
    Key? key,
  }) : super(key: key);

  @override
  State<ClubsResistanceWorkouts> createState() =>
      _ClubsResistanceWorkoutsState();
}

class _ClubsResistanceWorkoutsState extends State<ClubsResistanceWorkouts> {
  /// For inifinite scroll / pagination of public workouts from the network.
  final _resultsPageSize = 20;

  /// Cursor for public workouts pagination. The id of the last retrieved workout.
  String? _cursor;

  final PagingController<int, ClubResistanceWorkout> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 10);

  @override
  void initState() {
    super.initState();

    /// [nextPageKey] will be zero when the filters are refreshed. This means no cursor should be passed.
    /// Any other number for the pageKey causes this function to look up the [_cursor] from state.
    /// To standardize, we pass pageKey as [1] whenever a page is appended to the list.
    _pagingController.addPageRequestListener((nextPageKey) {
      _fetchClubResistanceWorkouts(nextPageKey);
    });
  }

  Future<List<ClubResistanceWorkout>> _executeClubResistanceWorkoutsQuery(
      {String? cursor}) async {
    final variables = UserClubsResistanceWorkoutsArguments(
      take: _resultsPageSize,
      cursor: cursor,
    );

    final query = UserClubsResistanceWorkoutsQuery(variables: variables);
    final response = await GraphQLStore.store.execute(query);

    if ((response.errors != null && response.errors!.isNotEmpty) ||
        response.data == null) {
      throw Exception(
          'Sorry, something went wrong!: ${response.errors != null ? response.errors!.join(',') : ''}');
    }

    return query.parse(response.data ?? {}).userClubsResistanceWorkouts;
  }

  Future<void> _fetchClubResistanceWorkouts(int nextPageKey) async {
    try {
      /// [nextPageKey] defaults to 0 when [_pagingController] is initialised.
      /// For every subsequent call for a page [nextPageKey] will be [NOT 0]
      /// Use as a boolean. If [not 0] then pass [_cursor] to the query args.
      final workouts = await _executeClubResistanceWorkoutsQuery(
          cursor: nextPageKey == 0 ? null : _cursor);

      final isLastPage = workouts.length < _resultsPageSize;
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, ClubResistanceWorkout>(
      cacheExtent: 3000,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<ClubResistanceWorkout>(
        itemBuilder: (context, clubResistanceWorkout, index) => FadeInUp(
          key: Key(clubResistanceWorkout.id),
          delay: 5,
          delayBasis: 20,
          duration: 100,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 26),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        context.navigateTo(ResistanceWorkoutDetailsRoute(
                      id: clubResistanceWorkout.resistanceWorkout.id,
                    )),
                    child: ResistanceWorkoutCard(
                      resistanceWorkout:
                          clubResistanceWorkout.resistanceWorkout,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.navigateTo(
                      ClubDetailsRoute(id: clubResistanceWorkout.id)),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      borderRadius: BorderRadius.circular(50),
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 1),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          UserAvatar(
                            avatarUri: clubResistanceWorkout.coverImageUri,
                            size: 30,
                          ),
                          const SizedBox(width: 4),
                          MyText(
                            clubResistanceWorkout.name,
                            size: FONTSIZE.one,
                            subtext: true,
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        firstPageErrorIndicatorBuilder: (c) =>
            const PageResultsErrorIndicator(),
        newPageErrorIndicatorBuilder: (c) => const PageResultsErrorIndicator(),
        firstPageProgressIndicatorBuilder: (c) =>
            const CupertinoActivityIndicator(),
        newPageProgressIndicatorBuilder: (c) =>
            const CupertinoActivityIndicator(),
        noItemsFoundIndicatorBuilder: (c) => const Center(
          child: ContentEmptyPlaceholder(
              message: 'Nothing to display',
              explainer:
                  'If you are part of Circles which contain workouts, you will be able to find them here!',
              actions: []),
        ),
      ),
    );
  }
}
