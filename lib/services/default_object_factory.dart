import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uuid/uuid.dart';

class DefaultObjectfactory {
  static ClubInviteToken defaultClubInviteToken() {
    return ClubInviteToken()
      ..$$typename = kClubInviteTokenTypeName
      ..id = const Uuid().v1()
      ..createdAt = DateTime.now()
      ..active = true
      ..name = ''
      ..inviteLimit = 0
      ..joinedUserIds = [];
  }

  /// [Free Session].
  static WorkoutSectionType defaultWorkoutSectionType() {
    return WorkoutSectionType()
      ..$$typename = kWorkoutSectionTypeTypename
      ..id = 0.toString()
      ..name = 'Section'
      ..description = '';
  }

  static LoggedWorkout defaultLoggedWorkout({required Workout workout}) {
    return LoggedWorkout()
      ..$$typename = kLoggedWorkoutTypename
      ..id = 'temp-$kLoggedWorkoutTypename:${const Uuid().v1()}'
      ..name = 'Log - ${workout.name}'
      ..completedOn = DateTime.now()
      ..loggedWorkoutSections = [];
  }

  static LoggedWorkoutSection defaultLoggedWorkoutSection(
      {required WorkoutSection workoutSection}) {
    return LoggedWorkoutSection()
      ..$$typename = kLoggedWorkoutSectionTypename
      ..id = 'temp-$kLoggedWorkoutSectionTypename:${const Uuid().v1()}'
      ..name = Utils.textNotNull(workoutSection.name)
          ? 'Log - ${workoutSection.name}'
          : 'Log - ${workoutSection.workoutSectionType.name}'
      ..workoutSectionType = workoutSection.workoutSectionType;
  }

  static WorkoutMove defaultRestWorkoutMove(
      {required Move move,
      required int sortPosition,
      required int timeAmount,
      required TimeUnit timeUnit}) {
    return WorkoutMove()
      ..$$typename = kWorkoutMoveTypename
      ..id = 'temp-$kWorkoutMoveTypename:${const Uuid().v1()}'
      ..sortPosition = sortPosition
      ..equipment = null
      ..reps = timeAmount.toDouble()
      ..repType = WorkoutMoveRepType.time
      ..distanceUnit = DistanceUnit.metres
      ..loadUnit = LoadUnit.kg
      ..timeUnit = timeUnit
      ..loadAmount = 0
      ..move = move;
  }
}
