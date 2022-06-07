import 'package:flutter/material.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

/// Note: Static methods called from higher level WorkoutSessionBloc ///
class ResistanceSessionBloc extends ChangeNotifier {
  /// The main data that gets edited on the client by the user.
  late ResistanceSession resistanceSession;
  final String workoutSessionId;

  late Map<String, dynamic> _backup;

  ResistanceSessionBloc(
      {required ResistanceSession initial, required this.workoutSessionId}) {
    resistanceSession = ResistanceSession.fromJson(initial.toJson());
    _backup = initial.toJson();
  }

  void _writeToStore(Map<String, dynamic> data) {
    GraphQLStore.store.writeDataToStore(data: data, broadcastQueryIds: [
      GQLVarParamKeys.workoutSessionById(workoutSessionId),
      GQLOpNames.userWorkoutSessions,
    ]);
  }

  void _revertToBackup() {
    resistanceSession = ResistanceSession.fromJson(_backup);
    _writeToStore(_backup);
    notifyListeners();
  }

  static Future<ResistanceSession?> createResistanceSession(
      {required String workoutSessionId}) async {
    final result = await GraphQLStore.store.networkOnlyOperation(
        operation: CreateResistanceSessionMutation(
            variables: CreateResistanceSessionArguments(
                data: CreateResistanceSessionInput(
                    workoutSession:
                        ConnectRelationInput(id: workoutSessionId)))));

    return result.data?.createResistanceSession;
  }

  static Future<ResistanceSession?> duplicateResistanceSession({
    required ResistanceSession resistanceSession,
  }) async {
    final result = await GraphQLStore.store.networkOnlyOperation(
        operation: DuplicateResistanceSessionMutation(
            variables:
                DuplicateResistanceSessionArguments(id: resistanceSession.id)));

    return result.data?.duplicateResistanceSession;
  }

  static Future<String?> deleteResistanceSession({
    required ResistanceSession resistanceSession,
  }) async {
    final result = await GraphQLStore.store.networkOnlyOperation(
        operation: DeleteResistanceSessionMutation(
            variables:
                DeleteResistanceSessionArguments(id: resistanceSession.id)));

    return result.data?.deleteResistanceSession;
  }

