import 'package:flutter/material.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
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
      ? workout.name
      : DateTime.now().dateString;
  return LoggedWorkout()
    ..$$typename = kLoggedWorkoutTypename
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
    ..$$typename = kLoggedWorkoutSectionTypename
    ..id = workoutSection.id
    ..name = workoutSection.name
    ..repScore = repScore
    ..sortPosition = workoutSection.sortPosition
    ..timeTakenSeconds = timeTakenSeconds ?? timecapIfValid ?? 0
    ..workoutSectionType = workoutSection.workoutSectionType
    ..loggedWorkoutSets = loggedWorkoutSetsFromWorkoutSection(workoutSection);
}

List<LoggedWorkoutSet> loggedWorkoutSetsFromWorkoutSection(
    WorkoutSection workoutSection) {
  return List.generate(
      workoutSection.rounds,
      (index) => workoutSection.workoutSets
          .map((wSet) => loggedWorkoutSetFromWorkoutSet(
              sectionType: workoutSection.workoutSectionType,
              workoutSet: wSet,
              roundNumber: index))
          .toList()).expand((x) => x).toList();
}

LoggedWorkoutSet loggedWorkoutSetFromWorkoutSet(
    {required WorkoutSectionType sectionType,
    required WorkoutSet workoutSet,
    required int roundNumber}) {
  return LoggedWorkoutSet()
    ..$$typename = kLoggedWorkoutSetTypename
    ..id = workoutSet.id
    ..sectionRoundNumber = roundNumber
    ..sortPosition = workoutSet.sortPosition
    ..timeTakenSeconds = workoutSetDurationOrNull(sectionType, workoutSet)
    ..loggedWorkoutMoves = workoutSet.workoutMoves
        .map((wSet) => loggedWorkoutMoveFromWorkoutMove(wSet))
        .toList();
}

LoggedWorkoutMove loggedWorkoutMoveFromWorkoutMove(WorkoutMove workoutMove) {
  return LoggedWorkoutMove()
    ..$$typename = kLoggedWorkoutMoveTypename
    ..id = workoutMove.id
    ..sortPosition = workoutMove.sortPosition
    ..repType = workoutMove.repType
    ..reps = workoutMove.reps
    ..distanceUnit = workoutMove.distanceUnit
    ..loadAmount = workoutMove.loadAmount
    ..loadUnit = workoutMove.loadUnit
    ..timeUnit = workoutMove.timeUnit
    ..move = workoutMove.move
    ..equipment = workoutMove.equipment;
}

WorkoutMove workoutMoveFromLoggedWorkoutMove(
    LoggedWorkoutMove loggedWorkoutMove) {
  return WorkoutMove()
    ..$$typename = kWorkoutMoveTypename
    ..id = loggedWorkoutMove.id
    ..sortPosition = loggedWorkoutMove.sortPosition
    ..repType = loggedWorkoutMove.repType
    ..reps = loggedWorkoutMove.reps
    ..distanceUnit = loggedWorkoutMove.distanceUnit
    ..loadAmount = loggedWorkoutMove.loadAmount
    ..loadUnit = loggedWorkoutMove.loadUnit
    ..timeUnit = loggedWorkoutMove.timeUnit
    ..move = loggedWorkoutMove.move
    ..equipment = loggedWorkoutMove.equipment;
}

//// Workout Moves List ////
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
  final reps = (workoutSectionType.isTimed &&
          workoutSet.workoutMoves.length == 1)
      ? ''
      : '${generateRepString(distanceUnit: workoutMove.distanceUnit, reps: workoutMove.reps, repType: workoutMove.repType, timeUnit: workoutMove.timeUnit)} ';
  final equipment = displayEquipment && workoutMove.equipment != null
      ? ' ${workoutMove.equipment!.name}'
      : '';
  final load = displayLoad && workoutMove.loadAmount != 0
      ? ' ${generateLoadString(loadAmount: workoutMove.loadAmount, loadUnit: workoutMove.loadUnit)}'
      : '';
  return '$reps${workoutMove.move.name}$load$equipment';
}

//// Logged Workout Moves List ////
Widget generateLoggedWorkoutMoveDisplay(
    {required LoggedWorkoutSet loggedWorkoutSet,
    required LoggedWorkoutMove loggedWorkoutMove,
    required WorkoutSectionType workoutSectionType,
    bool displayEquipment = true,
    bool displayLoad = true}) {
  /// Don't need reps for timed sets with only one move in.
  final reps = generateRepString(
      distanceUnit: loggedWorkoutMove.distanceUnit,
      reps: loggedWorkoutMove.reps,
      repType: loggedWorkoutMove.repType,
      timeUnit: loggedWorkoutMove.timeUnit);

  final equipment = displayEquipment && loggedWorkoutMove.equipment != null
      ? loggedWorkoutMove.equipment!.name
      : '';

  final load = displayLoad && loggedWorkoutMove.loadAmount != 0
      ? generateLoadString(
          loadAmount: loggedWorkoutMove.loadAmount,
          loadUnit: loggedWorkoutMove.loadUnit)
      : '';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      MyText('$reps ${loggedWorkoutMove.move.name}'),
      if (Utils.textNotNull(equipment) || Utils.textNotNull(load))
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: MyText(
            '$load${load != "" ? " " : ""}$equipment',
            color: Styles.primaryAccent,
            size: FONTSIZE.two,
          ),
        ),
    ],
  );
}

//// Moves List Helpers ////
String generateRepString({
  required double reps,
  required WorkoutMoveRepType repType,
  required TimeUnit timeUnit,
  required DistanceUnit distanceUnit,
}) {
  final repUnit = repType == WorkoutMoveRepType.time
      ? timeUnit.shortDisplay.capitalize
      : repType == WorkoutMoveRepType.calories
          ? 'Cals'
          : repType == WorkoutMoveRepType.distance
              ? distanceUnit.shortDisplay.capitalize
              : null;
  final repUnitString = repUnit != null ? ' $repUnit' : '';

  return '${reps.stringMyDouble()}$repUnitString -';
}

String generateLoadString(
        {required double loadAmount, required LoadUnit loadUnit}) =>
    '${loadAmount.stringMyDouble()} ${loadUnit.display}';

int? workoutSetDurationOrNull(WorkoutSectionType type, WorkoutSet workoutSet) =>
    type.isTimed ? workoutSet.duration : null;
