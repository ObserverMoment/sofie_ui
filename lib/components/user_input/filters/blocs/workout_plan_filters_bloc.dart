import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_utils.dart';

class WorkoutPlanFiltersBloc extends ChangeNotifier {
  late WorkoutPlanFilters _workoutPlanFilters;
  WorkoutPlanFiltersBloc() {
    // Open Hive box and check if there are filter settings saved.
    // Initialise them from Hive box.
    final workoutPlanFiltersFromDevice = Hive.box(kSettingsHiveBoxName)
        .get(kSettingsHiveBoxWorkoutPlanFiltersKey);

    /// Convert from [_InternalLinkedHashMap<dynamic, dynamic>] to [Map<String, dynamic>]
    final json = workoutPlanFiltersFromDevice == null
        ? null
        : DataUtils.convertToJsonMap(workoutPlanFiltersFromDevice as Map);

    _workoutPlanFilters =
        json != null ? WorkoutPlanFilters.fromJson(json) : WorkoutPlanFilters();
  }

  WorkoutPlanFilters get filters => _workoutPlanFilters;
  bool get activeFilters => _workoutPlanFilters.activeFilters;
  int get numActiveFilters => _workoutPlanFilters.numActiveFilters;

  bool filtersHaveChanged(WorkoutPlanFilters prev) {
    return !_workoutPlanFilters.areSameFilters(prev);
  }

  Future<void> clearAllFilters() async {
    await _updateAndSaveFilters(WorkoutPlanFilters());
  }

  void updateFilters(Map<String, dynamic> data) {
    _updateAndSaveFilters(
        WorkoutPlanFilters.fromJson({..._workoutPlanFilters.json, ...data}));
  }

  Future<void> _updateAndSaveFilters(
      WorkoutPlanFilters workoutPlanFilters) async {
    await Hive.box(kSettingsHiveBoxName)
        .put(kSettingsHiveBoxWorkoutPlanFiltersKey, workoutPlanFilters.json);
    _workoutPlanFilters = workoutPlanFilters;
    notifyListeners();
  }

  /// Client side filter method.
  List<WorkoutPlan> filterYourWorkoutPlans(List<WorkoutPlan> allPlans) {
    return _workoutPlanFilters.filter(allPlans);
  }
}

class WorkoutPlanFilters {
  /// Require all of these goals to be in the workout.
  List<WorkoutGoal> workoutGoals = [];

  /// A plan difficulty level is determined by the difficulty level of its workouts.
  /// To match this filter at least one workout must match this difficulty level.
  DifficultyLevel? difficultyLevel;

  int? lengthWeeks;
  int? daysPerWeek;

  /// If null, ignore, if true must be bodyweight only, if false must NOT be bodyweight only (i.e. must have equipment).
  bool? bodyweightOnly;

  WorkoutPlanFilters();

  /// Think this is worth doing to avoid re-calling the API whenever possible...
  bool areSameFilters(WorkoutPlanFilters o) {
    return const UnorderedIterableEquality()
            .equals(workoutGoals, o.workoutGoals) &&
        difficultyLevel == o.difficultyLevel &&
        lengthWeeks == o.lengthWeeks &&
        daysPerWeek == o.daysPerWeek &&
        bodyweightOnly == o.bodyweightOnly;
  }

  bool get activeFilters =>
      workoutGoals.isNotEmpty ||
      difficultyLevel != null ||
      lengthWeeks != null ||
      daysPerWeek != null ||
      bodyweightOnly != null;

  int get numActiveFilters {
    int active = 0;
    if (workoutGoals.isNotEmpty) active++;
    if (difficultyLevel != null) active++;
    if (lengthWeeks != null) active++;
    if (daysPerWeek != null) active++;
    if (bodyweightOnly != null) active++;

    return active;
  }

  bool _workoutMoveNeedsEquipment(WorkoutMove workoutMove) {
    return workoutMove.move.requiredEquipments.isNotEmpty ||
        (workoutMove.equipment != null &&
            workoutMove.equipment!.id != kBodyweightEquipmentId);
  }

