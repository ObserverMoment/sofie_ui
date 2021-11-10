import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/countdown_animation.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';

class StartResumeButton extends StatelessWidget {
  final int sectionIndex;
  final double height;
  const StartResumeButton(
      {Key? key, required this.sectionIndex, required this.height})
      : super(key: key);

  /// Runs a countdown animation and THEN starts the workout.
  void _startSectionCountdown(BuildContext context, bool isFreeSession) {
    final bloc = context.read<DoWorkoutBloc>();
    final playSection = bloc.playSection;

    if (isFreeSession) {
      playSection(sectionIndex);
    } else {
      /// Save refs before pushing route which will have new context which will not have access to [DoWorkoutBloc].
      final countdownToStartSeconds = bloc.countdownToStartSeconds;

      showCupertinoModalPopup(
          context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (modalContext) {
            return CountdownAnimation(
                bloc: bloc,
                onCountdownEnd: () {
                  modalContext.pop();
                  playSection(sectionIndex);
                },
                startFromSeconds: countdownToStartSeconds);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionHasStarted = context.select<DoWorkoutBloc, bool>(
        (b) => b.getControllerForSection(sectionIndex).sectionHasStarted);

    /// No countdown required for a free session.
    final isFreeSession = context.select<DoWorkoutBloc, bool>(
        (b) => b.activeWorkout.workoutSections[sectionIndex].isFreeSession);

    return GestureDetector(
      onTap: () => sectionHasStarted
          ? context.read<DoWorkoutBloc>().playSection(sectionIndex)
          : _startSectionCountdown(context, isFreeSession),
      child: AnimatedContainer(
        duration: kStandardAnimationDuration,
        height: height,
        decoration: BoxDecoration(
          gradient: sectionHasStarted
              ? Styles.secondaryButtonGradient
              : Styles.primaryAccentGradient,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.play,
              color: Styles.white,
            ),
            const SizedBox(width: 6),
            MyText(sectionHasStarted ? 'RESUME' : 'START',
                color: Styles.white, size: FONTSIZE.five)
          ],
        ),
      ),
    );
  }
}
