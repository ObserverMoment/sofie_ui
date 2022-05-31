import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class WorkoutSessionCreatorBloc extends ChangeNotifier {
  /// The main data that gets edited on the client by the user.
  late String workoutSessionId;

  /// User can revert to this if they want to void all changes.
  late Map<String, dynamic> original;

  /// Before every update we make a copy of the last workoutSession here.
  /// If there is an issue calling the api then this is reverted to.
  late Map<String, dynamic> backup;

  final GraphQLStore _store = GetIt.I<GraphQLStore>();

  WorkoutSessionCreatorBloc(WorkoutSession initial) {
    workoutSessionId = initial.id;
    original = initial.toJson();
    backup = initial.toJson();
  }

  void updateWorkoutSession(Map<String, dynamic> data) async {
    final updated = WorkoutSession.fromJson({...backup, ...data});

    final result = await _store.mutate(
        customVariablesMap: {
          'data': {'id': workoutSessionId, ...data}
        },
        optimisticData: updated.toJson(),
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
        mutation: UpdateWorkoutSessionMutation(
            variables: UpdateWorkoutSessionArguments(
                data: UpdateWorkoutSessionInput(id: workoutSessionId))));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _store.writeDataToStore(data: backup, broadcastQueryIds: [
        GQLVarParamKeys.workoutSessionById(workoutSessionId),
        GQLOpNames.userWorkoutSessions,
      ]);
    }, onSuccess: () {
      /// Update backup to reflect latest data.
      backup = {...backup, ...updated.toJson()};
    });
  }
}
