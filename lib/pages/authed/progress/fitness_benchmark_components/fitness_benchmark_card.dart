import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/fitness_benchmarks/fitness_benchmark_score_creator.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/utils.dart';

class FitnessBenchmarkCard extends StatelessWidget {
  final FitnessBenchmark benchmark;

  /// Is the benchmark being displayed on the user's dashboard.
  final bool isActive;
  final VoidCallback toggleActiveBenchmark;
  final VoidCallback deleteCustomBenchmark;
  const FitnessBenchmarkCard(
      {Key? key,
      required this.benchmark,
      required this.isActive,
      required this.toggleActiveBenchmark,
      required this.deleteCustomBenchmark})
      : super(key: key);

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
                  MyText(benchmark.name),
                  if (isActive)
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
              const SizedBox(height: 3),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  iconData: CupertinoIcons.ellipsis,
                  onPressed: () => openBottomSheetMenu(
                      context: context,
                      child: BottomSheetMenu(
                          header: BottomSheetMenuHeader(
                            name: benchmark.name,
                            subtitle: benchmark.type.display,
                          ),
                          items: [
                            BottomSheetMenuItem(
                                icon: material.Icons.score,
                                text: 'Submit a Score',
                                onPressed: () => context.push(
                                        child: FitnessBenchmarkScoreCreator(
                                      fitnessBenchmark: benchmark,
                                    ))),
                            isActive
                                ? BottomSheetMenuItem(
                                    icon: material.Icons.dashboard,
                                    text: 'Remove from Dashboard',
                                    onPressed: toggleActiveBenchmark)
                                : BottomSheetMenuItem(
                                    icon: material.Icons.dashboard,
                                    text: 'Add to Dashboard',
                                    onPressed: toggleActiveBenchmark),
                            if (benchmark.scope == FitnessBenchmarkScope.custom)
                              BottomSheetMenuItem(
                                  icon: CupertinoIcons.delete,
                                  isDestructive: true,
                                  text: 'Delete Custom Benchmark',
                                  onPressed: deleteCustomBenchmark)
                          ]))),
            ],
          )
        ],
      ),
    );
  }
}
