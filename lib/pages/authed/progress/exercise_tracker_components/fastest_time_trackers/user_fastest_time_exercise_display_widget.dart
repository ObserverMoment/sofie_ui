import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/fastest_time_trackers/user_fastest_time_tracker_details.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:supercharged/supercharged.dart';

class FastestTimeExerciseDisplayWidget extends StatelessWidget {
  final UserFastestTimeExerciseTracker tracker;
  const FastestTimeExerciseDisplayWidget({Key? key, required this.tracker})
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
    final bloc = context.read<ExerciseTrackersBloc>();
    final scores = tracker.manualEntries;

    final int? fastestTimeTakenMs = scores.map((s) => s.timeTakenMs).min();

    final duration = fastestTimeTakenMs != null
        ? Duration(milliseconds: fastestTimeTakenMs)
        : null;

    final showLoad =
        (tracker.equipment != null && tracker.equipment!.loadAdjustable) ||
            tracker.move.requiredEquipments.any((e) => e.loadAdjustable);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(
          child: ChangeNotifierProvider<ExerciseTrackersBloc>.value(
        value: bloc,
        builder: (context, child) => UserFastestTimeTrackerDetails(
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
                  child: CompactTimerIcon(
                    duration: duration,
                    iconSize: 26,
                    fontSize: FONTSIZE.seven,
                    color: Styles.primaryAccent,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _buildInfoHeader(
                  '${tracker.reps.stringMyDouble()} ${tracker.repType.display}',
                ),
                _buildInfoHeader(
                  'Fastest Time',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
