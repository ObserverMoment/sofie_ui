import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:collection/collection.dart';

/// Converts a workout to a logged workout.
LoggedWorkout loggedWorkoutFromWorkout(
    {required Workout workout,
    ScheduledWorkout? scheduledWorkout,
    bool copySections = false}) {
  final name = Utils.textNotNull(workout.name)
      ? 'Log - ${workout.name}'
      : 'Log - ${DateTime.now().dateString}';
  return LoggedWorkout()
    ..id = workout.id // Temp ID matches the workout
    ..completedOn = scheduledWorkout?.scheduledAt ?? DateTime.now()
    ..note = scheduledWorkout?.note
    ..name = name
    ..gymProfile = scheduledWorkout?.gymProfile
    ..workoutId = workout.id
    ..loggedWorkoutSections = copySections
        ? workout.workoutSections
            .sortedBy<num>((wSection) => wSection.sortPosition)
            .map((ws) =>
                loggedWorkoutSectionFromWorkoutSection(workoutSection: ws))
            .toList()
        : []
    ..workoutGoals = workout.workoutGoals;
}

LoggedWorkoutSection loggedWorkoutSectionFromWorkoutSection(
    {required WorkoutSection workoutSection,
    int? repScore,
    int? timeTakenSeconds}) {
  final timecapIfValid = workoutSection.timecapIfValid;

  if (timecapIfValid == null && timeTakenSeconds == null) {
    throw Exception(
        'Either [timecapIfValid] or [timeTakenSeconds] (usually from a user input are required to be non null when creating a [LoggedWorkoutSection]');
  }

  return LoggedWorkoutSection()
    ..id = workoutSection.id // Temp ID matches the workoutSection
    ..name = workoutSection.name
    ..repScore = repScore
    ..sortPosition = workoutSection.sortPosition
    ..timeTakenSeconds = timeTakenSeconds ?? timecapIfValid ?? 0
    ..workoutSectionType = workoutSection.workoutSectionType
    ..bodyAreas = workoutSection.uniqueBodyAreas
    ..moveTypes = workoutSection.uniqueMoveTypes
    ..loggedWorkoutSectionData =
        loggedWorkoutSectionDataFromWorkoutSection(workoutSection);
}

LoggedWorkoutSectionData loggedWorkoutSectionDataFromWorkoutSection(
    WorkoutSection workoutSection) {
  final sortedSets =
      workoutSection.workoutSets.sortedBy<num>((wSet) => wSet.sortPosition);
  final roundsData = List.generate(
      workoutSection.rounds,
      (index) => WorkoutSectionRoundData()
        ..timeTakenSeconds = workoutSection.timecapIfValid ?? 0
        ..sets = sortedSets
            .map((wSet) => loggedWorkoutSetDataFromWorkoutSet(
                wSet, workoutSection.workoutSectionType))
            .toList());

  return LoggedWorkoutSectionData()..rounds = roundsData;
}

WorkoutSectionRoundSetData loggedWorkoutSetDataFromWorkoutSet(
    WorkoutSet workoutSet, WorkoutSectionType workoutSectionType,
    {int? timeTakenseconds}) {
  return WorkoutSectionRoundSetData()
    ..rounds = workoutSet.rounds
    ..moves = generateMovesList(workoutSet, workoutSectionType)
    ..timeTakenSeconds = timeTakenseconds ??
        workoutSetDurationOrNull(workoutSectionType, workoutSet) ??
        0;
}

String generateMovesList(
        WorkoutSet workoutSet, WorkoutSectionType workoutSectionType) =>
    workoutSet.workoutMoves
        .sortedBy<num>((wMove) => wMove.sortPosition)
        .map((wm) => generateWorkoutMoveString(
            workoutSet: workoutSet,
            workoutMove: wm,
            workoutSectionType: workoutSectionType))
        .join(',');

String generateWorkoutMoveString(
    {required WorkoutSet workoutSet,
    required WorkoutMove workoutMove,
    required WorkoutSectionType workoutSectionType,
    bool displayEquipment = true,
    bool displayLoad = true}) {
  /// Don't need reps for timed sets with only one move in.
  final reps =
      (workoutSectionType.isTimed && workoutSet.workoutMoves.length == 1)
          ? ''
          : '${generateRepString(workoutMove)} ';
  final equipment = displayEquipment && workoutMove.equipment != null
      ? ' ${workoutMove.equipment!.name}'
      : '';
  final load = displayLoad && workoutMove.loadAmount != 0
      ? ' ${generateLoadString(workoutMove)}'
      : '';
  return '$reps${workoutMove.move.name}$load$equipment';
}

/// Very simlar to the [WorkoutMoveDisplay] widget.
String generateRepString(
  WorkoutMove workoutMove,
) {
  final repUnit = workoutMove.repType == WorkoutMoveRepType.time
      ? workoutMove.timeUnit.shortDisplay
      : workoutMove.repType == WorkoutMoveRepType.distance
          ? workoutMove.distanceUnit.shortDisplay
          : null;

  return '${workoutMove.reps.stringMyDouble()}${repUnit != null ? " $repUnit" : ""}';
}

String generateLoadString(WorkoutMove workoutMove) =>
    '(${workoutMove.loadAmount.stringMyDouble()} ${workoutMove.loadUnit.display})';

int? workoutSetDurationOrNull(WorkoutSectionType type, WorkoutSet workoutSet) =>
    type.isTimed ? workoutSet.duration : null;