  Future<void> updateResistanceSession(Map<String, dynamic> data) async {
    resistanceSession =
        ResistanceSession.fromJson({...resistanceSession.toJson(), ...data});

    /// Optimistic.
    notifyListeners();

    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
        mutation: UpdateResistanceSessionMutation(
            variables: UpdateResistanceSessionArguments(
                data: UpdateResistanceSessionInput.fromJson(
                    resistanceSession.toJson()))));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    });

    notifyListeners();
  }

  ////////////////////////////////////////
  //////// Resistance Exercise ///////////
  Future<void> createResistanceExercise(
      {required ResistanceExercise resistanceExercise,
      required VoidCallback onFail}) async {
    final result = await GraphQLStore.store.networkOnlyOperation(
      operation: CreateResistanceExerciseMutation(
          variables: CreateResistanceExerciseArguments(
              data: CreateResistanceExerciseInput(
                  resistanceSets: resistanceExercise.resistanceSets
                      .map((s) => CreateResistanceSetInExerciseInput(
                            reps: s.reps,
                            repType: s.repType,
                            equipment: s.equipment != null
                                ? ConnectRelationInput(id: s.equipment!.id)
                                : null,
                            move: ConnectRelationInput(id: s.move.id),
                          ))
                      .toList(),
                  resistanceSession:
                      ConnectRelationInput(id: resistanceSession.id)))),
    );

    checkOperationResult(result, onFail: onFail, onSuccess: () {
      resistanceSession.resistanceExercises
          .add(result.data!.createResistanceExercise);

      GraphQLStore.store.writeDataToStore(
        data: resistanceSession.toJson(),
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
      );

      _backup = resistanceSession.toJson();
    });

    notifyListeners();
  }

  Future<void> duplicateResistanceExercise(
      {required ResistanceExercise resistanceExercise,
      required VoidCallback onFail}) async {
    final result = await GraphQLStore.store.networkOnlyOperation(
      operation: DuplicateResistanceExerciseMutation(
          variables:
              DuplicateResistanceExerciseArguments(id: resistanceExercise.id)),
    );

    checkOperationResult(result, onFail: onFail, onSuccess: () {
      resistanceSession.resistanceExercises =
          result.data!.duplicateResistanceExercise;

      GraphQLStore.store.writeDataToStore(
        data: resistanceSession.toJson(),
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
      );

      _backup = resistanceSession.toJson();
    });

    notifyListeners();
  }

  Future<void> updateResistanceExercise(
      String exerciseId, Map<String, dynamic> data) async {
    ResistanceExercise updateExercise = resistanceSession.resistanceExercises
        .firstWhere((e) => e.id == exerciseId);

    updateExercise =
        ResistanceExercise.fromJson({...updateExercise.toJson(), ...data});

    resistanceSession.resistanceExercises = resistanceSession
        .resistanceExercises
        .map((e) => e.id == exerciseId ? updateExercise : e)
        .toList();

    /// Optimistic.
    notifyListeners();

    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
        mutation: UpdateResistanceExerciseMutation(
            variables: UpdateResistanceExerciseArguments(
                data: UpdateResistanceExerciseInput.fromJson(
                    updateExercise.toJson()))));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      _backup = resistanceSession.toJson();
    });
  }

  /// No need for optimistic updates as [MyReorderableList] has its own local state which updates optimistically when items are reordered.
  Future<void> reorderResistanceExercise(
    String resistanceExerciseId,
    int moveTo,
  ) async {
    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
        mutation: ReorderResistanceExerciseMutation(
            variables: ReorderResistanceExerciseArguments(
                id: resistanceExerciseId, moveTo: moveTo)));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      resistanceSession.resistanceExercises =
          result.data!.reorderResistanceExercise;
      _backup = resistanceSession.toJson();
    });
    notifyListeners();
  }

  Future<void> deleteResistanceExercise(
    String resistanceExerciseId,
  ) async {
    resistanceSession.resistanceExercises
        .removeWhere((e) => e.id == resistanceExerciseId);

    notifyListeners();

    final result = await GraphQLStore.store.delete(
        typename: kResistanceExerciseTypeName,
        objectId: resistanceExerciseId,
        removeAllRefsToId: true,
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
        mutation: DeleteResistanceExerciseMutation(
            variables:
                DeleteResistanceExerciseArguments(id: resistanceExerciseId)));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      _backup = resistanceSession.toJson();
    });

    notifyListeners();
  }

  ///////////////////////////////
  /////// ResistanceSet /////////
  ///////////////////////////////
  Future<void> updateResistanceSet(
      String exerciseId, String setId, Map<String, dynamic> data) async {
    ResistanceExercise resistanceExercise = resistanceSession
        .resistanceExercises
        .firstWhere((e) => e.id == exerciseId);

    ResistanceSet updateSet =
        resistanceExercise.resistanceSets.firstWhere((s) => s.id == setId);

    updateSet = ResistanceSet.fromJson({...updateSet.toJson(), ...data});

    resistanceExercise.resistanceSets = resistanceExercise.resistanceSets
        .map((s) => s.id == setId ? updateSet : s)
        .toList();

    /// Optimistic.
    notifyListeners();

    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
        mutation: UpdateResistanceSetMutation(
            variables: UpdateResistanceSetArguments(
                data: UpdateResistanceSetInput.fromJson(updateSet.toJson()))));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      _backup = resistanceSession.toJson();
    });
  }

  /// No need for optimistic updates as [MyReorderableList] has its own local state which updates optimistically when items are reordered.
  Future<void> reorderResistanceSet(
    String resistanceExerciseId,
    String resistanceSetId,
    int moveTo,
  ) async {
    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: [
          GQLVarParamKeys.workoutSessionById(workoutSessionId),
          GQLOpNames.userWorkoutSessions,
        ],
        mutation: ReorderResistanceSetMutation(
            variables: ReorderResistanceSetArguments(
                id: resistanceSetId, moveTo: moveTo)));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      resistanceSession.resistanceExercises
          .firstWhere((e) => e.id == resistanceExerciseId)
          .resistanceSets = result.data!.reorderResistanceSet;
      _backup = resistanceSession.toJson();
    });
    notifyListeners();
  }
}
