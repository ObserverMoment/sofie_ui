import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/lifting_set_creator/lifting_set_creator.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/menus/nav_bar_ellipsis_menu.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/workout/lifting_set_display.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Display only for a lifting set.
/// Includes an "Edit" button which should open up a [LiftingSetCreator] for editing.
class WorkoutLiftingSetDisplay extends StatelessWidget {
  final int sectionIndex;
  final int setIndex;
  final bool scrollable;
  final bool allowReorder;
  const WorkoutLiftingSetDisplay(
      {Key? key,
      required this.sectionIndex,
      required this.setIndex,
      this.scrollable = false,
      this.allowReorder = false})
      : super(key: key);

  Future<void> _openLiftingSetCreator(BuildContext context) async {
    // https://stackoverflow.com/questions/57598029/how-to-pass-provider-with-navigator
    final bloc = context.read<WorkoutCreatorBloc>();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ChangeNotifierProvider<WorkoutCreatorBloc>.value(
          value: bloc,
          builder: (context, child) => LiftingSetCreator(
            key: Key(sectionIndex.toString()),
            sectionIndex: sectionIndex,
            setIndex: setIndex,
          ),
        ),
      ),
    );
  }

  void _moveWorkoutSetDownOne(BuildContext context) {
    context
        .read<WorkoutCreatorBloc>()
        .reorderWorkoutSets(sectionIndex, setIndex, setIndex + 1);
  }

  void _deleteWorkoutSet(BuildContext context) {
    context.showConfirmDeleteDialog(
        itemType: 'Set',
        onConfirm: () => context
            .read<WorkoutCreatorBloc>()
            .deleteWorkoutSet(sectionIndex, setIndex));
  }

  void _duplicateWorkoutSet(BuildContext context) {
    context
        .read<WorkoutCreatorBloc>()
        .duplicateWorkoutSet(sectionIndex, setIndex);
  }

  void _moveWorkoutSetUpOne(BuildContext context) {
    context
        .read<WorkoutCreatorBloc>()
        .reorderWorkoutSets(sectionIndex, setIndex, setIndex - 1);
  }

  @override
  Widget build(BuildContext context) {
    final workoutSection = context.select<WorkoutCreatorBloc, WorkoutSection>(
        (b) => b.workout.workoutSections[sectionIndex]);
    final workoutSet = workoutSection.workoutSets[setIndex];
    final sortedWorkoutMoves =
        workoutSet.workoutMoves.sortedBy<num>((wm) => wm.sortPosition);

    /// All workou moves in a lifting set share the same move and equipment.
    final templateWorkoutMove =
        workoutSet.workoutMoves.isEmpty ? null : workoutSet.workoutMoves[0];

    return ContentBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              templateWorkoutMove != null
                  ? LiftingSetHeaderDisplay(
                      workoutMove: templateWorkoutMove,
                    )
                  : Container(),
              NavBarEllipsisMenu(items: [
                ContextMenuItem(
                    text: 'Edit',
                    iconData: CupertinoIcons.pencil,
                    onTap: () => _openLiftingSetCreator(context)),
                if (allowReorder)
                  ContextMenuItem(
                      text: 'Move Up',
                      iconData: CupertinoIcons.up_arrow,
                      onTap: () => _moveWorkoutSetUpOne(context)),
                if (allowReorder)
                  ContextMenuItem(
                      text: 'Move Down',
                      iconData: CupertinoIcons.down_arrow,
                      onTap: () => _moveWorkoutSetDownOne(context)),
                ContextMenuItem(
                    text: 'Duplicate',
                    iconData: CupertinoIcons.plus_rectangle_on_rectangle,
                    onTap: () => _duplicateWorkoutSet(context)),
                ContextMenuItem(
                  text: 'Delete',
                  iconData: CupertinoIcons.delete_simple,
                  onTap: () => _deleteWorkoutSet(context),
                  destructive: true,
                ),
              ]),
            ],
          ),
          if (sortedWorkoutMoves.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
              child: Column(
                children: sortedWorkoutMoves
                    .mapIndexed((i, wm) => Column(
                          children: [
                            LiftingWorkoutMoveDetailsDisplay(
                              workoutMove: wm,
                            ),
                            if (i != sortedWorkoutMoves.length - 1)
                              const HorizontalLine()
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
