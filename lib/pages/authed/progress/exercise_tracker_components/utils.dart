import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/data_utils.dart';

class ExerciseTrackerUtils {
  static double convertToTrackerLoadUnit(
      {required double loadAmount,
      required LoadUnit targetUnit,
      required LoadUnit loggedUnit}) {
    if (targetUnit == loggedUnit) {
      return loadAmount;
    } else if (targetUnit == LoadUnit.kg) {
      /// Logged unit is LB -> Convert from LB to KG;
      return DataUtils.convertLbToKg(loadAmount);
    } else {
      /// Logged unit is KG => Convert from KG to LB.
      return DataUtils.convertKgToLb(loadAmount);
    }
  }
}
