import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sofie_ui/components/animated/loading_spinners.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/workout_card.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout/fab_page/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/layout/fab_page/floating_text_button.dart';
import 'package:sofie_ui/components/my_tab_bar_view.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/components/resistance_workout_card.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/utils.dart';

class ClubDetailsWorkouts extends StatelessWidget {
  final String clubId;
  final bool isOwnerOrAdmin;
  const ClubDetailsWorkouts(
      {Key? key, required this.clubId, required this.isOwnerOrAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: const NavBarTitle('Circle Workouts'),
        trailing: NavBarIconButton(
            onPressed: () => print('enter edit mode'),
            iconData: CupertinoIcons.pencil),
      ),
      child: ClubsResistanceWorkouts(
        clubId: clubId,
      ),
    );
  }
}

class PaginationObject {
  final String id;
  final String type;
  final DateTime updatedAt;
  PaginationObject(this.id, this.type, this.updatedAt);
}

class ClubsResistanceWorkouts extends StatefulWidget {
  final String clubId;
  const ClubsResistanceWorkouts({
    Key? key,
    required this.clubId,
  }) : super(key: key);

  @override
  State<ClubsResistanceWorkouts> createState() =>
      _ClubsResistanceWorkoutsState();
}

class _ClubsResistanceWorkoutsState extends State<ClubsResistanceWorkouts> {
  /// For inifinite scroll / pagination of public workouts from the network.
  final _resultsPageSize = 20;

  /// Cursors pagination. One for each workout type.
  final ClubWorkoutsCursors _cursors = ClubWorkoutsCursors();
  final ClubWorkoutsRequestTypes _requestTypes = ClubWorkoutsRequestTypes(
    cardioWorkouts: true,
    resistanceWorkouts: true,
    intervalWorkouts: true,
    amrapWorkouts: true,
    forTimeWorkouts: true,
    mobilityWorkouts: true,
  );

  /// Retrieved data.
  List<ResistanceWorkout> _resistanceWorkouts = [];

  /// Type and id will be used to lookup
  /// Updated at will be used to sort.
  final PagingController<int, PaginationObject> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 10);

  @override
  void initState() {
    super.initState();

    /// [nextPageKey] will be [0] when no results are present and no pagination cursors exist. This means no cursors should be passed to the resolvers.
    /// Any other number for the pageKey causes this function to look up the [_cursor] from state.
    /// To standardize, we pass pageKey as [1] whenever a page is appended to the list.
    _pagingController.addPageRequestListener((nextPageKey) {
      _fetchClubWorkouts(nextPageKey);
    });
  }

  Future<List<PaginationObject>> _executeClubWorkoutsQuery() async {
    final variables = ClubWorkoutsArguments(
        clubId: widget.clubId,
        take: _resultsPageSize,
        cursors: _cursors,
        requestTypes: _requestTypes);

    final query = ClubWorkoutsQuery(variables: variables);
    final response = await GraphQLStore.store.execute(query);

    if ((response.errors != null && response.errors!.isNotEmpty) ||
        response.data == null) {
      throw Exception(
          'Sorry, something went wrong!: ${response.errors != null ? response.errors!.join(',') : ''}');
    }

    final clubWorkouts = query.parse(response.data ?? {}).clubWorkouts;

    /// Update cursors.
    _cursors.resistanceWorkout = clubWorkouts.resistanceWorkouts.isNotEmpty
        ? clubWorkouts.resistanceWorkouts.last.id
        : _cursors.resistanceWorkout;

    /// Put data in local state.
    _resistanceWorkouts = [
      ..._resistanceWorkouts,
      ...clubWorkouts.resistanceWorkouts
    ];

    /// Format [type]:[id] strings to return.
    final allSorted = [
      ..._resistanceWorkouts.map((w) =>
          PaginationObject(w.id, kResistanceWorkoutTypeName, w.updatedAt))
    ].sortedBy<DateTime>((o) => o.updatedAt);

    return allSorted;
  }

  Future<void> _fetchClubWorkouts(int nextPageKey) async {
    try {
      /// [nextPageKey] defaults to 0 when [_pagingController] is initialised.
      /// For every subsequent call for a page [nextPageKey] will be [NOT 0]
      /// Use as a boolean. If [not 0] then pass [_cursor] to the query args.
      final paginationObjects = await _executeClubWorkoutsQuery();

      final isLastPage = paginationObjects.length < _resultsPageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(paginationObjects);
      } else {
        /// Pass nextPageKey as 1. Acts like a boolean to tell future fetch calls to get the _[cursor] from local state.
        _pagingController.appendPage(paginationObjects, 1);
      }
    } catch (error) {
      printLog(error.toString());
      if (mounted) _pagingController.error = error;
    }

    setState(() {});
  }

  Widget _buildCardByWorkoutType(PaginationObject object) {
    switch (object.type) {
      case kResistanceWorkoutTypeName:
        final resistanceWorkout =
            _resistanceWorkouts.firstWhere((r) => r.id == object.id);
        return GestureDetector(
          onTap: () => context.navigateTo(ResistanceWorkoutDetailsRoute(
              id: resistanceWorkout.id, previousPageTitle: 'Circle')),
          behavior: HitTestBehavior.opaque,
          child: ResistanceWorkoutCard(
            resistanceWorkout: resistanceWorkout,
            showUserAvatar: true,
            showWorkoutTypeIndicator: true,
          ),
        );
      default:
        throw Exception(
            'ClubsResistanceWorkouts: _buildCardByWorkoutType: No builder defined for type ${object.type}');
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, PaginationObject>(
      padding: const EdgeInsets.all(4),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<PaginationObject>(
        itemBuilder: (context, object, index) => FadeInUp(
          key: Key(object.id),
          delay: 5,
          delayBasis: 20,
          duration: 100,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildCardByWorkoutType(object),
          ),
        ),
        firstPageErrorIndicatorBuilder: (c) =>
            const PageResultsErrorIndicator(),
        newPageErrorIndicatorBuilder: (c) => const PageResultsErrorIndicator(),
        firstPageProgressIndicatorBuilder: (c) => const LoadingSpinnerCircle(),
        newPageProgressIndicatorBuilder: (c) => const LoadingSpinnerCircle(),
        noItemsFoundIndicatorBuilder: (c) => const Center(
          child: ContentEmptyPlaceholder(
              message: 'Nothing to display', actions: []),
        ),
      ),
    );
  }
}
