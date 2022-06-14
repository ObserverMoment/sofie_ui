import 'package:flutter/material.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

/// Note: Static methods called from higher level WorkoutWorkoutBloc ///
class ResistanceWorkoutBloc extends ChangeNotifier {
  /// The main data that gets edited on the client by the user.
  late ResistanceWorkout resistanceWorkout;

  late Map<String, dynamic> _backup;

  late List<String> _storeQueryIds;

  ResistanceWorkoutBloc(ResistanceWorkout initial) {
    resistanceWorkout = ResistanceWorkout.fromJson(initial.toJson());
    _backup = initial.toJson();
    _storeQueryIds = [
      GQLVarParamKeys.resistanceWorkoutById(resistanceWorkout.id),
      GQLOpNames.userResistanceWorkouts,
    ];
  }

  void _writeToStore(Map<String, dynamic> data) {
    GraphQLStore.store
        .writeDataToStore(data: data, broadcastQueryIds: _storeQueryIds);
  }

  void _revertToBackup() {
    resistanceWorkout = ResistanceWorkout.fromJson(_backup);
    _writeToStore(_backup);
    notifyListeners();
  }

  Future<void> updateResistanceWorkout(Map<String, dynamic> data) async {
    resistanceWorkout =
        ResistanceWorkout.fromJson({...resistanceWorkout.toJson(), ...data});

    /// Optimistic.
    notifyListeners();

    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: _storeQueryIds,
        mutation: UpdateResistanceWorkoutMutation(
            variables: UpdateResistanceWorkoutArguments(
                data: UpdateResistanceWorkoutInput.fromJson(
                    resistanceWorkout.toJson()))));

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
                  resistanceWorkout:
                      ConnectRelationInput(id: resistanceWorkout.id)))),
    );

    checkOperationResult(result, onFail: onFail, onSuccess: () {
      resistanceWorkout.resistanceExercises
          .add(result.data!.createResistanceExercise);

      GraphQLStore.store.writeDataToStore(
        data: resistanceWorkout.toJson(),
        broadcastQueryIds: _storeQueryIds,
      );

      _backup = resistanceWorkout.toJson();
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
      resistanceWorkout.resistanceExercises =
          result.data!.duplicateResistanceExercise;

      GraphQLStore.store.writeDataToStore(
        data: resistanceWorkout.toJson(),
        broadcastQueryIds: _storeQueryIds,
      );

      _backup = resistanceWorkout.toJson();
    });

    notifyListeners();
  }

  Future<void> updateResistanceExercise(
      String exerciseId, Map<String, dynamic> data) async {
    ResistanceExercise updateExercise = resistanceWorkout.resistanceExercises
        .firstWhere((e) => e.id == exerciseId);

    updateExercise =
        ResistanceExercise.fromJson({...updateExercise.toJson(), ...data});

    resistanceWorkout.resistanceExercises = resistanceWorkout
        .resistanceExercises
        .map((e) => e.id == exerciseId ? updateExercise : e)
        .toList();

    /// Optimistic.
    notifyListeners();

    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: _storeQueryIds,
        mutation: UpdateResistanceExerciseMutation(
            variables: UpdateResistanceExerciseArguments(
                data: UpdateResistanceExerciseInput.fromJson(
                    updateExercise.toJson()))));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      _backup = resistanceWorkout.toJson();
    });
  }

  /// No need for optimistic updates as [MyReorderableList] has its own local state which updates optimistically when items are reordered.
  Future<void> reorderResistanceExercise(
    String resistanceExerciseId,
    int moveTo,
  ) async {
    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: _storeQueryIds,
        mutation: ReorderResistanceExerciseMutation(
            variables: ReorderResistanceExerciseArguments(
                id: resistanceExerciseId, moveTo: moveTo)));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      resistanceWorkout.resistanceExercises =
          result.data!.reorderResistanceExercise;
      _backup = resistanceWorkout.toJson();
    });
    notifyListeners();
  }

  Future<void> deleteResistanceExercise(
    String resistanceExerciseId,
  ) async {
    resistanceWorkout.resistanceExercises
        .removeWhere((e) => e.id == resistanceExerciseId);

    notifyListeners();

    final result = await GraphQLStore.store.delete(
        typename: kResistanceExerciseTypeName,
        objectId: resistanceExerciseId,
        broadcastQueryIds: _storeQueryIds,
        mutation: DeleteResistanceExerciseMutation(
            variables:
                DeleteResistanceExerciseArguments(id: resistanceExerciseId)));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      _backup = resistanceWorkout.toJson();
    });

    notifyListeners();
  }

  ///////////////////////////////
  /////// ResistanceSet /////////
  ///////////////////////////////
  /// Add a ResistanceSet to an already existing ResistanceExercise ///
  Future<void> createResistanceSet(String exerciseId, Move move) async {
    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: _storeQueryIds,
        mutation: CreateResistanceSetMutation(
            variables: CreateResistanceSetArguments(
                data: CreateResistanceSetInput(
                    move: ConnectRelationInput(id: move.id),
                    resistanceExercise:
                        ConnectRelationInput(id: exerciseId)))));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      final newSet = result.data!.createResistanceSet;
      ResistanceExercise resistanceExercise = resistanceWorkout
          .resistanceExercises
          .firstWhere((e) => e.id == exerciseId);
      resistanceExercise.resistanceSets.add(newSet);
      _backup = resistanceWorkout.toJson();
    });

    notifyListeners();
  }

  Future<void> duplicateResistanceSet(
      String exerciseId, ResistanceSet resistanceSet) async {
    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: _storeQueryIds,
        mutation: DuplicateResistanceSetMutation(
            variables: DuplicateResistanceSetArguments(id: resistanceSet.id)));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      final updatedSets = result.data!.duplicateResistanceSet;
      ResistanceExercise resistanceExercise = resistanceWorkout
          .resistanceExercises
          .firstWhere((e) => e.id == exerciseId);

      resistanceExercise.resistanceSets = updatedSets;
      _backup = resistanceWorkout.toJson();
    });

    notifyListeners();
  }

  Future<void> updateResistanceSet(
      String exerciseId, String setId, Map<String, dynamic> data) async {
    ResistanceExercise resistanceExercise = resistanceWorkout
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
        broadcastQueryIds: _storeQueryIds,
        mutation: UpdateResistanceSetMutation(
            variables: UpdateResistanceSetArguments(
                data: UpdateResistanceSetInput.fromJson(updateSet.toJson()))));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      _backup = resistanceWorkout.toJson();
    });
  }

  /// No need for optimistic updates as [MyReorderableList] has its own local state which updates optimistically when items are reordered.
  Future<void> reorderResistanceSet(
    String resistanceExerciseId,
    String resistanceSetId,
    int moveTo,
  ) async {
    final result = await GraphQLStore.store.mutate(
        broadcastQueryIds: _storeQueryIds,
        mutation: ReorderResistanceSetMutation(
            variables: ReorderResistanceSetArguments(
                id: resistanceSetId, moveTo: moveTo)));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      resistanceWorkout.resistanceExercises
          .firstWhere((e) => e.id == resistanceExerciseId)
          .resistanceSets = result.data!.reorderResistanceSet;
      _backup = resistanceWorkout.toJson();
    });
    notifyListeners();
  }

  Future<void> deleteResistanceSet(
    String resistanceExerciseId,
    String resistanceSetId,
  ) async {
    resistanceWorkout.resistanceExercises
        .firstWhere((e) => e.id == resistanceExerciseId)
        .resistanceSets
        .removeWhere((e) => e.id == resistanceSetId);

    notifyListeners();

    final result = await GraphQLStore.store.delete(
        typename: kResistanceSetTypeName,
        objectId: resistanceSetId,
        broadcastQueryIds: _storeQueryIds,
        mutation: DeleteResistanceSetMutation(
            variables: DeleteResistanceSetArguments(id: resistanceSetId)));

    checkOperationResult(result, onFail: () {
      /// Revert to backup and rebroadcast.
      _revertToBackup();
    }, onSuccess: () {
      _backup = resistanceWorkout.toJson();
    });

    notifyListeners();
  }
}
