import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/animated/dragged_item.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_move_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/workout_set_creator/workout_set_definition.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/workout_set_creator/workout_set_workout_move.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/nav_bar_ellipsis_menu.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/components/user_input/pickers/round_picker.dart';
import 'package:sofie_ui/components/user_input/pyramid_generator.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';

/// Displays a workout set with user interactions such as
/// [delete workoutMove], [addWorkoutMove (create superset)], [reorderWorkoutMove] etc.
class WorkoutSetCreator extends StatefulWidget {
  @override
  final Key key;
  final int sectionIndex;
  final int setIndex;
  final bool scrollable;
  final bool allowReorder;
  const WorkoutSetCreator({
    required this.key,
    required this.sectionIndex,
    required this.setIndex,
    this.scrollable = false,
    this.allowReorder = false,
  }) : super(key: key);

  @override
  _WorkoutSetCreatorState createState() => _WorkoutSetCreatorState();
}

class _WorkoutSetCreatorState extends State<WorkoutSetCreator> {
  late List<WorkoutMove> _sortedWorkoutMoves;
  late WorkoutSet _workoutSet;
  late WorkoutCreatorBloc _bloc;
  late WorkoutSectionType _workoutSectionType;
  bool _shouldRebuild = false;

  void _checkForNewData() {
    if (_workoutSectionType !=
        _bloc.workout.workoutSections[widget.sectionIndex].workoutSectionType) {
      _workoutSectionType =
          _bloc.workout.workoutSections[widget.sectionIndex].workoutSectionType;
      _shouldRebuild = true;
    }

    // Check that the set has not been deleted. Without this the below updates with throw an invalid index error every time a set is deleted.
    if (_bloc.workout.workoutSections[widget.sectionIndex].workoutSets.length >
        widget.setIndex) {
      final updatedSet = _bloc.workout.workoutSections[widget.sectionIndex]
          .workoutSets[widget.setIndex];
      final updatedWorkoutMoves = updatedSet.workoutMoves;

      if (_workoutSet != updatedSet) {
        _shouldRebuild = true;
        _workoutSet = WorkoutSet.fromJson(updatedSet.toJson());
      }

      if (!_sortedWorkoutMoves.equals(updatedWorkoutMoves)) {
        _shouldRebuild = true;
        _sortedWorkoutMoves =
            updatedWorkoutMoves.sortedBy<num>((wm) => wm.sortPosition);
      }
    }

    if (_shouldRebuild) {
      setState(() {});
    }
    _shouldRebuild = false;
  }

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WorkoutCreatorBloc>();

    _workoutSectionType =
        _bloc.workout.workoutSections[widget.sectionIndex].workoutSectionType;

    _workoutSet = WorkoutSet.fromJson(_bloc.workout
        .workoutSections[widget.sectionIndex].workoutSets[widget.setIndex]
        .toJson());

    _sortedWorkoutMoves = _bloc.workout.workoutSections[widget.sectionIndex]
        .workoutSets[widget.setIndex].workoutMoves
        .sortedBy<num>((wm) => wm.sortPosition);

