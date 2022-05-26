import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/club_card.dart';
import 'package:sofie_ui/components/cards/workout_card.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

/// Uses the same logic as [ProfilePage] to watch the router and re-query for recently viewed items whenever the user pushes or pops to this page.
/// [List<UserRecentlyViewedObject>]: List of mixed type objects that the user has interacted with recently.
/// [Workouts], [Plans], [Clubs], [Throwdowns] etc.
class RecentlyViewedObjects extends StatefulWidget {
  const RecentlyViewedObjects({Key? key}) : super(key: key);

  @override
  State<RecentlyViewedObjects> createState() => _RecentlyViewedObjectsState();
}

class _RecentlyViewedObjectsState extends State<RecentlyViewedObjects> {
  late final String _routeName;
  List<UserRecentlyViewedObject> _recents = [];
  bool _initDataRetrieved = false;

  /// Save a ref to avoid throwing errors when disposing (user logging in / out).
  /// Re. To safely refer to a widget's ancestor in its dispose() method, save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method
  late StackRouter _router;

  Future<void> _getRecentlyViewedList() async {
    final result = await GraphQLStore.store
        .networkOnlyOperation(operation: UserRecentlyViewedObjectsQuery());

    _initDataRetrieved = true;

    checkOperationResult(result,
        onSuccess: () {
          setState(
            () {
              _recents = result.data!.userRecentlyViewedObjects;
            },
          );
        },
        onFail: () => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    _router = context.router;
    _routeName = context.routeData.name;

    _getRecentlyViewedList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Instead of using polling or a websocket to get 'real time' updates to this list we re-run the query whenever the user pushes or pops to the page. I think this should be more efficient than either polling or setting up a websocket (certainly more simple than setting up a websocket and more efficient than polling).
    /// So we listen to the AutoRouter and check for when we are landing back on this page.
    _router.root.removeListener(_didPopOrSwitchToThisRoute);
    _router.root.addListener(_didPopOrSwitchToThisRoute);
  }

  void _didPopOrSwitchToThisRoute() {
    /// We need to run two checks.
    /// 1. is the AuthedRouter [router] currently showing the [MainTabsRoute].
    /// 2. Is the active tab route [tabsRouter] the same as [_routeName]
    if (_router.currentChild?.name == MainTabsRoute.name &&
        _routeName == context.tabsRouter.current.name) {
      _getRecentlyViewedList();
    }
  }

  Widget _buildRecentObjectCard(
      BuildContext context, UserRecentlyViewedObject object) {
    if (object.club != null) {
      return GestureDetector(
          onTap: () =>
              context.navigateTo(ClubDetailsRoute(id: object.club!.id)),
          child: ClubCard(club: object.club!));
    } else if (object.workout != null) {
      return GestureDetector(
          onTap: () =>
              context.navigateTo(WorkoutDetailsRoute(id: object.workout!.id)),
          child: WorkoutCard(object.workout!));
    } else if (object.workoutPlan != null) {
      return GestureDetector(
          onTap: () => context
              .navigateTo(WorkoutPlanDetailsRoute(id: object.workoutPlan!.id)),
          child: WorkoutPlanCard(object.workoutPlan!));
    } else {
      printLog(
          'RecentlyViewedObjects._buildRecentObjectCard: No valid sub field was found for $object');
      return Container();
    }
  }

  @override
  void dispose() {
    _router.root.removeListener(_didPopOrSwitchToThisRoute);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_initDataRetrieved
        ? const Padding(
            padding: EdgeInsets.all(32.0),
            child: CupertinoActivityIndicator(),
          )
        : _recents.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: const [
                    Opacity(
                        opacity: 0.4,
                        child: Icon(CupertinoIcons.list_bullet, size: 40)),
                    SizedBox(height: 12),
                    MyText(
                      'Nothing here yet...',
                      subtext: true,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                cacheExtent: 3000,
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recents.length,
                separatorBuilder: (c, i) => const SizedBox(height: 16),
                itemBuilder: (c, i) =>
                    _buildRecentObjectCard(context, _recents[i]));
  }
}
