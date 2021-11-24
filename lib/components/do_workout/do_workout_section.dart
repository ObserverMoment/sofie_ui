import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/abstract_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/amrap_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/fortime_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/moves_lists/lifting_moves_list.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/moves_lists/main_moves_list.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/timers/amrap_timer.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/timers/fortime_timer.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/timers/interval_timer.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/do_section_template_layout.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/do_workout_section_nav.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/paused_workout_overlay.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/timers/stopwatch_and_timer.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class DoWorkoutSection extends StatefulWidget {
  @override
  final Key key;
  final int sectionIndex;
  const DoWorkoutSection({
    required this.key,
    required this.sectionIndex,
  }) : super(key: key);

  @override
  _DoWorkoutSectionState createState() => _DoWorkoutSectionState();
}

class _DoWorkoutSectionState extends State<DoWorkoutSection> {
  late DoWorkoutBloc _bloc;

  /// 0 = Moves list. This is always displayed, regardless of workout type.
  /// 1 = Timer / stopwatch page. Always displays but for different uses.
  /// AMRAP = countdown to end. ForTime = large counting up clock. Free Session = countdown timer.
  /// HIITCircuit / EMOM = Current set countdown. Tabata = 20s then 10s.
  /// 2 = Video - if present.
  int _activePageIndex = 0;

  bool _muteAudio = false;

  bool _openCompleteModal = false;

