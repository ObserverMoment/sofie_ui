import 'package:flutter/material.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/abstract_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

/// Although it extends [WorkoutSectionController] it is not very similar...
/// Allows updating of sets (rounds) and moves (load and reps for moves) by updating the main [activeWorkout] object in the [DoWorkoutBloc].
/// The controller maintains a list of completed workoutSet Ids.
class FreeSessionSectionController extends WorkoutSectionController
    with ChangeNotifier {
  List<String> completedWorkoutSetIds = [];

  FreeSessionSectionController(
      {required WorkoutSection workoutSection,
      required StopWatchTimer stopWatchTimer,
      required void Function() onCompleteSection})
      : super(
            workoutSection: workoutSection,
            stopWatchTimer: stopWatchTimer,
            onCompleteSection: onCompleteSection) {
    initialize(workoutSection);
  }

  @override
  void initialize(
    WorkoutSection section,
  ) {
    state = WorkoutSectionProgressState(section);
    super.initialize(section);
  }

  /// Should never be called in a FreeSession!
  /// Noop.
  @override
  List<WorkoutSet?> getNowAndNextSets(int qty) {
    return [];
  }

  void markWorkoutSetComplete(WorkoutSet workoutSet) {
    completedWorkoutSetIds.add(workoutSet.id);
    state.updateSectionRoundSetDataFromCompletedSets(workoutSection.workoutSets
        .where((wSet) => completedWorkoutSetIds.contains(wSet.id))
        .toList());
    state.percentComplete =
        completedWorkoutSetIds.length / workoutSection.workoutSets.length;
    notifyListeners();
  }

  void markWorkoutSetIncomplete(WorkoutSet workoutSet) {
    completedWorkoutSetIds.remove(workoutSet.id);
    state.updateSectionRoundSetDataFromCompletedSets(workoutSection.workoutSets
        .where((wSet) => completedWorkoutSetIds.contains(wSet.id))
        .toList());
    state.percentComplete =
        completedWorkoutSetIds.length / workoutSection.workoutSets.length;
    notifyListeners();
  }

  void updateWorkoutSetRepeats(int setSortPosition, int rounds) {
    final setToUpdate = workoutSection.workoutSets
        .firstWhere((wSet) => wSet.sortPosition == setSortPosition);
    setToUpdate.rounds = rounds;

    workoutSection.workoutSets = workoutSection.workoutSets
        .map((o) => setSortPosition == o.sortPosition ? setToUpdate : o)
        .toList();

    notifyListeners();
  }

  void updateWorkoutMove(int setSortPosition, WorkoutMove workoutMove) {
    final setToUpdate = workoutSection.workoutSets
        .firstWhere((wSet) => wSet.sortPosition == setSortPosition);

    setToUpdate.workoutMoves = setToUpdate.workoutMoves
        .map((o) => o.id == workoutMove.id ? workoutMove : o)
        .toList();

    workoutSection.workoutSets = workoutSection.workoutSets
        .map((o) => setSortPosition == o.sortPosition ? setToUpdate : o)
        .toList();
    notifyListeners();
  }

  @override
  void markCurrentWorkoutSetAsComplete() {
    /// Noop. use [markWorkoutSetComplete].
  }
}
