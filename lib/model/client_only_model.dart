import 'package:equatable/equatable.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class EquipmentWithLoad extends Equatable {
  final Equipment equipment;
  final double? loadAmount;
  final LoadUnit loadUnit;
  const EquipmentWithLoad(
      {required this.equipment,
      required this.loadAmount,
      required this.loadUnit});

  @override
  List<Object?> get props => [equipment, loadAmount, loadUnit];
}