  void _checkForComplete() {
    if (_bloc.getControllerForSection(widget.sectionIndex).sectionComplete !=
        _openCompleteModal) {
      setState(() {
        _openCompleteModal =
            _bloc.getControllerForSection(widget.sectionIndex).sectionComplete;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = context.read<DoWorkoutBloc>();

    /// Listener for section complete.
    /// Pushes a dialog with some options.
    _bloc.addListener(_checkForComplete);
  }

  void _goToPage(int index) {
    setState(() => _activePageIndex = index);
  }

  void _handleResetRequest() {
    context.showConfirmDialog(
      title: 'Reset Section?',
      onConfirm: () {
        context.read<DoWorkoutBloc>().resetSection(widget.sectionIndex);
      },
    );
  }

  void _toggleMuteAudio() {
    /// get the audio player and mute / unmute it.
    final player = context
        .read<DoWorkoutBloc>()
        .getAudioPlayerForSection(widget.sectionIndex);

    if (player != null) {
      final isMuted = player.volume == 0.0;
      player.setVolume(isMuted ? 1.0 : 0.0);
      setState(() => _muteAudio = !_muteAudio);
    }
  }

  /// Only valid for scored types.
  String _repScoreText(WorkoutSectionController controller) {
    if (controller.workoutSection.isAMRAP) {
      return '${(controller as AMRAPSectionController).repsCompleted} reps';
    } else if (controller.workoutSection.isForTime) {
      return '${(controller as ForTimeSectionController).repsCompleted} reps';
    } else {
      return '';
    }
  }

  Widget _buildSectionCompleteDialog() {
    final bloc = context.read<DoWorkoutBloc>();
    final controller = bloc.getControllerForSection(widget.sectionIndex);
    final timer = bloc.getStopWatchTimerForSection(widget.sectionIndex);

    return Align(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CupertinoActionSheet(
        title: const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: MyHeaderText('SECTION COMPLETE', textAlign: TextAlign.center),
        ),
        message: Column(
          children: [
            const MyText(
              'GREAT WORK!',
              color: Styles.primaryAccent,
              size: FONTSIZE.four,
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: context.theme.background.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.workoutSection.isScored)
                    Column(
                      children: [
                        MyText(
                          _repScoreText(controller),
                          size: FONTSIZE.six,
                          weight: FontWeight.bold,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: MyText('in', subtext: true),
                        ),
                      ],
                    ),
                  MyText(
                    timer.secondTime.value.secondsToTimeDisplay,
                    size: FONTSIZE.six,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: PrimaryButton(
                onPressed: context.pop,
                prefixIconData: CupertinoIcons.arrow_left,
                text: 'To Overview',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: PrimaryButton(
                onPressed: () {
                  context.showConfirmDialog(
                      title: 'Reset section?',
                      onConfirm: () => _bloc.resetSection(widget.sectionIndex));
                },
                prefixIconData: CupertinoIcons.refresh_bold,
                text: 'Reset Section',
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _bloc.removeListener(_checkForComplete);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutSection = context.select<DoWorkoutBloc, WorkoutSection>(
        (b) => b.activeWorkout.workoutSections[widget.sectionIndex]);

    final initialState =
        context.select<DoWorkoutBloc, WorkoutSectionProgressState>(
            (b) => b.getProgressStateForSection(widget.sectionIndex));

    final audioController = context.select<DoWorkoutBloc, AudioPlayer?>(
        (b) => b.getAudioPlayerForSection(widget.sectionIndex));

    final isRunning = context.select<DoWorkoutBloc, bool>(
        (b) => b.getStopWatchTimerForSection(widget.sectionIndex).isRunning);

    final hasStarted = context.select<DoWorkoutBloc, bool>((b) =>
        b.getControllerForSection(widget.sectionIndex).sectionHasStarted);

    return StreamBuilder<WorkoutSectionProgressState>(
        initialData: initialState,
        stream: context
            .read<DoWorkoutBloc>()
            .getProgressStreamForSection(widget.sectionIndex),
        builder: (context, snapshot) {
          final state = snapshot.data!;
          return Stack(
            children: [
              _DoSectionTemplateSelector(
                workoutSection: workoutSection,
                state: state,
                activePageIndex: _activePageIndex,
              ),

              /// Render ModalBarrier and StartResumeButton when workout is paused.
              if (!isRunning && !_openCompleteModal)
                ModalBarrier(
                  color: Styles.black.withOpacity(0.4),
                  dismissible: false,
                ),
              if (!isRunning && !_openCompleteModal)
                FadeInUp(
                  child: Align(
                      alignment: Alignment.center,
                      child: PausedWorkoutOverlay(
                        workoutSection: workoutSection,
                      )),
                ),

              /// Top nav items.
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          AnimatedSwitcher(
                            duration: kStandardAnimationDuration,
                            child: isRunning
                                ? NavItem(
                                    activeIconData: CupertinoIcons.pause_fill,
                                    inactiveIconData: CupertinoIcons.pause_fill,
                                    isActive: true,
                                    onTap: () => context
                                        .read<DoWorkoutBloc>()
                                        .pauseSection(widget.sectionIndex))
                                : Row(
                                    children: [
                                      NavItem(
                                          activeIconData:
                                              CupertinoIcons.arrow_left,
                                          inactiveIconData:
                                              CupertinoIcons.arrow_left,
                                          isActive: true,
                                          // Pause section and pop back to the overview page.
                                          onTap: () {
                                            context
                                                .read<DoWorkoutBloc>()
                                                .pauseSection(
                                                    widget.sectionIndex);
                                            context.pop();
                                          }),
                                      // Don't show reset button for a FreeSession
                                      if (!workoutSection.isCustomSession &&
                                          hasStarted)
                                        NavItem(
                                            activeIconData:
                                                CupertinoIcons.refresh_bold,
                                            inactiveIconData:
                                                CupertinoIcons.refresh_bold,
                                            isActive: true,
                                            onTap: _handleResetRequest),
                                    ],
                                  ),
                          ),
                          // Display a 'Finish' button for untimed workouts where 'completing' it is not necessary.
                          if (workoutSection.isCustomSession ||
                              workoutSection.isLifting)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: TertiaryButton(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                backgroundColor: context.theme.primary,
                                textColor: context.theme.background,
                                fontSize: FONTSIZE.three,
                                text: 'Finish',
                                onPressed: () {
                                  // Pause and return to overview.
                                  context.read<DoWorkoutBloc>().pauseSection(
                                      workoutSection.sortPosition);
                                  context.pop();
                                },
                              ),
                            ),
                        ],
                      ),
                      FadeIn(
                        child: DoWorkoutSectionNav(
                          activePageIndex: _activePageIndex,
                          goToPage: _goToPage,
                          showVideoTab:
                              Utils.textNotNull(workoutSection.classVideoUri),
                          showAudioTab: audioController != null,
                          muteAudio: _muteAudio,
                          toggleMuteAudio: _toggleMuteAudio,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_openCompleteModal)
                ModalBarrier(
                  color: Styles.black.withOpacity(0.4),
                  dismissible: false,
                ),
              if (_openCompleteModal)
                FadeInUp(child: _buildSectionCompleteDialog()),
            ],
          );
        });
  }
}

class _DoSectionTemplateSelector extends StatelessWidget {
  final WorkoutSection workoutSection;
  final WorkoutSectionProgressState state;
  final int activePageIndex;
  const _DoSectionTemplateSelector(
      {Key? key,
      required this.workoutSection,
      required this.state,
      required this.activePageIndex})
      : super(key: key);

  Widget _buildMovesList() {
    switch (workoutSection.workoutSectionType.name) {
      case kAMRAPName:
      case kForTimeName:
      case kEMOMName:
      case kTabataName:
      case kHIITCircuitName:
        return MainMovesList(workoutSection: workoutSection, state: state);
      case kLiftingName:
      case kCustomSessionName:
        return LiftingMovesList(workoutSection: workoutSection, state: state);
      default:
        throw Exception(
            'No moves list builder specified for ${workoutSection.workoutSectionType.name}');
    }
  }

  Widget _buildTimer() {
    switch (workoutSection.workoutSectionType.name) {
      case kForTimeName:
        return ForTimeTimer(workoutSection: workoutSection, state: state);
      case kAMRAPName:
        return AMRAPTimer(workoutSection: workoutSection, state: state);
      case kEMOMName:
      case kTabataName:
      case kHIITCircuitName:
        return IntervalTimer(workoutSection: workoutSection, state: state);
      case kCustomSessionName:
      case kLiftingName:
        return const StopwatchAndTimer();
      default:
        throw Exception(
            'No timer builder specified for ${workoutSection.workoutSectionType.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DoSectionTemplateLayout(
      movesList: _buildMovesList(),
      timer: _buildTimer(),
      activePageIndex: activePageIndex,
      state: state,
      workoutSection: workoutSection,
    );
  }
}
