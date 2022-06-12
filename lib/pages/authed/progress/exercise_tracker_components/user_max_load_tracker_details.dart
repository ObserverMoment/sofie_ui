import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

/// Displays a graph at the top of the screen showing progress over time + a list below the graph of the top x entries (including manual entries) + any videos that the user has uploaded.
class UserMaxLoadTrackerDetails extends StatelessWidget {
  final String trackerId;
  const UserMaxLoadTrackerDetails({Key? key, required this.trackerId})
      : super(key: key);

  Future<void> _confirmDeleteTracker(
      BuildContext context, UserExerciseLoadTracker tracker) async {
    context.showConfirmDeleteDialog(
        message:
            'Deleting this tracker will not delete anything from your logs, scores or history.',
        itemType: 'Score Tracker',
        onConfirm: () async {
          final result = await GraphQLStore.store.delete(
            mutation: DeleteUserExerciseLoadTrackerMutation(
                variables:
                    DeleteUserExerciseLoadTrackerArguments(id: tracker.id)),
            objectId: tracker.id,
            typename: kUserExerciseLoadTracker,
          );

          checkOperationResult(result, onSuccess: context.pop);
        });
  }

  @override
  Widget build(BuildContext context) {
    final tracker =
        context.select<ExerciseTrackersBloc, UserExerciseLoadTracker?>((b) => b
            .userExerciseLoadTrackers
            .firstWhereOrNull((t) => t.id == trackerId));

    /// It has probably been deleted so this page will pop shortly.
    if (tracker == null) {
      return Container();
    }

    final trackerRelevantScores = context.select<ExerciseTrackersBloc,
            List<ExerciseLoadScoreWithCompletedOnDate>>(
        (b) => b.retrieveMaxLoadTrackerRelevantScores(tracker));

    final repString = tracker.reps == 1 ? 'rep' : 'reps';
    final equipmentString =
        tracker.equipment == null ? '' : ' - ${tracker.equipment!.name}';

    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarTitle(
            '${tracker.move.name} - ${tracker.reps} $repString$equipmentString - ${tracker.loadUnit.display}'),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.trash,
              size: 20,
            ),
            onPressed: () => _confirmDeleteTracker(context, tracker)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 14),
          if (trackerRelevantScores.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: MyText(
                  'No scores logged yet. When you log this move during a workout your history will show here.',
                  subtext: true,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  lineHeight: 1.4,
                ),
              ),
            ),
          if (trackerRelevantScores.isNotEmpty)
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _MaxLiftProgressGraph(
                    scores: trackerRelevantScores,
                    tracker: tracker,
                  ),
                  _TopTenScoresList(
                    tracker: tracker,
                    scores: trackerRelevantScores,
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
  final UserExerciseLoadTracker tracker;
  final List<ExerciseLoadScoreWithCompletedOnDate> scores;
  const _MaxLiftProgressGraph(
      {Key? key, required this.tracker, required this.scores})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridlineColor = context.theme.primary.withOpacity(0.07);
    final labelStyle = TextStyle(color: context.theme.primary, fontSize: 10);

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
            LineSeries<ExerciseLoadScoreWithCompletedOnDate, DateTime>(
              dataSource: scores.sorted((a, b) {
                if (a.completedOn == b.completedOn) {
                  return a.loadAmount.compareTo(b.loadAmount);
                } else {
                  return a.completedOn.compareTo(b.completedOn);
                }
              }),
              xValueMapper: (score, _) => score.completedOn,
              yValueMapper: (score, _) => score.loadAmount,
              color: Styles.primaryAccent,
            )
          ]),
    );
  }
}

class _TopTenScoresList extends StatelessWidget {
  final UserExerciseLoadTracker tracker;
  final List<ExerciseLoadScoreWithCompletedOnDate> scores;
  const _TopTenScoresList(
      {Key? key, required this.scores, required this.tracker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topTenScores = scores
        .sortedBy<ExerciseLoadScoreWithCompletedOnDate>((s) => s)
        .reversed
        .take(10);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Column(
        children: topTenScores
            .map((s) => _SingleEntryDisplay(tracker: tracker, score: s))
            .toList(),
      ),
    );
  }
}

class _SingleEntryDisplay extends StatelessWidget {
  final UserExerciseLoadTracker tracker;
  final ExerciseLoadScoreWithCompletedOnDate score;
  const _SingleEntryDisplay(
      {Key? key, required this.tracker, required this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonTagColor = context.theme.background.withOpacity(0.5);

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      score.loadAmount.stringMyDouble(),
                      color: Styles.primaryAccent,
                      size: FONTSIZE.six,
                    ),
                    const SizedBox(width: 2),
                    MyText(
                      tracker.loadUnit.display,
                      color: Styles.primaryAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // if (Utils.textNotNull(score.loggedWorkoutId))
              //   TertiaryButton(
              //       fontSize: FONTSIZE.one,
              //       iconSize: 14,
              //       backgroundColor: buttonTagColor,
              //       suffixIconData: CupertinoIcons.chevron_right,
              //       text: 'View Log',
              //       onPressed: () => context.navigateTo(
              //           LoggedWorkoutDetailsRoute(id: score.loggedWorkoutId!))),
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
