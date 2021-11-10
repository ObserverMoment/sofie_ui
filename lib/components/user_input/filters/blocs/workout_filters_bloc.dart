import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:supercharged/supercharged.dart';

class WorkoutFiltersBloc extends ChangeNotifier {
  late WorkoutFilters _workoutFilters;
  WorkoutFiltersBloc() {
    // Open Hive box and check if there are filter settings saved.
    // Initialise them from Hive box.
    final workoutFiltersFromDevice =
        Hive.box(kSettingsHiveBoxName).get(kSettingsHiveBoxWorkoutFiltersKey);

    /// Convert from [_InternalLinkedHashMap<dynamic, dynamic>] to [Map<String, dynamic>]
    final json = workoutFiltersFromDevice == null
        ? null
        : DataUtils.convertToJsonMap(workoutFiltersFromDevice as Map);

    _workoutFilters =
        json != null ? WorkoutFilters.fromJson(json) : WorkoutFilters();
  }

  WorkoutFilters get filters => _workoutFilters;
  bool get activeFilters => _workoutFilters.activeFilters;
  int get numActiveFilters => _workoutFilters.numActiveFilters;

  bool filtersHaveChanged(WorkoutFilters prev) {
    return !_workoutFilters.areSameFilters(prev);
  }

  Future<void> clearAllFilters() async {
    await _updateAndSaveFilters(WorkoutFilters());
  }

  void updateFilters(Map<String, dynamic> data) {
    _updateAndSaveFilters(
        WorkoutFilters.fromJson({..._workoutFilters.json, ...data}));
  }

  Future<void> _updateAndSaveFilters(WorkoutFilters workoutFilters) async {
    await Hive.box(kSettingsHiveBoxName)
        .put(kSettingsHiveBoxWorkoutFiltersKey, workoutFilters.json);
    _workoutFilters = workoutFilters;
    notifyListeners();
  }

  /// Client side filter method.
  List<Workout> filterYourWorkouts(List<Workout> allWorkouts) {
    return _workoutFilters.filter(allWorkouts);
  }
}

class WorkoutFilters {
  /// Require that at least one section is of one of these types.
  List<WorkoutSectionType> workoutSectionTypes = [];

  /// Require all of these goals to be in the workout.
  List<WorkoutGoal> workoutGoals = [];

  /// Must match this difficulty level.
  DifficultyLevel? difficultyLevel;

  /// Show workouts with / without class videos.
  bool? hasClassVideo;

  /// Show workouts with / without class audio.
  bool? hasClassAudio;

  /// [Workout.lengthMinutes] is between these two values. If null then ignore.
  Duration? minLength;
  Duration? maxLength;

  /// Equipment filters
  /// If null, ignore, if true must be bodyweight only, if false must NOT be bodyweight only (i.e. must have equipment).
  /// This will take precedence over [availableEquipments]
  bool? bodyweightOnly;

  /// Exclude any workouts that need equipments not in this list.
  /// Ignore if list is empty.
  List<Equipment> availableEquipments = [];

  /// Moves filters. If empty, ignore.
  /// Workouts must have all of these moves.
  List<Move> requiredMoves = [];

  /// Workouts must not contain any of these moves.
  List<Move> excludedMoves = [];

  /// BodyArea filters.
  /// Workout must target all of these body areas.
  List<BodyArea> targetedBodyAreas = [];

  WorkoutFilters();

  /// Think this is worth doing to avoid re-calling the API whenever possible...
  bool areSameFilters(WorkoutFilters o) {
    const e = UnorderedIterableEquality();
    return e.equals(workoutSectionTypes, o.workoutSectionTypes) &&
        e.equals(workoutGoals, o.workoutGoals) &&
        difficultyLevel == o.difficultyLevel &&
        hasClassVideo == o.hasClassVideo &&
        hasClassAudio == o.hasClassAudio &&
        minLength?.inMinutes == o.minLength?.inMinutes &&
        maxLength?.inMinutes == o.maxLength?.inMinutes &&
        bodyweightOnly == o.bodyweightOnly &&
        e.equals(availableEquipments, o.availableEquipments) &&
        e.equals(requiredMoves, o.requiredMoves) &&
        e.equals(excludedMoves, o.excludedMoves) &&
        e.equals(targetedBodyAreas, o.targetedBodyAreas);
  }

  bool get activeFilters =>
      workoutSectionTypes.isNotEmpty ||
      workoutGoals.isNotEmpty ||
      difficultyLevel != null ||
      hasClassVideo != null ||
      hasClassAudio != null ||
      minLength != null ||
      maxLength != null ||
      bodyweightOnly != null ||
      availableEquipments.isNotEmpty ||
      requiredMoves.isNotEmpty ||
      excludedMoves.isNotEmpty ||
      targetedBodyAreas.isNotEmpty;

