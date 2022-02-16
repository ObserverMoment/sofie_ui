import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:collection/collection.dart';

/// Converts a workout to a logged workout.
LoggedWorkout loggedWorkoutFromWorkout(
    {required Workout workout,
    bool copySections = false,
    DateTime? completedOn,
    String? note,
    GymProfile? gymProfile}) {
  final name = Utils.textNotNull(workout.name)
      ? workout.name
      : DateTime.now().dateString;
  return LoggedWorkout()
    ..$$typename = kLoggedWorkoutTypename
    ..id = workout.id // Temp ID matches the workout
    ..completedOn = completedOn ?? DateTime.now()
    ..note = note
    ..name = name
    ..gymProfile = gymProfile
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
    int? timeTakenSeconds,
    int? rounds}) {
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
    ..loggedWorkoutSets =
        loggedWorkoutSetsFromWorkoutSection(workoutSection, rounds: rounds);
}

/// Calculate which sets would be inclouded in a partially completed round of a section, based on the number of reps that the user has completed.
List<LoggedWorkoutSet> loggedWorkoutSetsPartialRound({
  required WorkoutSection workoutSection,
  required int reps,
  required int roundNumber,
}) {
  int repsCounted = 0;

  /// Move through the sets adding up the reps as you go.
  /// Stop when [repsCounted] == [reps].
  return workoutSection.workoutSets
      .sortedBy<num>((wSet) => wSet.sortPosition)
      .fold(<LoggedWorkoutSet>[], (acum, next) {
    if (repsCounted >= reps) {
      return acum;
    } else {
      final repsInSet = DataUtils.totalRepsInSet(next);
      if (repsInSet <= reps - repsCounted) {
        /// Update reps counted.
        repsCounted += repsInSet;

        /// Add the full set.
        return [
          ...acum,
          loggedWorkoutSetFromWorkoutSet(
              sectionType: workoutSection.workoutSectionType,
              workoutSet: next,
              roundNumber: roundNumber)
        ];
      } else {
        final remainingReps = reps - repsCounted;

        /// Update reps counted.
        repsCounted += remainingReps;

        /// We can only add a partial set.
        next.workoutMoves =
            workoutMovesForPartialSet(reps: remainingReps, workoutSet: next);

        return [
          ...acum,
          loggedWorkoutSetFromWorkoutSet(
              sectionType: workoutSection.workoutSectionType,
              workoutSet: next,
              roundNumber: roundNumber)
        ];
      }
    }
  });
}

/// Based on a number of reps completed - return a partial list of the workout moves that are in the set.
List<WorkoutMove> workoutMovesForPartialSet(
    {required WorkoutSet workoutSet, required int reps}) {
  int repsCounted = 0;
  return workoutSet.workoutMoves
      .sortedBy<num>((wMove) => wMove.sortPosition)
      .fold(<WorkoutMove>[], (acum, next) {
    final repsInWorkoutMove = DataUtils.repsFromWorkoutMove(next);
    if (repsCounted >= reps) {
      return acum;
    } else if (repsInWorkoutMove <= repsCounted - reps) {
      /// Update reps counted.
      repsCounted += repsInWorkoutMove;
      // Add the full set.
      return [...acum, next];
    } else {
      final remainingReps = reps - repsCounted;
      // We can only add a partial workout move, so set the reps to whatever is left.
      next.reps = remainingReps.toDouble();

      /// Update reps counted.
      repsCounted += remainingReps;
      return [...acum, next];
    }
  });
}

/// Use [rounds] when the number of rounds to generate depends on the user input.
/// i.e For an AMRAP...they will have completed a certain number of rounds before the timecap hit.
List<LoggedWorkoutSet> loggedWorkoutSetsFromWorkoutSection(
    WorkoutSection workoutSection,
    {int? rounds}) {
  return List.generate(
      rounds ?? workoutSection.rounds,
      (index) => workoutSection.workoutSets
          .sortedBy<num>((wSet) => wSet.sortPosition)
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
        .sortedBy<num>((wMove) => wMove.sortPosition)
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
      : '${generateRepString(distanceUnit: workoutMove.distanceUnit, reps: workoutMove.reps, repType: workoutMove.repType, timeUnit: workoutMove.timeUnit, displayLoad: displayLoad)} ';
  final equipment = displayEquipment && workoutMove.equipment != null
      ? ' ${workoutMove.equipment!.name}'
      : '';
  final load = displayLoad && workoutMove.loadAmount != 0
      ? ' ${generateLoadString(loadAmount: workoutMove.loadAmount, loadUnit: workoutMove.loadUnit)}'
      : '';
  return '$reps${workoutMove.move.name}$load$equipment';
}

//// Moves List Helpers ////
String generateRepString({
  required double reps,
  required WorkoutMoveRepType repType,
  required TimeUnit timeUnit,
  required DistanceUnit distanceUnit,
  bool displayLoad = true,
}) {
  final repUnit = repType == WorkoutMoveRepType.time
      ? timeUnit.shortDisplay.capitalize
      : repType == WorkoutMoveRepType.calories
          ? 'Cals'
          : repType == WorkoutMoveRepType.distance
              ? distanceUnit.shortDisplay.capitalize
              : null;
  final repUnitString = repUnit != null ? ' $repUnit' : '';

  return '${displayLoad ? " x " : ""}${reps.stringMyDouble()}$repUnitString';
}

String generateLoadString(
        {required double loadAmount, required LoadUnit loadUnit}) =>
    '${loadAmount.stringMyDouble()} ${loadUnit.display}';

int? workoutSetDurationOrNull(WorkoutSectionType type, WorkoutSet workoutSet) =>
    type.isTimed ? workoutSet.duration : null;
