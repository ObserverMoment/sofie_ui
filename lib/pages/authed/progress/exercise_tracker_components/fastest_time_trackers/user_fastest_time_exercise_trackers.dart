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
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/fastest_time_trackers/user_fastest_time_tracker_details.dart';

class UserFastestTimeExerciseTrackers extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const UserFastestTimeExerciseTrackers(
      {Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trackers = context
        .select<ExerciseTrackersBloc, List<UserFastestTimeExerciseTracker>>(
            (b) => b.userFastestTimeExerciseTrackers);

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: trackers
          .map((t) => _FastestTimeExerciseDisplayWidget(
                tracker: t,
              ))
          .toList(),
    );
  }
}

class _FastestTimeExerciseDisplayWidget extends StatelessWidget {
  final UserFastestTimeExerciseTracker tracker;
  const _FastestTimeExerciseDisplayWidget({Key? key, required this.tracker})
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
    final trackerRelevantScores = [];

    /// TODO.

    final repString = tracker.reps == 1 ? 'rep' : 'reps';

    final double? fastestTime = 0;

    /// TODO

    final fastestTimeString =
        fastestTime != null ? fastestTime.stringMyDouble() : ' - ';

    return MyText('Hello');

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
                          fastestTimeString,
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
