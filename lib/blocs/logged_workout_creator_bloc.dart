import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/data_model_converters/workout_to_create_log_inputs.dart';
import 'package:sofie_ui/services/data_model_converters/workout_to_logged_workout.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutSectionWithInput {
  WorkoutSection workoutSection;
  // Will be either reps (repScore) or time in seconds (timeTakenSeconds)
  // When none of these are null the user can proceed and we can generate the full list of loggedWorkoutSections.
  int? input;
  WorkoutSectionWithInput({required this.workoutSection, this.input});
}

/// Creating: LoggedWorkout is saved to the API at the end of the flow, not incrementally.
/// Editing: Data is saved to the DB as the user is inputting, with optimistic UI update.
class LoggedWorkoutCreatorBloc extends ChangeNotifier {
  final BuildContext context;

  final LoggedWorkout? prevLoggedWorkout;
  final Workout? workout;

  /// When present these will be passed on to log creation function.
  /// [scheduledWorkout] so that we can add the log to the scheduled workout to mark it as done.
  /// [workoutPlanDayWorkoutId] and [workoutPlanEnrolmentId] so that we can create a [CompletedWorkoutPlanDayWorkout] to mark it as done in the plan.
  final ScheduledWorkout? scheduledWorkout;
  final String? workoutPlanDayWorkoutId;
  final String? workoutPlanEnrolmentId;

  /// Before every update we make a copy of the last workout here.
  /// If there is an issue calling the api then this is reverted to.
  late Map<String, dynamic> backupJson = {};

  /// Can be create (from workout) or edit (a previous log).
  late bool _isEditing;

  final List<String> typesInputRequired = [
    kCustomSessionName,
    kLiftingName,
    kForTimeName,
    kAMRAPName
  ];

  late LoggedWorkout loggedWorkout;

  LoggedWorkoutCreatorBloc(
      {required this.context,
      this.prevLoggedWorkout,
      this.workout,
      this.scheduledWorkout,
      this.workoutPlanDayWorkoutId,
      this.workoutPlanEnrolmentId})
      : assert(
            (prevLoggedWorkout == null && workout != null) ||
                (prevLoggedWorkout != null && workout == null),
            'Provide a prior log to edit, or a workout to create a log from, not both, or neither') {
    if (prevLoggedWorkout != null) {
      _isEditing = true;
      loggedWorkout = prevLoggedWorkout!;
    } else {
      _isEditing = false;
      loggedWorkout = loggedWorkoutFromWorkout(
          workout: workout!, scheduledWorkout: scheduledWorkout);

      /// Are there any sections that require inputs from the user?
      /// i.e. FreeSession - timeTaken
      /// i.e. AMRAP - repScore
      /// i.e. ForTIme - timeTaken
      /// If not then go ahead and form the loggedWorkoutSections.
      /// Otherwise do not.
      final userInputNotRequired = workout!.workoutSections
          .none((w) => typesInputRequired.contains(w.workoutSectionType.name));

      if (userInputNotRequired) {
        loggedWorkout.loggedWorkoutSections = workout!.workoutSections
            .sortedBy<num>((ws) => ws.sortPosition)
            .map((ws) =>
                loggedWorkoutSectionFromWorkoutSection(workoutSection: ws))
            .toList();
      }
    }
    loggedWorkout.copyAndSortAllChildren;
  }

  /// Helpers for write methods.
  /// Should run at the start of all CRUD ops.
  void _backup() {
    backupJson = loggedWorkout.toJson();
  }

  void _revertChanges(List<Object>? errors) {
    // There was an error so revert to backup, notify listeners and show error toast.
    loggedWorkout = LoggedWorkout.fromJson(backupJson);
    notifyListeners();
    if (errors != null && errors.isNotEmpty) {
      for (final e in errors) {
        printLog(e.toString());
      }
    }
    context.showToast(
        message: 'There was a problem, changes not saved',
        toastType: ToastType.destructive);
  }

  bool _checkApiResult(OperationResult result,
      {required VoidCallback onSuccess}) {
    if (result.hasErrors || result.data == null) {
      _revertChanges(result.errors);
      return false;
    } else {
      onSuccess.call();
      return true;
    }
  }

  /// Only valid when creating and when [workout] is not null.
  /// Workout sections plus their inputs - inputted by the user.
  /// Do not run this before the user has added reps and timeTakenSeconds to AMRAP, ForTime and FreeSession sections.
  void generateLoggedWorkoutSections(
      List<WorkoutSectionWithInput> sectionsWithInputs) {
    loggedWorkout.loggedWorkoutSections = workout!.workoutSections
        .sortedBy<num>((ws) => ws.sortPosition)
        .map((ws) {
      if (ws.workoutSectionType.isAMRAP) {
        // Get the value from the inputs
        final s =
            sectionsWithInputs.firstWhere((s) => ws.id == s.workoutSection.id);
        return loggedWorkoutSectionFromWorkoutSection(
            workoutSection: ws, repScore: s.input);
      } else if (ws.workoutSectionType.isCustom ||
          ws.workoutSectionType.isForTime ||
          ws.workoutSectionType.isLifting) {
        // Get the value from the inputs
        final s =
            sectionsWithInputs.firstWhere((s) => ws.id == s.workoutSection.id);
        return loggedWorkoutSectionFromWorkoutSection(
            workoutSection: ws, timeTakenSeconds: s.input);
      } else {
        // Timed sections already have all the data needed to create a LoggedWorkoutSection
        return loggedWorkoutSectionFromWorkoutSection(workoutSection: ws);
      }
    }).toList();

    /// Ensure all sections and descendants correctly sorted.
    loggedWorkout.copyAndSortAllChildren;

    notifyListeners();
  }

