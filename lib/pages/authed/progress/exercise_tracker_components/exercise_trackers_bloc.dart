import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:json_annotation/json_annotation.dart' as json;

/// Bloc that manages all the data needed to display the three types of exercise trackers, plus the log history data that they need.
class ExerciseTrackersBloc extends ChangeNotifier {
  List<LoggedWorkout> loggedWorkouts = [];

  List<UserMaxLoadExerciseTracker> userMaxLoadExerciseTrackers = [];
  List<MaxLoadScoreWithCompletedOnDate> userMaxLoadScoresFromLogHistory = [];

  List<UserFastestTimeExerciseTracker> userFastestTimeExerciseTrackers = [];

  List<UserMaxUnbrokenExerciseTracker> userMaxUnbrokenExerciseTrackers = [];

  bool initialized = false;

  late GraphQLStore _graphQlStore;

  late ObservableQuery<UserLoggedWorkouts$Query, json.JsonSerializable>
      _userLoggedWorkoutsQuery;
  late StreamSubscription _userLoggedWorkoutsQueryListener;

  late ObservableQuery<UserMaxLoadExerciseTrackers$Query, json.JsonSerializable>
      _userMaxLoadExerciseTrackersQuery;
  late StreamSubscription _userMaxLoadExerciseTrackersQueryListener;

  late ObservableQuery<UserFastestTimeExerciseTrackers$Query,
      json.JsonSerializable> _userFastestTimeExerciseTrackersQuery;
  late StreamSubscription _userFastestTimeExerciseTrackersQueryListener;

  late ObservableQuery<UserMaxUnbrokenExerciseTrackers$Query,
      json.JsonSerializable> _userMaxUnbrokenExerciseTrackersQuery;
  late StreamSubscription _userMaxUnbrokenExerciseTrackersQueryListener;

  ExerciseTrackersBloc(BuildContext context) {
    _init(context);
  }

