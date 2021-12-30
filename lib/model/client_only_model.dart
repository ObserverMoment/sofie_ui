import 'package:equatable/equatable.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

// ignore: must_be_immutable
class EquipmentWithLoad extends Equatable {
  /// ID is auto formed by concating equipment.id, loadAmount.toString and loadUnit.toString
  late String id;
  final Equipment equipment;
  late double? loadAmount;
  final LoadUnit loadUnit;
  EquipmentWithLoad(
      {required this.equipment,
      required this.loadAmount,
      required this.loadUnit}) {
    id =
        '${equipment.id}:${equipment.loadAdjustable ? loadAmount.toString() : "no-load"}:${equipment.loadAdjustable ? loadUnit.toString() : "no-load"}';
    loadAmount = equipment.loadAdjustable ? loadAmount : null;
  }

  @override
  List<Object?> get props => [id];
}

/// E.g [Barbell] / [20kgs, 30kgs, 40kgs] so we can group the equipment for better display to the user.
class EquipmentWithLoadsAsStrings {
  final Equipment equipment;
  final List<String> loadStrings;
  EquipmentWithLoadsAsStrings(
      {required this.equipment, this.loadStrings = const []});
}
