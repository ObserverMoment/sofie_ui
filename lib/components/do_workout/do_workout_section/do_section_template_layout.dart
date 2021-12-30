import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_submit_button_2.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/section_video_player_screen.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

/// Wrapper around the three section pages for providing a common UI layout.
/// 1. Moves list.
/// 2. Timer page.
/// 3. Video if present.
class DoSectionTemplateLayout extends StatelessWidget {
  final Widget movesList;
  final Widget timer;
  final int activePageIndex;
  final WorkoutSection workoutSection;
  final WorkoutSectionProgressState state;
  const DoSectionTemplateLayout({
    Key? key,
    required this.movesList,
    required this.timer,
    required this.activePageIndex,
    required this.workoutSection,
    required this.state,
  }) : super(key: key);

  double get startResumeButtonHeight => Platform.isAndroid ? 80 : 94;

  @override
  Widget build(BuildContext context) {
    final isRunning = context.select<DoWorkoutBloc, bool>((b) =>
        b.getStopWatchTimerForSection(workoutSection.sortPosition).isRunning);

    return CupertinoPageScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: IndexedStack(
              index: activePageIndex,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: kDoWorkoutWorkoutSectionTopNavHeight),
                    child: movesList,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: kDoWorkoutWorkoutSectionTopNavHeight),
                    child: timer,
                  ),
                ),
                if (Utils.textNotNull(workoutSection.classVideoUri))
                  SectionVideoPlayerScreen(
                    workoutSection: workoutSection,
                    state: state,
                  )
              ],
            ),
          ),

          /// The set complete / start / stop button is always at the bottom of this column and is part of the layout for scored workouts.
          if (workoutSection.isScored && isRunning)
            AnimatedSubmitButtonV2(
              height: startResumeButtonHeight,
              text: 'Set Complete',
              onSubmit: () {
                Vibrate.feedback(FeedbackType.light);
                context.read<DoWorkoutBloc>().markCurrentWorkoutSetAsComplete(
                    workoutSection.sortPosition);
                showCupertinoModalPopup(
                    // Explicitly setting this because we need to ensure [rootNavigator] is true when we pop it below.
                    useRootNavigator: true,
                    context: context,
                    builder: (_) => const Center(
                            child: SizeFadeIn(
                          child: Icon(CupertinoIcons.checkmark_alt,
                              size: 100, color: Styles.white),
                        )));

                Future.delayed(const Duration(seconds: 1),
                    () => context.pop(rootNavigator: true));
              },
              borderRadius: 0,
            )
        ],
      ),
    );
  }
}
