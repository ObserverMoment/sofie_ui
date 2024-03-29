import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/creators/fitness_benchmarks/fitness_benchmark_score_creator.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/active_settings_and_benchmarks_container.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/fitness_benchmark_actions_menu.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/utils.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Details for a benchmark for the logged in User.
class UserFitnessBenchmarkDetails extends StatelessWidget {
  final String id;
  const UserFitnessBenchmarkDetails({Key? key, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActiveSettingsAndBenchmarksContainer(
        builder: (activeBenchmarkIds, benchmarks) {
      final benchmark = benchmarks.firstWhereOrNull((b) => b.id == id);

      if (benchmark == null) {
        /// It has probably just been deleted via [FitnessBenchmarkActionsMenu].
        return Container();
      } else {
        final scores = benchmark.fitnessBenchmarkScores ?? [];

        return CupertinoPageScaffold(
          navigationBar: MyNavBar(
            middle: NavBarTitle(benchmark.name),
            trailing: FitnessBenchmarkActionsMenu(
              benchmark: benchmark,
              activeBenchmarkIds: activeBenchmarkIds,
              showViewHistoryAction: false,
              child: const Icon(CupertinoIcons.ellipsis),
              onBenchmarkDelete: context.pop,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 14),
              if (scores.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: MyText(
                      'No scores logged yet',
                      subtext: true,
                    ),
                  ),
                ),
              if (scores.isNotEmpty)
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _BenchmarkProgressGraph(
                        benchmark: benchmark,
                      ),
                      _TopTenScoresList(
                        benchmark: benchmark,
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      }
    });
  }
}

class _BenchmarkProgressGraph extends StatelessWidget {
  final FitnessBenchmark benchmark;
  const _BenchmarkProgressGraph({
    Key? key,
    required this.benchmark,
  }) : super(key: key);

  final kMillisecondsPerMinute = 60000;
  final kMillisecondsPerHOur = 60000 * 60;

  double _mapRawScoreToYAxisValue(
      double raw, FitnessBenchmarkScore largestScore) {
    switch (benchmark.type) {
      case FitnessBenchmarkScoreType.fastesttimedistance:
      case FitnessBenchmarkScoreType.fastesttimereps:
      case FitnessBenchmarkScoreType.unbrokenmaxtime:
        // Raw = ms. Depending on the range (largestScore) we can adjust the Y axis scale to something appropriate.
        return largestScore.score <= kMillisecondsPerMinute * 5
            ? raw / 1000 // Display as seconds for x minutes or less.
            : raw / kMillisecondsPerMinute; // Otherwise display as minutes.

      case FitnessBenchmarkScoreType.longestdistance:
      case FitnessBenchmarkScoreType.maxload:
      case FitnessBenchmarkScoreType.timedmaxreps:
      case FitnessBenchmarkScoreType.unbrokenmaxreps:
        return raw;

      default:
        throw Exception(
            '_BenchmarkProgressGraph._mapRawScoreToYAxisValue: No branch defined for ${benchmark.type}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridlineColor = context.theme.primary.withOpacity(0.07);
    final labelStyle = TextStyle(color: context.theme.primary, fontSize: 10);
    final scores = benchmark.fitnessBenchmarkScores ?? [];

    final largestScore = scores.sortedBy<num>((score) => score.score).last;

    return Container(
      padding: const EdgeInsets.only(right: 10.0),
      child: SfCartesianChart(
          enableAxisAnimation: false,
          plotAreaBorderWidth: 0,
          zoomPanBehavior: ZoomPanBehavior(
              zoomMode: ZoomMode.x,
              enablePanning: true,
              enablePinching: true,
              enableDoubleTapZooming: true),
          primaryYAxis: NumericAxis(
              labelStyle: labelStyle,
              rangePadding: ChartRangePadding.round,
              decimalPlaces: 2,
              majorGridLines: MajorGridLines(color: gridlineColor)),
          primaryXAxis: DateTimeAxis(
              labelStyle: labelStyle,
              rangePadding: ChartRangePadding.round,
              desiredIntervals: 6,
              majorGridLines: MajorGridLines(color: gridlineColor)),
          series: <ChartSeries>[
            LineSeries<FitnessBenchmarkScore, DateTime>(
              dataSource: scores.sortedBy<DateTime>((s) => s.completedOn),
              xValueMapper: (score, _) => score.completedOn,
              yValueMapper: (score, _) =>
                  _mapRawScoreToYAxisValue(score.score, largestScore),
              color: Styles.primaryAccent,
            )
          ]),
    );
  }
}

class _TopTenScoresList extends StatelessWidget {
  final FitnessBenchmark benchmark;
  const _TopTenScoresList({Key? key, required this.benchmark})
      : super(key: key);

  Future<void> _deleteFitnessBenchmarkScore(
      BuildContext context, FitnessBenchmarkScore score) async {
    final result = await context.graphQLStore.mutate(
        mutation: DeleteFitnessBenchmarkScoreMutation(
            variables: DeleteFitnessBenchmarkScoreArguments(id: score.id)),
        broadcastQueryIds: [GQLOpNames.userFitnessBenchmarks]);

    checkOperationResult(context, result);
  }

  List<FitnessBenchmarkScore> _topTenScores() {
    if (benchmark.fitnessBenchmarkScores == null ||
        benchmark.fitnessBenchmarkScores!.isEmpty) {
      return [];
    } else {
      final sortedScores = benchmark.fitnessBenchmarkScores!
          .sortedBy<num>((score) => score.score);

      switch (benchmark.type) {
        case FitnessBenchmarkScoreType.fastesttimedistance:
        case FitnessBenchmarkScoreType.fastesttimereps:
          return sortedScores.take(10).toList();

        case FitnessBenchmarkScoreType.longestdistance:
        case FitnessBenchmarkScoreType.maxload:
        case FitnessBenchmarkScoreType.timedmaxreps:
        case FitnessBenchmarkScoreType.unbrokenmaxreps:
        case FitnessBenchmarkScoreType.unbrokenmaxtime:
          return sortedScores.reversed.take(10).toList();

        default:
          throw Exception(
              'This is not a valid FitnessBenchmarkScoreType enum: ${benchmark.type}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topTenScores = _topTenScores();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Column(
        children: topTenScores
            .mapIndexed((i, score) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push(
                        child: FitnessBenchmarkScoreCreator(
                      fitnessBenchmark: benchmark,
                      fitnessBenchmarkScore: score,
                    )),
                child: AnimatedSlidable(
                    key: Key(score.id),
                    index: i,
                    itemType: 'Benchmark Score',
                    confirmMessage:
                        'This will also delete any video that you have uploaded against this score.',
                    removeItem: (_) =>
                        _deleteFitnessBenchmarkScore(context, score),
                    secondaryActions: const [],
                    child: _SingleEntryDisplay(
                        benchmark: benchmark, score: score))))
            .toList(),
      ),
    );
  }
}

class _SingleEntryDisplay extends StatelessWidget {
  final FitnessBenchmark benchmark;
  final FitnessBenchmarkScore score;
  const _SingleEntryDisplay(
      {Key? key, required this.benchmark, required this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreDisplay =
        FitnessBenchmarkUtils.scoreDisplayText(benchmark.type, score.score);
    final scoreDisplayText = '${scoreDisplay.score}${scoreDisplay.suffix}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: ContentBox(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ContentBox(
                borderRadius: 30,
                backgroundColor: context.theme.background.withOpacity(0.2),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: MyText(scoreDisplayText),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyText(
                score.completedOn.compactDateString,
                size: FONTSIZE.two,
              ),
              const SizedBox(height: 2),
              MyText(
                score.completedOn.timeString,
                size: FONTSIZE.one,
              ),
            ],
          )
        ],
      )),
    );
  }
}
