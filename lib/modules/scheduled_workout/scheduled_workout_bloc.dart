import 'package:flutter/material.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ScheduledWorkoutBloc extends ChangeNotifier {
  final List<ScheduledWorkout> scheduled = [];

  ScheduledWorkoutBloc();
}