  /// Writes all changes to the graphQLStore.
  /// Via the normalized root object which is the LoggedWorkout.
  /// At [LoggedWorkout:{loggedWorkout.id}].
  /// Should only be run when user is editing the log ([_isEditing] is true),
  /// not when they are creating it.
  bool writeAllChangesToStore() {
    final success = context.graphQLStore.writeDataToStore(
        data: loggedWorkout.toJson(),
        broadcastQueryIds: [GQLNullVarsKeys.userLoggedWorkouts]);
    return success;
  }

  /// Used when creating only - when editing we save incrementally.
  /// When creating a log we need to check if the log should be associated with a scheduled workout and / or with a workout plan enrolment.
  Future<OperationResult> createAndSave(BuildContext context) async {
    final input = createLoggedWorkoutInputFromLoggedWorkout(loggedWorkout,
        scheduledWorkout: scheduledWorkout,
        workoutPlanDayWorkoutId: workoutPlanDayWorkoutId,
        workoutPlanEnrolmentId: workoutPlanEnrolmentId);

    final variables = CreateLoggedWorkoutArguments(data: input);

    final result = await context.graphQLStore.create(
        mutation: CreateLoggedWorkoutMutation(variables: variables),
        addRefToQueries: [GQLNullVarsKeys.userLoggedWorkouts]);

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: 'Sorry, something went wrong',
            toastType: ToastType.destructive),
        onSuccess: () async {
          /// We need to update the userEnrolmentsQuery and the enrolmentByIdQuery.
          /// We do this via the network for simplicity.
          if (workoutPlanDayWorkoutId != null &&
              workoutPlanEnrolmentId != null) {
            await refetchWorkoutPlanEnrolmentQueries(
                context, workoutPlanEnrolmentId!);
          }

          /// If the log is being created from a scheduled workout then we need to add the newly completed workout log to the scheduledWorkout.loggedWorkout in the store.
          if (scheduledWorkout != null) {
            updateScheduleWithLoggedWorkout(
                context, scheduledWorkout!, result.data!.createLoggedWorkout);
          }
        });

    return result;
  }

  void updateGymProfile(GymProfile? profile) {
    _backup();

    loggedWorkout.gymProfile = profile;
    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutToDB();
    }
  }

  void updateCompletedOn(DateTime completedOn) {
    _backup();

    loggedWorkout.completedOn = completedOn;
    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutToDB();
    }
  }

  void updateNote(String note) {
    _backup();

    loggedWorkout.note = note;
    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutToDB();
    }
  }

  void updateWorkoutGoals(List<WorkoutGoal> goals) {
    _backup();

    loggedWorkout.workoutGoals = goals;
    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutToDB();
    }
  }

  /// Run at the end of any loggedWorkout update IF we are editing a previous log already in the DB.
  /// If there are no errors, no action is needed. Don't write over local data with data that has returned because the user may have sent off another update already and this will lead to race.
  Future<void> _saveLoggedWorkoutToDB() async {
    final variables = UpdateLoggedWorkoutArguments(
        data: UpdateLoggedWorkoutInput.fromJson(loggedWorkout.toJson()));

    try {
      final result = await context.graphQLStore.networkOnlyOperation(
          operation: UpdateLoggedWorkoutMutation(variables: variables));

      _checkApiResult(result, onSuccess: writeAllChangesToStore);
    } catch (e) {
      _revertChanges([e]);
    }
  }

  /////// Section CRUD Methods //////
  void updateRepScore(int sectionIndex, int repScore) {
    _backup();

    final prev = loggedWorkout.loggedWorkoutSections[sectionIndex];

    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson({...prev.toJson(), 'repScore': repScore});
    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  void updateTimeTakenSeconds(int sectionIndex, int timeTakenSeconds) {
    _backup();

    final prev = loggedWorkout.loggedWorkoutSections[sectionIndex];

    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson(
            {...prev.toJson(), 'timeTakenSeconds': timeTakenSeconds});
    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  /// Run at the end of any loggedWorkoutSection update IF we are editing a previous log already in the DB.
  /// If there are no errors, no action is needed. Don't write over local data with data that has returned because the user may have sent off another update already and this will lead to race.
  Future<void> _saveLoggedWorkoutSectionToDB(int sectionIndex) async {
    final section = loggedWorkout.loggedWorkoutSections[sectionIndex];

    final variables = UpdateLoggedWorkoutSectionArguments(
        data: UpdateLoggedWorkoutSectionInput.fromJson(section.toJson()));

    try {
      final result = await context.graphQLStore.networkOnlyOperation(
          operation: UpdateLoggedWorkoutSectionMutation(variables: variables));

      _checkApiResult(result, onSuccess: writeAllChangesToStore);
    } catch (e) {
      _revertChanges([e]);
    }
  }

  //// Logged Workout Set CRUD ////
  Future<void> updateSetTimeTakenSeconds(
      {required int sectionIndex,
      required String setId,
      required int seconds}) async {
    _backup();

    final prevSection = loggedWorkout.loggedWorkoutSections[sectionIndex];

    final setToUpdate =
        prevSection.loggedWorkoutSets.firstWhere((lws) => lws.id == setId);

    setToUpdate.timeTakenSeconds = seconds;

    /// Listeners are at the section level. So make a new one so that they know to rebuild.
    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson(prevSection.toJson());

    notifyListeners();

    if (_isEditing) {
      final variables = UpdateLoggedWorkoutSetArguments(
          data: UpdateLoggedWorkoutSetInput(
              id: setId, timeTakenSeconds: seconds));

      final result = await context.graphQLStore.networkOnlyOperation(
          operation: UpdateLoggedWorkoutSetMutation(variables: variables));

      /// If no errors then assume update has worked, otherwise revert UI to backup.
      _checkApiResult(result, onSuccess: writeAllChangesToStore);
    }
  }

  //// Logged Workout Move CRUD ////
  Future<void> updateLoggedWorkoutMove({
    required int sectionIndex,
    required String loggedSetId,
    required LoggedWorkoutMove updatedLoggedWorkoutMove,
  }) async {
    _backup();

    final prevSection = loggedWorkout.loggedWorkoutSections[sectionIndex];

    final prevSet = prevSection.loggedWorkoutSets
        .firstWhere((lws) => lws.id == loggedSetId);

    prevSet.loggedWorkoutMoves = prevSet.loggedWorkoutMoves
        .map((lwm) => lwm.id == updatedLoggedWorkoutMove.id
            ? updatedLoggedWorkoutMove
            : lwm)
        .toList();

    /// Listeners are at the section level. So make a new one so that they know to rebuild.
    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson(prevSection.toJson());

    notifyListeners();

    if (_isEditing) {
      final variables = UpdateLoggedWorkoutMoveArguments(
          data: UpdateLoggedWorkoutMoveInput.fromJson(
              updatedLoggedWorkoutMove.toJson()));

      final result = await context.graphQLStore.networkOnlyOperation(
          operation: UpdateLoggedWorkoutMoveMutation(variables: variables));

      /// If no errors then assume update has worked, otherwise revert UI to backup.
      _checkApiResult(result, onSuccess: writeAllChangesToStore);
    }
  }

  Future<void> deleteLoggedWorkoutMove({
    required int sectionIndex,
    required String loggedSetId,
    required String loggedMoveId,
  }) async {
    _backup();

    final prevSection = loggedWorkout.loggedWorkoutSections[sectionIndex];

    final prevSet = prevSection.loggedWorkoutSets
        .firstWhere((lws) => lws.id == loggedSetId);

    prevSet.loggedWorkoutMoves.removeWhere((lwm) => lwm.id == loggedMoveId);

    /// Listeners are at the section level. So make a new one so that they know to rebuild.
    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson(prevSection.toJson());

    notifyListeners();

    if (_isEditing) {
      final variables = DeleteLoggedWorkoutMoveArguments(id: loggedMoveId);

      final result = await context.graphQLStore.networkOnlyOperation(
          operation: DeleteLoggedWorkoutMoveMutation(variables: variables));

      /// If no errors then assume update has worked, otherwise revert UI to backup.
      _checkApiResult(result, onSuccess: writeAllChangesToStore);
    }
  }

  /// Static helpers and methods ///
  /// Updates the [client side GraphQLStore] by adding the newly created workout log to the scheduled workout at [scheduledWorkout.loggedWorkoutId].
  /// The API will handle connecting the log to the scheduled workout in the DB.
  /// Meaning that the user's schedule will update and show the scheduled workout as completed.
  static void updateScheduleWithLoggedWorkout(BuildContext context,
      ScheduledWorkout scheduledWorkout, LoggedWorkout loggedWorkout) {
    final prevData = context.graphQLStore
        .readDenomalized('$kScheduledWorkoutTypename:${scheduledWorkout.id}');

    final updated = ScheduledWorkout.fromJson(prevData);
    updated.loggedWorkoutId = loggedWorkout.id;

    context.graphQLStore.writeDataToStore(
        data: updated.toJson(),
        broadcastQueryIds: [GQLOpNames.userScheduledWorkouts]);
  }

  /// Refetches from the network the enrolments query (summaries) and the details query.
  /// This would be overly complex to manage purely on the FE.
  static Future<void> refetchWorkoutPlanEnrolmentQueries(
      BuildContext context, String workoutPlanEnrolmentId) async {
    await context.graphQLStore.refetchQueriesByIds([
      GQLOpNames.workoutPlanEnrolments,
      GQLVarParamKeys.workoutPlanEnrolmentById(workoutPlanEnrolmentId)
    ]);
  }
}
