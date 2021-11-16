import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/name_and_repscore.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/now_and_next_moves.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/workout_section_simple_timer.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/timers/radial_countdown_timer.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MainVideoOverlay extends StatelessWidget {
  final WorkoutSection workoutSection;
  final WorkoutSectionProgressState state;
  const MainVideoOverlay(
      {Key? key, required this.workoutSection, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workoutSectionTypeName = workoutSection.workoutSectionType.name;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _VideoOverlayContainer(
              child: NameAndRepScore(workoutSection: workoutSection),
            ),
            if (workoutSectionTypeName == kForTimeName)
              _VideoOverlayContainer(
                  child: WorkoutSectionSimpleTimer(
                      workoutSection: workoutSection, fontSize: FONTSIZE.six))
            else
              _CircleTimerDisplay(
                workoutSection: workoutSection,
                state: state,
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: NowAndNextMoves(
            workoutSection: workoutSection,
            qty: 2,
            center: false,
          ),
        ),
      ],
    );
  }
}

/// Use for timed sections and for AMRAPs only.
/// For timed sections the checkpoint is the set the user is on.
/// For AMRAP the checkpoint is the timecap.
class _CircleTimerDisplay extends StatelessWidget {
  final WorkoutSection workoutSection;
  final WorkoutSectionProgressState state;
  const _CircleTimerDisplay(
      {Key? key, required this.workoutSection, required this.state})
      : super(key: key);

  /// Set.duration if timed workout or section timecap if AMRAP.
  int get _currentCheckpointLength => workoutSection.isTimed
      ? workoutSection.workoutSets[state.currentSetIndex].duration
      : workoutSection.timecap;

  @override
  Widget build(BuildContext context) {
    final secondsToNextCheckpoint = context.select<DoWorkoutBloc, int>((b) => b
        .getControllerForSection(workoutSection.sortPosition)
        .state
        .secondsToNextCheckpoint!);

    /// Get the display time.
    final overAnHour = secondsToNextCheckpoint > 3600;
    final displayTime = StopWatchTimer.getDisplayTime(
        secondsToNextCheckpoint * 1000,
        milliSecond: false,
        hours: overAnHour);

    return Stack(
      alignment: Alignment.center,
      children: [
        RadialCountdownTimer(
            size: 80,
            value: (1 - (secondsToNextCheckpoint / _currentCheckpointLength))
                .clamp(0.0, 1.0),
            fullBackground: true,
            progressColor: Styles.secondaryAccent,
            backgroundColor: Styles.secondaryAccent.withOpacity(0.3)),
        MyText(
          displayTime,
          size: FONTSIZE.five,
        ),
      ],
    );
  }
}

/// A semi opaque background so that text etc can be seen against a video background.
class _VideoOverlayContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _VideoOverlayContainer(
      {Key? key, required this.child, this.padding = kDefaultTagPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.theme.cardBackground.withOpacity(0.3)),
      child: child,
    );
  }
}
