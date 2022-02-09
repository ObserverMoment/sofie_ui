import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/user_day_log_mood_card.dart';
import 'package:sofie_ui/components/creators/user_day_log_mood_creator_page.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/components/widget_header.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LoggedMoodsWidget extends StatefulWidget {
  const LoggedMoodsWidget({Key? key}) : super(key: key);

  @override
  State<LoggedMoodsWidget> createState() => _LoggedMoodsWidgetState();
}

class _LoggedMoodsWidgetState extends State<LoggedMoodsWidget> {
  bool _moodDisplayIsOpen = false;

  Future<void> _getMoodAndOpenModal(
      List<UserDayLogMood> moods, ChartPointDetails d) async {
    if (!_moodDisplayIsOpen && d.pointIndex != null) {
      _moodDisplayIsOpen = true;
      await context.showActionSheetPopup(
          cancelCloseText: 'Close',
          child: UserDayLogMoodCard(mood: moods[d.pointIndex!]));
    }

    _moodDisplayIsOpen = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = UserDayLogMoodsQuery();

    return SizedBox(
      // height: 180,
      height: 500,
      child: QueryObserver<UserDayLogMoods$Query, json.JsonSerializable>(
          key: Key('LoggedMoodsWidget - ${query.operationName}'),
          query: query,
          fetchPolicy: QueryFetchPolicy.storeFirst,
          builder: (data) {
            final sortedMoods = data.userDayLogMoods
                .sortedBy<DateTime>((m) => m.createdAt)
                .toList();

            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);

            final fourWeeksAgo =
                DateTime(today.year, today.month, today.day - 28);

            final fourWeeksOfMoods = sortedMoods
                .where((m) => m.createdAt.isAfter(fourWeeksAgo))
                .toList();

            final firstDateForChart =
                fourWeeksAgo.isBefore(sortedMoods.first.createdAt)
                    ? sortedMoods.first.createdAt
                    : fourWeeksAgo;

            final markerColor = context.theme.background.withOpacity(0.2);

            return Column(
              children: [
                WidgetHeader(
                  icon: CupertinoIcons.heart,
                  title: 'Moods',
                  actions: [
                    WidgetHeaderAction(
                        icon: CupertinoIcons.plus,
                        onPressed: () => context.push(
                            fullscreenDialog: true,
                            child: const UserDayLogMoodCreatorPage())),
                    WidgetHeaderAction(
                        icon: CupertinoIcons.rectangle_expand_vertical,
                        onPressed: () => print('view full screen')),
                    WidgetHeaderAction(
                        icon: CupertinoIcons.settings,
                        onPressed: () => print('settings')),
                  ],
                ),
                UserDayLogMoodCard(
                  mood: fourWeeksOfMoods.first,
                ),
                // Flexible(
                //   child: SfCartesianChart(
                //       plotAreaBorderWidth: 0,
                //       primaryXAxis: DateTimeAxis(
                //         isVisible: false,
                //         maximum: now,
                //         minimum: firstDateForChart,
                //       ),
                //       primaryYAxis:
                //           NumericAxis(minimum: 0, maximum: 4, isVisible: false),
                //       series: <ChartSeries>[
                //         SplineSeries<UserDayLogMood, DateTime>(
                //             name: 'Mood',
                //             markerSettings: MarkerSettings(
                //                 height: 10,
                //                 width: 10,
                //                 isVisible: true,
                //                 color: markerColor),
                //             width: 4,
                //             color: Styles.primaryAccent,
                //             dataSource: fourWeeksOfMoods,
                //             xValueMapper: (m, _) => m.createdAt,
                //             yValueMapper: (m, _) => m.moodScore,
                //             onPointTap: (d) =>
                //                 _getMoodAndOpenModal(fourWeeksOfMoods, d)),
                //         SplineSeries<UserDayLogMood, DateTime>(
                //             name: 'Energy',
                //             markerSettings: MarkerSettings(
                //                 height: 10,
                //                 width: 10,
                //                 isVisible: true,
                //                 color: markerColor),
                //             width: 4,
                //             color: Styles.secondaryAccent,
                //             dataSource: fourWeeksOfMoods,
                //             xValueMapper: (m, _) => m.createdAt,
                //             yValueMapper: (m, _) => m.energyScore,
                //             onPointTap: (d) =>
                //                 _getMoodAndOpenModal(fourWeeksOfMoods, d))
                //       ]),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 3.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       MyText(
                //         firstDateForChart.minimalDateString,
                //         size: FONTSIZE.one,
                //         subtext: true,
                //       ),
                //       MyText(
                //         now.minimalDateString,
                //         size: FONTSIZE.one,
                //         subtext: true,
                //       ),
                //     ],
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const [
                //     ChartLegendItem(
                //       color: Styles.primaryAccent,
                //       label: 'Energy',
                //     ),
                //     SizedBox(width: 12),
                //     ChartLegendItem(
                //       color: Styles.secondaryAccent,
                //       label: 'Mood',
                //     ),
                //   ],
                // ),
              ],
            );
          }),
    );
  }
}

class ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const ChartLegendItem({Key? key, required this.color, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Dot(
          diameter: 8,
          color: color,
        ),
        const SizedBox(width: 4),
        MyText(
          label,
          size: FONTSIZE.one,
        ),
      ],
    );
  }
}
