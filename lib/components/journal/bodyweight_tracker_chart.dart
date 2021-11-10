import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class BodyweightTrackerChart extends StatelessWidget {
  final ProgressJournal journal;
  const BodyweightTrackerChart({Key? key, required this.journal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedEntries =
        journal.progressJournalEntries.sortedBy<DateTime>((e) => e.createdAt);

    final firstRecordedBodyweight =
        sortedEntries.firstWhereOrNull((e) => e.bodyweight != null)?.bodyweight;

    final minBodyweight = sortedEntries.fold<double>(
        firstRecordedBodyweight ?? 0.0,
        (lowest, next) =>
            next.bodyweight == null ? lowest : min(lowest, next.bodyweight!));

    final maxBodyweight = sortedEntries.fold<double>(
        firstRecordedBodyweight ?? 0.0,
        (highest, next) =>
            next.bodyweight == null ? highest : max(highest, next.bodyweight!));

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              'Bodyweight Tracker (in ${journal.bodyweightUnit.display})',
              weight: FontWeight.bold,
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      if (firstRecordedBodyweight == null)
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: MyText(
            'No bodyweight entries recorded.',
            maxLines: 3,
            subtext: true,
          ),
        )
      else
        SfCartesianChart(
            plotAreaBorderWidth: 0,
            tooltipBehavior: TooltipBehavior(
                enable: true,
                duration: 6000,
                header: 'Weight',
                format: 'point.x: point.y ${journal.bodyweightUnit.display}',
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            primaryXAxis:
                DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
            primaryYAxis: NumericAxis(
                minimum: max(minBodyweight - 10, 0),
                maximum: maxBodyweight + 10,
                majorGridLines: const MajorGridLines(width: 0)),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
              zoomMode: ZoomMode.x,
            ),
            series: [
              LineSeries<ProgressJournalEntry, DateTime>(
                color: context.theme.primary,
                width: 2,
                enableTooltip: true,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  height: 6,
                  width: 6,
                ),
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average),
                dataSource: sortedEntries,
                xValueMapper: (ProgressJournalEntry e, _) => e.createdAt,
                yValueMapper: (ProgressJournalEntry e, _) => e.bodyweight,
              ),
            ]),
      const SizedBox(height: 12),
    ]);
  }
}
