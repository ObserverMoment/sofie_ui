import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class MoveFiltersBloc extends ChangeNotifier {
  late MoveFilters _moveFilters;

  MoveFiltersBloc() {
    // Open Hive box and check if there are filter settings saved.
    // Initialise them from Hive box.
    final moveFiltersFromDevice =
        Hive.box(kSettingsHiveBoxName).get(kSettingsHiveBoxMoveFiltersKey);

    _moveFilters = moveFiltersFromDevice != null
        ? MoveFilters.fromJson(
            Map<String, dynamic>.from(moveFiltersFromDevice as Map))
        : MoveFilters.init();
  }

  Future<void> clearAllFilters() async {
    await updateFilters(MoveFilters.init());
  }

  Future<void> updateFilters(MoveFilters moveFilters) async {
    await Hive.box(kSettingsHiveBoxName)
        .put(kSettingsHiveBoxMoveFiltersKey, moveFilters.toJson());
    _moveFilters = moveFilters;
    notifyListeners();
  }

  MoveFilters get filters => _moveFilters;
  List<MoveType> get moveTypeFilters => _moveFilters.moveTypes;
  bool get bodyweightOnlyFilter => _moveFilters.bodyWeightOnly;
  List<Equipment> get equipmentFilters => _moveFilters.equipments;
  List<BodyArea> get bodyAreaFilters => _moveFilters.bodyAreas;

  bool get hasActiveFilters =>
      _moveFilters.bodyWeightOnly ||
      _moveFilters.moveTypes.isNotEmpty ||
      _moveFilters.equipments.isNotEmpty ||
      _moveFilters.bodyAreas.isNotEmpty;

  int get numActiveFilters => _moveFilters.numActiveFilters;

  bool _moveCanBeBodyWeight(Move move) {
    if (move.requiredEquipments.isEmpty && move.selectableEquipments.isEmpty) {
      return true;
    } else {
      return move.requiredEquipments.isEmpty &&
          (move.selectableEquipments.isEmpty ||
              move.selectableEquipments
                  .any((e) => e.id == kBodyweightEquipmentId));
    }
  }

  bool _moveEquipmentIsOk(Move move) {
    /// This is a move where the user has not added any equipment.
    /// If the user is requesting this equipment then it is assumed that they do want to see moves that use this equipment...not just moves that can be done given that you have it.
    /// i.e. all bodyweight moves can be done if you have a dumbbell...but this is probably not what the user is searching for.
    if (move.requiredEquipments.isEmpty && move.selectableEquipments.isEmpty) {
      return false;
    } else {
      return (move.requiredEquipments.isEmpty ||
              move.requiredEquipments
                  .every((e) => _moveFilters.equipments.contains(e))) &&
          (move.selectableEquipments.isEmpty ||
              move.selectableEquipments
                  .any((e) => _moveFilters.equipments.contains(e)));
    }
  }

  List<Move> filter(List<Move> moves) {
    final moveTypesFiltered = _moveFilters.moveTypes.isEmpty
        ? [...moves]
        : moves.where((m) => _moveFilters.moveTypes.contains(m.moveType));

    final equipmentsFiltered = _moveFilters.bodyWeightOnly
        ? moveTypesFiltered.where((m) => _moveCanBeBodyWeight(m))
        : _moveFilters.equipments.isEmpty
            ? moveTypesFiltered
            : moveTypesFiltered.where((m) => _moveEquipmentIsOk(m));

    final bodyAreasFiltered = _moveFilters.bodyAreas.isEmpty
        ? equipmentsFiltered
        : equipmentsFiltered.where((m) => _moveFilters.bodyAreas.any(
            (bodyArea) =>
                m.bodyAreaMoveScores.any((bams) => bams.bodyArea == bodyArea)));

    return bodyAreasFiltered.toList();
  }
}

class MoveFilters {
  /// Return only moves of these types.
  List<MoveType> moveTypes;

  /// Return only moves that can be done given that you have only these equipments.
  List<Equipment> equipments;

  /// Moves that either
  /// 1. Have empty required and selectable equipments
  /// 2. Have no required equipments and selectable equipments includes bodyweight.
  /// 3. Takes precedence over [equipments].
  bool bodyWeightOnly;

  /// Return only moves that target one or more of these body areas.
  List<BodyArea> bodyAreas;
  MoveFilters(
      {required this.moveTypes,
      required this.equipments,
      required this.bodyWeightOnly,
      required this.bodyAreas});

  MoveFilters.init()
      : moveTypes = <MoveType>[],
        equipments = <Equipment>[],
        bodyWeightOnly = false,
        bodyAreas = <BodyArea>[];

  /// Casting [Map<String, dynamic>.from()] is necessary because data from Hive is typed [dynamic] by default
  MoveFilters.fromJson(Map<String, dynamic> json)
      : moveTypes = json['moveTypes'] != null
            ? (json['moveTypes'] as List)
                .map((m) =>
                    MoveType.fromJson(Map<String, dynamic>.from(m as Map)))
                .toList()
            : <MoveType>[],
        equipments = json['equipments'] != null
            ? (json['equipments'] as List)
                .map((e) =>
                    Equipment.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()
            : <Equipment>[],
        bodyWeightOnly = (json['bodyWeightOnly'] as bool?) ?? false,
        bodyAreas = json['bodyAreas'] != null
            ? (json['bodyAreas'] as List)
                .map((b) =>
                    BodyArea.fromJson(Map<String, dynamic>.from(b as Map)))
                .toList()
            : <BodyArea>[];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'moveTypes': moveTypes.map((o) => o.toJson()).toList(),
        'equipments': equipments.map((o) => o.toJson()).toList(),
        'bodyWeightOnly': bodyWeightOnly,
        'bodyAreas': bodyAreas.map((o) => o.toJson()).toList(),
      };

  int get numActiveFilters {
    int active = 0;
    if (moveTypes.isNotEmpty) active++;
    if (equipments.isNotEmpty) active++;
    if (bodyWeightOnly == true) active++;
    if (bodyAreas.isNotEmpty) active++;

    return active;
  }
}
