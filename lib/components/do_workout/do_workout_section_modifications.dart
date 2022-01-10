import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_move_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/workout_set_creator/workout_set_definition.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/components/user_input/pickers/round_picker.dart';
import 'package:sofie_ui/components/workout/workout_move_display.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Make modifications to the structure of the section before starting.
class DoWorkoutSectionModifications extends StatelessWidget {
  final int sectionIndex;
  const DoWorkoutSectionModifications({Key? key, required this.sectionIndex})
      : super(key: key);

  /// For ARMAP Only (Sept 2021).
  void _updateSectionTimecap(BuildContext context, int seconds) {
    context
        .read<DoWorkoutBloc>()
        .updateWorkoutSectionTimecap(sectionIndex, seconds);
  }

  void _updateSectionRounds(BuildContext context, int rounds) {
    context
        .read<DoWorkoutBloc>()
        .updateWorkoutSectionRounds(sectionIndex, rounds);
  }

  void _openCreateWorkoutMove(
      {required BuildContext context, required bool hideReps}) {
    context.push(
        fullscreenDialog: true,
        child: WorkoutMoveCreator(
          pageTitle: 'Add Move',
          ignoreReps: hideReps,
          saveWorkoutMove: (workoutMove) {
            context
                .read<DoWorkoutBloc>()
                .addWorkoutMoveToSection(sectionIndex, workoutMove);
          },
          sortPosition: 0,
        ));
  }

  @override
  Widget build(BuildContext context) {
    /// Making changes to a section within [activeWorkout] will cause the controller for that section to run a [reset] function, unless it is a FreeSession.
    final activeWorkoutSection = context.select<DoWorkoutBloc, WorkoutSection>(
        (b) => b.activeWorkout.workoutSections[sectionIndex]);

    final sectionHasStarted = context.select<DoWorkoutBloc, bool>(
        (b) => b.getControllerForSection(sectionIndex).sectionHasStarted);

    return MyPageScaffold(
      navigationBar: MyNavBar(
        backgroundColor: context.theme.background,
        customLeading: NavBarChevronDownButton(context.pop),
        middle: const NavBarTitle(
          'View / Modify',
        ),
      ),
      child: ListView(
        children: [
          MyHeaderText(
            activeWorkoutSection.nameOrTypeForDisplay,
            size: FONTSIZE.four,
            textAlign: TextAlign.center,
          ),
          if (activeWorkoutSection.isTimed)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: MyText(
                'Total Time: ${activeWorkoutSection.timedSectionDuration.displayString}',
                textAlign: TextAlign.center,
              ),
            ),
          GrowInOut(
            show: sectionHasStarted && !activeWorkoutSection.isCustomSession,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(CupertinoIcons.exclamationmark_circle,
                          color: Styles.errorRed, size: 18),
                      SizedBox(width: 6),
                      MyText(
                        'You have already started this section.',
                        size: FONTSIZE.two,
                        maxLines: 3,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const MyText(
                    'Making any modifications now will cause the section to reset.',
                    size: FONTSIZE.two,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (activeWorkoutSection.roundsInputAllowed)
                  ContentBox(
                    child: RoundPicker(
                      rounds: activeWorkoutSection.rounds,
                      saveValue: (rounds) =>
                          _updateSectionRounds(context, rounds),
                    ),
                  ),
                if (activeWorkoutSection.isAMRAP)
                  ContentBox(
                    child: DurationPickerDisplay(
                      modalTitle: 'AMRAP Timecap',
                      duration: Duration(seconds: activeWorkoutSection.timecap),
                      updateDuration: (duration) =>
                          _updateSectionTimecap(context, duration.inSeconds),
                    ),
                  ),
              ],
            ),
          ),
          ImplicitlyAnimatedList<WorkoutSet>(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            items: activeWorkoutSection.workoutSets,
            itemBuilder: (context, animation, item, index) =>
                SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: animation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: _WorkoutSetEditor(
                  workoutSectionType: activeWorkoutSection.workoutSectionType,
                  sectionIndex: sectionIndex,
                  workoutSet: item,
                ),
              ),
            ),
            areItemsTheSame: (a, b) => a == b,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CreateTextIconButton(
                text: 'Add Move',
                onPressed: () => _openCreateWorkoutMove(
                    context: context, hideReps: activeWorkoutSection.isTimed)),
          ),
        ],
      ),
    );
  }
}

/// A stripped back version of WorkoutSetCreator specifically for use before a user starts a workout for making some basic modifications.
class _WorkoutSetEditor extends StatelessWidget {
  final int sectionIndex;
  final WorkoutSet workoutSet;
  final WorkoutSectionType workoutSectionType;
  const _WorkoutSetEditor({
    required this.workoutSet,
    required this.workoutSectionType,
    required this.sectionIndex,
  });

  void _updateSetDuration(BuildContext context, Duration duration) {
    context.read<DoWorkoutBloc>().updateWorkoutSetDuration(
        sectionIndex, workoutSet.sortPosition, duration.inSeconds);
  }

  void _openEditWorkoutMove(
      {required BuildContext context,
      required WorkoutMove workoutMove,
      required bool hideReps}) {
    context.push(
        fullscreenDialog: true,
        child: WorkoutMoveCreator(
          pageTitle: 'Modify Move',
          workoutMove: workoutMove,
          ignoreReps: hideReps,
          saveWorkoutMove: (workoutMove) {
            context.read<DoWorkoutBloc>().updateWorkoutMove(
                sectionIndex, workoutSet.sortPosition, workoutMove);
          },
          sortPosition: workoutMove.sortPosition,
        ));
  }

  void _confirmRemoveWorkoutSet(BuildContext context) {
    context.showConfirmDeleteDialog(
        itemType: 'Workout Set',
        onConfirm: () => _removeWorkoutSetFromSection(context));
  }

  void _removeWorkoutSetFromSection(BuildContext context) {
    context
        .read<DoWorkoutBloc>()
        .removeWorkoutSetFromSection(sectionIndex, workoutSet.sortPosition);
  }

  @override
  Widget build(BuildContext context) {
    // Don't show reps when user is doing a timed workout and when there is only one move in the set.
    // The user will just do single workout move for as long as workoutSet.duration, so reps are ignored.
    final showReps = workoutSectionType.showReps(workoutSet);

    return ContentBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (workoutSectionType.isTimed)
                    CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        onPressed: () => context.showBottomSheet(
                            expand: false,
                            child: WorkoutSetDurationPicker(
                                allowCopyToAll: false,
                                duration:
                                    Duration(seconds: workoutSet.duration),
                                updateDuration: (duration, _) =>
                                    _updateSetDuration(context, duration))),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.timer, size: 18),
                            const SizedBox(width: 5),
                            MyText(
                              Duration(seconds: workoutSet.duration)
                                  .displayString,
                              size: FONTSIZE.four,
                            )
                          ],
                        )),
                  if (!workoutSet.isRestSet)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: WorkoutSetDefinition(workoutSet: workoutSet),
                    ),
                ],
              ),
              if (workoutSet.isRestSet)
                const MyText(
                  'REST',
                  size: FONTSIZE.four,
                ),
              GestureDetector(
                  onTap: () => _confirmRemoveWorkoutSet(context),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(
                      CupertinoIcons.delete,
                      size: 20,
                    ),
                  )),
            ],
          ),
          Column(
            children: workoutSet.workoutMoves
                .mapIndexed((i, wm) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openEditWorkoutMove(
                        context: context, workoutMove: wm, hideReps: !showReps),
                    child: WorkoutMoveDisplay(wm, showReps: showReps)))
                .toList(),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
