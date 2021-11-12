import 'package:collection/collection.dart';
import 'package:sofie_ui/components/data_vis/waffle_chart.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/client_only_model.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

/// Extensions which pertain to the processing of fitness related data (i.e. the graphql types.)
extension ClubExtension on Club {
  int get totalMembers => 1 + admins.length + members.length;
}

extension ClubMembersExtension on ClubMembers {
  int get totalMembers => 1 + admins.length + members.length;
}

extension LoggedWorkoutExtension on LoggedWorkout {
  /// Returns a copy of the LoggedWorkout
  /// with its LoggedWorkoutSections sorted correctly by [sortPosition].
  LoggedWorkout get copyAndSortAllChildren {
    final copy = LoggedWorkout.fromJson(toJson());

    copy.loggedWorkoutSections.sortBy<num>((section) => section.sortPosition);

    return copy;
  }
}

extension MoveExtension on Move {
  /// Can any of its equipments have a load input. [loadAdjustable] = true.
  bool get isLoadAdjustable =>
      requiredEquipments.any((e) => e.loadAdjustable) ||
      selectableEquipments.any((e) => e.loadAdjustable);
}

extension WorkoutExtension on Workout {
  /// Returns a copy of the workout with all child lists, ([workoutSections], [workoutSets], [workoutMoves]) sorted by [sortPosition].
  Workout get copyAndSortAllChildren {
    final copy = Workout.fromJson(toJson());

    copy.workoutSections
        .sortBy<num>((workoutSection) => workoutSection.sortPosition);

    for (final workoutSection in copy.workoutSections) {
      workoutSection.workoutSets
          .sortBy<num>((workoutSets) => workoutSets.sortPosition);

      for (final workoutSet in workoutSection.workoutSets) {
        workoutSet.workoutMoves
            .sortBy<num>((workoutMove) => workoutMove.sortPosition);
      }
    }

    return copy;
  }

  List<Equipment> get allEquipment {
    final Set<Equipment> allEquipments = {};

    for (final section in workoutSections) {
      for (final workoutSet in section.workoutSets) {
        for (final workoutMove in workoutSet.workoutMoves) {
          if (workoutMove.equipment != null &&
              workoutMove.equipment!.id != kBodyweightEquipmentId) {
            allEquipments.add(workoutMove.equipment!);
          }
          if (workoutMove.move.requiredEquipments.isNotEmpty) {
            allEquipments.addAll(workoutMove.move.requiredEquipments);
          }
        }
      }
    }

    return allEquipments.toList();
  }
}

extension WorkoutPlanExtension on WorkoutPlan {
  DifficultyLevel? get calcDifficulty {
    final workouts = workoutsInPlan;
    if (workouts.isEmpty) {
      return null;
    }
    final average = workouts.averageBy((w) => w.difficultyLevel.numericValue);
    return DifficultyLevelExtension.levelFromNumber(average!);
  }

  String get sessionsPerWeek =>
      (workoutPlanDays.length / lengthWeeks).stringMyDouble();

  String get lengthString =>
      '$lengthWeeks ${lengthWeeks == 1 ? "week" : "weeks"}';

  double get reviewAverage =>
      workoutPlanReviews.averageBy((r) => r.score) ?? 0.0;

  List<WaffleChartInput> get waffleChartInputs {
    final goals = workoutGoalsInPlan;
    final data = goals.fold<Map<WorkoutGoal, int>>({}, (acum, next) {
      if (acum[next] != null) {
        acum[next] = acum[next]! + 1;
      } else {
        acum[next] = 1;
      }
      return acum;
    });

    return data.entries
        .map((e) => WaffleChartInput(
            fraction: e.value / goals.length,
            color: HexColor.fromHex(e.key.hexColor),
            name: e.key.name))
        .toList();
  }

  /// Excludes the equipment 'Bodyweight' by its ID in [workout.allEquipment].
  List<Equipment> get allEquipment {
    final Set<Equipment> allEquipment = {};
    final workouts = workoutsInPlan;

    for (final workout in workouts) {
      allEquipment.addAll(workout.allEquipment);
    }
    return allEquipment.toList();
  }

  List<Workout> get workoutsInPlan {
    return workoutPlanDays.fold<List<Workout>>(
        [],
        (acum, next) =>
            [...acum, ...next.workoutPlanDayWorkouts.map((d) => d.workout)]);
  }

  List<WorkoutGoal> get workoutGoalsInPlan {
    return workoutPlanDays
        .fold<List<List<WorkoutGoal>>>(
            [],
            (acum, next) => [
                  ...acum,
                  ...next.workoutPlanDayWorkouts
                      .map((d) => d.workout.workoutGoals)
                ])
        .expand((x) => x)
        .toList();
  }
}

extension WorkoutPlanDayExtension on WorkoutPlanDay {
  DifficultyLevel? get calcDifficulty {
    final workouts = workoutPlanDayWorkouts.map((d) => d.workout);
    if (workouts.isEmpty) {
      return null;
    }
    final average = workouts.averageBy((w) => w.difficultyLevel.numericValue);
    return DifficultyLevelExtension.levelFromNumber(average!);
  }
}

extension WorkoutSectionExtension on WorkoutSection {
  /// If there is a name, display the name, otherwise just display the type.
  String get nameOrTypeForDisplay =>
      Utils.textNotNull(name) ? name! : workoutSectionType.name;

