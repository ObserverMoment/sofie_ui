import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/user_day_log_mood_card.dart';
import 'package:sofie_ui/components/creators/user_day_logs/user_day_log_mood_creator_page.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

class LoggedMoodsWidget extends StatefulWidget {
  final List<UserDayLogMood> loggedMoods;
  const LoggedMoodsWidget({Key? key, required this.loggedMoods})
      : super(key: key);

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
          context.pop();
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
    final sortedMoods =
        widget.loggedMoods.sortedBy<DateTime>((m) => m.createdAt).toList();

    if (sortedMoods.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 12),
          const MyText(
            'No moods logged yet...',
            subtext: true,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
              text: 'How are you feeling?',
              onPressed: () => context.push(
                  fullscreenDialog: true,
                  child: const UserDayLogMoodCreatorPage())),
        ],
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final fourWeeksAgo = DateTime(today.year, today.month, today.day - 28);

    final fourWeeksOfMoods =
        sortedMoods.where((m) => m.createdAt.isAfter(fourWeeksAgo)).toList();

    final firstDateForChart = fourWeeksAgo.isBefore(sortedMoods.first.createdAt)
        ? sortedMoods.first.createdAt
        : fourWeeksAgo;

    final markerColor = context.theme.background.withOpacity(0.2);

    return Column(
      children: [
        SizedBox(
          height: 110,
          child: SfCartesianChart(
              borderWidth: 5,
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                isVisible: false,
                maximum: now,
                minimum: firstDateForChart,
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
                    markerSettings: MarkerSettings(
                        height: 10,
                        width: 10,
                        isVisible: true,
                        color: markerColor),
                    width: 3,
                    color: Styles.primaryAccent,
                    dataSource: fourWeeksOfMoods,
                    xValueMapper: (m, _) => m.createdAt,
                    yValueMapper: (m, _) => m.moodScore,
                    onPointTap: (d) =>
                        _getMoodAndOpenModal(fourWeeksOfMoods, d)),
                SplineSeries<UserDayLogMood, DateTime>(
                    splineType: SplineType.monotonic,
                    name: 'Energy',
                    markerSettings: MarkerSettings(
                        height: 10,
                        width: 10,
                        isVisible: true,
                        color: markerColor),
                    width: 3,
                    color: Styles.secondaryAccent,
                    dataSource: fourWeeksOfMoods,
                    xValueMapper: (m, _) => m.createdAt,
                    yValueMapper: (m, _) => m.energyScore,
                    onPointTap: (d) =>
                        _getMoodAndOpenModal(fourWeeksOfMoods, d))
              ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                firstDateForChart.minimalDateString,
                size: FONTSIZE.one,
                subtext: true,
              ),
              MyText(
                now.minimalDateString,
                size: FONTSIZE.one,
                subtext: true,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ChartLegendItem(
              color: Styles.primaryAccent,
              label: 'Energy',
            ),
            SizedBox(width: 12),
            ChartLegendItem(
              color: Styles.secondaryAccent,
              label: 'Mood',
            ),
          ],
        ),
      ],
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