  int get numActiveFilters {
    int active = 0;
    if (workoutSectionTypes.isNotEmpty) active++;
    if (workoutGoals.isNotEmpty) active++;
    if (difficultyLevel != null) active++;
    if (hasClassVideo != null) active++;
    if (hasClassAudio != null) active++;
    if (minLength != null || maxLength != null) active++;
    if (bodyweightOnly != null) active++;
    if (availableEquipments.isNotEmpty) active++;
    if (requiredMoves.isNotEmpty) active++;
    if (excludedMoves.isNotEmpty) active++;
    if (targetedBodyAreas.isNotEmpty) active++;

    return active;
  }

  // Based on the user selected available equipments. Is this exercise valid?
  bool _checkWorkoutMoveEquipment(WorkoutMove workoutMove) {
    final bool selectedEquipmentIsOk = workoutMove.equipment == null ||
        workoutMove.equipment!.id == kBodyweightEquipmentId ||
        availableEquipments.contains(workoutMove.equipment);

    final bool requiredEquipmentsAreOk =
        workoutMove.move.requiredEquipments.isEmpty ||
            workoutMove.move.requiredEquipments
                .every((Equipment e) => availableEquipments.contains(e));

    return selectedEquipmentIsOk && requiredEquipmentsAreOk;
  }

  bool _workoutMoveNeedsEquipment(WorkoutMove workoutMove) {
    return workoutMove.move.requiredEquipments.isNotEmpty ||
        (workoutMove.equipment != null &&
            workoutMove.equipment!.id != kBodyweightEquipmentId);
  }

  List<Workout> filter(List<Workout> workouts) {
    final Iterable<Workout> byWorkoutSectionTypes = workoutSectionTypes.isEmpty
        ? [...workouts]
        : workouts.where((w) => w.workoutSections.any((WorkoutSection ws) =>
            workoutSectionTypes.contains(ws.workoutSectionType)));

    final Iterable<Workout> byWorkoutGoals = workoutGoals.isEmpty
        ? byWorkoutSectionTypes
        : byWorkoutSectionTypes
            .where((w) => workoutGoals.any((g) => w.workoutGoals.contains(g)));

    final Iterable<Workout> byDifficultyLevel = difficultyLevel == null
        ? byWorkoutGoals
        : byWorkoutGoals.where((w) => w.difficultyLevel == difficultyLevel);

    /// [hasClassVideo] can be null (ignore), true (require video) or false (require no video)
    final Iterable<Workout> byHasClassVideo = hasClassVideo == null
        ? byDifficultyLevel
        : hasClassVideo!
            ? byDifficultyLevel.where((w) => w.workoutSections
                .any((WorkoutSection ws) => ws.classVideoUri != null))
            : byDifficultyLevel.where((w) => w.workoutSections
                .every((WorkoutSection ws) => ws.classVideoUri == null));

    /// [hasClassAudio] can be null (ignore), true (require video) or false (require no video)
    final Iterable<Workout> byHasClassAudio = hasClassAudio == null
        ? byHasClassVideo
        : hasClassAudio!
            ? byHasClassVideo.where((w) => w.workoutSections
                .any((WorkoutSection ws) => ws.classAudioUri != null))
            : byHasClassVideo.where((w) => w.workoutSections
                .every((WorkoutSection ws) => ws.classAudioUri == null));

    final Iterable<Workout> byMinLength = minLength == null
        ? byHasClassAudio
        : byHasClassAudio.where((w) =>
            w.lengthMinutes != null &&
            (w.lengthMinutes!.minutes >= minLength!));

    final Iterable<Workout> byMaxLength = maxLength == null
        ? byMinLength
        : byMinLength.where((w) =>
            w.lengthMinutes != null &&
            (w.lengthMinutes!.minutes <= maxLength!));

    final Iterable<Workout> byBodyweightOnly = bodyweightOnly == null
        ? byMaxLength
        : byMaxLength.where((w) => w.workoutSections.every(
            (WorkoutSection ws) => ws.workoutSets.every((WorkoutSet ws) =>
                ws.workoutMoves.every((WorkoutMove wm) => bodyweightOnly!
                    ? !_workoutMoveNeedsEquipment(wm)
                    : _workoutMoveNeedsEquipment(wm)))));

    /// if [bodyweightOnly] = true then available equipments is skipped / ignored.
    final Iterable<Workout> byAvailableEquipments = (bodyweightOnly == true ||
            availableEquipments.isEmpty)
        ? byBodyweightOnly
        : byBodyweightOnly.where((w) => w.workoutSections.every(
            (WorkoutSection ws) => ws.workoutSets.every((WorkoutSet ws) => ws
                .workoutMoves
                .every((WorkoutMove wm) => _checkWorkoutMoveEquipment(wm)))));

    final Iterable<Workout> byRequiredMoves = requiredMoves.isEmpty
        ? byAvailableEquipments
        : byAvailableEquipments.where((w) => requiredMoves.every((move) => w
            .workoutSections
            .any((WorkoutSection ws) => ws.workoutSets.any((WorkoutSet ws) =>
                ws.workoutMoves.any((WorkoutMove wm) => wm.move == move)))));

    final Iterable<Workout> byExcludedMoves = excludedMoves.isEmpty
        ? byRequiredMoves
        : byRequiredMoves.where((w) => !excludedMoves.any((move) => w
            .workoutSections
            .any((WorkoutSection ws) => ws.workoutSets.any((WorkoutSet ws) =>
                ws.workoutMoves.any((WorkoutMove wm) => wm.move == move)))));

    final Iterable<Workout> byTargetedBodyAreas = targetedBodyAreas.isEmpty
        ? byExcludedMoves
        : byExcludedMoves.where((w) => targetedBodyAreas.every((ba) =>
            w.workoutSections.any((WorkoutSection ws) => ws.workoutSets.any(
                (WorkoutSet ws) => ws.workoutMoves.any((WorkoutMove wm) => wm
                    .move.bodyAreaMoveScores
                    .any((bams) => bams.bodyArea == ba))))));

    return byTargetedBodyAreas.toList();
  }

