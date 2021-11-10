import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';

class DoWorkoutUtils {
  static bool moveIsCompleted(WorkoutSectionProgressState state,
      int moveRoundNumber, int moveSetIndex) {
    return state.currentRoundIndex > moveRoundNumber ||
        (state.currentRoundIndex == moveRoundNumber &&
            state.currentSetIndex > moveSetIndex);
  }
}
