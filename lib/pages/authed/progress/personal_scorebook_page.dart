import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/user_fastest_time_exercise_trackers.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/user_max_load_exercise_trackers.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/user_max_unbroken_exercise_tracker.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

class PersonalScoresPage extends StatelessWidget {
  const PersonalScoresPage({Key? key}) : super(key: key);

  void _openCreateTrackerSelectType(BuildContext context) {
    openBottomSheetMenu(
        context: context,
        child: BottomSheetMenu(items: [
          BottomSheetMenuItem(
              text: 'Max Lift / Max Load',
              onPressed: () => _openMaxLoadExerciseTrackerCreator(context)),
          BottomSheetMenuItem(
              text: 'Fastest Time',
              onPressed: () => _openFastestExerciseTrackerCreator(context)),
          BottomSheetMenuItem(
              text: 'Max Unbroken',
              onPressed: () => _openMaxUnbrokenExerciseTrackerCreator(context)),
        ]));
  }

  void _openMaxLoadExerciseTrackerCreator(BuildContext context) {
    context.navigateTo(const MaxLoadTrackerCreatorRoute());
  }

  void _openFastestExerciseTrackerCreator(BuildContext context) {
    context.navigateTo(const FastestTimeTrackerCreatorRoute());
  }

  void _openMaxUnbrokenExerciseTrackerCreator(BuildContext context) {
    context.navigateTo(const MaxUnbrokenTrackerCreatorRoute());
  }

  @override
  Widget build(BuildContext context) {
    /// TODO: Too much nesting!
    final userLoggedWorkoutsQuery = UserLoggedWorkoutsQuery();
    final userMaxLoadExerciseTrackersQuery = UserMaxLoadExerciseTrackersQuery();
    final userFastestTimeExerciseTrackersQuery =
        UserFastestTimeExerciseTrackersQuery();
    final userMaxUnbrokenExerciseTrackersQuery =
        UserMaxUnbrokenExerciseTrackersQuery();

    return QueryObserver<UserLoggedWorkouts$Query, json.JsonSerializable>(
        key: Key(
            'LoggedWorkoutsPage - ${userLoggedWorkoutsQuery.operationName}'),
        query: userLoggedWorkoutsQuery,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (loggedWorkouts) {
          return QueryObserver<UserMaxLoadExerciseTrackers$Query,
                  json.JsonSerializable>(
              key: Key(
                  'PersonalScoresPage - ${userMaxLoadExerciseTrackersQuery.operationName}'),
              query: userMaxLoadExerciseTrackersQuery,
              builder: (userMaxLoadExerciseTrackers) {
                return QueryObserver<UserFastestTimeExerciseTrackers$Query,
                        json.JsonSerializable>(
                    key: Key(
                        'PersonalScoresPage - ${userFastestTimeExerciseTrackersQuery.operationName}'),
                    query: userFastestTimeExerciseTrackersQuery,
                    builder: (userFastestTimeExerciseTrackers) {
                      return QueryObserver<
                              UserMaxUnbrokenExerciseTrackers$Query,
                              json.JsonSerializable>(
                          key: Key(
                              'UserMaxUnbrokenExerciseTrackers - ${userMaxUnbrokenExerciseTrackersQuery.operationName}'),
                          query: userMaxUnbrokenExerciseTrackersQuery,
                          builder: (userMaxUnbrokenExerciseTrackers) {
                            final noTrackers = userMaxLoadExerciseTrackers
                                    .userMaxLoadExerciseTrackers.isEmpty &&
                                userFastestTimeExerciseTrackers
                                    .userFastestTimeExerciseTrackers.isEmpty &&
                                userMaxUnbrokenExerciseTrackers
                                    .userMaxUnbrokenExerciseTrackers.isEmpty;

                            return MyPageScaffold(
                                child: NestedScrollView(
                                    headerSliverBuilder: (c, i) => [
                                          const MySliverNavbar(
                                            title: 'Personal Scorebook',
                                          ),
                                        ],
                                    body: noTrackers
                                        ? Center(
                                            child: YourContentEmptyPlaceholder(
                                                message:
                                                    'Create widgets to track your scores!',
                                                explainer:
                                                    'You can track things like scored workouts, max lifts, fastest times and max unbroken movements. Define your trackers here and then your scores will auto update when you log workouts, or you can add manual score entries complete with videos.',
                                                actions: [
                                                  EmptyPlaceholderAction(
                                                      action: () =>
                                                          _openCreateTrackerSelectType(
                                                              context),
                                                      buttonIcon:
                                                          CupertinoIcons.add,
                                                      buttonText:
                                                          'Create Score Tracker'),
                                                ]),
                                          )
                                        : FABPage(
                                            rowButtons: [
                                              FloatingButton(
                                                  text: 'Create New Tracker',
                                                  icon: CupertinoIcons.plus,
                                                  iconSize: 20,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16,
                                                      vertical: 11),
                                                  onTap: () =>
                                                      _openCreateTrackerSelectType(
                                                          context))
                                            ],
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              children: [
                                                UserMaxLoadExerciseTrackers(
                                                  trackers:
                                                      userMaxLoadExerciseTrackers
                                                          .userMaxLoadExerciseTrackers,
                                                  loggedWorkouts: loggedWorkouts
                                                      .userLoggedWorkouts,
                                                ),
                                                UserFastestTimeExerciseTrackers(
                                                  trackers:
                                                      userFastestTimeExerciseTrackers
                                                          .userFastestTimeExerciseTrackers,
                                                  loggedWorkouts: loggedWorkouts
                                                      .userLoggedWorkouts,
                                                ),
                                                UserMaxUnbrokenExerciseTrackers(
                                                  trackers:
                                                      userMaxUnbrokenExerciseTrackers
                                                          .userMaxUnbrokenExerciseTrackers,
                                                  loggedWorkouts: loggedWorkouts
                                                      .userLoggedWorkouts,
                                                ),
                                              ],
                                            ),
                                          )));
                          });
                    });
              });
        });
  }
}
