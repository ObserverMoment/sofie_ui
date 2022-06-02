import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/creator/blocs/resistance_session_bloc.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class WorkoutSessionBloc {
  /// The main data that gets edited on the client by the user.
  late String workoutSessionId;

  /// Before every update we make a copy of the last workoutSession here.
  /// If there is an issue calling the api then this is reverted to.
  late Map<String, dynamic> _backup;

  final GraphQLStore _store = GetIt.I<GraphQLStore>();

  WorkoutSessionBloc(WorkoutSession initial) {
    workoutSessionId = initial.id;
    _backup = initial.toJson();
  }

  void _writeToStoreAndBackup(Map<String, dynamic> data) {
    _backup = data;
    _store.writeDataToStore(data: data, broadcastQueryIds: [
      GQLVarParamKeys.workoutSessionById(workoutSessionId),
      GQLOpNames.userWorkoutSessions,
    ]);
  }

  void updateWorkoutSession(Map<String, dynamic> data) async {
    final updated = WorkoutSession.fromJson({..._backup, ...data});

    final result = await _store.mutate(
        optimisticData: updated.toJson(),
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
        mutation: UpdateWorkoutSessionMutation(
            variables: UpdateWorkoutSessionArguments(
                data: UpdateWorkoutSessionInput.fromJson(updated.toJson()))));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _writeToStoreAndBackup(_backup);
    }, onSuccess: () {
      /// Update backup to reflect latest data.
      _backup = {..._backup, ...updated.toJson()};
    });
  }

  /////// Resistance Session ////////
  Future<void> createResistanceSession(
      {required Function(ResistanceSession created) onSuccess,
      required VoidCallback onFail}) async {
    final created = await ResistanceSessionBloc.createResistanceSession(
        workoutSessionId: workoutSessionId);

    if (created != null) {
      WorkoutSession updated = WorkoutSession.fromJson(_backup);
      updated.childrenOrder.add(created.id);
      updated.resistanceSessions.add(created);

      _writeToStoreAndBackup(updated.toJson());
      onSuccess(created);
    } else {
      onFail();
    }
  }

  Future<void> duplicateResistanceSession(
      {required ResistanceSession resistanceSession,
      required Function(ResistanceSession created) onSuccess,
      required VoidCallback onFail}) async {
    final duplicated = await ResistanceSessionBloc.duplicateResistanceSession(
        resistanceSession: resistanceSession);

    if (duplicated != null) {
      WorkoutSession updated = WorkoutSession.fromJson(_backup);

      /// Add new ID just after the duplicated session.
      final i = updated.childrenOrder.indexOf(resistanceSession.id);
      updated.childrenOrder.insert(i + 1, duplicated.id);

      updated.resistanceSessions.add(duplicated);

      _writeToStoreAndBackup(updated.toJson());
    } else {
      onFail();
    }
  }

  Future<void> deleteResistanceSession(
      {required ResistanceSession resistanceSession,
      required VoidCallback onFail}) async {
    final deletedId = await ResistanceSessionBloc.deleteResistanceSession(
        resistanceSession: resistanceSession);

    if (deletedId == resistanceSession.id) {
      WorkoutSession updated = WorkoutSession.fromJson(_backup);

      updated.childrenOrder.remove(deletedId);
      updated.resistanceSessions.removeWhere((s) => s.id == deletedId);

      _writeToStoreAndBackup(updated.toJson());
    } else {
      onFail();
    }
  }
}
