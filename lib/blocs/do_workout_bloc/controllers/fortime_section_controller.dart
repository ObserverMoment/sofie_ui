import 'package:flutter/foundation.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/abstract_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ForTimeSectionController extends WorkoutSectionController {
  late int totalRepsToComplete;
  int repsCompleted = 0;

  ForTimeSectionController(
      {required WorkoutSection workoutSection,
      required StopWatchTimer stopWatchTimer,
      required VoidCallback onCompleteSection})
      : super(
            stopWatchTimer: stopWatchTimer,
            workoutSection: workoutSection,
            onCompleteSection: onCompleteSection) {
    initialize(workoutSection);
  }

  @override
  void initialize(
    WorkoutSection section,
  ) {
    state = WorkoutSectionProgressState(section);
    totalRepsToComplete =
        DataUtils.totalRepsInSection(section) * section.rounds;
    repsCompleted = 0;
    super.initialize(section);
  }

  /// When user reaches the end of the workout this method will start returning [null] for sets which will never be reached.
  @override
  List<WorkoutSet?> getNowAndNextSets(int qty) {
    if (sectionComplete) {
      return <WorkoutSet?>[null];
    }

    final totalRounds = workoutSection.rounds;
    final numSetsInSection = workoutSection.workoutSets.length;
    final currentRoundIndex = state.currentRoundIndex;
    final currentSetIndex = state.currentSetIndex;

    /// [offset] from current active set.
    return List.generate(qty, (offset) {
      if (currentRoundIndex == totalRounds - 1 &&
          (currentSetIndex + offset) > numSetsInSection - 1) {
        return null;
      } else {
        return workoutSection
            .workoutSets[(currentSetIndex + offset) % numSetsInSection];
      }
    });
  }

  /// Public method for the user to progress to the next set (or section if this is the last set in that section).
  @override
  void markCurrentWorkoutSetAsComplete() {
    if (!sectionComplete) {
      /// Update reps completed.
      repsCompleted += DataUtils.totalRepsInSet(
          workoutSection.workoutSets[state.currentSetIndex]);

      /// Update percentage complete.
      state.percentComplete = repsCompleted / totalRepsToComplete;

      /// Move to the next set.
      state.moveToNextSetOrSection(stopWatchTimer.secondTime.value);

      /// Broadcast new state.
      progressStateController.add(state);

      /// Check for end of the section.
      if (repsCompleted >= totalRepsToComplete) {
        sectionComplete = true;
        onCompleteSection();
      }
    }
  }
}
