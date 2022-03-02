import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/user_max_load_tracker_details.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/utils.dart';
import 'package:supercharged/supercharged.dart';

class UserMaxLoadExerciseTrackers extends StatelessWidget {
  final List<UserMaxLoadExerciseTracker> trackers;
  final List<LoggedWorkout> loggedWorkouts;
  const UserMaxLoadExerciseTrackers(
      {Key? key, required this.trackers, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MaxLoadScoreWithCompletedOnDate> allScoresFromLogHistory = [];

    for (final log in loggedWorkouts) {
      for (final lwSection in log.loggedWorkoutSections) {
        for (final lwSet in lwSection.loggedWorkoutSets) {
          /// Moves logged in LoadUnit bodyPercent or percentMax cannot be converted to a display in KG or LB. Only include KG and LB.
          allScoresFromLogHistory.addAll(lwSet.loggedWorkoutMoves
              .where((lwm) =>
                  lwm.loadUnit == LoadUnit.kg || lwm.loadUnit == LoadUnit.lb)
              .map((lwm) => MaxLoadScoreWithCompletedOnDate(
                  completedOn: log.completedOn,
                  loadAmount: lwm.loadAmount,
                  loadUnit: lwm.loadUnit,
                  equipment: lwm.equipment,
                  move: lwm.move,
                  reps: lwm.reps.round(),
                  loggedWorkoutId: log.id)));
        }
      }
    }

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: trackers
          .map((t) => _MaxLoadExerciseDisplayWidget(
                tracker: t,
                allScoresFromLogHistory: allScoresFromLogHistory,
              ))
          .toList(),
    );
  }
}

class _MaxLoadExerciseDisplayWidget extends StatelessWidget {
  final UserMaxLoadExerciseTracker tracker;
  final List<MaxLoadScoreWithCompletedOnDate> allScoresFromLogHistory;
  const _MaxLoadExerciseDisplayWidget(
      {Key? key, required this.tracker, required this.allScoresFromLogHistory})
      : super(key: key);

  Widget _buildInfoHeader(String text) => MyHeaderText(
        text,
        size: FONTSIZE.two,
        lineHeight: 1.3,
        weight: FontWeight.normal,
        maxLines: 2,
        textAlign: TextAlign.center,
      );

  @override
  Widget build(BuildContext context) {
    /// Get the matching scores - i.e. where move, equipment and reps match.
    /// Format all as [MaxLoadScoreWithCompletedOnDate]
    final matchingScoresFromHistory = allScoresFromLogHistory.where((score) {
      return tracker.move == score.move &&
          tracker.equipment == score.equipment &&
          tracker.reps <= score.reps;
    }).toList();

    /// Ensure all logs from history have been converted to the correct unit system.
    for (final score in matchingScoresFromHistory) {
      score.loadAmount = ExerciseTrackerUtils.convertToTrackerLoadUnit(
          loadAmount: score.loadAmount,
          targetUnit: tracker.loadUnit,
          loggedUnit: score.loadUnit);
      score.loadUnit = tracker.loadUnit;
    }

    final manualEntries = tracker.manualEntries
        .map((entry) => MaxLoadScoreWithCompletedOnDate(
              completedOn: entry.completedOn,
              equipment: tracker.equipment,
              loadAmount: entry.loadAmount,
              loadUnit: tracker.loadUnit,
              move: tracker.move,
              reps: tracker.reps,
              videoUri: entry.videoUri,
            ))
        .toList();

    final allScores = [...matchingScoresFromHistory, ...manualEntries];

    final repString = tracker.reps == 1 ? 'rep' : 'reps';

    final double? largestLoad =
        allScores.map((score) => score.loadAmount).max();

    final topScoreString =
        largestLoad != null ? largestLoad.stringMyDouble() : ' - ';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(
          child: UserMaxLoadTrackerDetails(
        scores: allScores,
        tracker: tracker,
      )),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                _buildInfoHeader(
                  tracker.move.name,
                ),
                _buildInfoHeader(
                  tracker.equipment?.name ?? '',
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          topScoreString,
                          color: Styles.primaryAccent,
                          size: FONTSIZE.seven,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(width: 2),
                        MyText(
                          tracker.loadUnit.display,
                          color: Styles.primaryAccent,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _buildInfoHeader(
                  '${tracker.reps} $repString',
                ),
                _buildInfoHeader(
                  'Max Lift',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MaxLoadScoreWithCompletedOnDate
    implements Comparable<MaxLoadScoreWithCompletedOnDate> {
  DateTime completedOn;
  double loadAmount;
  LoadUnit loadUnit;
  Move move;
  Equipment? equipment;
  int reps;
  String? videoUri;
  String? videoThumbUri;
  String? loggedWorkoutId;
  MaxLoadScoreWithCompletedOnDate({
    required this.move,
    required this.equipment,
    required this.loadAmount,
    required this.completedOn,
    required this.loadUnit,
    required this.reps,
    this.loggedWorkoutId,
    this.videoUri,
  });

  @override
  int compareTo(MaxLoadScoreWithCompletedOnDate other) {
    if (loadAmount != other.loadAmount) {
      return loadAmount.compareTo(other.loadAmount);
    } else {
      return completedOn.compareTo(other.completedOn);
    }
  }
}
