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
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_move_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_set_generator_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/workout_set_creator/workout_set_definition.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

/// Using this style list for [Custom] and [Lifting] sections.
/// Both user [LiftingSectionController]
/// When it is [Custom] user can edit / change the whole move.
/// When it is [Lifting] user can modify just the reps and load.
class LiftingMovesList extends StatelessWidget {
  final WorkoutSection workoutSection;
  final WorkoutSectionProgressState state;
  const LiftingMovesList({
    Key? key,
    required this.workoutSection,
    required this.state,
  }) : super(key: key);

  Future<void> _openWorkoutSetGeneratorCreator(BuildContext context) async {
    await context.push(
        child: WorkoutSetGeneratorCreator(
      handleGeneratedSet: (workoutSet) {
        context
            .read<DoWorkoutBloc>()
            .addWorkoutSetToSection(workoutSection.sortPosition, workoutSet);
        context.pop();
      },
      validRepTypes:
          workoutSection.isCustomSession ? [] : [WorkoutMoveRepType.reps],
      newSetSortPosition: workoutSection.workoutSets.length,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final controller = context
            .read<DoWorkoutBloc>()
            .getControllerForSection(workoutSection.sortPosition)
        as LiftingSectionController;

    return ChangeNotifierProvider<LiftingSectionController>.value(
      value: controller,
      builder: (context, child) {
        final completedSetIds =
            context.watch<LiftingSectionController>().completedWorkoutSetIds;

        final completedWorkoutMoveIds =
            controller.completedWorkoutMoveIds.toList();

        return Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: LinearPercentIndicator(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                lineHeight: 4,
                percent: state.percentComplete.clamp(0.0, 1.0),
                backgroundColor: context.theme.primary.withOpacity(0.07),
                linearGradient: Styles.primaryAccentGradient,
                linearStrokeCap: LinearStrokeCap.roundAll,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: workoutSection.workoutSets.length + 1,
                itemBuilder: (c, i) {
                  if (i == workoutSection.workoutSets.length) {
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
                        .contains(workoutSection.workoutSets[i].id);

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _WorkoutSetInLiftingSession(
                        workoutSet: workoutSection.workoutSets[i],
                        setIsMarkedComplete: setIsMarkedComplete,
                        completedWorkoutMoveIds: completedWorkoutMoveIds,
                        sectionController: controller,
                        sectionIndex: workoutSection.sortPosition,
                        workoutSectionType: workoutSection.workoutSectionType,
                      ),
                    );
                  }
                },
              ),
            ),
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
  const _WorkoutSetInLiftingSession({
    Key? key,
    required this.workoutSet,
    required this.setIsMarkedComplete,
    required this.sectionController,
    required this.sectionIndex,
    required this.completedWorkoutMoveIds,
    required this.workoutSectionType,
  }) : super(key: key);

  void _markWorkoutMoveComplete(WorkoutMove workoutMove) {
    Vibrate.feedback(FeedbackType.light);
    sectionController.markWorkoutMoveComplete(workoutSet, workoutMove);
  }

  void _markWorkoutMoveIncomplete(WorkoutMove workoutMove) {
    sectionController.markWorkoutMoveIncomplete(workoutSet, workoutMove);
  }

  void _openModifyMove(BuildContext context, WorkoutMove originalWorkoutMove) {
    if (workoutSectionType.isLifting) {
      /// Modify the reps and load only.
      context.showBottomSheet(
          child: _ModifyMove(
        updateWorkoutMove: (updated) {
          context.read<DoWorkoutBloc>().updateWorkoutMove(
              sectionIndex, workoutSet.sortPosition, updated);
        },
        workoutMove: originalWorkoutMove,
      ));
    } else {
      context.push(
          child: WorkoutMoveCreator(
        pageTitle: 'Modify Move',
        workoutMove: originalWorkoutMove,
        saveWorkoutMove: (workoutMove) {
          context.read<DoWorkoutBloc>().updateWorkoutMove(
              sectionIndex, workoutSet.sortPosition, workoutMove);
        },
        sortPosition: originalWorkoutMove.sortPosition,
      ));
    }
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
                                      _markWorkoutMoveComplete(wm),
                                  markWorkoutMoveIncomplete: () =>
                                      _markWorkoutMoveIncomplete(wm),
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
                                        _markWorkoutMoveComplete(wm),
                                    markWorkoutMoveIncomplete: () =>
                                        _markWorkoutMoveIncomplete(wm),
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
    return MyText(
      workoutMove.repDisplay,
      size: FONTSIZE.two,
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

class _ModifyMove extends StatefulWidget {
  final WorkoutMove workoutMove;
  final void Function(WorkoutMove workoutMove) updateWorkoutMove;
  const _ModifyMove({
    Key? key,
    required this.workoutMove,
    required this.updateWorkoutMove,
  }) : super(key: key);

  @override
  State<_ModifyMove> createState() => _ModifyMoveState();
}

class _ModifyMoveState extends State<_ModifyMove> {
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _loadController = TextEditingController();
  late LoadUnit _loadUnit;

  @override
  void initState() {
    _repsController.text = widget.workoutMove.reps.round().toString();
    _loadController.text = widget.workoutMove.loadAmount.round().toString();
    _loadUnit = widget.workoutMove.loadUnit;
    super.initState();
  }

  void _saveAndUpdateWorkoutMove() {
    final updated = WorkoutMove.fromJson(widget.workoutMove.toJson());
    updated.reps = double.parse(_repsController.text);
    updated.loadAmount = double.parse(_loadController.text);
    updated.loadUnit = _loadUnit;

    widget.updateWorkoutMove(updated);
    context.pop();
  }

  @override
  void dispose() {
    _repsController.dispose();
    _loadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyHeaderText(
                'Modify Set',
                size: FONTSIZE.four,
              ),
              TertiaryButton(
                onPressed: context.pop,
                text: 'Cancel',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyHeaderText('Reps'),
              const SizedBox(width: 16),
              SizedBox(
                width: 160,
                child: MyNumberInput(
                  _repsController,
                  textSize: 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ],
          ),
        ),
        if (widget.workoutMove.equipment != null &&
            !widget.workoutMove.equipment!.isBodyweight)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyHeaderText('Load'),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 160,
                      child: MyNumberInput(
                        _loadController,
                        allowDouble: true,
                        textSize: 40,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MySlidingSegmentedControl<LoadUnit>(
                        value: _loadUnit,
                        fontSize: 14,
                        containerPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        childPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8),
                        children: {
                          for (final v in LoadUnit.values
                              .where((v) => v != LoadUnit.artemisUnknown))
                            v: v.display
                        },
                        updateValue: (loadUnit) =>
                            setState(() => _loadUnit = loadUnit)),
                  ],
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: PrimaryButton(
            onPressed: _saveAndUpdateWorkoutMove,
            text: 'Save',
          ),
        ),
      ],
    );
  }
}
