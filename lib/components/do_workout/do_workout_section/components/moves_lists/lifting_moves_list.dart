import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/lifting_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_section_creator/workout_set_generator_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_move_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_set_definition.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/timers/mini_rest_timer.dart';
import 'package:sofie_ui/components/do_workout/do_workout_settings.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/graphql_type_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

/// Using this style list for [Custom] and [Lifting] sections.
/// Both user [LiftingSectionController]
class LiftingMovesList extends StatefulWidget {
  final WorkoutSection workoutSection;
  final WorkoutSectionProgressState state;
  const LiftingMovesList({
    Key? key,
    required this.workoutSection,
    required this.state,
  }) : super(key: key);

  @override
  State<LiftingMovesList> createState() => _LiftingMovesListState();
}

class _LiftingMovesListState extends State<LiftingMovesList> {
  bool _showRestTimer = false;

  Future<void> _openWorkoutSetGeneratorCreator(BuildContext context) async {
    await context.push(
        child: WorkoutSetGeneratorCreator(
      handleGeneratedSet: (workoutSet) {
        context.read<DoWorkoutBloc>().addWorkoutSetToSection(
            widget.workoutSection.sortPosition, workoutSet,
            doNotReset: true);
        context.pop();
      },
      validRepTypes: widget.workoutSection.isCustomSession
          ? []
          : [WorkoutMoveRepType.reps],
      newSetSortPosition: widget.workoutSection.workoutSets.length,
    ));
  }

  void _markWorkoutMoveComplete(
      {required LiftingSectionController controller,
      required WorkoutSet workoutSet,
      required WorkoutMove workoutMove,
      required bool enableAutoRestTimer,
      required int autoRestTimerSeconds}) {
    Vibrate.feedback(FeedbackType.light);
    controller.markWorkoutMoveComplete(workoutSet, workoutMove);
    if (enableAutoRestTimer && autoRestTimerSeconds != 0) {
      setState(() {
        _showRestTimer = true;
      });
    }
  }

