import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/abstract_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/amrap_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/fortime_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section_modifications.dart';
import 'package:sofie_ui/components/do_workout/do_workout_settings.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/model/client_only_model.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:auto_route/auto_route.dart';

class DoWorkoutOverview extends StatelessWidget {
  final VoidCallback handleExitRequest;
  final void Function(int sectionIndex) navigateToSectionPage;
  final VoidCallback generateLog;
  const DoWorkoutOverview(
      {Key? key,
      required this.handleExitRequest,
      required this.navigateToSectionPage,
      required this.generateLog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numWorkoutSections = context.select<DoWorkoutBloc, int>(
        (b) => b.activeWorkout.workoutSections.length);

    final workout =
        context.select<DoWorkoutBloc, Workout>((b) => b.activeWorkout);

    return CupertinoPageScaffold(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (workout.coverImageUri != null)
            SizedUploadcareImage(workout.coverImageUri!)
          else
            Image.asset(
              'assets/placeholder_images/workout.jpg',
              fit: BoxFit.cover,
            ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [
                    0.0,
                    0.35,
                    1.0
                  ],
                      colors: [
                    Styles.black.withOpacity(0.95),
                    Styles.black.withOpacity(0.6),
                    Styles.black.withOpacity(0.3),
                  ])),
            ),
          ),
          Column(
            children: [
              _TopNavBar(
                  handleExitRequest: handleExitRequest,
                  generateLog: generateLog),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: _WorkoutIntroSummaryCard(
                          workout: workout, generateLog: generateLog),
                    ),
                    ...List.generate(
                        numWorkoutSections,
                        (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: _WorkoutSectionSummary(
                                  sectionIndex: index,
                                  navigateToSectionPage: () =>
                                      navigateToSectionPage(index)),
                            )),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkoutIntroSummaryCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback generateLog;
  const _WorkoutIntroSummaryCard(
      {Key? key, required this.workout, required this.generateLog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        padding: const EdgeInsets.all(12),
        backgroundColor: context.theme.cardBackground.withOpacity(0.95),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: MyHeaderText(
                workout.name,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            if (Utils.textNotNull(workout.description))
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ReadMoreTextBlock(
                  text: workout.description!,
                  title: workout.name,
                  textAlign: TextAlign.center,
                ),
              ),
            if (Utils.anyNotNull(
                [workout.introAudioUri, workout.introVideoUri]))
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (Utils.textNotNull(workout.introVideoUri))
                      _TopNavBarIcon(
                        iconData: CupertinoIcons.tv,
                        label: 'Intro Video',
                        onPressed: () =>
                            VideoSetupManager.openFullScreenVideoPlayer(
                                context: context,
                                videoUri: workout.introVideoUri!,
                                videoThumbUri: workout.introVideoThumbUri,
                                autoPlay: true,
                                autoLoop: true),
                      ),
                    if (Utils.textNotNull(workout.introAudioUri))
                      _TopNavBarIcon(
                        iconData: CupertinoIcons.headphones,
                        label: 'Intro Audio',
                        onPressed: () => AudioPlayerController.openAudioPlayer(
                            context: context,
                            audioUri: workout.introAudioUri!,
                            audioTitle: workout.name,
                            pageTitle: 'Intro Audio',
                            autoPlay: true),
                      ),
                  ],
                ),
              ),
          ],
        ));
  }
}

