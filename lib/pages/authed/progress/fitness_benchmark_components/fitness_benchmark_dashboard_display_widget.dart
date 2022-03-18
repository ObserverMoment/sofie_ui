import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/utils.dart';

class FitnessBenchmarkDashboardDisplayWidget extends StatelessWidget {
  final FitnessBenchmark benchmark;
  const FitnessBenchmarkDashboardDisplayWidget(
      {Key? key, required this.benchmark})
      : super(key: key);

  Widget _buildInfoHeader(String text) => MyHeaderText(
        text,
        size: FONTSIZE.one,
        lineHeight: 1.3,
        weight: FontWeight.normal,
        maxLines: 2,
        textAlign: TextAlign.center,
      );

  @override
  Widget build(BuildContext context) {
    final bestScore = FitnessBenchmarkUtils.bestScore(
        benchmark.type, benchmark.fitnessBenchmarkScores);

    final scoreDisplay = bestScore != null
        ? FitnessBenchmarkUtils.scoreDisplayText(
            benchmark.type, bestScore.score)
        : null;

    return Card(
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoHeader(
            benchmark.name,
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
                        scoreDisplay == null ? '-' : scoreDisplay.score,
                        color: Styles.primaryAccent,
                        size: FONTSIZE.five,
                      ),
                      const SizedBox(width: 2),
                      MyText(
                        scoreDisplay == null ? '-' : scoreDisplay.suffix,
                        color: Styles.primaryAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MyText(
            benchmark.type.display,
            size: FONTSIZE.one,
            subtext: true,
          ),
          MyText(
            benchmark.fitnessBenchmarkCategory.name,
            size: FONTSIZE.one,
            subtext: true,
          ),
        ],
      ),
    );
  }
}
