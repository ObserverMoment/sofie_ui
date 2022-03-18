import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/profile/edit_profile_page.dart';

class FitnessBenchmarkScoreDisplay {
  final String score;
  final String suffix;
  FitnessBenchmarkScoreDisplay(this.score, this.suffix);
}

class FitnessBenchmarkUtils {
  static Future<void> toggleActivateBenchmark(BuildContext context,
      List<String> activeBenchmarkIds, String benchmarkId) async {
    late List<String> updated;

    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    if (activeBenchmarkIds.contains(benchmarkId)) {
      updated = activeBenchmarkIds.where((b) => b != benchmarkId).toList();
    } else {
      updated = [...activeBenchmarkIds, benchmarkId];
    }

    await EditProfilePage.updateUserFields(
        context, authedUserId, {'activeFitnessBenchmarks': updated});
  }

  static FitnessBenchmarkScoreDisplay scoreDisplayText(
      FitnessBenchmarkScoreType type, double score) {
    switch (type) {
      case FitnessBenchmarkScoreType.fastesttimedistance:
      case FitnessBenchmarkScoreType.fastesttimereps:
      case FitnessBenchmarkScoreType.unbrokenmaxtime:
        return FitnessBenchmarkScoreDisplay(
            Duration(milliseconds: score.round()).prettyDuration, '');

      case FitnessBenchmarkScoreType.longestdistance:
        return FitnessBenchmarkScoreDisplay(score.stringMyDouble(), 'mtr');

      case FitnessBenchmarkScoreType.maxload:
        return FitnessBenchmarkScoreDisplay(score.stringMyDouble(), 'kg');

      case FitnessBenchmarkScoreType.timedmaxreps:
      case FitnessBenchmarkScoreType.unbrokenmaxreps:
        return FitnessBenchmarkScoreDisplay(score.round().toString(), 'reps');

      default:
        throw Exception(
            'This is not a valid FitnessBenchmarkScoreType enum: $type');
    }
  }

  static String scoreSiffixText(FitnessBenchmarkScoreType type, double score) {
    switch (type) {
      case FitnessBenchmarkScoreType.fastesttimedistance:
      case FitnessBenchmarkScoreType.fastesttimereps:
      case FitnessBenchmarkScoreType.unbrokenmaxtime:
        return Duration(milliseconds: score.round()).displayString;

      case FitnessBenchmarkScoreType.longestdistance:
        return '${score.stringMyDouble()}m';

      case FitnessBenchmarkScoreType.maxload:
        return '${score.stringMyDouble()}kg';

      case FitnessBenchmarkScoreType.timedmaxreps:
      case FitnessBenchmarkScoreType.unbrokenmaxreps:
        return '${score.round()} reps';

      default:
        throw Exception(
            'This is not a valid FitnessBenchmarkScoreType enum: $type');
    }
  }

  /// Lowest or highest, depending on the [FitnessBenchmarkScoreType]
  static FitnessBenchmarkScore? bestScore(
      FitnessBenchmarkScoreType type, List<FitnessBenchmarkScore>? scores) {
    if (scores == null || scores.isEmpty) {
      return null;
    } else {
      final sortedScores = scores.sortedBy<num>((score) => score.score);

      switch (type) {
        case FitnessBenchmarkScoreType.fastesttimedistance:
        case FitnessBenchmarkScoreType.fastesttimereps:
          return sortedScores.first;

        case FitnessBenchmarkScoreType.longestdistance:
        case FitnessBenchmarkScoreType.maxload:
        case FitnessBenchmarkScoreType.timedmaxreps:
        case FitnessBenchmarkScoreType.unbrokenmaxreps:
        case FitnessBenchmarkScoreType.unbrokenmaxtime:
          return sortedScores.last;

        default:
          throw Exception(
              'This is not a valid FitnessBenchmarkScoreType enum: $type');
      }
    }
  }
}
