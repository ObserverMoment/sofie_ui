import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';

class UserMaxUnbrokenExerciseTrackers extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const UserMaxUnbrokenExerciseTrackers(
      {Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trackers = context
        .select<ExerciseTrackersBloc, List<UserMaxUnbrokenExerciseTracker>>(
            (b) => b.userMaxUnbrokenExerciseTrackers);

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: trackers
          .map((t) => _MaxUnbrokenExerciseDisplayWidget(
                tracker: t,
                loggedWorkouts: loggedWorkouts,
              ))
          .toList(),
    );
  }
}

class _MaxUnbrokenExerciseDisplayWidget extends StatelessWidget {
  final UserMaxUnbrokenExerciseTracker tracker;
  final List<LoggedWorkout> loggedWorkouts;
  const _MaxUnbrokenExerciseDisplayWidget(
      {Key? key, required this.tracker, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MyText('Max unbroken'),
    );
  }
}
