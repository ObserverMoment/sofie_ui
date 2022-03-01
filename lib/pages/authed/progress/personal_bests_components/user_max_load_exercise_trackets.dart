import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';

class UserMaxLoadExerciseTrackers extends StatelessWidget {
  final List<UserMaxLoadExerciseTracker> trackers;
  final List<LoggedWorkout> loggedWorkouts;
  const UserMaxLoadExerciseTrackers(
      {Key? key, required this.trackers, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: trackers
          .map((t) => _MaxLoadExerciseDisplayWidget(
                tracker: t,
                loggedWorkouts: loggedWorkouts,
              ))
          .toList(),
    );
  }
}

class _MaxLoadExerciseDisplayWidget extends StatelessWidget {
  final UserMaxLoadExerciseTracker tracker;
  final List<LoggedWorkout> loggedWorkouts;
  const _MaxLoadExerciseDisplayWidget(
      {Key? key, required this.tracker, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MyText('max load'),
    );
  }
}