  Future<void> _init(BuildContext context) async {
    _graphQlStore = context.read<GraphQLStore>();
    await Future.wait([
      _setupLoggedWorkoutsQuery(),
      _setupMaxLoadExerciseTrackersQuery(),
      _setupFastestTimeExerciseTrackersQuery(),
      _setupMaxUnbrokenExerciseTrackersQuery(),
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

    /// TODO: The same for FastestTime and MaxUnbroken
    _convertAllMaxLoadScoresFromLogHistory();
    // convertAllMaxLoadScoresFromLogHistory();
    // convertAllMaxLoadScoresFromLogHistory();

    _userLoggedWorkoutsQueryListener =
        _userLoggedWorkoutsQuery.subject.listen((value) {
      if (!value.hasErrors && value.data != null) {
        loggedWorkouts = [...value.data!.userLoggedWorkouts];

        /// TODO: The same for FastestTime and MaxUnbroken
        _convertAllMaxLoadScoresFromLogHistory();
        // convertAllMaxLoadScoresFromLogHistory();
        // convertAllMaxLoadScoresFromLogHistory();
        notifyListeners();
      }
    });
  }

  Future<void> _setupMaxLoadExerciseTrackersQuery() async {
    _userMaxLoadExerciseTrackersQuery = _graphQlStore.registerObserver<
            UserMaxLoadExerciseTrackers$Query,
            json.JsonSerializable>(UserMaxLoadExerciseTrackersQuery(),
        parameterizeQuery: false);

    await _graphQlStore.fetchInitialQuery(
        id: _userMaxLoadExerciseTrackersQuery.id,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        garbageCollectAfterFetch: false);

    _userMaxLoadExerciseTrackersQueryListener =
        _userMaxLoadExerciseTrackersQuery.subject.listen((value) {
      if (!value.hasErrors && value.data != null) {
        userMaxLoadExerciseTrackers = [
          ...value.data!.userMaxLoadExerciseTrackers
        ];
        notifyListeners();
      }
    });
  }

  Future<void> _setupFastestTimeExerciseTrackersQuery() async {
    _userFastestTimeExerciseTrackersQuery = _graphQlStore.registerObserver<
            UserFastestTimeExerciseTrackers$Query,
            json.JsonSerializable>(UserFastestTimeExerciseTrackersQuery(),
        parameterizeQuery: false);

    await _graphQlStore.fetchInitialQuery(
        id: _userFastestTimeExerciseTrackersQuery.id,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        garbageCollectAfterFetch: false);

    _userFastestTimeExerciseTrackersQueryListener =
        _userFastestTimeExerciseTrackersQuery.subject.listen((value) {
      if (!value.hasErrors && value.data != null) {
        userFastestTimeExerciseTrackers = [
          ...value.data!.userFastestTimeExerciseTrackers
        ];
        notifyListeners();
      }
    });
  }

  Future<void> _setupMaxUnbrokenExerciseTrackersQuery() async {
    _userMaxUnbrokenExerciseTrackersQuery = _graphQlStore.registerObserver<
            UserMaxUnbrokenExerciseTrackers$Query,
            json.JsonSerializable>(UserMaxUnbrokenExerciseTrackersQuery(),
        parameterizeQuery: false);

    await _graphQlStore.fetchInitialQuery(
        id: _userMaxUnbrokenExerciseTrackersQuery.id,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        garbageCollectAfterFetch: false);

    _userMaxUnbrokenExerciseTrackersQueryListener =
        _userMaxUnbrokenExerciseTrackersQuery.subject.listen((value) {
      if (!value.hasErrors && value.data != null) {
        userMaxUnbrokenExerciseTrackers = [
          ...value.data!.userMaxUnbrokenExerciseTrackers
        ];
        notifyListeners();
      }
    });
  }

  /// Covert all relevant log history to a list of [MaxLoadScoreWithCompletedOnDate] and save them to local state. Run this on init and whenever [userLoggedWorkoutQuery] is updated.
  void _convertAllMaxLoadScoresFromLogHistory() {
    final List<MaxLoadScoreWithCompletedOnDate> allScores = [];

    for (final log in loggedWorkouts) {
      for (final lwSection in log.loggedWorkoutSections) {
        for (final lwSet in lwSection.loggedWorkoutSets) {
          /// Moves logged in LoadUnit bodyPercent or percentMax cannot be converted to a display in KG or LB. Only include KG and LB.
          allScores.addAll(lwSet.loggedWorkoutMoves
              .where((lwm) =>
                  lwm.loadUnit == LoadUnit.kg || lwm.loadUnit == LoadUnit.lb)
              .map((lwm) => MaxLoadScoreWithCompletedOnDate(
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

    userMaxLoadScoresFromLogHistory = allScores;
  }

  /// Get all the workout moves from log history, plus [tracker.manualEntries] and convert them all into [MaxLoadScoreWithCompletedOnDate] for display in a UI widget.
  List<MaxLoadScoreWithCompletedOnDate> retrieveTrackerRelevantScores(
      UserMaxLoadExerciseTracker tracker) {
    /// Get the matching scores - i.e. where move, equipment and reps match.
    /// Format all as [MaxLoadScoreWithCompletedOnDate]
    final trackerRelevantScoresFromHistory =
        userMaxLoadScoresFromLogHistory.where((score) {
      return tracker.move == score.move &&
          tracker.equipment == score.equipment &&
          tracker.reps <= score.reps;
    }).toList();

    /// Ensure all logs from history have been converted to the correct unit system.
    for (final score in trackerRelevantScoresFromHistory) {
      score.loadAmount = ExerciseTrackerUtils.convertToTrackerLoadUnit(
          loadAmount: score.loadAmount,
          targetUnit: tracker.loadUnit,
          loggedUnit: score.loadUnit);
      score.loadUnit = tracker.loadUnit;
    }

    final scoresFromManualEntries = tracker.manualEntries
        .map((entry) => MaxLoadScoreWithCompletedOnDate(
              completedOn: entry.completedOn,
              equipment: tracker.equipment,
              loadAmount: entry.loadAmount,
              loadUnit: tracker.loadUnit,
              move: tracker.move,
              reps: tracker.reps,
              videoUri: entry.videoUri,
              manualEntryId: entry.id,
            ))
        .toList();

    return [...trackerRelevantScoresFromHistory, ...scoresFromManualEntries];
  }

  @override
  void dispose() {
    /// Cancel listeners.
    _userLoggedWorkoutsQueryListener.cancel();
    _userMaxLoadExerciseTrackersQueryListener.cancel();
    _userFastestTimeExerciseTrackersQueryListener.cancel();
    _userMaxUnbrokenExerciseTrackersQueryListener.cancel();

    /// Unregister query observers to close streams if necessary.
    _graphQlStore.unregisterObserver(_userLoggedWorkoutsQuery.id);
    _graphQlStore.unregisterObserver(_userMaxLoadExerciseTrackersQuery.id);
    _graphQlStore.unregisterObserver(_userFastestTimeExerciseTrackersQuery.id);
    _graphQlStore.unregisterObserver(_userMaxUnbrokenExerciseTrackersQuery.id);
    super.dispose();
  }
}

class MaxLoadScoreWithCompletedOnDate
    implements Comparable<MaxLoadScoreWithCompletedOnDate> {
  DateTime completedOn;
  double loadAmount;
  LoadUnit loadUnit;
  Move move;
  Equipment? equipment;
  int reps;
  String? videoUri;
  String? videoThumbUri;

  /// [loggedWorkoutId] XOR [manualEntryId]
  String? loggedWorkoutId;
  String? manualEntryId;

  MaxLoadScoreWithCompletedOnDate({
    required this.move,
    required this.equipment,
    required this.loadAmount,
    required this.completedOn,
    required this.loadUnit,
    required this.reps,
    this.manualEntryId,
    this.loggedWorkoutId,
    this.videoUri,
  });

  /// Sorts by highest loadAmount and then by date.
  @override
  int compareTo(MaxLoadScoreWithCompletedOnDate other) {
    if (loadAmount != other.loadAmount) {
      return loadAmount.compareTo(other.loadAmount);
    } else {
      return completedOn.compareTo(other.completedOn);
    }
  }
}
