import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/lifting_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/workout/lifting_set_display.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class LiftingMovesList extends StatelessWidget {
  final WorkoutSection workoutSection;
  const LiftingMovesList({
    Key? key,
    required this.workoutSection,
  }) : super(key: key);

  void _openCreateLiftingSet(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final controller = context
            .read<DoWorkoutBloc>()
            .getControllerForSection(workoutSection.sortPosition)
        as LiftingSectionController;

    return ChangeNotifierProvider<LiftingSectionController>.value(
      value: controller,
      builder: (context, child) {
        final _workoutSection =
            context.watch<LiftingSectionController>().workoutSection;

        final completedSetIds = controller.completedWorkoutSetIds;

        final completedWorkoutMoveIds =
            controller.completedWorkoutMoveIds.toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _workoutSection.workoutSets.length + 1,
          itemBuilder: (c, i) {
            if (i == _workoutSection.workoutSets.length) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CreateTextIconButton(
                    text: 'Add Exercise',
                    onPressed: () => _openCreateLiftingSet(context)),
              );
            } else {
              final setIsMarkedComplete =
                  completedSetIds.contains(_workoutSection.workoutSets[i].id);

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: _WorkoutSetInLiftingSession(
                  workoutSet: _workoutSection.workoutSets[i],
                  setIsMarkedComplete: setIsMarkedComplete,
                  completedWorkoutMoveIds: completedWorkoutMoveIds,
                  sectionController: controller,
                  sectionIndex: _workoutSection.sortPosition,
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _WorkoutSetInLiftingSession extends StatelessWidget {
  final int sectionIndex;
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
  }) : super(key: key);

  void _markSetComplete() {
    sectionController.markWorkoutSetComplete(workoutSet);
  }

  void _markSetIncomplete() {
    sectionController.markWorkoutSetIncomplete(workoutSet);
  }

  void _markWorkoutMoveComplete(WorkoutMove workoutMove) {
    sectionController.markWorkoutMoveComplete(workoutSet, workoutMove);
  }

  void _markWorkoutMoveIncomplete(WorkoutMove workoutMove) {
    sectionController.markWorkoutMoveIncomplete(workoutSet, workoutMove);
  }

  void _openModifyMove(BuildContext context, WorkoutMove originalWorkoutMove) {
    context.showBottomSheet(
        child: _ModifyMove(
      updateWorkoutMove: (updated) {
        sectionController.modifyMove(workoutSet.sortPosition, updated);
      },
      workoutMove: originalWorkoutMove,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final workoutMoves = workoutSet.workoutMoves;

    /// All workout moves in a LiftingSet must share the same equipment and move.
    /// i.e. it is a classic lifting set of a single exercise.
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
                    LiftingSetHeaderDisplay(workoutMove: templateWorkoutMove),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: AnimatedSwitcher(
                              duration: kStandardAnimationDuration,
                              child: setIsMarkedComplete
                                  ? FadeInUp(
                                      child: TextButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _markSetIncomplete,
                                        text: 'Completed!',
                                        underline: false,
                                      ),
                                    )
                                  : TextButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: _markSetComplete,
                                      text: 'Mark all',
                                      underline: false,
                                    ),
                            ),
                          ),
                          CupertinoButton(
                              padding: const EdgeInsets.only(left: 8),
                              onPressed: () => context.push(
                                  fullscreenDialog: true,
                                  child: MoveDetails(templateWorkoutMove.move)),
                              child: const Icon(CupertinoIcons.info)),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: workoutMoves
                        .map((wm) => _WorkoutMoveInLifting(
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

class _WorkoutMoveInLifting extends StatelessWidget {
  final WorkoutMove workoutMove;
  final VoidCallback markWorkoutMoveComplete;
  final VoidCallback markWorkoutMoveIncomplete;
  final VoidCallback openModifyMove;
  final bool isMarkedComplete;

  const _WorkoutMoveInLifting(
      {Key? key,
      required this.workoutMove,
      required this.openModifyMove,
      required this.isMarkedComplete,
      required this.markWorkoutMoveComplete,
      required this.markWorkoutMoveIncomplete})
      : super(key: key);

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
              height: 50,
              width: 50,
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
                      size: repsOverHundred ? FONTSIZE.four : FONTSIZE.five)),
            ),
            const SizedBox(height: 7),
            MyText(
              '${workoutMove.loadAmount.stringMyDouble()}${workoutMove.loadUnit.display}',
            )
          ],
        ));
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                    SlidingSelect<LoadUnit>(
                        value: _loadUnit,
                        children: {
                          for (final v in LoadUnit.values
                              .where((v) => v != LoadUnit.artemisUnknown))
                            v: MyText(v.display)
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
