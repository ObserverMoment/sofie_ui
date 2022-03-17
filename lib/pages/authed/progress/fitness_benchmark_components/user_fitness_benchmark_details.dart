import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/fitness_benchmarks/fitness_benchmark_score_creator.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/main.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/utils.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:syncfusion_flutter_charts/charts.dart';

/// Details for a benchmark for the logged in User.
class UserFitnessBenchmarkDetails extends StatelessWidget {
  final String id;
  const UserFitnessBenchmarkDetails({Key? key, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userFitnessBenchmarksQuery = UserFitnessBenchmarksQuery();

    return QueryObserver<UserFitnessBenchmarks$Query, json.JsonSerializable>(
        key: Key(
            'UserFitnessBenchmarksList - ${userFitnessBenchmarksQuery.operationName}'),
        query: userFitnessBenchmarksQuery,
        loadingIndicator: const GlobalLoadingPage(),
        builder: (data) {
          final benchmark =
              data.userFitnessBenchmarks.firstWhere((b) => b.id == id);
          final scores = benchmark.fitnessBenchmarkScores ?? [];

          return CupertinoPageScaffold(
            navigationBar: MyNavBar(
              middle: NavBarTitle(benchmark.name),
              trailing: IconButton(
                iconData: CupertinoIcons.plus,
                onPressed: () => context.push(
                    child: FitnessBenchmarkScoreCreator(
                  fitnessBenchmark: benchmark,
                )),
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
        });
  }
}

class _BenchmarkProgressGraph extends StatelessWidget {
  final FitnessBenchmark benchmark;
  const _BenchmarkProgressGraph({
    Key? key,
    required this.benchmark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridlineColor = context.theme.primary.withOpacity(0.07);
    final labelStyle = TextStyle(color: context.theme.primary, fontSize: 10);
    final scores = benchmark.fitnessBenchmarkScores ?? [];

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
              yValueMapper: (score, _) => score.score,
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
            .map((s) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push(
                        child: FitnessBenchmarkScoreCreator(
                      fitnessBenchmark: benchmark,
                      fitnessBenchmarkScore: s,
                    )),
                child: _SingleEntryDisplay(benchmark: benchmark, score: s)))
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
                child: MyText(FitnessBenchmarkUtils.scoreDisplayText(
                    benchmark.type, score.score)),
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
