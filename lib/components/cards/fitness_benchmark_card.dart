import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/fitness_benchmarks/fitness_benchmark_score_creator.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/utils.dart';

class FitnessBenchmarkCard extends StatelessWidget {
  final FitnessBenchmark fitnessBenchmark;
  const FitnessBenchmarkCard({Key? key, required this.fitnessBenchmark})
      : super(key: key);

  FitnessBenchmarkScore? get _bestScore {
    if (fitnessBenchmark.fitnessBenchmarkScores == null ||
        fitnessBenchmark.fitnessBenchmarkScores!.isEmpty) {
      return null;
    } else {
      final sortedScores = fitnessBenchmark.fitnessBenchmarkScores!
          .sortedBy<num>((score) => score.score);

      switch (fitnessBenchmark.type) {
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
              'This is not a valid FitnessBenchmarkScoreType enum: ${fitnessBenchmark.type}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bestScore = _bestScore;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(fitnessBenchmark.name),
              const SizedBox(height: 3),
              MyText(
                fitnessBenchmark.type.display,
                size: FONTSIZE.one,
              ),
              const SizedBox(height: 6),
              bestScore == null
                  ? const MyText(
                      '- No scores',
                      subtext: true,
                      size: FONTSIZE.two,
                    )
                  : MyText(
                      FitnessBenchmarkUtils.scoreDisplayText(
                          fitnessBenchmark.type, bestScore.score),
                      size: FONTSIZE.five),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  iconData: CupertinoIcons.circle,
                  onPressed: () => print('activate / deactivate')),
              IconButton(
                  iconData: CupertinoIcons.plus,
                  onPressed: () => context.push(
                          child: FitnessBenchmarkScoreCreator(
                        fitnessBenchmark: fitnessBenchmark,
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
