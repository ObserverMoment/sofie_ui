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
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/max_load_tracker/user_max_load_tracker_details.dart';
import 'package:supercharged/supercharged.dart';

class UserMaxLoadExerciseTrackers extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const UserMaxLoadExerciseTrackers({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trackers =
        context.select<ExerciseTrackersBloc, List<UserMaxLoadExerciseTracker>>(
            (b) => b.userMaxLoadExerciseTrackers);

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
              ))
          .toList(),
    );
  }
}

class _MaxLoadExerciseDisplayWidget extends StatelessWidget {
  final UserMaxLoadExerciseTracker tracker;
  const _MaxLoadExerciseDisplayWidget({Key? key, required this.tracker})
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
    final trackerRelevantScores =
        bloc.retrieveMaxLoadTrackerRelevantScores(tracker);

    final repString = tracker.reps == 1 ? 'rep' : 'reps';

    final double? largestLoad =
        trackerRelevantScores.map((score) => score.loadAmount).max();

    final topScoreString =
        largestLoad != null ? largestLoad.stringMyDouble() : ' - ';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(
          child: ChangeNotifierProvider<ExerciseTrackersBloc>.value(
        value: bloc,
        builder: (context, child) => UserMaxLoadTrackerDetails(
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
