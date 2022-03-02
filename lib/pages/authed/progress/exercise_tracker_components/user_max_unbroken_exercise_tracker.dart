import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';

class UserMaxUnbrokenExerciseTrackers extends StatelessWidget {
  final List<UserMaxUnbrokenExerciseTracker> trackers;
  final List<LoggedWorkout> loggedWorkouts;
  const UserMaxUnbrokenExerciseTrackers(
      {Key? key, required this.trackers, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