    _bloc.addListener(_checkForNewData);
  }

  void _deleteWorkoutSet() {
    context.showConfirmDeleteDialog(
        itemType: 'Set',
        onConfirm: () => context
            .read<WorkoutCreatorBloc>()
            .deleteWorkoutSet(widget.sectionIndex, widget.setIndex));
  }

  void _duplicateWorkoutSet() {
    _bloc.duplicateWorkoutSet(widget.sectionIndex, widget.setIndex);
  }

  void _moveWorkoutSetUpOne() {
    _bloc.reorderWorkoutSets(
        widget.sectionIndex, widget.setIndex, widget.setIndex - 1);
  }

  void _moveWorkoutSetDownOne() {
    _bloc.reorderWorkoutSets(
        widget.sectionIndex, widget.setIndex, widget.setIndex + 1);
  }

  void _generateSequenceForPyramid() {
    context.push(
        fullscreenDialog: true,
        child: PyramidGenerator(
            pageTitle: 'Rep Pyramid Generator',
            generateSequence: _createSetSequence));
  }

  void _createSetSequence(List<int> repSequence) {
    context.showConfirmDialog(
        title: 'Generate Pyramid',
        message:
            'This will replace the current set with ${repSequence.length} separate new sets. Continue?',
        verb: 'Generate',
        onConfirm: () {
          context.read<WorkoutCreatorBloc>().createSetSequence(
              widget.sectionIndex, widget.setIndex, repSequence);
        });
  }

  void _updateDuration(Duration duration, bool copyToAll) {
    if (copyToAll) {
      context.read<WorkoutCreatorBloc>().updateAllSetDurations(
          widget.sectionIndex,
          duration.inSeconds,
          _workoutSet.isRestSet
              ? DurationUpdateType.rests
              : DurationUpdateType.sets);
    } else {
      context.read<WorkoutCreatorBloc>().editWorkoutSet(widget.sectionIndex,
          widget.setIndex, {'duration': duration.inSeconds});
    }
  }

  void _updateRounds(int rounds) {
    context.read<WorkoutCreatorBloc>().editWorkoutSet(
        widget.sectionIndex, widget.setIndex, {'rounds': rounds});
  }

  void _openAddWorkoutMoveToSet() {
    context.push(
        child: WorkoutMoveCreator(
      pageTitle: 'Add Move To Set',
      saveWorkoutMove: (workoutMove) {
        context.read<WorkoutCreatorBloc>().createWorkoutMove(
            widget.sectionIndex, widget.setIndex, workoutMove);
      },
      sortPosition: _workoutSet.workoutMoves.length,
    ));
  }

  void _openEditWorkoutMove(WorkoutMove originalWorkoutMove, bool ignoreReps) {
    context.push(
        child: WorkoutMoveCreator(
      pageTitle: 'Edit Move',
      workoutMove: originalWorkoutMove,
      ignoreReps: ignoreReps,
      saveWorkoutMove: (workoutMove) {
        context
            .read<WorkoutCreatorBloc>()
            .editWorkoutMove(widget.sectionIndex, widget.setIndex, workoutMove);
      },
      sortPosition: originalWorkoutMove.sortPosition,
    ));
  }

  void _deleteWorkoutMove(int workoutMoveIndex) {
    _bloc.deleteWorkoutMove(
        widget.sectionIndex, widget.setIndex, workoutMoveIndex);
  }

  void _duplicateWorkoutMove(int workoutMoveIndex) {
    _bloc.duplicateWorkoutMove(
        widget.sectionIndex, widget.setIndex, workoutMoveIndex);
  }

  void _reorderWorkoutMoves(int from, int to) {
    _bloc.reorderWorkoutMoves(widget.sectionIndex, widget.setIndex, from, to);
  }

  Widget _minimizeExpandButton(bool isMinimized) => CupertinoButton(
      padding: isMinimized ? EdgeInsets.zero : const EdgeInsets.only(right: 16),
      child: Icon(
          isMinimized
              ? CupertinoIcons.fullscreen
              : CupertinoIcons.fullscreen_exit,
          size: 20),
      onPressed: () => context.read<WorkoutCreatorBloc>().toggleMinimizeSetInfo(
            _workoutSet.id,
          ));

  Widget get _buildEllipsisMenu => NavBarEllipsisMenu(items: [
        if (widget.allowReorder)
          ContextMenuItem(
              text: 'Move Up',
              iconData: CupertinoIcons.up_arrow,
              onTap: _moveWorkoutSetUpOne),
        if (widget.allowReorder)
          ContextMenuItem(
              text: 'Move Down',
              iconData: CupertinoIcons.down_arrow,
              onTap: _moveWorkoutSetDownOne),
        ContextMenuItem(
            text: 'Duplicate',
            iconData: CupertinoIcons.plus_rectangle_on_rectangle,
            onTap: _duplicateWorkoutSet),
        if (_workoutSectionType.canPyramid)
          ContextMenuItem(
              text: 'Pyramid',
              iconData: CupertinoIcons.triangle_righthalf_fill,
              onTap: _generateSequenceForPyramid),
        ContextMenuItem(
          text: 'Delete',
          iconData: CupertinoIcons.delete_simple,
          onTap: _deleteWorkoutSet,
          destructive: true,
        ),
      ]);

  @override
  void dispose() {
    _bloc.removeListener(_checkForNewData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMinimized = context.select<WorkoutCreatorBloc, bool>(
        (b) => b.displayMinimizedSetIds.contains(_workoutSet.id));

    final uniqueMoves =
        _sortedWorkoutMoves.map((wm) => wm.move).toSet().toList();

    if (isMinimized) {
      return FadeIn(
        child: ContentBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommaSeparatedList(uniqueMoves.map((m) => m.name).toList(),
                  fontSize: FONTSIZE.three),
            ),
            Column(
              children: [
                _buildEllipsisMenu,
                _minimizeExpandButton(isMinimized),
              ],
            )
          ],
        )),
      );
    }
    // Don't show reps when user is doing a timed workout and when there is only one move in the set.
    // The user will just do single workout move for as long as workoutSet.duration, so reps are ignored.
    final ignoreReps = !_workoutSectionType.showReps(_workoutSet);

    final isMultiMoveSet = _workoutSet.isMultiMoveSet;

    return ContentBox(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (_workoutSectionType.isTimed)
                    CupertinoButton(
                        padding: const EdgeInsets.all(4),
                        onPressed: () => context.showBottomSheet(
                            expand: false,
                            child: WorkoutSetDurationPicker(
                                switchTitle: _workoutSet.isRestSet
                                    ? 'Copy new time to all rest sets'
                                    : 'Copy new time to all sets',
                                duration:
                                    Duration(seconds: _workoutSet.duration),
                                updateDuration: _updateDuration)),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.timer, size: 18),
                            const SizedBox(width: 5),
                            MyText(
                              Duration(seconds: _workoutSet.duration)
                                  .displayString,
                              size: FONTSIZE.four,
                            )
                          ],
                        )),
                  if (_workoutSectionType.roundsInputAllowed)
                    RoundPicker(
                        rounds: _workoutSet.rounds,
                        saveValue: _updateRounds,
                        padding: const EdgeInsets.all(4)),
                  if (!_workoutSet.isRestSet && isMultiMoveSet)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: WorkoutSetDefinition(workoutSet: _workoutSet),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: _workoutSet.isRestSet
                        ? const MyText(
                            'REST',
                            size: FONTSIZE.four,
                          )
                        : IconButton(
                            iconData: CupertinoIcons.add,
                            size: 22,
                            onPressed: _openAddWorkoutMoveToSet,
                          ),
                  ),
                  _minimizeExpandButton(isMinimized),
                  _buildEllipsisMenu
                ],
              )
            ],
          ),
          if (!_workoutSet.isRestSet)
            material.ReorderableListView.builder(
                proxyDecorator: (child, index, animation) =>
                    DraggedItem(child: child),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sortedWorkoutMoves.length,
                itemBuilder: (context, index) => WorkoutSetWorkoutMove(
                    key: Key(
                        '$index-workout_set_creator-${_sortedWorkoutMoves[index].id}'),
                    workoutMove: _sortedWorkoutMoves[index],
                    deleteWorkoutMove: _deleteWorkoutMove,
                    duplicateWorkoutMove: _duplicateWorkoutMove,
                    openEditWorkoutMove: (wm) =>
                        _openEditWorkoutMove(wm, ignoreReps),
                    showReps: !ignoreReps,
                    isLast: index == _sortedWorkoutMoves.length - 1,
                    isPartOfSuperSet: isMultiMoveSet),
                onReorder: _reorderWorkoutMoves)
          else
            Container()
        ],
      ),
    );
  }
}
