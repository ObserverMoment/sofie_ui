import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/countdown_animation.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';

class StartResumeButton extends StatefulWidget {
  final int sectionIndex;
  const StartResumeButton({Key? key, required this.sectionIndex})
      : super(key: key);

  @override
  State<StartResumeButton> createState() => _StartResumeButtonState();
}

class _StartResumeButtonState extends State<StartResumeButton> {
  bool _countdownStarted = false;

  /// Runs a countdown animation and THEN starts the workout.
  void _startSectionCountdown(
      BuildContext context, bool isFreeSessionOrLifting) {
    final bloc = context.read<DoWorkoutBloc>();
    final playSection = bloc.playSection;

    if (isFreeSessionOrLifting) {
      playSection(widget.sectionIndex);
    } else {
      setState(() => _countdownStarted = true);

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
                  playSection(widget.sectionIndex);
                },
                startFromSeconds: countdownToStartSeconds);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionHasStarted = context.select<DoWorkoutBloc, bool>((b) =>
        b.getControllerForSection(widget.sectionIndex).sectionHasStarted);

    /// No countdown required for a free session.
    final isFreeSessionOrLifting = context.select<DoWorkoutBloc, bool>((b) {
      return b.activeWorkout.workoutSections[widget.sectionIndex]
              .isFreeSession ||
          b.activeWorkout.workoutSections[widget.sectionIndex].isLifting;
    });

    return GestureDetector(
      onTap: () => sectionHasStarted
          ? context.read<DoWorkoutBloc>().playSection(widget.sectionIndex)
          : _startSectionCountdown(context, isFreeSessionOrLifting),
      child: _countdownStarted
          ? null
          : AnimatedContainer(
              width: 180,
              height: 180,
              alignment: Alignment.center,
              duration: kStandardAnimationDuration,
              decoration: BoxDecoration(
                boxShadow: kElevation[5],
                shape: BoxShape.circle,
                gradient: sectionHasStarted
                    ? Styles.secondaryButtonGradient
                    : Styles.primaryAccentGradient,
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