  bool _planRequiresEquipment(WorkoutPlan plan) {
    return plan.workoutPlanDays.any((wpd) => wpd.workoutPlanDayWorkouts.any(
        (wpdw) => wpdw.workout.workoutSections.any((wSection) =>
            wSection.workoutSets.any((wSet) => wSet.workoutMoves
                .any((wMove) => _workoutMoveNeedsEquipment(wMove))))));
  }

  /// Does the plan have at least one workout that is the specified [difficultyLevel]
  /// V. rough and ready check.
  bool _planContainsDifficultyLevel(WorkoutPlan plan) {
    return plan.workoutPlanDays.any((wpd) => wpd.workoutPlanDayWorkouts
        .any((wpdw) => wpdw.workout.difficultyLevel == difficultyLevel));
  }

  /// Only has to contain a workout that contains at least one of the specified goals.
  /// Needs revisiting as this is very broad.
  bool _planContainsWorkoutGoal(WorkoutPlan plan) {
    return plan.workoutPlanDays.any((wpd) => wpd.workoutPlanDayWorkouts.any(
        (wpdw) => wpdw.workout.workoutGoals
            .any((goal) => workoutGoals.contains(goal))));
  }

  List<WorkoutPlan> filter(List<WorkoutPlan> plans) {
    final Iterable<WorkoutPlan> byLengthWeeks = lengthWeeks == null
        ? [...plans]
        : plans.where((p) => p.lengthWeeks == lengthWeeks);

    final Iterable<WorkoutPlan> byDaysPerWeek = daysPerWeek == null
        ? byLengthWeeks
        : plans.where((p) => p.daysPerWeek == daysPerWeek);

    final Iterable<WorkoutPlan> byBodyweightOnly = bodyweightOnly == null
        ? byDaysPerWeek
        : plans.where((p) => bodyweightOnly!
            ? !_planRequiresEquipment(p)
            : _planRequiresEquipment(p));

    /// At least one of the plans workouts must be this difficulty level.
    final Iterable<WorkoutPlan> byDifficultyLevel = difficultyLevel == null
        ? byBodyweightOnly
        : plans.where((p) => _planContainsDifficultyLevel(p));

    /// At least one of the plans workouts must have a specified goal.
    final Iterable<WorkoutPlan> byWorkoutGoals = workoutGoals.isEmpty
        ? byDifficultyLevel
        : plans.where((p) => _planContainsWorkoutGoal(p));

    return byWorkoutGoals.toList();
  }

  WorkoutPlanFilters.fromJson(Map<String, dynamic> json)
      : workoutGoals = json['workoutGoals'] != null
            ? (json['workoutGoals'] as List)
                .map((e) =>
                    WorkoutGoal.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()
            : <WorkoutGoal>[],
        difficultyLevel = json['difficultyLevel'] != null
            ? (json['difficultyLevel'] as String).toDifficultyLevel()
            : null,
        lengthWeeks =
            json['lengthWeeks'] != null ? json['lengthWeeks'] as int : null,
        daysPerWeek =
            json['daysPerWeek'] != null ? json['daysPerWeek'] as int : null,
        bodyweightOnly = json['bodyweightOnly'] as bool?;

  Map<String, dynamic> get json => <String, dynamic>{
        'workoutGoals': workoutGoals.map((o) => o.toJson()).toList(),
        'difficultyLevel': difficultyLevel?.apiValue,
        'lengthWeeks': lengthWeeks,
        'daysPerWeek': daysPerWeek,
        'bodyweightOnly': bodyweightOnly,
      };

  Map<String, dynamic> get apiJson => <String, dynamic>{
        'workoutGoals': workoutGoals.map((o) => o.id).toList(),
        'difficultyLevel': difficultyLevel?.apiValue,
        'lengthWeeks': lengthWeeks,
        'daysPerWeek': daysPerWeek,
        'bodyweightOnly': bodyweightOnly,
      };
}
