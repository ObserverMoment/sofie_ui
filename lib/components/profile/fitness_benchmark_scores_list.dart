import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/utils.dart';

class UserFitnessBenchmarkScoresList extends StatelessWidget {
  final List<BestBenchmarkScoreSummary> bestBenchmarkScores;
  const UserFitnessBenchmarkScoresList(
      {Key? key, required this.bestBenchmarkScores})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        children: bestBenchmarkScores
            .map((score) => _BenchmarkScore(score: score))
            .toList());
  }
}

class _BenchmarkScore extends StatelessWidget {
  final BestBenchmarkScoreSummary score;
  const _BenchmarkScore({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreDisplay = FitnessBenchmarkUtils.scoreDisplayText(
        score.benchmarkType, score.bestScore);
    return Card(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyHeaderText(
            score.benchmarkName,
            weight: FontWeight.normal,
            size: FONTSIZE.two,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContentBox(
                  borderRadius: 30,
                  backgroundColor: context.theme.background.withOpacity(0.4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        scoreDisplay.score,
                        color: Styles.primaryAccent,
                        size: FONTSIZE.four,
                      ),
                      const SizedBox(width: 2),
                      MyText(
                        scoreDisplay.suffix,
                        color: Styles.primaryAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MyText(
            score.benchmarkType.display,
            size: FONTSIZE.one,
            subtext: true,
          ),
        ],
      ),
    );
  }
}