  void _closeTimerAndOpenSettings() {
    setState(() {
      _showRestTimer = false;
    });
    final bloc = context.read<DoWorkoutBloc>();
    context.push(
        fullscreenDialog: true,
        child: ChangeNotifierProvider<DoWorkoutBloc>.value(
          value: bloc,
          child: const DoWorkoutSettings(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final enableAutoRestTimer = context.select<DoWorkoutBloc, bool>(
        (b) => b.userWorkoutSettingsBloc.settings.enableAutoRestTimer);

    final autoRestTimerSeconds = context.select<DoWorkoutBloc, int>(
        (b) => b.userWorkoutSettingsBloc.settings.autoRestTimerSeconds);

    final controller = context
            .read<DoWorkoutBloc>()
            .getControllerForSection(widget.workoutSection.sortPosition)
        as LiftingSectionController;

    return ChangeNotifierProvider<LiftingSectionController>.value(
      value: controller,
      builder: (context, child) {
        final completedSetIds =
            context.watch<LiftingSectionController>().completedWorkoutSetIds;

        final completedWorkoutMoveIds =
            controller.completedWorkoutMoveIds.toList();

        return Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        lineHeight: 4,
                        percent: widget.state.percentComplete.clamp(0.0, 1.0),
                        backgroundColor:
                            context.theme.primary.withOpacity(0.07),
                        linearGradient: Styles.primaryAccentGradient,
                        barRadius: const Radius.circular(60),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: MyText(
                        '${(widget.state.percentComplete * 100).round()}%',
                        size: FONTSIZE.two,
                        weight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.workoutSection.workoutSets.length + 1,
                    itemBuilder: (c, i) {
                      if (i == widget.workoutSection.workoutSets.length) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CreateTextIconButton(
                            text: 'Add Set',
                            onPressed: () =>
                                _openWorkoutSetGeneratorCreator(context),
                          ),
                        );
                      } else {
                        final setIsMarkedComplete = completedSetIds
                            .contains(widget.workoutSection.workoutSets[i].id);

                        final workoutSet = widget.workoutSection.workoutSets[i];

                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _WorkoutSetInLiftingSession(
                            workoutSet: workoutSet,
                            setIsMarkedComplete: setIsMarkedComplete,
                            completedWorkoutMoveIds: completedWorkoutMoveIds,
                            sectionController: controller,
                            sectionIndex: widget.workoutSection.sortPosition,
                            workoutSectionType:
                                widget.workoutSection.workoutSectionType,
                            markWorkoutMoveComplete: (workoutMove) =>
                                _markWorkoutMoveComplete(
                                    autoRestTimerSeconds: autoRestTimerSeconds,
                                    controller: controller,
                                    enableAutoRestTimer: enableAutoRestTimer,
                                    workoutMove: workoutMove,
                                    workoutSet: workoutSet),
                            markWorkoutMoveIncomplete: (workoutMove) =>
                                controller.markWorkoutMoveIncomplete(
                                    workoutSet, workoutMove),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            if (enableAutoRestTimer && _showRestTimer)
              Align(
                alignment: Alignment.bottomCenter,
                child: FadeInUp(
                    child: MiniRestTimer(
                  seconds: autoRestTimerSeconds,
                  closeTimer: () => setState(() => _showRestTimer = false),
                  closeTimerAndOpenSettings: _closeTimerAndOpenSettings,
                )),
              )
          ],
        );
      },
    );
  }
}

class _WorkoutSetInLiftingSession extends StatelessWidget {
  final int sectionIndex;
  final WorkoutSectionType workoutSectionType;
  final WorkoutSet workoutSet;
  final bool setIsMarkedComplete;
  final LiftingSectionController sectionController;
  final List<String> completedWorkoutMoveIds;
  final void Function(WorkoutMove workoutMove) markWorkoutMoveComplete;
  final void Function(WorkoutMove workoutMove) markWorkoutMoveIncomplete;
  const _WorkoutSetInLiftingSession({
    Key? key,
    required this.workoutSet,
    required this.setIsMarkedComplete,
    required this.sectionController,
    required this.sectionIndex,
    required this.completedWorkoutMoveIds,
    required this.workoutSectionType,
    required this.markWorkoutMoveComplete,
    required this.markWorkoutMoveIncomplete,
  }) : super(key: key);

  void _openModifyMove(BuildContext context, WorkoutMove originalWorkoutMove) {
    Vibrate.feedback(FeedbackType.selection);
    context.push(
        fullscreenDialog: true,
        child: WorkoutMoveCreator(
          pageTitle: 'Modify Move',
          workoutMove: originalWorkoutMove,
          saveWorkoutMove: (workoutMove) {
            context.read<DoWorkoutBloc>().updateWorkoutMove(
                sectionIndex, workoutSet.sortPosition, workoutMove,
                doNotReset: true);
          },
          sortPosition: originalWorkoutMove.sortPosition,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final workoutMoves = workoutSet.workoutMoves;
    final displayVerticalList =
        workoutSet.isMultiMoveSet || workoutSet.workoutMoves.length == 1;

    /// All workout moves in a LiftingSet must share the same equipment and move.
    /// i.e. it is a classic lifting set of a single exercise.
    /// Only used if [isMultiMoveSet] is true.
    final templateWorkoutMove =
        workoutMoves.isNotEmpty ? workoutMoves[0] : null;

    return ContentBox(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: templateWorkoutMove == null
          ? const MyText('No sets specified...')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    displayVerticalList
                        ? WorkoutSetDefinition(workoutSet: workoutSet)
                        : GestureDetector(
                            onTap: () => context.push(
                                fullscreenDialog: true,
                                child: MoveDetails(templateWorkoutMove.move)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    MyText(
                                      templateWorkoutMove.move.name,
                                    ),
                                    if (workoutSectionType.isCustom)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 6.0),
                                        child: MyText(
                                            '(${templateWorkoutMove.repDisplay.capitalize})'),
                                      )
                                  ],
                                ),
                                if (templateWorkoutMove.equipment != null)
                                  MyText(
                                    templateWorkoutMove.equipment!.name,
                                    color: Styles.primaryAccent,
                                    lineHeight: 1.2,
                                  ),
                              ],
                            ),
                          ),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      child: setIsMarkedComplete
                          ? const FadeInUp(
                              child: MyText('Completed!',
                                  size: FONTSIZE.two, weight: FontWeight.bold),
                            )
                          : null,
                    )
                  ],
                ),
                displayVerticalList
                    ? Column(
                        children: workoutMoves
                            .map((wm) => _WorkoutMoveInMultiMoveSet(
                                  workoutMove: wm,
                                  markWorkoutMoveComplete: () =>
                                      markWorkoutMoveComplete(wm),
                                  markWorkoutMoveIncomplete: () =>
                                      markWorkoutMoveIncomplete(wm),
                                  isMarkedComplete:
                                      completedWorkoutMoveIds.contains(wm.id),
                                  openModifyMove: () =>
                                      _openModifyMove(context, wm),
                                ))
                            .toList(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 16,
                          children: workoutMoves
                              .map((wm) => _WorkoutMoveInSingleMoveSet(
                                    workoutMove: wm,
                                    markWorkoutMoveComplete: () =>
                                        markWorkoutMoveComplete(wm),
                                    markWorkoutMoveIncomplete: () =>
                                        markWorkoutMoveIncomplete(wm),
                                    isMarkedComplete:
                                        completedWorkoutMoveIds.contains(wm.id),
                                    openModifyMove: () =>
                                        _openModifyMove(context, wm),
                                  ))
                              .toList(),
                        ),
                      ),
              ],
            ),
    );
  }
}

