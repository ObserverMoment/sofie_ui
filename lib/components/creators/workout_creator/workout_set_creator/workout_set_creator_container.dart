import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_move_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_set_creator_ui.dart';
import 'package:sofie_ui/components/user_input/pyramid_generator.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';

/// Handles retrieving the WorkoutSet data from [WorkoutCreatorBloc] and passes it down to the create UI.
/// Also passes down methods which interact with the [WorkoutCreatorBloc].
class WorkoutSetCreatorContainer extends StatefulWidget {
  @override
  final Key key;
  final int sectionIndex;
  final int setIndex;
  final bool scrollable;
  final bool allowReorder;
  const WorkoutSetCreatorContainer({
    required this.key,
    required this.sectionIndex,
    required this.setIndex,
    this.scrollable = false,
    this.allowReorder = false,
  }) : super(key: key);

  @override
  _WorkoutSetCreatorContainerState createState() =>
      _WorkoutSetCreatorContainerState();
}

class _WorkoutSetCreatorContainerState
    extends State<WorkoutSetCreatorContainer> {
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

  void _toggleMinimizeSetInfo() =>
      context.read<WorkoutCreatorBloc>().toggleMinimizeSetInfo(
            _workoutSet.id,
          );

  @override
  void dispose() {
    _bloc.removeListener(_checkForNewData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMinimized = context.select<WorkoutCreatorBloc, bool>(
        (b) => b.displayMinimizedSetIds.contains(_workoutSet.id));

    return WorkoutSetCreatorUI(
      duplicateWorkoutSet: _duplicateWorkoutSet,
      workoutSectionType: _workoutSectionType,
      generateSequenceForPyramid: _generateSequenceForPyramid,
      deleteWorkoutSet: _deleteWorkoutSet,
      workoutSet: _workoutSet,
      moveWorkoutSetUpOne: _moveWorkoutSetUpOne,
      moveWorkoutSetDownOne: _moveWorkoutSetDownOne,
      toggleMinimizeSetInfo: _toggleMinimizeSetInfo,
      isMinimized: isMinimized,
      updateDuration: _updateDuration,
      openAddWorkoutMoveToSet: _openAddWorkoutMoveToSet,
      openEditWorkoutMove: _openEditWorkoutMove,
      deleteWorkoutMove: _deleteWorkoutMove,
      duplicateWorkoutMove: _duplicateWorkoutMove,
      reorderWorkoutMoves: _reorderWorkoutMoves,
      allowReorder: widget.allowReorder,
    );
  }
}
