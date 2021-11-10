import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_model_converters/workout_to_logged_workout.dart';

class WorkoutSectionProgressState {
  late WorkoutSection workoutSection;
  late int numberSetsPerRound;
  int latestRoundSplitTimeSeconds = 0;
  int latestSetSplitTimeSeconds = 0;

  int currentRoundIndex = 0;
  int currentSetIndex = 0;

  LoggedWorkoutSectionData sectionData = LoggedWorkoutSectionData()
    ..rounds = [
      WorkoutSectionRoundData()
        ..sets = []
        ..timeTakenSeconds = 0
    ];

  /// Used for timed workouts or timecaps.
  /// Can be the next set or the end of the section, depending on the section type.
  int? secondsToNextCheckpoint;

  /// Must be a double between 0.0 and 1.0 inclusive.
  /// How this is calculated will depend on the type of workout / workout controller.
  /// For example timed workouts are just curTime / totalTime.
  /// ForTime and Free Session workouts are based on rounds and sets complete vs total rounds and set in the workout.
  double percentComplete = 0.0;

  WorkoutSectionProgressState(this.workoutSection) {
    numberSetsPerRound = workoutSection.workoutSets.length;
  }

  /// This is invoked each time a new state is generated.
  /// So make sure if you add any fields that they also get added to this copy method!
  WorkoutSectionProgressState.copy(WorkoutSectionProgressState o)
      : currentRoundIndex = o.currentRoundIndex,
        currentSetIndex = o.currentSetIndex,
        sectionData = o.sectionData,
        percentComplete = o.percentComplete,
        secondsToNextCheckpoint = o.secondsToNextCheckpoint,
        numberSetsPerRound = o.numberSetsPerRound,
        latestRoundSplitTimeSeconds = o.latestRoundSplitTimeSeconds,
        latestSetSplitTimeSeconds = o.latestSetSplitTimeSeconds;

  /// Move to next set, or if currently on the last set of a section round, move to the round - resetting the section index to 0.
  /// [secondsElapsed] is the total seconds passed for this section.
  /// This method will calculate the time taken for the set / section from [secondsElapsed] and the latest split times stored locally. [latestRoundSplitTimeSeconds] and [latestSetSplitTimeSeconds].
  void moveToNextSetOrSection(int secondsElapsed) {
    final roundTimeTakenSeconds = secondsElapsed - latestRoundSplitTimeSeconds;
    final setTimeTakenSeconds = secondsElapsed - latestSetSplitTimeSeconds;

    if (currentSetIndex >= numberSetsPerRound - 1) {
      /// Moving to the next round.
      /// Update the latest round split time.
      latestRoundSplitTimeSeconds = secondsElapsed;

      /// Add the latest lap times.
      addSectionRoundData(roundTimeTakenSeconds);

      addSectionRoundSetData(setTimeTakenSeconds, roundTimeTakenSeconds);

      currentRoundIndex += 1;
      currentSetIndex = 0;
    } else {
      /// Moving to the next set only.
      addSectionRoundSetData(setTimeTakenSeconds, roundTimeTakenSeconds);

      currentSetIndex += 1;
    }

    /// Update the latest set split time.
    latestSetSplitTimeSeconds = secondsElapsed;
  }

  /// At the [currentRoundIndex] add [timeTakenSeconds]
  /// Add new WorkoutSectionRoundData object ready for the next rounds data.
  void addSectionRoundData(int roundTimeTakenSeconds) {
    sectionData.rounds[currentRoundIndex].timeTakenSeconds =
        roundTimeTakenSeconds;
    sectionData.rounds.add(WorkoutSectionRoundData()
      ..sets = []
      ..timeTakenSeconds = 0);
  }

  /// At the [currentRoundIndex] and [currentSetIndex]
  /// [roundTimeTakenSeconds] = so far for this round.
  void addSectionRoundSetData(
      int setTimeTakenSeconds, int roundTimeTakenSeconds) {
    /// Add the latest round split time to the current round.
    /// So that the round timetaken should be equal to the sum of all the logged set timeTakenMs.
    sectionData.rounds[currentRoundIndex].timeTakenSeconds =
        roundTimeTakenSeconds;

    /// Then create and add the new set data.
    final workoutSet = workoutSection.workoutSets[currentSetIndex];
    final setData = loggedWorkoutSetDataFromWorkoutSet(
        workoutSet, workoutSection.workoutSectionType,
        timeTakenseconds: setTimeTakenSeconds);

    sectionData.rounds[currentRoundIndex].sets.add(setData);
  }

  /// For Free Sessions. Run this whenever a set is marked complete or incomplete.
  void updateSectionRoundSetDataFromCompletedSets(
      List<WorkoutSet> completedSets) {
    sectionData.rounds[currentRoundIndex].sets = completedSets
        .map((wSet) => loggedWorkoutSetDataFromWorkoutSet(
            wSet, workoutSection.workoutSectionType))
        .toList();
  }

  void moveToNextSet() {
    if (currentSetIndex == numberSetsPerRound - 1) {
      currentRoundIndex++;
      currentSetIndex = 0;
    } else {
      currentSetIndex++;
    }
  }

  void moveToNextSection() {
    currentRoundIndex++;
    currentSetIndex = 0;
  }
}
