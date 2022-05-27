import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class WorkoutSessionCreatorBloc extends ChangeNotifier {
  /// The main data that gets edited on the client by the user.
  late WorkoutSession workoutSession;

  /// Before every update we make a copy of the last workoutSession here.
  /// If there is an issue calling the api then this is reverted to.
  late Map<String, dynamic> backupJson = {};

  WorkoutSessionCreatorBloc(WorkoutSession initial) {
    workoutSession = initial;
    backupJson = workoutSession.toJson();
  }
}
