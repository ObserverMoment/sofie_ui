import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/repos/move_data.repo.dart';

extension EquipmentExtension on Equipment {
  bool get isBodyweight => id == kBodyweightEquipmentId;
}

extension MoveDataExtension on MoveData {
  WorkoutMoveRepType get initialRepType =>
      validRepTypes.contains(WorkoutMoveRepType.reps)
          ? WorkoutMoveRepType.reps
          : validRepTypes.contains(WorkoutMoveRepType.calories)
              ? WorkoutMoveRepType.calories
              : validRepTypes.contains(WorkoutMoveRepType.distance)
                  ? WorkoutMoveRepType.distance
                  : WorkoutMoveRepType.time;

  /// Can any of its equipments have a load input. [loadAdjustable] = true.
  bool get isLoadAdjustable =>
      requiredEquipments.any((e) => e.loadAdjustable) ||
      selectableEquipments.any((e) => e.loadAdjustable);
}

extension ResistanceSessionExtension on ResistanceSession {
  List<Equipment> uniqueEquipments(MoveDataRepo moveDataRepo) {
    Set<Equipment> uniqueEquipments = {};
    for (final e in resistanceExercises) {
      for (final s in e.resistanceSets) {
        uniqueEquipments.addAll([
          ...moveDataRepo.moveDataById(s.move.id)?.requiredEquipments ?? [],
          s.equipment
        ].whereType<Equipment>());
      }
    }
    return uniqueEquipments.toList();
  }

  List<BodyArea> uniqueBodyAreas(List<MoveData> moves) {
    return moves.fold<Set<BodyArea>>({}, (acum, next) {
      final bodyAreas =
          moves.map((m) => m.bodyAreaMoveScores.map((bams) => bams.bodyArea));
      acum.addAll(bodyAreas.expand((b) => b));
      return acum;
    }).toList();
  }

  List<MoveData> uniqueMovesInSession(MoveDataRepo moveDataRepo) {
    Set<String> moveIds = {};
    for (final e in resistanceExercises) {
      for (final s in e.resistanceSets) {
        moveIds.add(s.move.id);
      }
    }

    return moveIds
        .map((id) => moveDataRepo.moveDataById(id))
        .whereType<MoveData>()
        .toList();
  }
}
