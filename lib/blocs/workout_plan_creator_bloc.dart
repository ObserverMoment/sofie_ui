import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uuid/uuid.dart';

/// All updates to workout plan or descendants follow this pattern.
/// 1: Update local data
/// 2. Notify listeners so UI rebuilds optimistically
/// 3. Call API mutation (if not a create op).
/// 4. Check response is what was expected.
/// 5. If not then roll back local state changes and display error message.
/// 6: If ok then action is complete.
class WorkoutPlanCreatorBloc extends ChangeNotifier {
  final BuildContext context;

  /// The main data that gets edited on the client by the user.
  late WorkoutPlan workoutPlan;

  /// Before every update we make a copy of the last workout plan here.
  /// If there is an issue calling the api then this is reverted to.
  Map<String, dynamic> backupJson = {};

  WorkoutPlanCreatorBloc(this.context, WorkoutPlan initialWorkoutPlan) {
    workoutPlan = initialWorkoutPlan;
    backupJson = workoutPlan.toJson();
  }

  /// Send all new data to the graphql store and broadcast new data to streams.
  /// The api has been updating incrementally so does not need further update here.
  /// When updating data in this bloc we write to the bloc data and to the network only.
  /// This flow should be reviewed at some point.
  bool saveAllChanges() {
    final success = context.graphQLStore.writeDataToStore(
      data: workoutPlan.toJson(),
      broadcastQueryIds: [
        GQLVarParamKeys.workoutPlanByIdQuery(workoutPlan.id),
        GQLOpNames.userWorkoutPlansQuery
      ],
    );
    return success;
  }

  /// Helpers for write methods.
  /// Should run at the start of all CRUD ops.
  void _backup() {
    backupJson = workoutPlan.toJson();
  }

  void _revertChanges(List<Object>? errors) {
    // There was an error so revert to backup, notify listeners and show error toast.
    workoutPlan = WorkoutPlan.fromJson(backupJson);
    if (errors != null && errors.isNotEmpty) {
      for (final e in errors) {
        printLog(e.toString());
      }
    }
    context.showToast(
        message: 'There was a problem, changes not saved',
        toastType: ToastType.destructive);
  }

  bool _checkApiResult(MutationResult result) {
    if (result.hasErrors || result.data == null) {
      _revertChanges(result.errors);
      return false;
    } else {
      return true;
    }
  }

  /// Users should not be able to navigate away from the media page while this in in progress.
  /// Otherwise the upload will fail and throw an error.
  /// The top right 'done' button should also be disabled.
  bool uploadingMedia = false;
  void setUploadingMedia({required bool uploading}) {
    uploadingMedia = uploading;
    notifyListeners();
  }

  /// Makes a copy so that the UI (provider [select<>()] check) spots the updates.
  /// Data flow probably needs more thought.
  List<WorkoutPlanDay> _copyWorkoutPlanDays(int dayNumber) => workoutPlan
      .workoutPlanDays
      .map((d) =>
          d.dayNumber == dayNumber ? WorkoutPlanDay.fromJson(d.toJson()) : d)
      .toList();

  ///// WorkoutPlan CRUD /////
  ////////////////////////////
  Future<void> updateWorkoutPlanInfo(Map<String, dynamic> data) async {
    /// Client / Optimistic
    _backup();
    workoutPlan = WorkoutPlan.fromJson({...workoutPlan.toJson(), ...data});
    notifyListeners();

    /// Api
    final variables = UpdateWorkoutPlanArguments(
        data: UpdateWorkoutPlanInput.fromJson(
            {...workoutPlan.toJson(), ...data}));

    final result = await context.graphQLStore
        .mutate<UpdateWorkoutPlan$Mutation, UpdateWorkoutPlanArguments>(
            mutation: UpdateWorkoutPlanMutation(variables: variables),
            writeToStore: false);

    final success = _checkApiResult(result);

    if (success) {
      workoutPlan = WorkoutPlan.fromJson({
        ...workoutPlan.toJson(),
        ...result.data!.updateWorkoutPlan.toJson()
      });
    }

    notifyListeners();
  }

