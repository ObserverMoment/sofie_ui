import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/name_and_repscore.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/now_and_next_moves_timer.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/timers/radial_countdown_timer.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

/// Counts up from zero. The circle fills as the time approaches the timecap.
/// For AMRAP it will be the end of the workout.
class AMRAPTimer extends StatelessWidget {
  final WorkoutSectionProgressState state;
  final WorkoutSection workoutSection;
  const AMRAPTimer(
      {Key? key, required this.state, required this.workoutSection})
      : super(key: key);

  void _handlePlayPause(BuildContext context, bool isRunning) {
    if (isRunning) {
      context.read<DoWorkoutBloc>().pauseSection(workoutSection.sortPosition);
    } else {
      context.read<DoWorkoutBloc>().playSection(workoutSection.sortPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = context.select<DoWorkoutBloc, bool>((b) =>
        b.getStopWatchTimerForSection(workoutSection.sortPosition).isRunning);

    final hasStarted = context.select<DoWorkoutBloc, bool>((b) => b
        .getControllerForSection(workoutSection.sortPosition)
        .sectionHasStarted);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handlePlayPause(context, isRunning),
      child: StreamBuilder<int>(
        initialData: 0,
        stream: context
            .read<DoWorkoutBloc>()
            .getStopWatchTimerForSection(workoutSection.sortPosition)
            .secondTime,
        builder: (context, AsyncSnapshot<int> snapshot) {
          final secondsElapsed = snapshot.data!;

          /// Get the display time.
          final overAnHour = secondsElapsed > 3600;
          final displayTime = StopWatchTimer.getDisplayTime(
              secondsElapsed * 1000,
              milliSecond: false,
              hours: overAnHour);

          final remainingTime = StopWatchTimer.getDisplayTime(
              state.secondsToNextCheckpoint! * 1000,
              milliSecond: false,
              hours: overAnHour);

          return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //   child: Row(
                        //     children: [
                        //       NameAndRepScore(workoutSection: workoutSection)
                        //     ],
                        //   ),
                        // ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            RadialCountdownTimer(
                              size: constraints.maxWidth / 1.6,
                              value: state.percentComplete,
                              progressColor: Styles.primaryAccent,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const MyText(
                                  'Elapsed',
                                  subtext: true,
                                  size: FONTSIZE.one,
                                ),
                                const SizedBox(height: 4),
                                MyText(
                                  displayTime,
                                  size: FONTSIZE.nine,
                                  lineHeight: 1,
                                ),
                                const SizedBox(height: 4),
                                Opacity(
                                  opacity: hasStarted ? 1 : 0.0,
                                  child: MyText(
                                    'Tap to ${isRunning ? "pause" : "play"}',
                                    size: FONTSIZE.two,
                                    lineHeight: 1,
                                    subtext: true,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const MyText(
                              'Remaining',
                              subtext: true,
                              size: FONTSIZE.two,
                            ),
                            const SizedBox(height: 2),
                            MyText(
                              remainingTime,
                              size: FONTSIZE.six,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NowAndNextMovesTimer(
                              workoutSection: workoutSection),
                        ),
                      ],
                    ),
                  ));
        },
      ),
    );
  }
}
