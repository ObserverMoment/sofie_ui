import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/user_day_log_mood_card.dart';
import 'package:sofie_ui/components/creators/user_day_logs/user_day_log_mood_creator_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

class LoggedMoodsFullScreen extends StatefulWidget {
  final String widgetId;
  final List<UserDayLogMood> loggedMoods;
  const LoggedMoodsFullScreen(
      {Key? key, required this.widgetId, required this.loggedMoods})
      : super(key: key);

  @override
  State<LoggedMoodsFullScreen> createState() => _LoggedMoodsFullScreenState();
}

class _LoggedMoodsFullScreenState extends State<LoggedMoodsFullScreen> {
  bool _moodDisplayIsOpen = false;

  /// Being repeated in the min size widget version of this.
  Future<void> _getMoodAndOpenModal(
      List<UserDayLogMood> moods, ChartPointDetails d) async {
    if (!_moodDisplayIsOpen && d.pointIndex != null) {
      _moodDisplayIsOpen = true;
      await context.showActionSheetPopup(
          cancelCloseText: 'Close',
          child: UserDayLogMoodCard(
              mood: moods[d.pointIndex!],
              deleteMoodLog: () =>
                  _confirmDeleteUserDayLogMood(moods[d.pointIndex!])));
    }

    _moodDisplayIsOpen = false;
    setState(() {});
  }

  void _confirmDeleteUserDayLogMood(UserDayLogMood mood) {
    context.showConfirmDeleteDialog(
        itemName: mood.createdAt.dateAndTime,
        itemType: 'Mood Entry',
        onConfirm: () {
          _deleteUserDayLogMood(mood);
        });
  }

  Future<void> _deleteUserDayLogMood(UserDayLogMood mood) async {
    final result = await GraphQLStore.store.delete(
      mutation: DeleteUserDayLogMoodMutation(
          variables: DeleteUserDayLogMoodArguments(id: mood.id)),
      objectId: mood.id,
      typename: kUserDayLogMoodTypename,
    );

    checkOperationResult(result,
        onSuccess: () => context.showToast(
              message: 'Mood log deleted',
            ),
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem',
            toastType: ToastType.destructive));
  }

  @override
  Widget build(BuildContext context) {
    final sortedMoods = widget.loggedMoods
        .sortedBy<DateTime>((m) => m.createdAt)
        .reversed
        .toList();

    return CupertinoPageScaffold(
        backgroundColor: context.theme.cardBackground,
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  MySliverNavbar(
                    title: 'Moods',
                    leadingIcon: CupertinoIcons.chevron_down,
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: NavBarTrailingRow(
                        children: [
                          IconButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              onPressed: () => context.push(
                                  fullscreenDialog: true,
                                  child: const UserDayLogMoodCreatorPage()),
                              iconData: CupertinoIcons.plus),
                          CircularBox(
                            padding: const EdgeInsets.all(10),
                            color: context.theme.background,
                            child: Icon(kWidgetIdToIconMap[widget.widgetId],
                                size: 20),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: context.theme.cardBackground,
                  ),
                ],
            body: ListView.separated(
              itemCount: sortedMoods.length + 4,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              separatorBuilder: (c, i) => const SizedBox(height: 10),
              itemBuilder: (c, i) {
                if (i == 0) {
                  return _TwoWeekAverages(
                    loggedMoods: sortedMoods,
                  );
                } else if (i == 1) {
                  return _MoodGraph(
                    loggedMoods: sortedMoods,
                    getMoodAndOpenModal: (d) =>
                        _getMoodAndOpenModal(sortedMoods, d),
                  );
                } else if (i == 2) {
                  return _EnergyGraph(
                    loggedMoods: sortedMoods,
                    getLogAndOpenModal: (d) =>
                        _getMoodAndOpenModal(sortedMoods, d),
                  );
                } else if (i == 3) {
                  return Column(
                    children: [
                      const HorizontalLine(),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Icon(CupertinoIcons.list_bullet),
                          SizedBox(width: 8),
                          MyHeaderText('Log History'),
                        ],
                      ),
                    ],
                  );
                } else {
                  return UserDayLogMoodCard(
                    mood: sortedMoods[i - 4],
                    deleteMoodLog: () =>
                        _confirmDeleteUserDayLogMood(sortedMoods[i - 4]),
                  );
                }
              },
            )));
  }
}

class _TwoWeekAverages extends StatelessWidget {
  final List<UserDayLogMood> loggedMoods;
  const _TwoWeekAverages({Key? key, required this.loggedMoods})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final twoWeeksAgo = DateTime(today.year, today.month, today.day - 14);

    final twoWeeksOfMoods =
        loggedMoods.where((m) => m.createdAt.isAfter(twoWeeksAgo)).toList();