/// Displays as part of a horizontal list of dots - where each dot is a workout move.
class _WorkoutMoveInSingleMoveSet extends StatelessWidget {
  final WorkoutMove workoutMove;
  final VoidCallback markWorkoutMoveComplete;
  final VoidCallback markWorkoutMoveIncomplete;
  final VoidCallback openModifyMove;
  final bool isMarkedComplete;

  const _WorkoutMoveInSingleMoveSet({
    Key? key,
    required this.workoutMove,
    required this.openModifyMove,
    required this.isMarkedComplete,
    required this.markWorkoutMoveComplete,
    required this.markWorkoutMoveIncomplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repsOverHundred = workoutMove.reps >= 100;

    return GestureDetector(
        onLongPress: isMarkedComplete ? null : openModifyMove,
        onTap: isMarkedComplete
            ? markWorkoutMoveIncomplete
            : markWorkoutMoveComplete,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: AnimatedContainer(
                  duration: kStandardAnimationDuration,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isMarkedComplete
                          ? null
                          : context.theme.background.withOpacity(0.3),
                      gradient: isMarkedComplete
                          ? Styles.primaryAccentGradient
                          : null,
                      border: isMarkedComplete
                          ? null
                          : Border.all(color: context.theme.primary)),
                  child: MyText(workoutMove.reps.round().toString(),
                      color: isMarkedComplete
                          ? Styles.white
                          : context.theme.primary,
                      size: repsOverHundred ? FONTSIZE.three : FONTSIZE.four)),
            ),
            const SizedBox(height: 7),
            if (Utils.hasLoad(workoutMove.loadAmount))
              MyText(
                '${workoutMove.loadAmount.stringMyDouble()}${workoutMove.loadUnit.display}',
              )
          ],
        ));
  }
}

/// Displays as part of vertical list of rows where each row is a single workout move.
class _WorkoutMoveInMultiMoveSet extends StatelessWidget {
  final WorkoutMove workoutMove;
  final VoidCallback markWorkoutMoveComplete;
  final VoidCallback markWorkoutMoveIncomplete;
  final VoidCallback openModifyMove;
  final bool isMarkedComplete;

  const _WorkoutMoveInMultiMoveSet({
    Key? key,
    required this.workoutMove,
    required this.openModifyMove,
    required this.isMarkedComplete,
    required this.markWorkoutMoveComplete,
    required this.markWorkoutMoveIncomplete,
  }) : super(key: key);

  Widget _buildRepSuffix() {
    return SizedBox(
      width: 32,
      child: MyText(
        workoutMove.repDisplay,
        size: FONTSIZE.two,
      ),
    );
  }

  Widget _buildLoadDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 12),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          border: Border(
              right:
                  BorderSide(color: context.theme.primary.withOpacity(0.5)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MyText(
            workoutMove.loadAmount.stringMyDouble(),
            lineHeight: 1.1,
            size: FONTSIZE.four,
          ),
          const SizedBox(width: 3),
          MyText(
            workoutMove.loadUnit.display,
            size: FONTSIZE.two,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repsOverHundred = workoutMove.reps >= 100;

    final equipmentIsLoadAdjustable = (workoutMove.equipment != null &&
            !workoutMove.equipment!.isBodyweight) ||
        (workoutMove.move.requiredEquipments.any((e) => e.loadAdjustable));

    final showLoad =
        Utils.hasLoad(workoutMove.loadAmount) && equipmentIsLoadAdjustable;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
        onTap: () => context.push(
            fullscreenDialog: true, child: MoveDetails(workoutMove.move)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  workoutMove.move.name,
                ),
                if (Utils.textNotNull(workoutMove.equipment?.name))
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: MyText(workoutMove.equipment!.name,
                        size: FONTSIZE.two, color: Styles.primaryAccent),
                  ),
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: isMarkedComplete ? null : openModifyMove,
              onTap: isMarkedComplete
                  ? markWorkoutMoveIncomplete
                  : markWorkoutMoveComplete,
              child: Row(
                children: [
                  if (showLoad) _buildLoadDisplay(context),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: AnimatedContainer(
                        duration: kStandardAnimationDuration,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isMarkedComplete
                                ? null
                                : context.theme.background.withOpacity(0.3),
                            gradient: isMarkedComplete
                                ? Styles.primaryAccentGradient
                                : null,
                            border: isMarkedComplete
                                ? null
                                : Border.all(color: context.theme.primary)),
                        child: MyText(workoutMove.reps.round().toString(),
                            color: isMarkedComplete
                                ? Styles.white
                                : context.theme.primary,
                            size: repsOverHundred
                                ? FONTSIZE.three
                                : FONTSIZE.four)),
                  ),
                  const SizedBox(width: 4),
                  _buildRepSuffix()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
