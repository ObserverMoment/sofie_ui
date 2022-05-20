import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uuid/uuid.dart';

/// Specify to update either all set.durations of sets of the specified type.
/// Rest set is a set with one workoutMove in it where that move is a Rest.
enum DurationUpdateType { sets, rests }

class WorkoutCreatorBloc extends ChangeNotifier {
  final BuildContext context;

  /// The main data that gets edited on the client by the user.
  late Workout workout;

  /// Before every update we make a copy of the last workout here.
  /// If there is an issue calling the api then this is reverted to.
  late Map<String, dynamic> backupJson = {};

  WorkoutCreatorBloc(this.context, Workout initialWorkout) {
    workout = initialWorkout.copyAndSortAllChildren;
    backupJson = workout.toJson();
  }

  /// Use when creating new objects which have to wait for network responses before updating the UI with their presence.
  bool creatingSection = false;
  bool creatingSet = false;
  bool creatingMove = false;

  /// Send all new data to the graphql store which will broadcast new data to streams.
  /// The api has been updating incrementally so does not need further update here.
  /// When updating data in this bloc we write to the bloc data and to the network only.
  /// Not to the client store. This is for two reasons.
  /// 1. Sections, sets and workoutMoves do not get normalized in the store. The object of normalization is the workout. The data returned from a network update on a section or set, for example, does not contain the necessary data for it to be normalized into the store. I.e it would need to be returned within the full workout object.
  /// 2. Witholding these store updates means that you get some optimisation in that UI in that the background stack is not being updated every time a small update is made by the user.
  /// Store gets written and the UI gets updated when the user clicks [done].
  /// This flow should be reviewed at some point.
  bool saveAllChanges() {
    final writeWorkoutSuccess = context.graphQLStore.writeDataToStore(
      data: workout.toJson(),
      broadcastQueryIds: [
        GQLVarParamKeys.workoutById(workout.id),
      ],
    );

    if (writeWorkoutSuccess) {
      final success = context.graphQLStore.writeDataToStore(
        data: workout.summary.toJson(),
        broadcastQueryIds: [
          GQLOpNames.userScheduledWorkouts,
          GQLOpNames.userWorkouts,
          GQLOpNames.userCollections,
          GQLOpNames.userClubs
        ],
      );
      return success;
    }

    return false;
  }

  /// Helpers for write methods.
  /// Should run at the start of all CRUD ops.
  void _backup() {
    backupJson = workout.toJson();
  }

  void _revertChanges(List<Object>? errors) {
    // There was an error so revert to backup, notify listeners and show error toast.
    workout = Workout.fromJson(backupJson);
    if (errors != null && errors.isNotEmpty) {
      for (final e in errors) {
        printLog(e.toString());
      }
    }
    context.showToast(
        message: 'There was a problem, changes not saved',
        toastType: ToastType.destructive);
  }

  bool _checkApiResult(OperationResult result) {
    if (result.hasErrors || result.data == null) {
      _revertChanges(result.errors);
      return false;
    } else {
      return true;
    }
  }

  /// The user can minimize how sets are displayed (for easy re-ordering or overviewing).
  /// They can minimize whole sections or just one set at a time.
  List<String> displayMinimizedSetIds = [];

  /// Using [sectionIndex] as this is being called from [set] level and the set creator widget does not have the section ID.
  void toggleMinimizeSetInfo(String setId) {
    displayMinimizedSetIds = displayMinimizedSetIds.toggleItem<String>(setId);
    notifyListeners();
  }

  /// Users should not be able to navigate away from the media page while this in in progress.
  /// Otherwise the upload will fail and throw an error.
  /// The top right 'done' button should also be disabled.
  bool uploadingMedia = false;
  void setUploadingMedia({required bool uploading}) {
    uploadingMedia = uploading;
    notifyListeners();
  }