  /// When reducing we need to delete all of the WorkoutPlanDays that happen later than the time period that the user is reducing the plan to.
  Future<void> reduceWorkoutPlanlength(int lengthWeeks) async {
    /// Client / Optimistic
    _backup();
    workoutPlan = WorkoutPlan.fromJson(workoutPlan.toJson());
    workoutPlan.lengthWeeks = lengthWeeks;
    notifyListeners();

    /// API
    final idsToDelete = workoutPlan.workoutPlanDays
        .where((d) => d.dayNumber > (7 * lengthWeeks) - 1)
        .map((d) => d.id)
        .toList();

    final variables = DeleteWorkoutPlanDaysByIdArguments(ids: idsToDelete);

    final result = await context.graphQLStore.networkOnlyDelete<
            DeleteWorkoutPlanDaysById$Mutation,
            DeleteWorkoutPlanDaysByIdArguments>(
        mutation: DeleteWorkoutPlanDaysByIdMutation(variables: variables));

    final success = _checkApiResult(result);

    if (success) {
      final deletedIds = result.data!.deleteWorkoutPlanDaysById;
      // If the ids do not match then there was a problem - revert the changes.
      if (!const UnorderedIterableEquality().equals(idsToDelete, deletedIds)) {
        _revertChanges(result.errors);
        notifyListeners();
      }
    }
  }

  ///// WorkoutPlanDay CRUD /////
  ///////////////////////////////
  Future<void> createWorkoutPlanDayWithWorkout(
      int dayNumber, Workout workout) async {
    /// Client / Optimistic
    _backup();
    final tempWorkoutPlanDay = WorkoutPlanDay()
      ..id = const Uuid().v1()
      ..dayNumber = dayNumber
      ..workoutPlanDayWorkouts = [
        WorkoutPlanDayWorkout()
          ..id = const Uuid().v1()
          ..sortPosition = 0
          ..workout = workout
      ];

    workoutPlan.workoutPlanDays.add(tempWorkoutPlanDay);
    notifyListeners();

    /// Api.
    final variables = CreateWorkoutPlanDayWithWorkoutArguments(
        data: CreateWorkoutPlanDayWithWorkoutInput(
            dayNumber: dayNumber,
            workout: ConnectRelationInput(id: workout.id),
            workoutPlan: ConnectRelationInput(id: workoutPlan.id)));

    final result = await context.graphQLStore.mutate<
            CreateWorkoutPlanDayWithWorkout$Mutation,
            CreateWorkoutPlanDayWithWorkoutArguments>(
        mutation: CreateWorkoutPlanDayWithWorkoutMutation(variables: variables),
        writeToStore: false);

    final success = _checkApiResult(result);

    if (success) {
      workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
          .map((d) => d.id == tempWorkoutPlanDay.id
              ? result.data!.createWorkoutPlanDayWithWorkout
              : d)
          .toList();

      notifyListeners();
    }
  }

  Future<void> addNoteToWorkoutPlanDay(int dayNumber, String note) async {
    /// Client / Optimistic
    _backup();

    workoutPlan.workoutPlanDays = _copyWorkoutPlanDays(dayNumber);

    final dayToUpdate =
        workoutPlan.workoutPlanDays.firstWhere((d) => d.dayNumber == dayNumber);
    dayToUpdate.note = note;
    notifyListeners();

    /// Api
    final variables = UpdateWorkoutPlanDayArguments(
        data: UpdateWorkoutPlanDayInput(id: dayToUpdate.id));

    final result = await context.graphQLStore
        .mutate<UpdateWorkoutPlanDay$Mutation, UpdateWorkoutPlanDayArguments>(
            mutation: UpdateWorkoutPlanDayMutation(variables: variables),
            customVariablesMap: {
              'data': {'id': dayToUpdate.id, 'note': note}
            },
            writeToStore: false);

    final success = _checkApiResult(result);

    if (success) {
      workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
          .map((d) =>
              d.id == dayToUpdate.id ? result.data!.updateWorkoutPlanDay : d)
          .toList();

      notifyListeners();
    }
  }

