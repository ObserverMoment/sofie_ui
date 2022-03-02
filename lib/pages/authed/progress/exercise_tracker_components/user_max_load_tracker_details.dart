import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/user_max_load_exercise_trackers.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

/// Displays a graph at the top of the screen showing progress over time + a list below the graph of the top x entries (including manual entries) + any videos that the user has uploaded.
class UserMaxLoadTrackerDetails extends StatelessWidget {
  final UserMaxLoadExerciseTracker tracker;
  final List<MaxLoadScoreWithCompletedOnDate> scores;
  const UserMaxLoadTrackerDetails(
      {Key? key, required this.tracker, required this.scores})
      : super(key: key);

  Future<void> _confirmDeleteTracker(BuildContext context) async {
    context.showConfirmDeleteDialog(
        message:
            'Deleting this tracker will also delete all manual entries that you have previously submitted. This cannot be undone. OK?',
        itemType: 'Score Tracker',
        onConfirm: () async {
          final result = await context.graphQLStore.delete(
              mutation: DeleteUserMaxLoadExerciseTrackerMutation(
                  variables: DeleteUserMaxLoadExerciseTrackerArguments(
                      id: tracker.id)),
              objectId: tracker.id,
              typename: kUserMaxLoadExerciseTracker,
              removeRefFromQueries: [GQLOpNames.userMaxLoadExerciseTrackers]);

          checkOperationResult(context, result, onSuccess: context.pop);
        });
  }

  String get _repString => tracker.reps == 1 ? 'rep' : 'reps';
  String get _equipmentString =>
      tracker.equipment == null ? '' : ' - ${tracker.equipment!.name}';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
        middle: TertiaryButton(
            prefixIconData: MyCustomIcons.medal,
            iconSize: 14,
            fontSize: FONTSIZE.three,
            onPressed: () => print('create manual score'),
            text: 'Submit a Score'),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.trash,
              size: 20,
            ),
            onPressed: () => _confirmDeleteTracker(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: MyHeaderText(
              tracker.move.name,
              weight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: MyHeaderText(
              '${tracker.reps} $_repString$_equipmentString - ${tracker.loadUnit.display}',
              size: FONTSIZE.two,
              weight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 14),
          if (scores.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: MyText(
                  'No scores logged or submitted yet',
                  subtext: true,
                ),
              ),
            ),
          if (scores.isNotEmpty)
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _MaxLiftProgressGraph(
                    scores: scores,
                    tracker: tracker,
                  ),
                  _TopTenScoresList(
                    tracker: tracker,
                    scores: scores,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class _MaxLiftProgressGraph extends StatelessWidget {
  final UserMaxLoadExerciseTracker tracker;
  final List<MaxLoadScoreWithCompletedOnDate> scores;
  const _MaxLiftProgressGraph(
      {Key? key, required this.tracker, required this.scores})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridlineColor = context.theme.primary.withOpacity(0.07);
    final labelStyle = TextStyle(color: context.theme.primary, fontSize: 10);

    /// We only need the highest score in a given day, otherwise the graph can get very messy.
    /// We could open this out if needed to be on a given hour etc...
    final topScoresPerDay = <DateTime, MaxLoadScoreWithCompletedOnDate>{};

    for (final score in scores) {
      final dayDate = DateTime(score.completedOn.year, score.completedOn.month,
          score.completedOn.day);
      if ((topScoresPerDay[dayDate] == null) ||
          (topScoresPerDay[dayDate]!.loadAmount < score.loadAmount)) {
        topScoresPerDay[dayDate] = score;
      }
    }

    final chartData = topScoresPerDay.entries.map((e) => e.value).toList();

    return Padding(
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
              decimalPlaces: 2,
              majorGridLines: MajorGridLines(color: gridlineColor)),
          primaryXAxis: DateTimeAxis(
              labelStyle: labelStyle,
              majorGridLines: MajorGridLines(color: gridlineColor)),
          series: <ChartSeries>[
            AreaSeries<MaxLoadScoreWithCompletedOnDate, DateTime>(
                color: Styles.primaryAccent,
                dataSource: chartData,
                xValueMapper: (score, _) => score.completedOn,
                yValueMapper: (score, _) => score.loadAmount,
                gradient: Styles.primaryAccentGradient)
          ]),
    );
  }
}

class _TopTenScoresList extends StatelessWidget {
  final UserMaxLoadExerciseTracker tracker;
  final List<MaxLoadScoreWithCompletedOnDate> scores;
  const _TopTenScoresList(
      {Key? key, required this.scores, required this.tracker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topTenScores = scores
        .sortedBy<MaxLoadScoreWithCompletedOnDate>((s) => s)
        .reversed
        .take(10);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Column(
        children: topTenScores
            .map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: ContentBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ContentBox(
                            borderRadius: 30,
                            backgroundColor:
                                context.theme.background.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  s.loadAmount.stringMyDouble(),
                                  color: Styles.primaryAccent,
                                  size: FONTSIZE.seven,
                                ),
                                const SizedBox(width: 2),
                                MyText(
                                  tracker.loadUnit.display,
                                  color: Styles.primaryAccent,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (Utils.textNotNull(s.loggedWorkoutId))
                            TertiaryButton(
                                fontSize: FONTSIZE.one,
                                iconSize: 14,
                                backgroundColor:
                                    context.theme.background.withOpacity(0.5),
                                suffixIconData: CupertinoIcons.chevron_right,
                                text: 'View Log',
                                onPressed: () => context.navigateTo(
                                    LoggedWorkoutDetailsRoute(
                                        id: s.loggedWorkoutId!))),
                          if (Utils.textNotNull(s.videoUri))
                            TertiaryButton(
                                fontSize: FONTSIZE.one,
                                iconSize: 14,
                                backgroundColor:
                                    context.theme.background.withOpacity(0.5),
                                suffixIconData: CupertinoIcons.tv,
                                text: 'View Video',
                                onPressed: () =>
                                    VideoSetupManager.openFullScreenVideoPlayer(
                                        context: context,
                                        videoUri: s.videoUri!)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MyText(
                            s.completedOn.compactDateString,
                            size: FONTSIZE.two,
                          ),
                          const SizedBox(height: 2),
                          MyText(
                            s.completedOn.timeString,
                            size: FONTSIZE.two,
                          ),
                        ],
                      )
                    ],
                  )),
                ))
            .toList(),
      ),
    );
  }
}
