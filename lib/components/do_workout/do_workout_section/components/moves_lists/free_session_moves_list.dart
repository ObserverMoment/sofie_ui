import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/free_session_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_move_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/workout_set_creator/workout_set_definition.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/workout/move_details.dart';
import 'package:sofie_ui/components/workout/workout_move_display.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class FreeSessionMovesList extends StatelessWidget {
  final WorkoutSection workoutSection;
  final WorkoutSectionProgressState state;
  const FreeSessionMovesList({
    Key? key,
    required this.workoutSection,
    required this.state,
  }) : super(key: key);

  void _openCreateWorkoutMove(BuildContext context) {
    context.push(
        child: WorkoutMoveCreator(
      pageTitle: 'Add Move',
      saveWorkoutMove: (workoutMove) {
        context
            .read<DoWorkoutBloc>()
            .addWorkoutMoveToSection(workoutSection.sortPosition, workoutMove);
      },
      sortPosition: 0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final controller = context
            .read<DoWorkoutBloc>()
            .getControllerForSection(workoutSection.sortPosition)
        as FreeSessionSectionController;

    return ChangeNotifierProvider<FreeSessionSectionController>.value(
      value: controller,
      builder: (context, child) {
        final completedSetIds = context
            .watch<FreeSessionSectionController>()
            .completedWorkoutSetIds;

        return Column(
          children: [
            const SizedBox(height: 8),
            LinearPercentIndicator(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              lineHeight: 4,
              percent: state.percentComplete.clamp(0.0, 1.0),
              backgroundColor: context.theme.primary.withOpacity(0.07),
              linearGradient: Styles.primaryAccentGradient,
              linearStrokeCap: LinearStrokeCap.roundAll,
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
                          text: 'Add Move',
                          onPressed: () => _openCreateWorkoutMove(context)),
                    );
                  } else {
                    final setIsMarkedComplete = completedSetIds
                        .contains(workoutSection.workoutSets[i].id);

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _WorkoutSetInFreeSession(
                        workoutSet: workoutSection.workoutSets[i],
                        setIsMarkedComplete: setIsMarkedComplete,
                        freeSessionController: controller,
                        sectionIndex: workoutSection.sortPosition,
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

class _WorkoutSetInFreeSession extends StatelessWidget {
  final int sectionIndex;
  final WorkoutSet workoutSet;
  final bool setIsMarkedComplete;
  final FreeSessionSectionController freeSessionController;
  const _WorkoutSetInFreeSession({
    required this.workoutSet,
    required this.setIsMarkedComplete,
    required this.freeSessionController,
    required this.sectionIndex,
  });

  void _handleMarkSetComplete() {
    freeSessionController.markWorkoutSetComplete(workoutSet);
  }

  void _handleMarkSetInComplete() {
    freeSessionController.markWorkoutSetIncomplete(workoutSet);
  }

  void _openEditWorkoutMove(
      BuildContext context, WorkoutMove originalWorkoutMove) {
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

  @override
  Widget build(BuildContext context) {
    final workoutMoves = workoutSet.workoutMoves;

    return ContentBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WorkoutSetDefinition(workoutSet: workoutSet),
              AnimatedSwitcher(
                duration: kStandardAnimationDuration,
                child: setIsMarkedComplete
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _handleMarkSetInComplete,
                        child: const Icon(
                          CupertinoIcons.checkmark_alt_circle,
                          size: 30,
                          color: Styles.primaryAccent,
                        ),
                      )
                    : CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _handleMarkSetComplete,
                        child: const Icon(
                          CupertinoIcons.add_circled,
                          size: 30,
                        ),
                      ),
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: workoutMoves.length,
            itemBuilder: (context, i) => _WorkoutMoveInFreeSession(
              key: Key('$i-free-session-moves-list-${workoutMoves[i].id}'),
              workoutMove: workoutMoves[i],
              isLast: i == workoutMoves.length - 1,
              isMarkedComplete: setIsMarkedComplete,
              openEditWorkoutMove: () =>
                  _openEditWorkoutMove(context, workoutMoves[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutMoveInFreeSession extends StatelessWidget {
  @override
  final Key key;
  final WorkoutMove workoutMove;
  final VoidCallback openEditWorkoutMove;
  final bool isLast;

  final bool isMarkedComplete;

  const _WorkoutMoveInFreeSession(
      {required this.key,
      required this.workoutMove,
      required this.openEditWorkoutMove,
      this.isLast = false,
      required this.isMarkedComplete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isMarkedComplete
          ? null
          : () => openBottomSheetMenu(
              context: context,
              child: BottomSheetMenu(
                  header: BottomSheetMenuHeader(
                    name: workoutMove.move.name,
                  ),
                  items: [
                    BottomSheetMenuItem(
                        text: 'Modify Move',
                        icon: const Icon(CupertinoIcons.plus_slash_minus),
                        onPressed: openEditWorkoutMove),
                    BottomSheetMenuItem(
                        text: 'View Info',
                        icon: const Icon(CupertinoIcons.info),
                        onPressed: () => context.push(
                              child: MoveDetails(workoutMove.move),
                            )),
                  ])),
      child: WorkoutMoveDisplay(
        workoutMove,
      ),
    );
  }
}