  /// Moves it to another day by changing the dayNumber.
  Future<void> moveWorkoutPlanDay(int fromDayNumber, int toDayNumber) async {
    /// Client / Optimistic
    _backup();

    /// Check if there is content on the day we are moving to.
    if (workoutPlan.workoutPlanDays
            .firstWhereOrNull((d) => d.dayNumber == toDayNumber) !=
        null) {
      /// If there is then filter it out it.
      workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
          .where((d) => d.dayNumber != toDayNumber)
          .toList();
    }

    final dayToUpdate = WorkoutPlanDay.fromJson(workoutPlan.workoutPlanDays
        .firstWhere((d) => d.dayNumber == fromDayNumber)
        .toJson());
    dayToUpdate.dayNumber = toDayNumber;

    workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
        .map((d) => d.dayNumber == fromDayNumber ? dayToUpdate : d)
        .toList();

    notifyListeners();

    /// Api.
    final variables = MoveWorkoutPlanDayToAnotherDayArguments(
        data: MoveWorkoutPlanDayToAnotherDayInput(
            id: dayToUpdate.id, moveToDay: toDayNumber));

    final result = await context.graphQLStore.mutate<
            MoveWorkoutPlanDayToAnotherDay$Mutation,
            MoveWorkoutPlanDayToAnotherDayArguments>(
        mutation: MoveWorkoutPlanDayToAnotherDayMutation(variables: variables),
        writeToStore: false);

    final success = _checkApiResult(result);

    if (success) {
      workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
          .map((d) => d.id == dayToUpdate.id
              ? result.data!.moveWorkoutPlanDayToAnotherDay
              : d)
          .toList();

      notifyListeners();
    }
  }

  /// Copy contents that are at workoutPlanDay.dayNumber and add to another day.
  Future<void> copyWorkoutPlanDay(int fromDayNumber, int toDayNumber) async {
    /// Client / Optimistic
    _backup();

    /// Check if there is content on the day we are copying to.
    if (workoutPlan.workoutPlanDays
            .firstWhereOrNull((d) => d.dayNumber == toDayNumber) !=
        null) {
      /// If there is then filter it out it.
      workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
          .where((d) => d.dayNumber != toDayNumber)
          .toList();
    }

    final copyDayToMove = WorkoutPlanDay.fromJson(workoutPlan.workoutPlanDays
        .firstWhere((d) => d.dayNumber == fromDayNumber)
        .toJson());

    final originalIdToCopy = copyDayToMove.id;

    copyDayToMove.id = const Uuid().v1();
    copyDayToMove.dayNumber = toDayNumber;

    workoutPlan.workoutPlanDays = [
      ...workoutPlan.workoutPlanDays,
      copyDayToMove
    ];

    notifyListeners();

    /// Api.
    final variables = CopyWorkoutPlanDayToAnotherDayArguments(
        data: CopyWorkoutPlanDayToAnotherDayInput(
            id: originalIdToCopy, copyToDay: toDayNumber));

    final result = await context.graphQLStore.mutate<
            CopyWorkoutPlanDayToAnotherDay$Mutation,
            CopyWorkoutPlanDayToAnotherDayArguments>(
        mutation: CopyWorkoutPlanDayToAnotherDayMutation(variables: variables),
        writeToStore: false);

    final success = _checkApiResult(result);

    if (success) {
      workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
          .map((d) => d.id == copyDayToMove.id
              ? result.data!.copyWorkoutPlanDayToAnotherDay
              : d)
          .toList();

      notifyListeners();
    }
  }

