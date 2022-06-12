import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:uuid/uuid.dart';

class WorkoutSectionInput {
  WorkoutSection workoutSection;
  // Will be either reps (repScore) or time in seconds (timeTakenSeconds)
  // When none of these are null the user can proceed and we can generate the full list of loggedWorkoutSections.
  int? input;
  WorkoutSectionInput({required this.workoutSection, this.input});
}

/// Use to edit a workout before you log it. For when you modified some moves or did not do all the sections.
/// Data modified here is not persisted to the store but only modified and then passed off to some other handler.
/// No media or meta info editing, or adding sections. Sections can be removed
/// NOTE: Currently almost exact copy of [DoWorkoutBloc] view / modifications methods. Abstraction is probably possible.
class WorkoutStructureModificationsBloc extends ChangeNotifier {
  final BuildContext context;
  late Workout workout;
  late List<WorkoutSectionInput> sectionInputs;
  late List<String> includedSectionIds;

  final List<String> typesInputRequired = [
    kCustomSessionName,
    kLiftingName,
    kForTimeName,
    kAMRAPName
  ];

  WorkoutStructureModificationsBloc(this.context, Workout initialWorkout) {
    // workout = initialWorkout.copyAndSortAllChildren;
    // includedSectionIds = workout.workoutSections.map((ws) => ws.id).toList();
    // sectionInputs = workout.workoutSections
    //     .map((wSection) => WorkoutSectionInput(
    //         workoutSection: wSection, input: getInputFromSection(wSection)))
    //     .toList();
  }

  int? getInputFromSection(WorkoutSection wSection) => 9;

  bool savingLogToDB = false;

  void setSavingLogToDB(bool value) {
    savingLogToDB = value;
    notifyListeners();
  }

  void toggleIncludeSectionId(String sectionId) {
    includedSectionIds = includedSectionIds.toggleItem<String>(sectionId);
    notifyListeners();
  }

  void updateSectionInput(String sectionId, int input) {
    sectionInputs = sectionInputs
        .map((o) => o.workoutSection.id == sectionId
            ? WorkoutSectionInput(
                workoutSection: o.workoutSection, input: input)
            : o)
        .toList();

    notifyListeners();
  }

  /// Use this after user has performed some section modifications, IF it is a section which calculates its own input ONLY.
  void refreshTimedSectionInput(String workoutSectionId) {
    final workoutSection =
        workout.workoutSections.firstWhere((ws) => ws.id == workoutSectionId);

    sectionInputs = sectionInputs
        .map((o) => o.workoutSection.id == workoutSectionId
            ? WorkoutSectionInput(
                workoutSection: workoutSection,
                input: getInputFromSection(workoutSection))
            : o)
        .toList();

    notifyListeners();
  }

  /// The user can minimize how sets are displayed (for easy re-ordering or overviewing).
  /// They can minimize whole sections or just one set at a time.
  List<String> displayMinimizedSetIds = [];

  /// Using [sectionIndex] as this is being called from [set] level and the set creator widget does not have the section ID.
  void toggleMinimizeSetInfo(String setId) {
    displayMinimizedSetIds = displayMinimizedSetIds.toggleItem<String>(setId);
    notifyListeners();
  }

  Future<void> updateWorkoutSectionRounds(int sectionIndex, int rounds) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.rounds = rounds;
    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  /// For AMRAPs.
  Future<void> updateWorkoutSectionTimecap(
      int sectionIndex, int seconds) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.timecap = seconds;

    workout.workoutSections[sectionIndex] = section;

    /// Update the workout section that is on the section input.
    sectionInputs = sectionInputs
        .map((o) => o.workoutSection.id == section.id
            ? WorkoutSectionInput(workoutSection: section, input: o.input)
            : o)
        .toList();

