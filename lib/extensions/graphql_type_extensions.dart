import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

extension EquipmentExtension on Equipment {
  bool get isBodyweight => id == kBodyweightEquipmentId;
}
