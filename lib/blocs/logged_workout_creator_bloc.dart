import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
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
  final ScheduledWorkout? scheduledWorkout;

  /// Before every update we make a copy of the last workout here.
  /// If there is an issue calling the api then this is reverted to.
  late Map<String, dynamic> backupJson = {};

  /// Can be create (from workout) or edit (a previous log).
  late bool _isEditing;

  final List<String> typesInputRequired = [
    kFreeSessionName,
    kForTimeName,
    kAMRAPName
  ];

  late LoggedWorkout loggedWorkout;

  LoggedWorkoutCreatorBloc(
      {required this.context,
      this.prevLoggedWorkout,
      this.workout,
      this.scheduledWorkout})
      : assert(
            (prevLoggedWorkout == null && workout != null) ||
                (prevLoggedWorkout != null && workout == null),
            'Provide a priod log to edit, or a workout to create a log from, not both, or neither') {
    if (prevLoggedWorkout != null) {
      _isEditing = true;
      loggedWorkout = prevLoggedWorkout!.copyAndSortAllChildren;
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
      if (workout!.workoutSections.none(
          (w) => typesInputRequired.contains(w.workoutSectionType.name))) {
        loggedWorkout.loggedWorkoutSections = workout!.workoutSections
            .sortedBy<num>((ws) => ws.sortPosition)
            .map((ws) =>
                loggedWorkoutSectionFromWorkoutSection(workoutSection: ws))
            .toList();
      }
    }
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

  bool _checkApiResult(MutationResult result) {
    if (result.hasErrors || result.data == null) {
      _revertChanges(result.errors);
      return false;
    } else {
      return true;
    }
  }

  /// Only valid when creating and when [workout] is not null.
  /// From workout sections plus their inputs - inputted by the user.
  /// Do not sun this before the user has added reps and timeTakenSeconds to AMRAP, ForTime and FreeSession sections.
  void generateLoggedWorkoutSections(
      List<WorkoutSectionWithInput> sectionsWithInputs) {
    loggedWorkout.loggedWorkoutSections = workout!.workoutSections
        .sortedBy<num>((ws) => ws.sortPosition)
        .map((ws) {
      if (ws.workoutSectionType.name == kAMRAPName) {
        // Get the value from the inputs
        final s =
            sectionsWithInputs.firstWhere((s) => ws.id == s.workoutSection.id);
        return loggedWorkoutSectionFromWorkoutSection(
            workoutSection: ws, repScore: s.input);
      } else if ([kFreeSessionName, kForTimeName]
          .contains(ws.workoutSectionType.name)) {
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
        broadcastQueryIds: [GQLNullVarsKeys.userLoggedWorkoutsQuery]);
    return success;
  }

  /// Used when creating only - when editing we save incrementally.
  Future<MutationResult> createAndSave(BuildContext context) async {
    final input = createLoggedWorkoutInputFromLoggedWorkout(
        loggedWorkout, scheduledWorkout);

    final variables = CreateLoggedWorkoutArguments(data: input);

    final result = await context.graphQLStore.create(
        mutation: CreateLoggedWorkoutMutation(variables: variables),
        addRefToQueries: [GQLNullVarsKeys.userLoggedWorkoutsQuery]);

    await checkOperationResult(context, result);

    /// If the log is being created from a scheduled workout then we need to add the newly completed workout log to the scheduledWorkout.loggedWorkout in the store.
    if (scheduledWorkout != null && result.data != null) {
      updateScheduleWithLoggedWorkout(
          context, scheduledWorkout!, result.data!.createLoggedWorkout);
    }

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

      _checkApiResult(result);
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

  void toggleSectionBodyArea(int sectionIndex, BodyArea bodyArea) {
    _backup();

    final prev = loggedWorkout.loggedWorkoutSections[sectionIndex];
    final updated = prev.bodyAreas
        .toggleItem<BodyArea>(bodyArea)
        .map((b) => b.toJson())
        .toList();

    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson({...prev.toJson(), 'BodyAreas': updated});
    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  void updateSectionMoveTypes(int sectionIndex, List<MoveType> moveTypes) {
    _backup();

    final prev = loggedWorkout.loggedWorkoutSections[sectionIndex];
    final updated = moveTypes.map((m) => m.toJson()).toList();

    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson({...prev.toJson(), 'MoveTypes': updated});

    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  ///// LoggedWorkoutSectionData //////
  /// Creates a new roundData object with original round data from
  void addRoundToSection(int sectionIndex) {
    _backup();

    final prevSection = loggedWorkout.loggedWorkoutSections[sectionIndex];
    final rounds = prevSection.loggedWorkoutSectionData!.rounds;

    final roundData = rounds.isNotEmpty
        ? rounds.last
        : WorkoutSectionRoundData.fromJson(
            {'timeTakenSeconds': 60, 'sets': []});

    prevSection.loggedWorkoutSectionData!.rounds
        .add(WorkoutSectionRoundData.fromJson(roundData.toJson()));

    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  void removeRoundFromSection(int sectionIndex, int roundIndex) {
    _backup();

    final prevSection = loggedWorkout.loggedWorkoutSections[sectionIndex];

    prevSection.loggedWorkoutSectionData!.rounds.removeAt(roundIndex);

    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  void updateRoundTimeTakenSeconds(
      {required int sectionIndex,
      required int roundIndex,
      required int seconds}) {
    _backup();

    final prev = loggedWorkout.loggedWorkoutSections[sectionIndex];
    prev.loggedWorkoutSectionData!.rounds[roundIndex].timeTakenSeconds =
        seconds;

    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson(prev.toJson());
    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  void addSetToSectionRound(int sectionIndex, int roundIndex) {
    _backup();

    final prevSection = loggedWorkout.loggedWorkoutSections[sectionIndex];
    final prevRound = prevSection.loggedWorkoutSectionData!.rounds[roundIndex];

    final setData = prevRound.sets.isNotEmpty
        ? prevRound.sets.last
        : WorkoutSectionRoundSetData.fromJson(
            {'timeTakenSeconds': 60, 'moves': '...'});

    prevSection.loggedWorkoutSectionData!.rounds[roundIndex].sets
        .add(WorkoutSectionRoundSetData.fromJson(setData.toJson()));

    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  void removeSetFromSectionRound(
      int sectionIndex, int roundIndex, int setIndex) {
    _backup();

    final prevSection = loggedWorkout.loggedWorkoutSections[sectionIndex];
    prevSection.loggedWorkoutSectionData!.rounds[roundIndex].sets
        .removeAt(setIndex);

    /// Listeners are at the section level. So make a new one so that they know to rebuild.
    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson(prevSection.toJson());

    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  void updateSetTimeTakenSeconds(
      {required int sectionIndex,
      required int roundIndex,
      required int setIndex,
      required int seconds}) {
    _backup();

    final prev = loggedWorkout.loggedWorkoutSections[sectionIndex];
    prev.loggedWorkoutSectionData!.rounds[roundIndex].sets[setIndex]
        .timeTakenSeconds = seconds;

    /// Listeners are at the section level. So make a new one so that they know to rebuild.
    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson(prev.toJson());

    notifyListeners();

    if (_isEditing) {
      _saveLoggedWorkoutSectionToDB(sectionIndex);
    }
  }

  void updateSetMovesList(
      {required int sectionIndex,
      required int roundIndex,
      required int setIndex,
      required String moves}) {
    _backup();

    final prev = loggedWorkout.loggedWorkoutSections[sectionIndex];
    prev.loggedWorkoutSectionData!.rounds[roundIndex].sets[setIndex].moves =
        moves;

    /// Listeners are at the section level. So make a new one so that they know to rebuild.
    loggedWorkout.loggedWorkoutSections[sectionIndex] =
        LoggedWorkoutSection.fromJson(prev.toJson());

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

      _checkApiResult(result);
    } catch (e) {
      _revertChanges([e]);
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
        broadcastQueryIds: [GQLOpNames.userScheduledWorkoutsQuery]);
  }

  /// To add a gym profile to the logged workout input you can either to add it to
  /// [scheduledWorkout.gymProfile] or to [loggedWorkout.gymProfile].
  /// [loggedWorkout.gymProfile] will take precedence over [scheduledWorkout.gymProfile].
  static CreateLoggedWorkoutInput createLoggedWorkoutInputFromLoggedWorkout(
      LoggedWorkout loggedWorkout, ScheduledWorkout? scheduledWorkout) {
    final gymProfile = loggedWorkout.gymProfile ?? scheduledWorkout?.gymProfile;

    return CreateLoggedWorkoutInput(
      name: loggedWorkout.name,
      note: loggedWorkout.note,
      scheduledWorkout: scheduledWorkout != null
          ? ConnectRelationInput(id: scheduledWorkout.id)
          : null,
      gymProfile:
          gymProfile != null ? ConnectRelationInput(id: gymProfile.id) : null,
      workoutGoals: loggedWorkout.workoutGoals
          .map((goal) => ConnectRelationInput(id: goal.id))
          .toList(),
      completedOn: loggedWorkout.completedOn,
      loggedWorkoutSections: loggedWorkout.loggedWorkoutSections
          .sortedBy<num>((section) => section.sortPosition)
          .mapIndexed((index, section) =>
              CreateLoggedWorkoutSectionInLoggedWorkoutInput(
                name: section.name,
                sortPosition: index,
                moveTypes: section.moveTypes
                    .map((m) => ConnectRelationInput(id: m.id))
                    .toList(),
                bodyAreas: section.bodyAreas
                    .map((b) => ConnectRelationInput(id: b.id))
                    .toList(),
                repScore: section.repScore,
                timeTakenSeconds: section.timeTakenSeconds,
                loggedWorkoutSectionData:
                    LoggedWorkoutSectionDataInput.fromJson(
                        section.loggedWorkoutSectionData?.toJson() ?? {}),
                workoutSectionType:
                    ConnectRelationInput(id: section.workoutSectionType.id),
              ))
          .toList(),
    );
  }
}
