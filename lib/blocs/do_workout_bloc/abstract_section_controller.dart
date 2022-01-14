import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

/// Abstract parent for all workout section type sub controllers.
abstract class WorkoutSectionController {
  late WorkoutSection workoutSection;

  final StopWatchTimer stopWatchTimer;

  /// Broadcast changes to the progress state.
  StreamController<WorkoutSectionProgressState> progressStateController =
      StreamController<WorkoutSectionProgressState>.broadcast();

  Stream<WorkoutSectionProgressState> get progressStream =>
      progressStateController.stream;

  late WorkoutSectionProgressState state;

  bool sectionHasStarted = false;
  bool sectionComplete = false;

  late CreateLoggedWorkoutSectionInLoggedWorkoutInput loggedSection;

  final VoidCallback onCompleteSection;

  WorkoutSectionController(
      {required this.onCompleteSection,
      required this.workoutSection,
      required this.stopWatchTimer}) {
    initialize(workoutSection);
  }

  /// Based on the current state, what set are you doing now and which sets are coming up.
  /// [qty] is the total number returned including the current set.
  /// i.e if [qty] == 3 you get current set and two upcoming sets.
  /// Noop in Timed workouts and Free Session
  List<WorkoutSet?> getNowAndNextSets(int qty);

  /// Public method for the user to progress to the next set (or section if this is the last set).
  /// Noop in Timed workouts and Free Session
  void markCurrentWorkoutSetAsComplete();

  @mustCallSuper // Call super.initialize() at the end in descendants as this broadcasts the state. Sepcial state setup can be done in descendants if needed for each particular section type.
  /// Also use this for resetting section functionality.
  void initialize(
    WorkoutSection section,
  ) {
    workoutSection = WorkoutSection.fromJson(section.toJson());
    sectionHasStarted = false;
    sectionComplete = false;
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    progressStateController.add(state);
  }

  @mustCallSuper
  void dispose() {
    progressStateController.close();
    stopWatchTimer.dispose();
  }
}
