import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/fitness_benchmark_actions_menu.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/utils.dart';

class FitnessBenchmarkCard extends StatelessWidget {
  final FitnessBenchmark benchmark;
  final List<String> activeBenchmarkIds;

  const FitnessBenchmarkCard({
    Key? key,
    required this.benchmark,
    required this.activeBenchmarkIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bestScore = FitnessBenchmarkUtils.bestScore(
        benchmark.type, benchmark.fitnessBenchmarkScores);

    final scoreDisplay = bestScore != null
        ? FitnessBenchmarkUtils.scoreDisplayText(
            benchmark.type, bestScore.score)
        : null;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyText(
                    benchmark.name,
                  ),
                  if (activeBenchmarkIds.contains(benchmark.id))
                    const FadeInUp(
                        child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        material.Icons.dashboard,
                        size: 18,
                        color: Styles.primaryAccent,
                      ),
                    ))
                ],
              ),
              const SizedBox(height: 4),
              MyText(
                benchmark.type.display,
                size: FONTSIZE.one,
              ),
              const SizedBox(height: 6),
              scoreDisplay == null
                  ? const MyText(
                      '- No scores',
                      subtext: true,
                      size: FONTSIZE.two,
                    )
                  : MyText('${scoreDisplay.score}${scoreDisplay.suffix}',
                      size: FONTSIZE.five),
            ],
          ),
          FitnessBenchmarkActionsMenu(
            benchmark: benchmark,
            activeBenchmarkIds: activeBenchmarkIds,
            showViewHistoryAction: true,
            child: const Icon(CupertinoIcons.ellipsis),
          )
        ],
      ),
    );
  }
}
