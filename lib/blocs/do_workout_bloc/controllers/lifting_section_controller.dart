import 'package:flutter/material.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/abstract_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

/// Although it extends [WorkoutSectionController] it has some differences.
/// Allows updating of sets (rounds) and moves (load and reps for moves) by updating the main [activeWorkout] object in the [DoWorkoutBloc].
/// The controller maintains a list of completed workoutSet Ids and workout move Ids.
class LiftingSectionController extends WorkoutSectionController
    with ChangeNotifier {
  List<String> completedWorkoutSetIds = [];

  /// state.percentComplete is [completedWorkoutMoveIds.length / totalWorkoutMoves]
  /// Using sets to easily ensure ids are not duplicated when user is marking / unmarking whole set.
  Set<String> completedWorkoutMoveIds = {};

  /// In a lifting section "sets" are workout moves and "exercises" are sets.
  int totalWorkoutMoves = 0;

  LiftingSectionController(
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
    totalWorkoutMoves = section.workoutSets
        .fold(0, (acum, next) => acum + next.workoutMoves.length);
    completedWorkoutMoveIds = <String>{};
    state = WorkoutSectionProgressState(section);
    super.initialize(section);
  }

  /// Should never be called in a FreeSession or Lifting!
  /// Noop.
  @override
  List<WorkoutSet?> getNowAndNextSets(int qty) {
    return [];
  }

  void markWorkoutMoveComplete(WorkoutSet workoutSet, WorkoutMove workoutMove) {
    completedWorkoutMoveIds.add(workoutMove.id);

    final allMoveIdsfromSet =
        workoutSet.workoutMoves.map((wm) => wm.id).toList();

    if (allMoveIdsfromSet.every((id) => completedWorkoutMoveIds.contains(id))) {
      completedWorkoutSetIds.add(workoutSet.id);
    }

    state.percentComplete = completedWorkoutMoveIds.length / totalWorkoutMoves;

    /// Broadcast new state.
    progressStateController.add(state);

    notifyListeners();
  }

  void markWorkoutMoveIncomplete(
      WorkoutSet workoutSet, WorkoutMove workoutMove) {
    completedWorkoutMoveIds.remove(workoutMove.id);

    final allMoveIdsfromSet =
        workoutSet.workoutMoves.map((wm) => wm.id).toList();

    if (allMoveIdsfromSet.any((id) => !completedWorkoutMoveIds.contains(id))) {
      completedWorkoutSetIds.remove(workoutSet.id);
    }

    state.percentComplete = completedWorkoutMoveIds.length / totalWorkoutMoves;

    /// Broadcast new state.
    progressStateController.add(state);

    notifyListeners();
  }

  @override
  void markCurrentWorkoutSetAsComplete() {
    /// Noop. use [markWorkoutSetComplete].
  }
}
