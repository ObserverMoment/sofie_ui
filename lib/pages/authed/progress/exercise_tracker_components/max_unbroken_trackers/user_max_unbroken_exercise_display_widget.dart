import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/max_unbroken_trackers/user_max_unbroken_tracker_details.dart';
import 'package:sofie_ui/services/utils.dart';

class MaxUnbrokenExerciseDisplayWidget extends StatelessWidget {
  final UserMaxUnbrokenExerciseTracker tracker;
  const MaxUnbrokenExerciseDisplayWidget({Key? key, required this.tracker})
      : super(key: key);

  Widget _buildInfoHeader(String text) => MyHeaderText(
        text,
        size: FONTSIZE.two,
        lineHeight: 1.3,
        weight: FontWeight.normal,
        maxLines: 2,
        textAlign: TextAlign.center,
      );

  Widget _buildScoreDisplay(UserMaxUnbrokenTrackerManualEntry entry) {
    switch (tracker.repType) {
      case WorkoutMoveRepType.reps:
      case WorkoutMoveRepType.calories:
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          MyText(
            entry.score.toString(),
            size: FONTSIZE.eight,
            color: Styles.primaryAccent,
          ),
          const SizedBox(width: 2),
          MyText(
            tracker.repType.display.toLowerCase(),
            color: Styles.primaryAccent,
          ),
        ]);
      case WorkoutMoveRepType.time:
        return MyText(
          Duration(milliseconds: entry.score).compactDisplay,
          size: FONTSIZE.eight,
          color: Styles.primaryAccent,
        );
      case WorkoutMoveRepType.distance:
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          MyText(
            entry.score.toString(),
            size: FONTSIZE.eight,
            color: Styles.primaryAccent,
          ),
          const SizedBox(width: 2),
          MyText(
            tracker.distanceUnit.shortDisplay.toLowerCase(),
            color: Styles.primaryAccent,
          ),
        ]);
      default:
        throw Exception(
            'MaxUnbrokenExerciseDisplayWidget._buildScoreDisplay: No builder provided for ${tracker.repType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ExerciseTrackersBloc>();
    final highestScore = tracker.manualEntries.isNotEmpty
        ? tracker.manualEntries.sortedBy<num>((e) => e.score).last
        : null;

    final showLoad =
        (tracker.equipment != null && tracker.equipment!.loadAdjustable) ||
            tracker.move.requiredEquipments.any((e) => e.loadAdjustable);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(
          child: ChangeNotifierProvider<ExerciseTrackersBloc>.value(
        value: bloc,
        builder: (context, child) => UserMaxUnbrokenTrackerDetails(
          trackerId: tracker.id,
        ),
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
                if (Utils.textNotNull(tracker.equipment?.name))
                  _buildInfoHeader(
                    tracker.equipment!.name,
                  ),
                if (showLoad)
                  _buildInfoHeader(
                      '${tracker.loadAmount.stringMyDouble()} ${tracker.loadUnit.display}'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContentBox(
                  borderRadius: 26,
                  backgroundColor: context.theme.background.withOpacity(0.2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: highestScore != null
                      ? _buildScoreDisplay(highestScore)
                      : const MyText(
                          ' - ',
                          size: FONTSIZE.six,
                          color: Styles.primaryAccent,
                        ),
                ),
              ],
            ),
            Column(
              children: [
                _buildInfoHeader(
                  tracker.repType.display,
                ),
                _buildInfoHeader(
                  'Max Unbroken',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
