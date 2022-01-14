import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/abstract_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class AMRAPSectionController extends WorkoutSectionController {
  late int _timecapSeconds;
  late StreamSubscription _timerStreamSubscription;
  late int repsCompleted;
  final VoidCallback playBeepOne;

  AMRAPSectionController(
      {required WorkoutSection workoutSection,
      required StopWatchTimer stopWatchTimer,
      required this.playBeepOne,
      required VoidCallback onCompleteSection})
      : super(
            stopWatchTimer: stopWatchTimer,
            workoutSection: workoutSection,
            onCompleteSection: onCompleteSection) {
    _timerStreamSubscription =
        stopWatchTimer.secondTime.listen(_timerStreamListener);
    initialize(workoutSection);
  }

  @override
  void initialize(
    WorkoutSection section,
  ) {
    repsCompleted = 0;
    state = WorkoutSectionProgressState(section);

    /// [workoutSection.timecap] must not be null for an AMRAP.
    _timecapSeconds = section.timecap;

    state.secondsToNextCheckpoint = _timecapSeconds;
    super.initialize(section);
  }

  /// AMRAPS loop infinitely (until time is up) so this method should never return a null value
  @override
  List<WorkoutSet?> getNowAndNextSets(int qty) {
    if (sectionComplete) {
      return <WorkoutSet?>[null];
    }
    final numSetsInSection = workoutSection.workoutSets.length;
    final currentSetIndex = state.currentSetIndex;

    /// [offset] from current active set.
    return List.generate(
        qty,
        (offset) => workoutSection
            .workoutSets[(currentSetIndex + offset) % numSetsInSection]);
  }

  Future<void> _timerStreamListener(int secondsElapsed) async {
    if (sectionComplete || !sectionHasStarted) {
      return;
    } else {
      /// Check for the end of the workout
      if (secondsElapsed >= _timecapSeconds) {
        sectionComplete = true;
        stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        onCompleteSection();
      } else if (_timecapSeconds - secondsElapsed < 4) {
        playBeepOne();
      }

      /// Update time left till timecap and percent complete.
      state.secondsToNextCheckpoint = _timecapSeconds - secondsElapsed;

      /// TODO: Some old AMRAPS might have a zero timecap...they shouldn't but it is possible given how data is structured in the DB.
      state.percentComplete =
          _timecapSeconds == 0 ? 0 : (secondsElapsed / _timecapSeconds);

      progressStateController.add(state);
    }
  }

  /// Public method for the user to progress to the next set (or section if this is the last set).
  @override
  void markCurrentWorkoutSetAsComplete() {
    /// Update reps completed.
    repsCompleted += DataUtils.totalRepsInSet(
        workoutSection.workoutSets[state.currentSetIndex]);

    final secondsElapsed = stopWatchTimer.secondTime.value;
    state.moveToNextSetOrRound(stopWatchTimer.secondTime.value);

    /// Update percentage complete.
    state.percentComplete = secondsElapsed / _timecapSeconds;

    /// Broadcast new state.
    progressStateController.add(state);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _timerStreamSubscription.cancel();
  }
}
