import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';

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

//// Logged Workout To CreateLoggedWorkoutInput ////
////// To add a gym profile to the logged workout input you can either add it to
/// [scheduledWorkout.gymProfile] or to [loggedWorkout.gymProfile].
/// [loggedWorkout.gymProfile] will take precedence over [scheduledWorkout.gymProfile].
CreateLoggedWorkoutInput createLoggedWorkoutInputFromLoggedWorkout(
    LoggedWorkout loggedWorkout,
    {ScheduledWorkout? scheduledWorkout,
    String? workoutPlanDayWorkoutId,
    String? workoutPlanEnrolmentId}) {
  final gymProfile = loggedWorkout.gymProfile ?? scheduledWorkout?.gymProfile;

  return CreateLoggedWorkoutInput(
    name: loggedWorkout.name,
    note: loggedWorkout.note,
    scheduledWorkout: scheduledWorkout != null
        ? ConnectRelationInput(id: scheduledWorkout.id)
        : null,
    workoutPlanDayWorkout: workoutPlanDayWorkoutId != null
        ? ConnectRelationInput(id: workoutPlanDayWorkoutId)
        : null,
    workoutPlanEnrolment: workoutPlanEnrolmentId != null
        ? ConnectRelationInput(id: workoutPlanEnrolmentId)
        : null,
    gymProfile:
        gymProfile != null ? ConnectRelationInput(id: gymProfile.id) : null,
    workoutGoals: loggedWorkout.workoutGoals
        .map((goal) => ConnectRelationInput(id: goal.id))
        .toList(),
    completedOn: loggedWorkout.completedOn,
    workout: loggedWorkout.workoutId != null
        ? ConnectRelationInput(id: loggedWorkout.workoutId!)
        : null,
    loggedWorkoutSections: loggedWorkout.loggedWorkoutSections
        .sortedBy<num>((section) => section.sortPosition)
        .mapIndexed((index, section) =>
            CreateLoggedWorkoutSectionInLoggedWorkoutInput(
              name: section.name,
              sortPosition: index,
              repScore: section.repScore,
              timeTakenSeconds: section.timeTakenSeconds,
              workoutSectionType:
                  ConnectRelationInput(id: section.workoutSectionType.id),
              loggedWorkoutSets: section.loggedWorkoutSets
                  .sortedBy<num>((lws) => lws.sortPosition)
                  .mapIndexed((i, lws) =>
                      CreateLoggedWorkoutSetInLoggedWorkoutSectionInput(
                          sectionRoundNumber: lws.sectionRoundNumber,
                          sortPosition: lws.sortPosition,
                          loggedWorkoutMoves: lws.loggedWorkoutMoves
                              .map((lwm) =>
                                  CreateLoggedWorkoutMoveInLoggedWorkoutSetInput(
                                      equipment: lwm.equipment != null
                                          ? ConnectRelationInput(
                                              id: lwm.equipment!.id)
                                          : null,
                                      distanceUnit: lwm.distanceUnit,
                                      loadUnit: lwm.loadUnit,
                                      loadAmount: lwm.loadAmount,
                                      timeUnit: lwm.timeUnit,
                                      move:
                                          ConnectRelationInput(id: lwm.move.id),
                                      reps: lwm.reps,
                                      repType: lwm.repType,
                                      sortPosition: lwm.sortPosition))
                              .toList()))
                  .toList(),
            ))
        .toList(),
  );
}