  bool get isFreeSession => workoutSectionType.name == kFreeSessionName;
  bool get isAMRAP => workoutSectionType.name == kAMRAPName;
  bool get isForTime => workoutSectionType.name == kForTimeName;

  bool get isScored => isAMRAP || isForTime;

  bool get isTimed => [
        kHIITCircuitName,
        kTabataName,
        kEMOMName,
      ].contains(workoutSectionType.name);

  Duration get timedSectionDuration =>
      DataUtils.calculateTimedSectionDuration(this);

  /// For AMRAP - returns the timecap.
  /// For Timed / Fixed length workouts calculate length based on contents.
  int? get timecapIfValid => isAMRAP
      ? timecap
      : isTimed
          ? DataUtils.calculateTimedSectionDuration(this).inSeconds
          : null;

  /// These section types ignore rounds input - generally it should be forced to be [1] when these sections are being used.
  bool get roundsInputAllowed =>
      ![kAMRAPName, kFreeSessionName].contains(workoutSectionType.name);

  List<BodyArea> get uniqueBodyAreas {
    final Set<BodyArea> sectionBodyAreas =
        workoutSets.fold({}, (acum1, workoutSet) {
      final Set<BodyArea> setBodyAreas =
          workoutSet.workoutMoves.fold({}, (acum2, workoutMove) {
        acum2.addAll(
            workoutMove.move.bodyAreaMoveScores.map((bams) => bams.bodyArea));
        return acum2;
      });

      acum1.addAll(setBodyAreas);

      return acum1;
    });

    return sectionBodyAreas.toList();
  }

  /// Retuns all the equipment needed for completing the section and also removes [bodyweight] if present.
  List<Equipment> get uniqueEquipments {
    final Set<Equipment> sectionEquipments =
        workoutSets.fold({}, (acum1, workoutSet) {
      final Set<Equipment> setEquipments =
          workoutSet.workoutMoves.fold({}, (acum2, workoutMove) {
        if (workoutMove.equipment != null) {
          acum2.add(workoutMove.equipment!);
        }
        if (workoutMove.move.requiredEquipments.isNotEmpty) {
          acum2.addAll(workoutMove.move.requiredEquipments);
        }
        return acum2;
      });

      acum1.addAll(setEquipments);

      return acum1;
    });

    return sectionEquipments
        .where((e) => e.id != kBodyweightEquipmentId)
        .toList();
  }

  /// Retuns all the equipment needed for completing the section along with the load needed for each. Also removes [bodyweight] if present.
  List<EquipmentWithLoad> get equipmentsWithLoad {
    final Set<EquipmentWithLoad> sectionEquipmentsWithLoad =
        workoutSets.fold({}, (acum1, workoutSet) {
      final Set<EquipmentWithLoad> setEquipments =
          workoutSet.workoutMoves.fold({}, (acum2, workoutMove) {
        if (workoutMove.equipment != null) {
          acum2.add(EquipmentWithLoad(
              equipment: workoutMove.equipment!,
              loadAmount: workoutMove.equipment!.loadAdjustable
                  ? workoutMove.loadAmount
                  : null,
              loadUnit: workoutMove.loadUnit));
        }
        if (workoutMove.move.requiredEquipments.isNotEmpty) {
          acum2.addAll(workoutMove.move.requiredEquipments.map((e) =>
              EquipmentWithLoad(
                  equipment: e,
                  loadAmount: e.loadAdjustable ? workoutMove.loadAmount : null,
                  loadUnit: workoutMove.loadUnit)));
        }
        return acum2;
      });

      acum1.addAll(setEquipments);

      return acum1;
    });

    return sectionEquipmentsWithLoad
        .where((e) => e.equipment.id != kBodyweightEquipmentId)
        .toList();
  }

  List<MoveType> get uniqueMoveTypes {
    final Set<MoveType> sectionMoveTypes =
        workoutSets.fold({}, (acum1, workoutSet) {
      final Set<MoveType> setMoveTypes =
          workoutSet.workoutMoves.fold({}, (acum2, workoutMove) {
        acum2.add(workoutMove.move.moveType);
        return acum2;
      });

      acum1.addAll(setMoveTypes);

      return acum1;
    });

    return sectionMoveTypes.toList();
  }
}

extension WorkoutSectionTypeExtension on WorkoutSectionType {
  bool get canPyramid => ![kHIITCircuitName, kTabataName].contains(name);

  bool get isAMRAP => name == kAMRAPName;

  bool get isScored => [kAMRAPName, kForTimeName].contains(name);

  bool get isTimed => [
        kHIITCircuitName,
        kTabataName,
        kEMOMName,
      ].contains(name);

  bool get roundsInputAllowed =>
      [kForTimeName, kFreeSessionName].contains(name);

  /// Don't show reps when the section is a HIIT or a tabata because the user just repeats the move for workoutSet.duration. UNLESS there are more than one moves, and then the user loops around these two moves for workoutSet.duration - which means you need to know how much of each move to do before moving onto the next.
  bool showReps(WorkoutSet workoutSet) =>
      ![
        kHIITCircuitName,
        kTabataName,
      ].contains(name) ||
      workoutSet.workoutMoves.length > 1;
}

extension WorkoutSetExtension on WorkoutSet {
  bool get isRestSet =>
      workoutMoves.length == 1 && workoutMoves[0].move.id == kRestMoveId;
}