    /// + 1 as input data is 0 -> 4 but we want to display as 1 -> 5.
    final moodAverage = twoWeeksOfMoods.isNotEmpty
        ? twoWeeksOfMoods.map((m) => m.moodScore + 1).average
        : null;
    final energyAverage = twoWeeksOfMoods.isNotEmpty
        ? twoWeeksOfMoods.map((m) => m.energyScore + 1).average
        : null;

    return Column(
      children: [
        if (twoWeeksOfMoods.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: MyHeaderText(
              '14 Day Average',
              weight: FontWeight.normal,
            ),
          ),
        if (twoWeeksOfMoods.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AvgSummaryDisplay(
                    average: moodAverage!,
                    label: 'Mood',
                  ),
                  ScoreMeter(
                    label: 'Mood',
                    score: moodAverage,
                    gradient: Styles.primaryAccentGradientVertical,
                    displayWidth: 60,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScoreMeter(
                    label: 'Energy',
                    score: energyAverage!,
                    gradient: Styles.secondaryAccentGradient,
                    displayWidth: 60,
                  ),
                  _AvgSummaryDisplay(
                    average: energyAverage,
                    label: 'Energy',
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

class _AvgSummaryDisplay extends StatelessWidget {
  final double average;
  final String label;
  const _AvgSummaryDisplay({
    Key? key,
    required this.average,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.background.withOpacity(0.45);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          MyText(
            average.stringMyDouble(),
            size: FONTSIZE.six,
            color: Styles.secondaryAccent,
          ),
          const MyText(
            'OUT OF 5',
            size: FONTSIZE.one,
            subtext: true,
          ),
        ],
      ),
    );
  }
}

/// Scrollable moods graph
class _MoodGraph extends StatelessWidget {
  final List<UserDayLogMood> loggedMoods;
  final void Function(ChartPointDetails d) getMoodAndOpenModal;
  const _MoodGraph(
      {Key? key, required this.loggedMoods, required this.getMoodAndOpenModal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: SfCartesianChart(
          borderWidth: 0,
          plotAreaBorderWidth: 0,
          primaryXAxis: DateTimeAxis(
            desiredIntervals: 6,
            maximum: DateTime.now(),
            majorGridLines: const MajorGridLines(width: 0),
            labelStyle: TextStyle(color: context.theme.primary, fontSize: 12),
          ),
          primaryYAxis: NumericAxis(
              minimum: 0,
              // When this is 4 (the actual max) the spline curvature can mean that the top of the line can get cut off
              maximum: 4.2,
              isVisible: false,
              rangePadding: ChartRangePadding.additional),
          series: <ChartSeries>[
            SplineSeries<UserDayLogMood, DateTime>(
                splineType: SplineType.monotonic,
                name: 'Mood',
                markerSettings: const MarkerSettings(
                    height: 10,
                    width: 10,
                    isVisible: true,
                    color: Styles.primaryAccent),
                width: 3,
                color: Styles.primaryAccent,
                dataSource: loggedMoods,
                xValueMapper: (m, _) => m.createdAt,
                yValueMapper: (m, _) => m.moodScore,
                onPointTap: getMoodAndOpenModal),
          ]),
    );
  }
}

/// Scrollable energy graph
class _EnergyGraph extends StatelessWidget {
  final List<UserDayLogMood> loggedMoods;
  final void Function(ChartPointDetails d) getLogAndOpenModal;
  const _EnergyGraph(
      {Key? key, required this.loggedMoods, required this.getLogAndOpenModal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: SfCartesianChart(
          borderWidth: 0,
          plotAreaBorderWidth: 0,
          primaryXAxis: DateTimeAxis(
            desiredIntervals: 6,
            maximum: DateTime.now(),
            majorGridLines: const MajorGridLines(width: 0),
            labelStyle: TextStyle(color: context.theme.primary, fontSize: 12),
          ),
          primaryYAxis: NumericAxis(
              minimum: 0,
              // When this is 4 (the actual max) the spline curvature can mean that the top of the line can get cut off
              maximum: 4.2,
              isVisible: false,
              rangePadding: ChartRangePadding.additional),
          series: <ChartSeries>[
            SplineSeries<UserDayLogMood, DateTime>(
                splineType: SplineType.monotonic,
                name: 'Energy',
                markerSettings: const MarkerSettings(
                    height: 10,
                    width: 10,
                    isVisible: true,
                    color: Styles.secondaryAccent),
                width: 3,
                color: Styles.secondaryAccent,
                dataSource: loggedMoods,
                xValueMapper: (m, _) => m.createdAt,
                yValueMapper: (m, _) => m.energyScore,
                onPointTap: getLogAndOpenModal)
          ]),
    );
  }
}
