import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';

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
                loggedWorkouts: loggedWorkouts,
              ))
          .toList(),
    );
  }
}

class _FastestTimeExerciseDisplayWidget extends StatelessWidget {
  final UserFastestTimeExerciseTracker tracker;
  final List<LoggedWorkout> loggedWorkouts;
  const _FastestTimeExerciseDisplayWidget(
      {Key? key, required this.tracker, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MyText('Fastest Time'),
    );
  }
}