class _TopNavBar extends StatelessWidget {
  final VoidCallback handleExitRequest;
  final VoidCallback generateLog;
  const _TopNavBar(
      {Key? key, required this.handleExitRequest, required this.generateLog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final safeTopPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: safeTopPadding),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _TopNavBarIcon(
              iconData: CupertinoIcons.clear_thick,
              label: 'Exit',
              onPressed: handleExitRequest,
            ),
            _TopNavBarIcon(
                iconData: CupertinoIcons.settings,
                label: 'Settings',
                onPressed: () {
                  final _bloc = context.read<DoWorkoutBloc>();
                  context.push(
                      fullscreenDialog: true,
                      child: ChangeNotifierProvider<DoWorkoutBloc>.value(
                        value: _bloc,
                        child: const DoWorkoutSettings(),
                      ));
                }),
            _TopNavBarIcon(
              iconData: CupertinoIcons.text_badge_checkmark,
              label: 'Log It',
              onPressed: generateLog,
            ),
            _TopNavBarIcon(
              iconData: CupertinoIcons.timer,
              label: 'Timer',
              onPressed: () => context.navigateTo(const TimersRoute()),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopNavBarIcon extends StatelessWidget {
  final IconData iconData;
  final String label;
  final VoidCallback onPressed;
  const _TopNavBarIcon({
    Key? key,
    required this.iconData,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.theme.cardBackground.withOpacity(0.95),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Column(
          children: [
            Icon(iconData),
            const SizedBox(height: 2),
            MyText(label, size: FONTSIZE.one)
          ],
        ),
      ),
    );
  }
}

class _WorkoutSectionSummary extends StatelessWidget {
  final int sectionIndex;
  final VoidCallback navigateToSectionPage;
  const _WorkoutSectionSummary(
      {Key? key,
      required this.sectionIndex,
      required this.navigateToSectionPage})
      : super(key: key);

  void _confirmResetSection(BuildContext context, DoWorkoutBloc bloc) {
    context.showConfirmDialog(
        title: 'Reset Section?',
        onConfirm: () {
          bloc.resetSection(sectionIndex);
        });
  }

  String _repScoreText(WorkoutSectionController controller) {
    if (controller.workoutSection.isAMRAP) {
      return '${(controller as AMRAPSectionController).repsCompleted} reps';
    } else if (controller.workoutSection.isForTime) {
      return '${(controller as ForTimeSectionController).repsCompleted} reps';
    } else {
      return '';
    }
  }

  /// AMRAP / ForTime: Number of reps + Percentage complete.
  /// Others: Percentage complete.
  Widget _sectionDisplayTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: Styles.secondaryButtonGradient,
          boxShadow: kElevation[3]),
      child: MyText(
        text,
        color: Styles.white,
      ),
    );
  }

  Widget _buildProgressDisplay(
      WorkoutSectionController controller, double percentComplete) {
    final percent = (percentComplete * 100).round();
    final complete = percent >= 100;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (controller.workoutSection.isScored)
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: _sectionDisplayTag(_repScoreText(controller)),
          ),
        _sectionDisplayTag('$percent%'),
        if (complete)
          const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Icon(
              CupertinoIcons.checkmark_alt_circle,
              color: Styles.primaryAccent,
            ),
          )
      ],
    );
  }

  Widget _buildSectionFooterButton(
      IconData iconData, String label, VoidCallback onPressed,
      {bool disabled = false}) {
    return AnimatedOpacity(
      duration: kStandardAnimationDuration,
      opacity: disabled ? 0.3 : 1,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: disabled ? null : onPressed,
        child: Column(
          children: [
            Row(
              children: [
                MyText(
                  label,
                  size: FONTSIZE.two,
                ),
                const SizedBox(width: 6),
                Icon(
                  iconData,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DoWorkoutBloc>();

    final controller = context.select<DoWorkoutBloc, WorkoutSectionController>(
        (b) => b.getControllerForSection(sectionIndex));

    /// TODO: May be unreliable as this state object is usually broadcast via a stream.
    /// We seemto be getting correct values from this at the correct time because of some other change (play / pause of section?) triggering the listener.
    final percentComplete = context.select<DoWorkoutBloc, double>(
        (b) => b.getControllerForSection(sectionIndex).state.percentComplete);

    final workoutSection = context.select<DoWorkoutBloc, WorkoutSection>(
        (b) => b.getControllerForSection(sectionIndex).workoutSection);

    final isComplete = context.select<DoWorkoutBloc, bool>((b) =>
        b.getControllerForSection(workoutSection.sortPosition).sectionComplete);

    final hasStarted = context.select<DoWorkoutBloc, bool>((b) => b
        .getControllerForSection(workoutSection.sortPosition)
        .sectionHasStarted);

    final List<EquipmentWithLoad> equipmentsWithLoad =
        workoutSection.equipmentsWithLoad;

    return Card(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      backgroundColor: context.theme.cardBackground.withOpacity(0.95),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WorkoutSectionTypeTag(
                workoutSection: workoutSection,
                fontSize: FONTSIZE.four,
                withBackground: false,
                fontColor: Styles.primaryAccent,
              ),
              AnimatedSwitcher(
                duration: kStandardAnimationDuration,
                child: (isComplete || hasStarted)
                    ? _buildProgressDisplay(controller, percentComplete)
                    : Container(),
              ),
            ],
          ),
          if (Utils.textNotNull(workoutSection.name))
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: MyHeaderText(
                workoutSection.name!,
                weight: FontWeight.normal,
              ),
            ),
          if (Utils.textNotNull(workoutSection.note))
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ReadMoreTextBlock(
                text: workoutSection.note!,
                title: 'Section Note',
              ),
            ),
          if (equipmentsWithLoad.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: equipmentsWithLoad
                    .sorted((a, b) {
                      if (a.equipment.name == b.equipment.name) {
                        return (a.loadAmount ?? 0).compareTo(b.loadAmount ?? 0);
                      } else {
                        return a.equipment.name.compareTo(b.equipment.name);
                      }
                    })
                    .map((e) =>
                        MyText(_getEquipmentWithLoadTag(e), lineHeight: 1.4))
                    .toList(),
              ),
            ),
          if (Utils.anyNotNull(
              [workoutSection.introAudioUri, workoutSection.introVideoUri]))
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (Utils.textNotNull(workoutSection.introVideoUri))
                    _TopNavBarIcon(
                      iconData: CupertinoIcons.tv,
                      label: 'Intro Video',
                      onPressed: () =>
                          VideoSetupManager.openFullScreenVideoPlayer(
                              context: context,
                              videoUri: workoutSection.introVideoUri!,
                              videoThumbUri: workoutSection.introVideoThumbUri,
                              autoPlay: true,
                              autoLoop: true),
                    ),
                  if (Utils.textNotNull(workoutSection.introAudioUri))
                    _TopNavBarIcon(
                      iconData: CupertinoIcons.headphones,
                      label: 'Intro Audio',
                      onPressed: () => AudioPlayerController.openAudioPlayer(
                          context: context,
                          audioUri: workoutSection.introAudioUri!,
                          audioTitle: workoutSection.nameOrTypeForDisplay,
                          pageTitle: 'Intro Audio',
                          autoPlay: true),
                    ),
                ],
              ),
            ),
          const HorizontalLine(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSectionFooterButton(
                  CupertinoIcons.list_bullet,
                  'View / Modify',
                  () => context.push(
                        fullscreenDialog: true,
                        child: ChangeNotifierProvider<DoWorkoutBloc>.value(
                          value: bloc,
                          child: DoWorkoutSectionModifications(
                              sectionIndex: workoutSection.sortPosition),
                        ),
                      )),
              if (isComplete)
                _buildSectionFooterButton(
                  CupertinoIcons.refresh_bold,
                  'Reset',
                  () => _confirmResetSection(context, bloc),
                )
              else if (hasStarted)
                _buildSectionFooterButton(
                  CupertinoIcons.play,
                  'Continue',
                  navigateToSectionPage,
                )
              else
                _buildSectionFooterButton(
                  CupertinoIcons.play,
                  'Do It',
                  navigateToSectionPage,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

String _getEquipmentWithLoadTag(EquipmentWithLoad equipmentWithLoad) {
  final name = equipmentWithLoad.equipment.name;
  final isDumbbells = name == 'Dumbbells (x2)';
  final isKettleBells = name == 'Kettlebells (x2)';
  final individualLoadAmount = isDumbbells || isKettleBells
      ? (equipmentWithLoad.loadAmount! / 2)
      : equipmentWithLoad.loadAmount;

  final load = individualLoadAmount != null
      ? '${individualLoadAmount.stringMyDouble()} ${equipmentWithLoad.loadUnit.display} '
      : '';

  return '$load$name';
}