  WorkoutFilters.fromJson(Map<String, dynamic> json)
      : workoutSectionTypes = json['workoutSectionTypes'] != null
            ? (json['workoutSectionTypes'] as List)
                .map((e) => WorkoutSectionType.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList()
            : <WorkoutSectionType>[],
        workoutGoals = json['workoutGoals'] != null
            ? (json['workoutGoals'] as List)
                .map((e) =>
                    WorkoutGoal.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()
            : <WorkoutGoal>[],
        difficultyLevel = json['difficultyLevel'] != null
            ? (json['difficultyLevel'] as String).toDifficultyLevel()
            : null,
        hasClassVideo = json['hasClassVideo'] != null
            ? (json['hasClassVideo'] as bool?)
            : null,
        hasClassAudio = json['hasClassAudio'] != null
            ? (json['hasClassAudio'] as bool?)
            : null,
        minLength = json['minLength'] != null
            ? Duration(minutes: json['minLength'] as int)
            : null,
        maxLength = json['maxLength'] != null
            ? Duration(minutes: json['maxLength'] as int)
            : null,
        bodyweightOnly = json['bodyweightOnly'] as bool?,
        availableEquipments = json['availableEquipments'] != null
            ? (json['availableEquipments'] as List)
                .map((e) =>
                    Equipment.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()
            : <Equipment>[],
        requiredMoves = json['requiredMoves'] != null
            ? (json['requiredMoves'] as List)
                .map((e) => Move.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()
            : <Move>[],
        excludedMoves = json['excludedMoves'] != null
            ? (json['excludedMoves'] as List)
                .map((e) => Move.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()
            : <Move>[],
        targetedBodyAreas = json['targetedBodyAreas'] != null
            ? (json['targetedBodyAreas'] as List)
                .map((e) =>
                    BodyArea.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()
            : <BodyArea>[];

  Map<String, dynamic> get json => <String, dynamic>{
        'workoutSectionTypes':
            workoutSectionTypes.map((o) => o.toJson()).toList(),
        'workoutGoals': workoutGoals.map((o) => o.toJson()).toList(),
        'difficultyLevel': difficultyLevel?.apiValue,
        'hasClassVideo': hasClassVideo,
        'hasClassAudio': hasClassAudio,
        'minLength': minLength?.inMinutes,
        'maxLength': maxLength?.inMinutes,
        'bodyweightOnly': bodyweightOnly,
        'availableEquipments':
            availableEquipments.map((o) => o.toJson()).toList(),
        'requiredMoves': requiredMoves.map((o) => o.toJson()).toList(),
        'excludedMoves': excludedMoves.map((o) => o.toJson()).toList(),
        'targetedBodyAreas': targetedBodyAreas.map((o) => o.toJson()).toList(),
      };

  Map<String, dynamic> get apiJson => <String, dynamic>{
        'workoutSectionTypes': workoutSectionTypes.map((o) => o.id).toList(),
        'workoutGoals': workoutGoals.map((o) => o.id).toList(),
        'difficultyLevel': difficultyLevel?.apiValue,
        'hasClassVideo': hasClassVideo,
        'hasClassAudio': hasClassAudio,
        'minLength': minLength?.inMinutes,
        'maxLength': maxLength?.inMinutes,
        'bodyweightOnly': bodyweightOnly,
        'availableEquipments': availableEquipments.map((o) => o.id).toList(),
        'requiredMoves': requiredMoves.map((o) => o.id).toList(),
        'excludedMoves': excludedMoves.map((o) => o.id).toList(),
        'targetedBodyAreas': targetedBodyAreas.map((o) => o.id).toList(),
      };
}