  Future<void> deleteWorkoutPlanDay(int dayNumber) async {
    /// Client / Optimistic
    _backup();
    final dayToDelete =
        workoutPlan.workoutPlanDays.firstWhere((d) => d.dayNumber == dayNumber);

    workoutPlan.workoutPlanDays =
        workoutPlan.workoutPlanDays.where((d) => d != dayToDelete).toList();
    notifyListeners();

    /// Api
    /// As this resolver works via batch delete we cast to []
    /// Then do an unordered list equality check on the api result to check success.
    final idsToDelete = [dayToDelete.id];

    final variables = DeleteWorkoutPlanDaysByIdArguments(ids: idsToDelete);

    final result = await context.graphQLStore.networkOnlyDelete<
            DeleteWorkoutPlanDaysById$Mutation,
            DeleteWorkoutPlanDaysByIdArguments>(
        mutation: DeleteWorkoutPlanDaysByIdMutation(variables: variables));

    final success = _checkApiResult(result);

    if (success) {
      final deletedIds = result.data!.deleteWorkoutPlanDaysById;
      // If the ids do not match then there was a problem - revert the changes.
      if (!const UnorderedIterableEquality().equals(idsToDelete, deletedIds)) {
        _revertChanges(result.errors);
        notifyListeners();
      }
    }
  }

  ///// WorkoutPlanDayWorkout CRUD /////
  //////////////////////////////////////
  /// In an already created WorkoutPlanDay - specified by its day number in the plan.
  Future<void> createWorkoutPlanDayWorkout(
      int dayNumber, Workout workout) async {
    /// Client / Optimistic
    _backup();
    final dayToUpdate = WorkoutPlanDay.fromJson(workoutPlan.workoutPlanDays
        .firstWhere((d) => d.dayNumber == dayNumber)
        .toJson());

    final sortPosition = dayToUpdate.workoutPlanDayWorkouts.length;

    dayToUpdate.workoutPlanDayWorkouts.add(WorkoutPlanDayWorkout()
      ..id = const Uuid().v1()
      ..sortPosition = sortPosition
      ..workout = workout);

    workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
        .map((original) =>
            original.id == dayToUpdate.id ? dayToUpdate : original)
        .toList();

    notifyListeners();

    /// Api
    final variables = CreateWorkoutPlanDayWorkoutArguments(
        data: CreateWorkoutPlanDayWorkoutInput(
            sortPosition: sortPosition,
            workout: ConnectRelationInput(id: workout.id),
            workoutPlanDay: ConnectRelationInput(id: dayToUpdate.id)));

    final result = await context.graphQLStore.mutate<
            CreateWorkoutPlanDayWorkout$Mutation,
            CreateWorkoutPlanDayWorkoutArguments>(
        mutation: CreateWorkoutPlanDayWorkoutMutation(variables: variables),
        writeToStore: false);

    final success = _checkApiResult(result);

    if (success) {
      final updated = result.data!.createWorkoutPlanDayWorkout;

      dayToUpdate.workoutPlanDayWorkouts = dayToUpdate.workoutPlanDayWorkouts
          .map((original) => original.sortPosition == updated.sortPosition
              ? updated
              : original)
          .toList();

      workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
          .map((original) =>
              original.id == dayToUpdate.id ? dayToUpdate : original)
          .toList();

      notifyListeners();
    }
  }

  Future<void> addNoteToWorkoutPlanDayWorkout(int dayNumber, String note,
      WorkoutPlanDayWorkout workoutPlanDayWorkout) async {
    /// Client / Optimistic
    _backup();

    workoutPlan.workoutPlanDays = _copyWorkoutPlanDays(dayNumber);

    final dayToUpdate =
        workoutPlan.workoutPlanDays.firstWhere((d) => d.dayNumber == dayNumber);

    workoutPlanDayWorkout.note = note;

    notifyListeners();

    /// Api
    final idToUpdate = workoutPlanDayWorkout.id;
    final variables = UpdateWorkoutPlanDayWorkoutArguments(
        data: UpdateWorkoutPlanDayWorkoutInput(id: idToUpdate));

    final result = await context.graphQLStore.mutate<
            UpdateWorkoutPlanDayWorkout$Mutation,
            UpdateWorkoutPlanDayWorkoutArguments>(
        mutation: UpdateWorkoutPlanDayWorkoutMutation(variables: variables),
        customVariablesMap: {
          'data': {'id': idToUpdate, 'note': note}
        },
        writeToStore: false);

    final success = _checkApiResult(result);

    if (success) {
      final updated = result.data!.updateWorkoutPlanDayWorkout;
      dayToUpdate.workoutPlanDayWorkouts = dayToUpdate.workoutPlanDayWorkouts
          .map((w) => w.id == updated.id ? updated : w)
          .toList();

      notifyListeners();
    }
  }

