import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';

class FitnessBenchmarkUtils {
  FitnessBenchmarkUtils(double score);

  static String scoreDisplayText(FitnessBenchmarkScoreType type, double score) {
    switch (type) {
      case FitnessBenchmarkScoreType.fastesttimedistance:
      case FitnessBenchmarkScoreType.fastesttimereps:
      case FitnessBenchmarkScoreType.unbrokenmaxtime:
        return Duration(milliseconds: score.round()).displayString;

      case FitnessBenchmarkScoreType.longestdistance:
        return '${score}m';

      case FitnessBenchmarkScoreType.maxload:
        return '${score}kg';

      case FitnessBenchmarkScoreType.timedmaxreps:
      case FitnessBenchmarkScoreType.unbrokenmaxreps:
        return '$score reps';

      default:
        throw Exception(
            'This is not a valid FitnessBenchmarkScoreType enum: $type');
    }
  }
}