    notifyListeners();
  }

  /// Always making a copy of the section as this is what the provider.select listener is checking.
  /// This method can be called during the workout (Lifting and Custom sections).
  /// Make sure you pass [doNotReset] as true to avoid resetting section progress.
  Future<void> addWorkoutSetToSection(int sectionIndex, WorkoutSet workoutSet,
      {bool doNotReset = false}) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.workoutSets.add(workoutSet);

    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  Future<void> removeWorkoutSetFromSection(
      int sectionIndex, int setIndex) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.workoutSets.removeAt(setIndex);

    section.workoutSets.forEachIndexed((i, wSet) {
      wSet.sortPosition = i;
    });

    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  Future<void> updateWorkoutSetDuration(
      int sectionIndex, int setIndex, int seconds) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.workoutSets[setIndex].duration = seconds;

    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  /// Will call editSet on all sets one after another in series to perform this update.
  Future<void> updateAllSetDurations(
      int sectionIndex, int seconds, DurationUpdateType type) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.workoutSets.forEachIndexed((i, w) {
      // if (type == DurationUpdateType.sets && !w.isRestSet ||
      //     type == DurationUpdateType.rests && w.isRestSet) {
      //   /// [updateWorkoutSetDuration] will reset section and notify listeners.
      //   updateWorkoutSetDuration(sectionIndex, i, seconds);
      // }
    });
  }

  Future<void> duplicateWorkoutSet(int sectionIndex, int setIndex) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    final toDuplicate = section.workoutSets[setIndex];

    section.workoutSets.insert(
        setIndex + 1,
        WorkoutSet.fromJson({
          ...toDuplicate.toJson(),
          'id': 'temp-${const Uuid().v1()}',
        }));

    _updateWorkoutSetsSortPosition(section.workoutSets);

    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  Future<void> deleteWorkoutSet(int sectionIndex, int setIndex) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.workoutSets.removeAt(setIndex);

    _updateWorkoutSetsSortPosition(section.workoutSets);

    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  Future<void> reorderWorkoutSets(int sectionIndex, int from, int to) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    // Check that user is not trying to move beyond the bounds of the list.
    if (to >= 0 && to < section.workoutSets.length) {
      final workoutSets = section.workoutSets;

      final inTransit = workoutSets.removeAt(from);
      workoutSets.insert(to, inTransit);

      _updateWorkoutSetsSortPosition(workoutSets);

      workout.workoutSections[sectionIndex] = section;

      notifyListeners();
    }
  }

  void _updateWorkoutSetsSortPosition(List<WorkoutSet> workoutSets) {
    workoutSets.forEachIndexed((i, workoutSet) {
      workoutSet.sortPosition = i;
    });
  }

  Future<void> addWorkoutMoveToSet(
      int sectionIndex, int setIndex, WorkoutMove workoutMove) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.workoutSets[setIndex].workoutMoves.add(workoutMove);

    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  /// This method can be called during the workout (Lifting and Custom sections).
  /// Make sure you pass [doNotReset] as true to avoid resetting section progress.
  Future<void> updateWorkoutMove(
      int sectionIndex, int setIndex, WorkoutMove workoutMove,
      {bool doNotReset = true}) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.workoutSets[setIndex].workoutMoves = section
        .workoutSets[setIndex].workoutMoves
        .map((wm) => wm.id == workoutMove.id ? workoutMove : wm)
        .toList();

    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  Future<void> duplicateWorkoutMove(
      int sectionIndex, int setIndex, int workoutMoveIndex) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    final toDuplicate =
        section.workoutSets[setIndex].workoutMoves[workoutMoveIndex];

    section.workoutSets[setIndex].workoutMoves.insert(
        workoutMoveIndex + 1,
        WorkoutMove.fromJson({
          ...toDuplicate.toJson(),
          'id': 'temp-${const Uuid().v1()}',
        }));

    _updateWorkoutMovesSortPosition(section.workoutSets[setIndex].workoutMoves);

    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  Future<void> deleteWorkoutMove(
      int sectionIndex, int setIndex, int workoutMoveIndex) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    section.workoutSets[setIndex].workoutMoves.removeAt(workoutMoveIndex);

    _updateWorkoutMovesSortPosition(section.workoutSets[setIndex].workoutMoves);

    workout.workoutSections[sectionIndex] = section;

    notifyListeners();
  }

  Future<void> reorderWorkoutMoves(
      int sectionIndex, int setIndex, int from, int to) async {
    final section =
        WorkoutSection.fromJson(workout.workoutSections[sectionIndex].toJson());

    // https://api.flutter.dev/flutter/material/ReorderableListView-class.html
    // // Necessary because of how flutters reorderable list calculates drop position...I think.
    final moveTo = from < to ? to - 1 : to;

    // Check that user is not trying to move beyond the bounds of the list.
    if (moveTo >= 0 &&
        moveTo < section.workoutSets[setIndex].workoutMoves.length) {
      final inTransit =
          section.workoutSets[setIndex].workoutMoves.removeAt(from);
      section.workoutSets[setIndex].workoutMoves.insert(moveTo, inTransit);

      _updateWorkoutMovesSortPosition(
          section.workoutSets[setIndex].workoutMoves);

      workout.workoutSections[sectionIndex] = section;

      notifyListeners();
    }
  }

  void _updateWorkoutMovesSortPosition(List<WorkoutMove> workoutMoves) {
    workoutMoves.forEachIndexed((i, workoutMove) {
      workoutMove.sortPosition = i;
    });
  }
}