  Future<void> reorderWorkoutPlanWorkoutsInDay(
      int dayNumber, int from, int to) async {
    /// Client / Optimistic
    _backup();

    workoutPlan.workoutPlanDays = _copyWorkoutPlanDays(dayNumber);

    final dayToUpdate =
        workoutPlan.workoutPlanDays.firstWhere((d) => d.dayNumber == dayNumber);

    final inTransit = dayToUpdate.workoutPlanDayWorkouts.removeAt(from);
    dayToUpdate.workoutPlanDayWorkouts.insert(to, inTransit);

    _updateWorkoutPlanDayWorkoutSortPositions(dayToUpdate);

    notifyListeners();

    /// Api
    final variables = ReorderWorkoutPlanDayWorkoutsArguments(
        data: dayToUpdate.workoutPlanDayWorkouts
            .map((sw) => UpdateSortPositionInput(
                id: sw.id, sortPosition: sw.sortPosition))
            .toList());

    final result = await context.graphQLStore.mutate<
            ReorderWorkoutPlanDayWorkouts$Mutation,
            ReorderWorkoutPlanDayWorkoutsArguments>(
        mutation: ReorderWorkoutPlanDayWorkoutsMutation(variables: variables),
        writeToStore: false);

    final success = _checkApiResult(result);

    if (success) {
      /// From the API - overwrite client side data to be certain you have latest correct data.
      final updatedPositions = result.data!.reorderWorkoutPlanDayWorkouts;

      /// Write new sort positions.
      for (final w in dayToUpdate.workoutPlanDayWorkouts) {
        w.sortPosition =
            updatedPositions.firstWhere((p) => p.id == w.id).sortPosition;
      }

      notifyListeners();
    }
  }

  Future<void> deleteWorkoutPlanDayWorkout(
      int dayNumber, WorkoutPlanDayWorkout workoutPlanDayWorkout) async {
    /// Client / Optimistic
    _backup();

    final dayToUpdate = WorkoutPlanDay.fromJson(workoutPlan.workoutPlanDays
        .firstWhere((d) => d.dayNumber == dayNumber)
        .toJson());

    dayToUpdate.workoutPlanDayWorkouts
        .removeWhere((w) => w == workoutPlanDayWorkout);

    workoutPlan.workoutPlanDays = workoutPlan.workoutPlanDays
        .map((d) => d.dayNumber == dayNumber ? dayToUpdate : d)
        .toList();

    _updateWorkoutPlanDayWorkoutSortPositions(dayToUpdate);
    notifyListeners();

    /// Api
    final variables =
        DeleteWorkoutPlanDayWorkoutByIdArguments(id: workoutPlanDayWorkout.id);

    final result = await context.graphQLStore.networkOnlyDelete<
            DeleteWorkoutPlanDayWorkoutById$Mutation,
            DeleteWorkoutPlanDayWorkoutByIdArguments>(
        mutation:
            DeleteWorkoutPlanDayWorkoutByIdMutation(variables: variables));

    final success = _checkApiResult(result);

    if (success) {
      final deletedId = result.data!.deleteWorkoutPlanDayWorkoutById;

      // If the ids do not match then there was a problem - revert the changes.
      if (workoutPlanDayWorkout.id != deletedId) {
        _revertChanges(result.errors);
        notifyListeners();
      }
    }
  }

  void _updateWorkoutPlanDayWorkoutSortPositions(
      WorkoutPlanDay workoutPlanDay) {
    workoutPlanDay.workoutPlanDayWorkouts
        .forEachIndexed((index, workoutPlanDayWorkout) {
      workoutPlanDayWorkout.sortPosition = index;
    });
  }
}
