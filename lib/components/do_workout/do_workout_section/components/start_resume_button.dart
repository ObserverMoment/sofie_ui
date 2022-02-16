import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/countdown_animation.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';

class StartResumeButton extends StatelessWidget {
  final int sectionIndex;
  const StartResumeButton({Key? key, required this.sectionIndex})
      : super(key: key);

  /// Runs a countdown animation and THEN starts the workout.
  void _startSectionCountdown(
      BuildContext context, bool isFreeSessionOrLifting) {
    Vibrate.feedback(FeedbackType.light);

    final bloc = context.read<DoWorkoutBloc>();
    final playSection = bloc.playSection;

    if (isFreeSessionOrLifting) {
      playSection(sectionIndex);
    } else {
      /// Save refs before pushing route which will have new context which will not have access to [DoWorkoutBloc].
      final countdownToStartSeconds =
          bloc.userWorkoutSettingsBloc.settings.countdownToStartSeconds;

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
    final isFreeSessionOrLifting = context.select<DoWorkoutBloc, bool>((b) {
      return b.activeWorkout.workoutSections[sectionIndex].isCustomSession ||
          b.activeWorkout.workoutSections[sectionIndex].isLifting;
    });

    return GestureDetector(
      onTap: sectionHasStarted
          ? () {
              Vibrate.feedback(FeedbackType.light);
              context.read<DoWorkoutBloc>().playSection(sectionIndex);
            }
          : () => _startSectionCountdown(context, isFreeSessionOrLifting),
      child: Container(
        width: 160,
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: kElevation[5],
          shape: BoxShape.circle,
          gradient: Styles.primaryAccentGradient,
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Icon(
            CupertinoIcons.play_fill,
            color: Styles.white,
            size: 70,
          ),
        ),
      ),
    );
  }
}
