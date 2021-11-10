import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/name_and_repscore.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/now_and_next_moves.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

/// A minute based timer like iOS timer. The outer circles fills over a one minute period.
/// Counts up from zero.
class ForTimeTimer extends StatelessWidget {
  final WorkoutSectionProgressState state;
  final WorkoutSection workoutSection;
  const ForTimeTimer(
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
          final seconds = snapshot.data!;

          /// Get the remaining seconds in the minute.
          final remainingOfCurrentMinute = (seconds % 60) / 60;

          /// Get the display time.
          final overAnHour = seconds > 3600;
          final displayTime = StopWatchTimer.getDisplayTime(seconds * 1000,
              milliSecond: false, hours: overAnHour);

          return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              NameAndRepScore(workoutSection: workoutSection)
                            ],
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 10),
                              child: CircularPercentIndicator(
                                  center: Column(
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
                                  ),
                                  backgroundColor:
                                      context.theme.primary.withOpacity(0.15),
                                  linearGradient:
                                      Styles.secondaryAccentGradient,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  percent: remainingOfCurrentMinute,
                                  radius: constraints.maxWidth / 1.6),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              NowAndNextMoves(workoutSection: workoutSection),
                        ),
                      ],
                    ),
                  ));
        },
      ),
    );
  }
}