  Future<void> updateWorkoutInfo(Map<String, dynamic> data) async {
    /// Client / Optimistic
    _backup();
    workout = Workout.fromJson({...workout.toJson(), ...data});
    notifyListeners();

    /// Api
    final variables = UpdateWorkoutArguments(
        data: UpdateWorkoutInput.fromJson(workout.toJson()));

    final result = await context.graphQLStore
        .networkOnlyOperation<UpdateWorkout$Mutation, UpdateWorkoutArguments>(
      operation: UpdateWorkoutMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      workout = Workout.fromJson(
          {...workout.toJson(), ...result.data!.updateWorkout.toJson()});
    }

    notifyListeners();
  }

  ////// WorkoutSection CRUD //////
  Future<void> createWorkoutSection(WorkoutSection workoutSection) async {
    _backup();
    creatingSection = true;
    notifyListeners();

    /// New sections go in last position by default.
    final nextIndex = workout.workoutSections.length;

    /// Api only for creates.
    final variables = CreateWorkoutSectionArguments(
        data: CreateWorkoutSectionInput(
            sortPosition: nextIndex,
            name: workoutSection.name,
            timecap: workoutSection.timecap,
            workout: ConnectRelationInput(id: workout.id),
            workoutSectionType: ConnectRelationInput(
                id: workoutSection.workoutSectionType.id)));

    final result = await context.graphQLStore.networkOnlyOperation<
        CreateWorkoutSection$Mutation, CreateWorkoutSectionArguments>(
      operation: CreateWorkoutSectionMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      workout.workoutSections.add(
          WorkoutSection.fromJson(result.data!.createWorkoutSection.toJson()));
    }

    creatingSection = false;
    notifyListeners();
  }

  Future<void> updateWorkoutSection(
      int index, Map<String, dynamic> data) async {
    /// Client
    _backup();
    final updatedWorkoutSection = WorkoutSection.fromJson(
        {...workout.workoutSections[index].toJson(), ...data});

    workout.workoutSections[index] = WorkoutSection.fromJson(
        {...workout.workoutSections[index].toJson(), ...data});

    notifyListeners();

    /// Api
    final variables = UpdateWorkoutSectionArguments(
        data:
            UpdateWorkoutSectionInput.fromJson(updatedWorkoutSection.toJson()));

    final result = await context.graphQLStore.networkOnlyOperation<
        UpdateWorkoutSection$Mutation, UpdateWorkoutSectionArguments>(
      operation: UpdateWorkoutSectionMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      workout.workoutSections[index] = WorkoutSection.fromJson({
        ...updatedWorkoutSection.toJson(),
        ...result.data!.updateWorkoutSection.toJson()
      });
    }

    notifyListeners();
  }

  Future<void> reorderWorkoutSections(int from, int to) async {
    // Check that user is not trying to move beyond the bounds of the list.
    if (to >= 0 && to < workout.workoutSections.length) {
      _backup();

      /// Client.
      final inTransit = workout.workoutSections.removeAt(from);

      workout.workoutSections.insert(to, inTransit);

      _updateWorkoutSectionsSortPosition(workout.workoutSections);

      notifyListeners();

      /// Api.
      final variables = ReorderWorkoutSectionsArguments(
          data: workout.workoutSections
              .map((s) => UpdateSortPositionInput(
                  id: s.id, sortPosition: s.sortPosition))
              .toList());

      final result = await context.graphQLStore.networkOnlyOperation<
          ReorderWorkoutSections$Mutation, ReorderWorkoutSectionsArguments>(
        operation: ReorderWorkoutSectionsMutation(variables: variables),
      );

      final success = _checkApiResult(result);

      if (success) {
        final positions = result.data!.reorderWorkoutSections;

        /// Write new sort positions.
        for (final ws in workout.workoutSections) {
          ws.sortPosition =
              positions.firstWhere((p) => p.id == ws.id).sortPosition;
        }
      }

      notifyListeners();
    }
  }

