import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Note: Does not currently add [timeTakenSeconds] or create any [loggedWorkoutSets].
CreateLoggedWorkoutSectionInLoggedWorkoutInput
    workoutSectionToLoggedSectionInput(WorkoutSection workoutSection) {
  return CreateLoggedWorkoutSectionInLoggedWorkoutInput(
      sortPosition: workoutSection.sortPosition,
      timeTakenSeconds: 0,
      workoutSectionType:
          ConnectRelationInput(id: workoutSection.workoutSectionType.id),
      loggedWorkoutSets: []);
}

CreateLoggedWorkoutMoveInLoggedWorkoutSetInput
    workoutMoveToCreateLoggedWorkoutMoveInput(WorkoutMove workoutMove) {
  return CreateLoggedWorkoutMoveInLoggedWorkoutSetInput(
      equipment: workoutMove.equipment != null
          ? ConnectRelationInput(id: workoutMove.equipment!.id)
          : null,
      distanceUnit: workoutMove.distanceUnit,
      loadUnit: workoutMove.loadUnit,
      loadAmount: workoutMove.loadAmount,
      timeUnit: workoutMove.timeUnit,
      move: ConnectRelationInput(id: workoutMove.move.id),
      reps: workoutMove.reps,
      repType: workoutMove.repType,
      sortPosition: workoutMove.sortPosition);
}
