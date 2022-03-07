import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/max_unbroken_trackers/user_max_unbroken_manual_entry_creator.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:supercharged/supercharged.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class UserMaxUnbrokenTrackerDetails extends StatelessWidget {
  final String trackerId;
  const UserMaxUnbrokenTrackerDetails({Key? key, required this.trackerId})
      : super(key: key);

  Future<void> _confirmDeleteTracker(
      BuildContext context, UserMaxUnbrokenExerciseTracker tracker) async {
    context.showConfirmDeleteDialog(
        message:
            'Deleting this tracker will also delete all manual entries that you have previously submitted. This cannot be undone. OK?',
        itemType: 'Score Tracker',
        onConfirm: () async {
          final result = await context.graphQLStore.delete(
              mutation: DeleteUserMaxUnbrokenExerciseTrackerMutation(
                  variables: DeleteUserMaxUnbrokenExerciseTrackerArguments(
                      id: tracker.id)),
              objectId: tracker.id,
              typename: kUserMaxUnbrokenExerciseTracker,
              removeRefFromQueries: [
                GQLOpNames.userMaxUnbrokenExerciseTrackers
              ]);

          checkOperationResult(context, result, onSuccess: context.pop);
        });
  }

  Future<void> _submitManualEntry(
      BuildContext context, UserMaxUnbrokenExerciseTracker tracker) async {
    context.push(
        child: UserMaxUnbrokenManualEntryCreator(
      parent: tracker,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final tracker =
        context.select<ExerciseTrackersBloc, UserMaxUnbrokenExerciseTracker?>(
            (b) => b.userMaxUnbrokenExerciseTrackers
                .firstWhereOrNull((t) => t.id == trackerId));

    /// It has probably been deleted so this page will pop shortly.
    if (tracker == null) {
      return Container();
    }

    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
        middle: TertiaryButton(
            prefixIconData: MyCustomIcons.medal,
            iconSize: 14,
            fontSize: FONTSIZE.three,
            onPressed: () => _submitManualEntry(context, tracker),
            text: 'Submit a Score'),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.trash,
              size: 20,
            ),
            onPressed: () => _confirmDeleteTracker(context, tracker)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          _ExerciseDefinition(
            tracker: tracker,
          ),
          const SizedBox(height: 14),
          if (tracker.manualEntries.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: MyText(
                  'No scores logged or submitted yet',
                  subtext: true,
                ),
              ),
            ),
          if (tracker.manualEntries.isNotEmpty)
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _MaxUnbrokensProgressGraph(
                    tracker: tracker,
                  ),
                  _TopTenScoresList(
                    tracker: tracker,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class _ExerciseDefinition extends StatelessWidget {
  final UserMaxUnbrokenExerciseTracker tracker;
  const _ExerciseDefinition({Key? key, required this.tracker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showLoad =
        (tracker.equipment != null && tracker.equipment!.loadAdjustable) ||
            tracker.move.requiredEquipments.any((e) => e.loadAdjustable);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        children: [
          MyHeaderText(
            tracker.move.name,
            weight: FontWeight.normal,
          ),
          const SizedBox(height: 6),
          if (tracker.equipment != null || showLoad)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (tracker.equipment != null)
                    MyHeaderText(
                      tracker.equipment!.name,
                      size: FONTSIZE.two,
                      weight: FontWeight.normal,
                    ),
                  if (tracker.equipment != null && showLoad)
                    const MyHeaderText(
                      ' - ',
                      size: FONTSIZE.two,
                      weight: FontWeight.normal,
                    ),
                  if (showLoad)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyHeaderText(
                          tracker.loadAmount.stringMyDouble(),
                          size: FONTSIZE.two,
                          weight: FontWeight.normal,
                        ),
                        const SizedBox(width: 4),
                        MyHeaderText(
                          tracker.loadUnit.display,
                          size: FONTSIZE.two,
                          weight: FontWeight.normal,
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MaxUnbrokensProgressGraph extends StatelessWidget {
  final UserMaxUnbrokenExerciseTracker tracker;
  const _MaxUnbrokensProgressGraph({Key? key, required this.tracker})
      : super(key: key);

  double get _yAxisPadPercentRange => 0.15;

  String _buildMarkerLabel(UserMaxUnbrokenTrackerManualEntry entry) {
    switch (tracker.repType) {
      case WorkoutMoveRepType.reps:
      case WorkoutMoveRepType.calories:
        return entry.score.toString();
      case WorkoutMoveRepType.time:
        return Duration(milliseconds: entry.score).compactDisplay;
      case WorkoutMoveRepType.distance:
        return '${entry.score} ${tracker.distanceUnit.shortDisplay.toUpperCase()}';

      default:
        throw Exception(
            'UserMaxUnbrokenTrackerDetails._MaxUnbrokensProgressGraph._buildMarkerLabel: No builder provided for ${tracker.repType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(color: context.theme.primary, fontSize: 10);
    final scores = tracker.manualEntries.map((e) => e.score);

    final minScore = scores.min() ?? 0.0;
    final maxScore = scores.max();

    /// Use this to add some padding to the numeric axis - based on a percantage of the range.
    final range = maxScore != null ? maxScore - minScore : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SfCartesianChart(
          enableAxisAnimation: false,
          plotAreaBorderWidth: 0,
          zoomPanBehavior: ZoomPanBehavior(
              zoomMode: ZoomMode.x,
              enablePanning: true,
              enablePinching: true,
              enableDoubleTapZooming: true),
          primaryYAxis: NumericAxis(
              rangePadding: ChartRangePadding.additional,
              isVisible: false,
              minimum: range != null
                  ? (minScore - range * _yAxisPadPercentRange)
                      .clamp(0.0, minScore)
                      .toDouble()
                  : minScore - 1000,
              maximum: (maxScore != null && range != null)
                  ? (maxScore + range * _yAxisPadPercentRange)
                  : null),
          primaryXAxis: DateTimeAxis(
              labelStyle: labelStyle,
              majorGridLines: const MajorGridLines(width: 0)),
          series: <ChartSeries>[
            LineSeries<UserMaxUnbrokenTrackerManualEntry, DateTime>(
              markerSettings: MarkerSettings(
                  width: 10,
                  height: 10,
                  isVisible: true,
                  color: context.theme.background),
              dataLabelMapper: (entry, _) => _buildMarkerLabel(entry),
              dataLabelSettings: DataLabelSettings(
                  margin: EdgeInsets.zero,
                  textStyle:
                      TextStyle(color: context.theme.primary, fontSize: 12),
                  isVisible: true),
              dataSource: tracker.manualEntries.sorted((a, b) {
                if (a.completedOn == b.completedOn) {
                  return a.score.compareTo(b.score);
                } else {
                  return a.completedOn.compareTo(b.completedOn);
                }
              }),
              xValueMapper: (e, _) => e.completedOn,
              yValueMapper: (e, _) => e.score,
              color: Styles.primaryAccent,
            )
          ]),
    );
  }
}

class _TopTenScoresList extends StatelessWidget {
  final UserMaxUnbrokenExerciseTracker tracker;
  const _TopTenScoresList({Key? key, required this.tracker}) : super(key: key);

  Future<void> _confirmDeleteManualEntry(
    BuildContext context,
    String entryId,
  ) async {
    final result = await context.graphQLStore.mutate(
        mutation: DeleteUserMaxUnbrokenTrackerManualEntryMutation(
            variables: DeleteUserMaxUnbrokenTrackerManualEntryArguments(
                entryId: entryId, parentId: tracker.id)),
        broadcastQueryIds: [GQLOpNames.userMaxUnbrokenExerciseTrackers]);

    checkOperationResult(context, result);
  }

  /// Very simlar / duplicated (diff font sizes) in [ExerciseDisplayWidget]
  Widget _buildScoreDisplay(UserMaxUnbrokenTrackerManualEntry entry) {
    switch (tracker.repType) {
      case WorkoutMoveRepType.reps:
      case WorkoutMoveRepType.calories:
        return Row(children: [
          MyText(
            entry.score.toString(),
            size: FONTSIZE.six,
            color: Styles.primaryAccent,
          ),
          const SizedBox(width: 6),
          MyText(
            tracker.repType.display.toUpperCase(),
            color: Styles.primaryAccent,
          ),
        ]);
      case WorkoutMoveRepType.time:
        return MyText(
          Duration(milliseconds: entry.score).compactDisplay,
          size: FONTSIZE.six,
          color: Styles.primaryAccent,
        );
      case WorkoutMoveRepType.distance:
        return Row(children: [
          MyText(
            entry.score.toString(),
            size: FONTSIZE.six,
            color: Styles.primaryAccent,
          ),
          const SizedBox(width: 6),
          MyText(
            tracker.distanceUnit.shortDisplay.toUpperCase(),
            color: Styles.primaryAccent,
          ),
        ]);
      default:
        throw Exception(
            'UserMaxUnbrokenTrackerDetails._TopTenScoresList._buildScoreDisplay: No builder provided for ${tracker.repType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final topTenScores =
        tracker.manualEntries.sortedBy<num>((e) => e.score).reversed.take(10);

    final buttonTagColor = context.theme.background.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Column(
        children: topTenScores
            .mapIndexed((i, e) => AnimatedSlidable(
                  index: i,
                  itemType: 'Max Unbroken Score',
                  key: Key(e.id),
                  removeItem: (int index) =>
                      _confirmDeleteManualEntry(context, e.id),
                  secondaryActions: const [],
                  child: Padding(
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
                              child: _buildScoreDisplay(e),
                            ),
                            const SizedBox(width: 8),
                            if (Utils.textNotNull(e.videoUri))
                              TertiaryButton(
                                  fontSize: FONTSIZE.one,
                                  iconSize: 14,
                                  backgroundColor: buttonTagColor,
                                  suffixIconData: CupertinoIcons.tv,
                                  text: 'View Video',
                                  onPressed: () => VideoSetupManager
                                      .openFullScreenVideoPlayer(
                                          context: context,
                                          videoUri: e.videoUri!)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MyText(
                              e.completedOn.compactDateString,
                              size: FONTSIZE.two,
                            ),
                            const SizedBox(height: 2),
                            MyText(
                              e.completedOn.timeString,
                              size: FONTSIZE.one,
                            ),
                          ],
                        )
                      ],
                    )),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
