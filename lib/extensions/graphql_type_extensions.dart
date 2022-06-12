import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

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