  Future<void> deleteWorkoutSection(int sectionIndex) async {
    _backup();

    final idToDelete = workout.workoutSections[sectionIndex].id;

    /// Client
    workout.workoutSections.removeAt(sectionIndex);

    _updateWorkoutSectionsSortPosition(workout.workoutSections);

    notifyListeners();

    /// Api.
    final variables = DeleteWorkoutSectionByIdArguments(id: idToDelete);

    final result = await context.graphQLStore.networkOnlyOperation<
            DeleteWorkoutSectionById$Mutation,
            DeleteWorkoutSectionByIdArguments>(
        operation: DeleteWorkoutSectionByIdMutation(variables: variables));

    final success = _checkApiResult(result);

    if (success) {
      final deletedId = result.data!.deleteWorkoutSectionById;

      // If the ids do not match then there was a problem - revert the changes.
      if (idToDelete != deletedId) {
        _revertChanges(result.errors);
        notifyListeners();
      }
    }
  }

  /// Internal: Client
  void _updateWorkoutSectionsSortPosition(
      List<WorkoutSection> workoutSections) {
    workoutSections.forEachIndexed((i, workoutSection) {
      workoutSection.sortPosition = i;
    });
  }

  ////// WorkoutSet CRUD //////
  /// [defaults] used to create sets for certain workoutsection types.
  /// E.g a set for a HIIT circuit with a pre filled [duration] field which matches what the user has inputted previously. Or a 20 second timed set if it is a tabata.
  /// [shouldNotifyListeners]: Set this to false when creating a new set. Flow is:
  /// 1. User selects a workoutMove (but not created in the DB).
  /// 2. A new set is created (don't notify listeners)
  /// 3. The new workoutMove is created and added to the set (notify listeners)
  /// A workoutMove must be created within a set - so we need to create the set first. The above flow hides this from the user and makes it seem like they are just doing one action - i.e. selecting a workoutMove.
  Future<WorkoutSet?> createWorkoutSetWithWorkoutMoves(
      int sectionIndex, WorkoutSet workoutSet) async {
    _backup();
    creatingSet = true;
    notifyListeners();

    final parentSection = workout.workoutSections[sectionIndex];
    final newSetSortPosition = parentSection.workoutSets.length;

    /// Api only for create ops.
    final variables = CreateWorkoutSetWithWorkoutMovesArguments(
        data: CreateWorkoutSetWithWorkoutMovesInput(
      workoutSet: CreateWorkoutSetInput(
          duration: workoutSet.duration,
          workoutSection: ConnectRelationInput(id: parentSection.id),
          sortPosition: newSetSortPosition),
      workoutMoves: workoutSet.workoutMoves
          .map((wm) => CreateWorkoutMoveInSetInput(
                sortPosition: wm.sortPosition,
                reps: wm.reps,
                repType: wm.repType,
                loadAmount: wm.loadAmount,
                loadUnit: wm.loadUnit,
                timeUnit: wm.timeUnit,
                equipment: wm.equipment != null
                    ? ConnectRelationInput(id: wm.equipment!.id)
                    : null,
                distanceUnit: wm.distanceUnit,
                move: ConnectRelationInput(id: wm.move.id),
              ))
          .toList(),
    ));

    final result = await context.graphQLStore.networkOnlyOperation<
        CreateWorkoutSetWithWorkoutMoves$Mutation,
        CreateWorkoutSetWithWorkoutMovesArguments>(
      operation: CreateWorkoutSetWithWorkoutMovesMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    WorkoutSet? newCreatedSet;

    if (success) {
      newCreatedSet = WorkoutSet.fromJson(
          {...result.data!.createWorkoutSetWithWorkoutMoves.toJson()});

      workout.workoutSections[sectionIndex].workoutSets.add(newCreatedSet);
    }

    creatingSet = false;
    notifyListeners();

    return newCreatedSet;
  }

  Future<WorkoutSet?> createWorkoutSet(int sectionIndex,
      {int? duration, bool shouldNotifyListeners = true}) async {
    _backup();
    creatingSet = true;

    /// We notify listeners here even if [shouldNotifyListeners] is false.
    /// So that the loading indicators display.
    notifyListeners();

    final parentSection = workout.workoutSections[sectionIndex];
    final newSetSortPosition = parentSection.workoutSets.length;

    /// Api only for create.
    final variables = CreateWorkoutSetArguments(
        data: CreateWorkoutSetInput(
      sortPosition: newSetSortPosition,
      duration: duration,
      workoutSection: ConnectRelationInput(id: parentSection.id),
    ));

    final result = await context.graphQLStore.networkOnlyOperation<
        CreateWorkoutSet$Mutation, CreateWorkoutSetArguments>(
      operation: CreateWorkoutSetMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    WorkoutSet? newCreatedSet;

    if (success) {
      newCreatedSet = WorkoutSet.fromJson(
          {...result.data!.createWorkoutSet.toJson(), 'WorkoutMoves': []});

      workout.workoutSections[sectionIndex].workoutSets.add(newCreatedSet);
    }

    creatingSet = false;
    if (shouldNotifyListeners) {
      notifyListeners();
    }

    return newCreatedSet;
  }

  Future<void> editWorkoutSet(
      int sectionIndex, int setIndex, Map<String, dynamic> data) async {
    _backup();

    /// Client.
    final oldWorkoutSet =
        workout.workoutSections[sectionIndex].workoutSets[setIndex];
    final updatedWorkoutSet =
        WorkoutSet.fromJson({...oldWorkoutSet.toJson(), ...data});

    workout.workoutSections[sectionIndex].workoutSets[setIndex] =
        updatedWorkoutSet;
    notifyListeners();

    /// Api.
    final variables = UpdateWorkoutSetArguments(
        data: UpdateWorkoutSetInput.fromJson(updatedWorkoutSet.toJson()));

    final result = await context.graphQLStore.networkOnlyOperation<
        UpdateWorkoutSet$Mutation, UpdateWorkoutSetArguments>(
      operation: UpdateWorkoutSetMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      workout.workoutSections[sectionIndex].workoutSets[setIndex] =
          WorkoutSet.fromJson({
        ...updatedWorkoutSet.toJson(),
        ...result.data!.updateWorkoutSet.toJson(),
      });
    }

    notifyListeners();
  }

  /// Will call editSet on all sets one after another in series to perform this update.
  /// May be a bit slow. Update this once there is a batch update API resolver for sets.
  void updateAllSetDurations(
      int sectionIndex, int duration, DurationUpdateType type) {
    _backup();

    final List<WorkoutSet> workoutSets =
        workout.workoutSections[sectionIndex].workoutSets;

    workoutSets.forEachIndexed((i, w) {
      if (type == DurationUpdateType.sets && !w.isRestSet ||
          type == DurationUpdateType.rests && w.isRestSet) {
        editWorkoutSet(sectionIndex, i, {'duration': duration});
      }
    });
  }

  Future<void> duplicateWorkoutSet(int sectionIndex, int setIndex) async {
    _backup();

    final workoutSets = workout.workoutSections[sectionIndex].workoutSets;
    final toDuplicate = workoutSets[setIndex];

    /// Client.
    workoutSets.insert(
        setIndex + 1,
        WorkoutSet.fromJson({
          ...toDuplicate.toJson(),
          'id': 'temp-${const Uuid().v1()}',
        }));

    _updateWorkoutSetsSortPosition(workoutSets);

    notifyListeners();

    /// Api
    final variables = DuplicateWorkoutSetByIdArguments(id: toDuplicate.id);

    final result = await context.graphQLStore.networkOnlyOperation<
        DuplicateWorkoutSetById$Mutation, DuplicateWorkoutSetByIdArguments>(
      operation: DuplicateWorkoutSetByIdMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      final updated = result.data!.duplicateWorkoutSetById;
      // Write over the client write above.
      workoutSets[setIndex + 1] = WorkoutSet()
        ..$$typename = updated.$$typename
        ..id = updated.id
        ..sortPosition = updated.sortPosition
        ..duration = updated.duration
        ..workoutMoves =
            updated.workoutMoves.sortedBy<num>((wm) => wm.sortPosition);
    }

    notifyListeners();
  }

  /// For generating ladders and pyramids.
  /// The original set will be written over with the set created by the first int in the repSequence. For each int in repSequence a new set will be created, where all of its moves will have their reps adjusted.
  Future<void> createSetSequence(
      int sectionIndex, int originalsetIndex, List<int> repSequence) async {
    context.showToast(
        icon: const Icon(CupertinoIcons.triangle_righthalf_fill),
        message: 'Generating Pyramid');

    /// 1. run duplicate set [repSequence.length - 1] times
    final dupes = List.generate(repSequence.length - 1, (i) => i);

    /// Run these in series to ensure correct set is always being duplicated.
    await Future.forEach(
        dupes, (_) => duplicateWorkoutSet(sectionIndex, originalsetIndex));

    /// 2. New sets are from originalSetIndex to originalSetIndex + repSequence.length - 1. For each
    final workoutSection = workout.workoutSections[sectionIndex];

    final updates = List.generate(repSequence.length, (i) => i);

    for (final i in updates) {
      final workoutSet = workoutSection.workoutSets[originalsetIndex + i];
      final workoutMoves = workoutSet.workoutMoves;

      for (final wm in workoutMoves) {
        wm.reps = repSequence[i].toDouble();
        editWorkoutMove(sectionIndex, workoutSet.sortPosition, wm);
      }
    }
  }

  Future<void> reorderWorkoutSets(int sectionIndex, int from, int to) async {
    // Check that user is not trying to move beyond the bounds of the list.
    if (to >= 0 &&
        to < workout.workoutSections[sectionIndex].workoutSets.length) {
      _backup();

      /// Client.
      final workoutSets = workout.workoutSections[sectionIndex].workoutSets;

      final inTransit = workoutSets.removeAt(from);
      workoutSets.insert(to, inTransit);

      _updateWorkoutSetsSortPosition(workoutSets);

      notifyListeners();

      /// Api.
      final variables = ReorderWorkoutSetsArguments(
          data: workoutSets
              .map((s) => UpdateSortPositionInput(
                  id: s.id, sortPosition: s.sortPosition))
              .toList());

      final result = await context.graphQLStore.networkOnlyOperation<
          ReorderWorkoutSets$Mutation, ReorderWorkoutSetsArguments>(
        operation: ReorderWorkoutSetsMutation(variables: variables),
      );

      final success = _checkApiResult(result);

      if (success) {
        /// Write new sort positions.
        final positions = result.data!.reorderWorkoutSets;

        for (final ws in workoutSets) {
          ws.sortPosition =
              positions.firstWhere((p) => p.id == ws.id).sortPosition;
        }
      }

      notifyListeners();
    }
  }

  Future<void> deleteWorkoutSet(int sectionIndex, int setIndex) async {
    _backup();

    final idToDelete =
        workout.workoutSections[sectionIndex].workoutSets[setIndex].id;
    final oldWorkoutSets = workout.workoutSections[sectionIndex].workoutSets;

    // Client.
    oldWorkoutSets.removeAt(setIndex);

    _updateWorkoutSetsSortPosition(oldWorkoutSets);

    notifyListeners();

    /// Api.
    final variables = DeleteWorkoutSetByIdArguments(id: idToDelete);

    final result = await context.graphQLStore.networkOnlyOperation<
            DeleteWorkoutSetById$Mutation, DeleteWorkoutSetByIdArguments>(
        operation: DeleteWorkoutSetByIdMutation(variables: variables));

    final success = _checkApiResult(result);

    if (success) {
      final deletedId = result.data!.deleteWorkoutSetById;

      // If the ids do not match then there was a problem - revert the changes.
      if (idToDelete != deletedId) {
        _revertChanges(result.errors);
        notifyListeners();
      }
    }
  }

  /// Internal: Client
  void _updateWorkoutSetsSortPosition(List<WorkoutSet> workoutSets) {
    workoutSets.forEachIndexed((i, workoutSet) {
      workoutSet.sortPosition = i;
    });
  }

  ////// WorkoutMove CRUD //////
  /// Add a workoutMove to a set.
  Future<void> createWorkoutMove(
      int sectionIndex, int setIndex, WorkoutMove workoutMove) async {
    _backup();

    final workoutSetId =
        workout.workoutSections[sectionIndex].workoutSets[setIndex].id;

    /// Api only for create.
    final variables = CreateWorkoutMoveArguments(
        data: CreateWorkoutMoveInput(
            sortPosition: workoutMove.sortPosition,
            reps: workoutMove.reps,
            repType: workoutMove.repType,
            loadAmount: workoutMove.loadAmount,
            loadUnit: workoutMove.loadUnit,
            timeUnit: workoutMove.timeUnit,
            equipment: workoutMove.equipment != null
                ? ConnectRelationInput(id: workoutMove.equipment!.id)
                : null,
            distanceUnit: workoutMove.distanceUnit,
            move: ConnectRelationInput(id: workoutMove.move.id),
            workoutSet: ConnectRelationInput(id: workoutSetId)));

    final result = await context.graphQLStore.networkOnlyOperation<
        CreateWorkoutMove$Mutation, CreateWorkoutMoveArguments>(
      operation: CreateWorkoutMoveMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      workout.workoutSections[sectionIndex].workoutSets[setIndex].workoutMoves
          .add(WorkoutMove.fromJson(
        result.data!.createWorkoutMove.toJson(),
      ));
    }
    notifyListeners();
  }

  /// For batch updates use [editWorkoutMoves]
  Future<void> editWorkoutMove(
      int sectionIndex, int setIndex, WorkoutMove workoutMove) async {
    _backup();

    /// Client.
    workout.workoutSections[sectionIndex].workoutSets[setIndex]
        .workoutMoves[workoutMove.sortPosition] = workoutMove;
    notifyListeners();

    /// Api.
    final variables = UpdateWorkoutMoveArguments(
        data: UpdateWorkoutMoveInput.fromJson(workoutMove.toJson()));

    final result = await context.graphQLStore.networkOnlyOperation<
        UpdateWorkoutMove$Mutation, UpdateWorkoutMoveArguments>(
      operation: UpdateWorkoutMoveMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      workout.workoutSections[sectionIndex].workoutSets[setIndex]
          .workoutMoves[workoutMove.sortPosition] = WorkoutMove.fromJson(
        result.data!.updateWorkoutMove.toJson(),
      );
    }

    notifyListeners();
  }

  /// Batch update method version of [editWorkoutMove]
  Future<void> editWorkoutMoves(
      int sectionIndex, int setIndex, List<WorkoutMove> workoutMoves) async {
    _backup();

    /// Client.
    for (final wm in workoutMoves) {
      workout.workoutSections[sectionIndex].workoutSets[setIndex]
          .workoutMoves[wm.sortPosition] = wm;
    }

    notifyListeners();

    /// Api.
    final input = workoutMoves
        .map((wm) => UpdateWorkoutMoveInput.fromJson(wm.toJson()))
        .toList();

    final variables = UpdateWorkoutMovesArguments(data: input);

    final result = await context.graphQLStore.networkOnlyOperation<
        UpdateWorkoutMoves$Mutation, UpdateWorkoutMovesArguments>(
      operation: UpdateWorkoutMovesMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      for (final wm in result.data!.updateWorkoutMoves) {
        workout.workoutSections[sectionIndex].workoutSets[setIndex]
            .workoutMoves[wm.sortPosition] = WorkoutMove.fromJson(
          wm.toJson(),
        );
      }
    }

    notifyListeners();
  }

  Future<void> deleteWorkoutMove(
      int sectionIndex, int setIndex, int workoutMoveIndex) async {
    _backup();

    final workoutMoves = workout
        .workoutSections[sectionIndex].workoutSets[setIndex].workoutMoves;

    final idToDelete = workoutMoves[workoutMoveIndex].id;

    // Client.
    workoutMoves.removeAt(workoutMoveIndex);

    _updateWorkoutMovesSortPosition(workoutMoves);

    notifyListeners();

    // Api.
    final variables = DeleteWorkoutMoveByIdArguments(id: idToDelete);

    final result = await context.graphQLStore.networkOnlyOperation<
            DeleteWorkoutMoveById$Mutation, DeleteWorkoutMoveByIdArguments>(
        operation: DeleteWorkoutMoveByIdMutation(variables: variables));

    final success = _checkApiResult(result);

    if (success) {
      final deletedId = result.data!.deleteWorkoutMoveById;

      // If the ids do not match then there was a problem - revert the changes.
      if (idToDelete != deletedId) {
        _revertChanges(result.errors);
        notifyListeners();
      }
    }
  }

  Future<void> duplicateWorkoutMove(
      int sectionIndex, int setIndex, int workoutMoveIndex) async {
    _backup();

    final workoutMoves = workout
        .workoutSections[sectionIndex].workoutSets[setIndex].workoutMoves;
    final toDuplicate = workoutMoves[workoutMoveIndex];

    /// Client side.
    workoutMoves.insert(
        workoutMoveIndex + 1,
        WorkoutMove.fromJson({
          ...toDuplicate.toJson(),
          'id': 'temp-${const Uuid().v1()}',
        }));

    _updateWorkoutMovesSortPosition(workoutMoves);

    /// Api only for duplication
    /// If we do optimistic client update then the user can immediately click to edit a workoutMove with a temp id that does not exist in the DB - causing network error on an update mutation request.
    final variables = DuplicateWorkoutMoveByIdArguments(id: toDuplicate.id);

    final result = await context.graphQLStore.networkOnlyOperation<
        DuplicateWorkoutMoveById$Mutation, DuplicateWorkoutMoveByIdArguments>(
      operation: DuplicateWorkoutMoveByIdMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      workoutMoves[workoutMoveIndex + 1] =
          WorkoutMove.fromJson(result.data!.duplicateWorkoutMoveById.toJson());
    }

    notifyListeners();
  }

  Future<void> reorderWorkoutMoves(
      int sectionIndex, int setIndex, int from, int to) async {
    // https://api.flutter.dev/flutter/material/ReorderableListView-class.html
    // // Necessary because of how flutters reorderable list calculates drop position...I think.
    final moveTo = from < to ? to - 1 : to;

    // Check that user is not trying to move beyond the bounds of the list.
    if (moveTo >= 0 &&
        moveTo <
            workout.workoutSections[sectionIndex].workoutSets[setIndex]
                .workoutMoves.length) {
      _backup();

      final workoutMoves = workout
          .workoutSections[sectionIndex].workoutSets[setIndex].workoutMoves;

      final inTransit = workoutMoves.removeAt(from);
      workoutMoves.insert(moveTo, inTransit);

      _updateWorkoutMovesSortPosition(workoutMoves);

      notifyListeners();

      /// Api.
      final variables = ReorderWorkoutMovesArguments(
          data: workoutMoves
              .map((s) => UpdateSortPositionInput(
                  id: s.id, sortPosition: s.sortPosition))
              .toList());

      final result = await context.graphQLStore.networkOnlyOperation<
          ReorderWorkoutMoves$Mutation, ReorderWorkoutMovesArguments>(
        operation: ReorderWorkoutMovesMutation(variables: variables),
      );

      final success = _checkApiResult(result);

      if (success) {
        final positions = result.data!.reorderWorkoutMoves;

        // Write new sort positions.
        for (final wm in workoutMoves) {
          wm.sortPosition =
              positions.firstWhere((p) => p.id == wm.id).sortPosition;
        }
      }

      notifyListeners();
    }
  }

  void _updateWorkoutMovesSortPosition(List<WorkoutMove> workoutMoves) {
    workoutMoves.forEachIndexed((i, workoutMove) {
      workoutMove.sortPosition = i;
    });
  }
}
