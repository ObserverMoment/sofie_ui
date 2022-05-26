import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:json_annotation/json_annotation.dart' as json;

/// Bloc that manages all the data needed to display exercise trackers, plus the log history data that they need.
/// [userExerciseLoadTrackers] search log history for heaviest lifts for a given move + reps + equipment combination.
class ExerciseTrackersBloc extends ChangeNotifier {
  List<LoggedWorkout> loggedWorkouts = [];

  List<UserExerciseLoadTracker> userExerciseLoadTrackers = [];
  List<ExerciseLoadScoreWithCompletedOnDate> userLoadScoresFromLogHistory = [];

  bool initialized = false;

  late GraphQLStore _graphQlStore;

  late ObservableQuery<UserLoggedWorkouts$Query, json.JsonSerializable>
      _userLoggedWorkoutsQuery;
  late StreamSubscription _userLoggedWorkoutsQueryListener;

  late ObservableQuery<UserExerciseLoadTrackers$Query, json.JsonSerializable>
      _userExerciseLoadTrackersQuery;
  late StreamSubscription _userExerciseLoadTrackersQueryListener;

  ExerciseTrackersBloc(BuildContext context) {
    _init(context);
  }

  Future<void> _init(BuildContext context) async {
    _graphQlStore = GraphQLStore.store;
    await Future.wait([
      _setupLoggedWorkoutsQuery(),
      _setupExerciseLoadTrackersQuery(),
    ]);

    initialized = true;
    notifyListeners();
  }

  Future<void> _setupLoggedWorkoutsQuery() async {
    _userLoggedWorkoutsQuery = _graphQlStore
        .registerObserver<UserLoggedWorkouts$Query, json.JsonSerializable>(
            UserLoggedWorkoutsQuery(),
            parameterizeQuery: false);

    await _graphQlStore.fetchInitialQuery(
        id: _userLoggedWorkoutsQuery.id,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        garbageCollectAfterFetch: false);

    _convertAllLoadScoresFromLogHistory();

    _userLoggedWorkoutsQueryListener =
        _userLoggedWorkoutsQuery.subject.listen((value) {
      if (!value.hasErrors && value.data != null) {
        loggedWorkouts = [...value.data!.userLoggedWorkouts];

        _convertAllLoadScoresFromLogHistory();

        notifyListeners();
      }
    });
  }

  Future<void> _setupExerciseLoadTrackersQuery() async {
    _userExerciseLoadTrackersQuery = _graphQlStore.registerObserver<
            UserExerciseLoadTrackers$Query,
            json.JsonSerializable>(UserExerciseLoadTrackersQuery(),
        parameterizeQuery: false);

    await _graphQlStore.fetchInitialQuery(
        id: _userExerciseLoadTrackersQuery.id,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        garbageCollectAfterFetch: false);

    _userExerciseLoadTrackersQueryListener =
        _userExerciseLoadTrackersQuery.subject.listen((value) {
      if (!value.hasErrors && value.data != null) {
        userExerciseLoadTrackers = [...value.data!.userExerciseLoadTrackers];
        notifyListeners();
      }
    });
  }

  /// Convert all relevant log history to a list of [ExerciseLoadScoreWithCompletedOnDate] and save them to local state. Run this on init and whenever [userLoggedWorkoutQuery] is updated.
  void _convertAllLoadScoresFromLogHistory() {
    final List<ExerciseLoadScoreWithCompletedOnDate> allScores = [];

    for (final log in loggedWorkouts) {
      for (final lwSection in log.loggedWorkoutSections) {
        for (final lwSet in lwSection.loggedWorkoutSets) {
          /// Moves logged in LoadUnit bodyPercent or percentMax cannot be converted to a display in KG or LB. Only include KG and LB.
          allScores.addAll(lwSet.loggedWorkoutMoves
              .where((lwm) =>
                  lwm.loadUnit == LoadUnit.kg || lwm.loadUnit == LoadUnit.lb)
              .map((lwm) => ExerciseLoadScoreWithCompletedOnDate(
                    completedOn: log.completedOn,
                    loadAmount: lwm.loadAmount,
                    loadUnit: lwm.loadUnit,
                    equipment: lwm.equipment,
                    move: lwm.move,
                    reps: lwm.reps.round(),
                    loggedWorkoutId: log.id,
                  )));
        }
      }
    }

    userLoadScoresFromLogHistory = allScores;
  }

  /// Get all the workout moves from log history, plus [tracker.manualEntries] and convert them all into [ExerciseLoadScoreWithCompletedOnDate] for display in a UI widget.
  List<ExerciseLoadScoreWithCompletedOnDate>
      retrieveMaxLoadTrackerRelevantScores(UserExerciseLoadTracker tracker) {
    /// Get the matching scores - i.e. where move, equipment and reps match.
    /// Format all as [ExerciseLoadScoreWithCompletedOnDate]
    final trackerRelevantScoresFromHistory =
        userLoadScoresFromLogHistory.where((score) {
      return tracker.move == score.move &&
          tracker.equipment == score.equipment &&
          tracker.reps == score.reps;
    }).toList();

    /// Ensure all logs from history have been converted to the correct unit system.
    for (final score in trackerRelevantScoresFromHistory) {
      score.loadAmount = ExerciseTrackerUtils.convertToTrackerLoadUnit(
          loadAmount: score.loadAmount,
          targetUnit: tracker.loadUnit,
          loggedUnit: score.loadUnit);
      score.loadUnit = tracker.loadUnit;
    }

    return trackerRelevantScoresFromHistory;
  }

  @override
  void dispose() {
    /// Cancel listeners.
    _userLoggedWorkoutsQueryListener.cancel();
    _userExerciseLoadTrackersQueryListener.cancel();

    /// Unregister query observers to close streams if necessary.
    _graphQlStore.unregisterObserver(_userLoggedWorkoutsQuery.id);
    _graphQlStore.unregisterObserver(_userExerciseLoadTrackersQuery.id);
    super.dispose();
  }
}

class ExerciseLoadScoreWithCompletedOnDate
    implements Comparable<ExerciseLoadScoreWithCompletedOnDate> {
  DateTime completedOn;
  double loadAmount;
  LoadUnit loadUnit;
  Move move;
  Equipment? equipment;
  int reps;

  /// [loggedWorkoutId]
  String? loggedWorkoutId;

  ExerciseLoadScoreWithCompletedOnDate({
    required this.move,
    required this.equipment,
    required this.loadAmount,
    required this.completedOn,
    required this.loadUnit,
    required this.reps,
    this.loggedWorkoutId,
  });

  /// Sorts by highest loadAmount and then by date.
  @override
  int compareTo(ExerciseLoadScoreWithCompletedOnDate other) {
    if (loadAmount != other.loadAmount) {
      return loadAmount.compareTo(other.loadAmount);
    } else {
      return completedOn.compareTo(other.completedOn);
    }
  }
}
