import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/load_picker.dart';
import 'package:sofie_ui/components/user_input/pickers/number_picker.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/move_selector.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

/// Interacts directly with the bloc in a similar way to the WorkoutSetCreator.
/// With custom functionality relevant to creating classic lift style sets.
/// Shares functionality with [WorkoutSetCreator] and [WorkoutMoveCreator].
class LiftingSetCreator extends StatefulWidget {
  final int sectionIndex;
  final int? setIndex; // If user is editing. Do not pass when creating!
  const LiftingSetCreator({
    Key? key,
    required this.sectionIndex,
    this.setIndex,
  }) : super(key: key);

  @override
  State<LiftingSetCreator> createState() => _LiftingSetCreatorState();
}

class _LiftingSetCreatorState extends State<LiftingSetCreator> {
  WorkoutSet? _workoutSet;
  int? _setIndex;
  Move? _activeMove;

  /// 0 = MoveSelector
  /// 1 = Reps etc editor
  int _activeTabIndex = 0;

  late WorkoutCreatorBloc _bloc;

  void _checkForNewData() {
    // Check that the set has not been deleted. Without this the below updates with throw an invalid index error every time a set is deleted.
    if (_setIndex != null) {
      final updatedSet = _bloc
          .workout.workoutSections[widget.sectionIndex].workoutSets[_setIndex!];
      _workoutSet = WorkoutSet.fromJson(updatedSet.toJson());
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WorkoutCreatorBloc>();

    if (widget.setIndex != null) {
      _setIndex = widget.setIndex;
      _workoutSet = WorkoutSet.fromJson(_bloc.workout
          .workoutSections[widget.sectionIndex].workoutSets[widget.setIndex!]
          .toJson());

      _activeMove = _workoutSet!.workoutMoves.isNotEmpty
          ? _workoutSet!.workoutMoves[0].move
          : null;

      _activeTabIndex = _activeMove == null ? 0 : 1;
    }

    _bloc.addListener(_checkForNewData);
  }

  void _changeTab(int index) {
    Utils.hideKeyboard(context);
    setState(() => _activeTabIndex = index);
  }

  /// Creating.
  /// Once the user selects a move for the first time we can create a new set and workoutmove.
  Future<void> _createSetAndAddWorkoutMove(
    WorkoutMove workoutMove,
  ) async {
    /// Only [shouldNotifyListeners] after creating the workoutMove so that the UI just updates once.
    final newSet = await context
        .read<WorkoutCreatorBloc>()
        .createWorkoutSet(widget.sectionIndex, shouldNotifyListeners: false);

    if (newSet != null) {
      setState(() {
        _setIndex = newSet.sortPosition;
      });
      await context.read<WorkoutCreatorBloc>().createWorkoutMove(
          widget.sectionIndex, newSet.sortPosition, workoutMove);
    } else {
      context.showToast(
          message: 'Sorry, there was a problem',
          toastType: ToastType.destructive);
    }
  }

  /// Editing.
  /// [_workoutSet] must be non null before calling any of these update methods!
  ///
  /// Update all workout moves to have this equipment.
  Future<void> _updateEquipment(Equipment e) async {
    for (final wm in _workoutSet!.workoutMoves) {
      wm.equipment = e;
    }
    context.read<WorkoutCreatorBloc>().editWorkoutMoves(widget.sectionIndex,
        _workoutSet!.sortPosition, _workoutSet!.workoutMoves);
  }

  Future<void> _editWorkoutMove(WorkoutMove workoutMove) async {
    await context.read<WorkoutCreatorBloc>().editWorkoutMove(
        widget.sectionIndex, _workoutSet!.sortPosition, workoutMove);
  }

  /// Duplicate the last workoutMove in the list when user is 'Adding Set'
  void _duplicateWorkoutMove() {
    _bloc.duplicateWorkoutMove(widget.sectionIndex, _workoutSet!.sortPosition,
        _workoutSet!.workoutMoves.length - 1);
  }

  void _deleteWorkoutMove(int workoutMoveIndex) {
    _bloc.deleteWorkoutMove(
        widget.sectionIndex, _workoutSet!.sortPosition, workoutMoveIndex);
  }

  Future<void> _selectMove(Move move) async {
    setState(() {
      _activeMove = move;
    });

    if (_workoutSet != null) {
      /// Update each workoutMove with the new move.
      final updatedWorkoutMoves = _workoutSet!.workoutMoves
          .map((wm) => WorkoutMove()
            ..id = wm.id
            ..sortPosition = wm.sortPosition
            ..equipment = move.selectableEquipments.contains(wm.equipment)
                ? wm.equipment
                : null
            ..reps = wm.reps
            ..repType = move.validRepTypes.contains(WorkoutMoveRepType.reps)
                ? WorkoutMoveRepType.reps
                : move.validRepTypes.first
            ..distanceUnit = wm.distanceUnit
            ..loadUnit = wm.loadUnit
            ..timeUnit = wm.timeUnit
            ..loadAmount = move.isLoadAdjustable ? wm.loadAmount : 0
            ..move = move)
          .toList();

      await context.read<WorkoutCreatorBloc>().editWorkoutMoves(
          widget.sectionIndex, _workoutSet!.sortPosition, updatedWorkoutMoves);
    } else {
      /// Create a single set and workoutmove.
      _createSetAndAddWorkoutMove(WorkoutMove()
        ..id = 'temp'
        ..sortPosition = 0
        ..equipment = null
        ..reps = 10
        ..repType = move.validRepTypes.contains(WorkoutMoveRepType.reps)
            ? WorkoutMoveRepType.reps
            : move.validRepTypes.first
        ..distanceUnit = DistanceUnit.metres
        ..loadUnit = LoadUnit.kg
        ..timeUnit = TimeUnit.seconds
        ..loadAmount = 0
        ..move = move);
    }
    _changeTab(1);
  }

  @override
  void dispose() {
    _bloc.removeListener(_checkForNewData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// All workout moves will be the same - just with varying reps and load amounts.
    final sortedWorkoutMoves = _workoutSet != null
        ? _workoutSet!.workoutMoves.sortedBy<num>((wm) => wm.sortPosition)
        : <WorkoutMove>[];

    final workoutMoveTemplate =
        sortedWorkoutMoves.isEmpty ? null : sortedWorkoutMoves[0];

    final equipment = workoutMoveTemplate?.equipment;

    return IndexedStack(
      index: _activeTabIndex,
      children: [
        MoveSelector(
            selectMove: _selectMove,
            onCancel: () =>
                _activeMove == null ? context.pop() : _changeTab(1)),
        MyPageScaffold(
          navigationBar: const MyNavBar(
            middle: NavBarTitle('Lifting'),
          ),
          child: _activeMove == null
              ? ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TertiaryButton(
                            prefixIconData: CupertinoIcons.arrow_left_right,
                            text: 'Select a move',
                            onPressed: () => _changeTab(0))
                      ],
                    )
                  ],
                )
              : ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(child: MyHeaderText(_activeMove!.name)),
                        const SizedBox(
                          width: 16,
                        ),
                        TertiaryButton(
                            prefixIconData: CupertinoIcons.arrow_left_right,
                            text: 'Change',
                            onPressed: () => _changeTab(0))
                      ],
                    ),
                    if (workoutMoveTemplate != null &&
                        workoutMoveTemplate.move.requiredEquipments.isNotEmpty)
                      Column(
                        children: [
                          const MyText('Required'),
                          const SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                workoutMoveTemplate.move.requiredEquipments
                                    .map((e) => ContentBox(
                                          child: MyText(
                                            e.name,
                                            weight: FontWeight.bold,
                                            size: FONTSIZE.four,
                                          ),
                                        ))
                                    .toList(),
                          )
                        ],
                      ),
                    if (workoutMoveTemplate != null &&
                        workoutMoveTemplate
                            .move.selectableEquipments.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: MyText('Select one from',
                                  color: workoutMoveTemplate.equipment == null
                                      ? Styles.errorRed
                                      : null,
                                  lineHeight: 1.4),
                            ),
                            SizedBox(
                              height: 90,
                              child: Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: DataUtils
                                          .sortEquipmentsWithBodyWeightFirst(
                                              workoutMoveTemplate
                                                  .move.selectableEquipments)
                                      .map((e) => SizedBox(
                                            height: 90,
                                            width: 90,
                                            child: GestureDetector(
                                                onTap: () =>
                                                    _updateEquipment(e),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: EquipmentTile(
                                                      showIcon: true,
                                                      equipment: e,
                                                      withBorder: false,
                                                      fontSize: FONTSIZE.two,
                                                      isSelected:
                                                          equipment == e),
                                                )),
                                          ))
                                      .toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    if (workoutMoveTemplate != null)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, right: 8.0, bottom: 8, left: 8),
                        child: MyText(
                          '${workoutMoveTemplate.move.name} with ${equipment?.name ?? ""}',
                          size: FONTSIZE.five,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ...sortedWorkoutMoves
                        .mapIndexed(
                          (i, wm) => FadeInUp(
                            key: Key(wm.id),
                            child: _LiftSetWorkoutMoveEditor(
                              index: i,
                              workoutMove: wm,
                              updateWorkoutMove: _editWorkoutMove,
                              deleteWorkoutMove: () => _deleteWorkoutMove(i),
                            ),
                          ),
                        )
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CreateTextIconButton(
                        text: 'Add Set',
                        onPressed: _duplicateWorkoutMove,
                      ),
                    ),
                  ],
                ),
        )
      ],
    );
  }
}

class _LiftSetWorkoutMoveEditor extends StatelessWidget {
  final int index;
  final WorkoutMove workoutMove;
  final void Function(WorkoutMove workoutMove) updateWorkoutMove;
  final VoidCallback deleteWorkoutMove;
  const _LiftSetWorkoutMoveEditor({
    Key? key,
    required this.workoutMove,
    required this.deleteWorkoutMove,
    required this.index,
    required this.updateWorkoutMove,
  }) : super(key: key);

  void _updateReps(int reps) {
    workoutMove.reps = reps.toDouble();
    updateWorkoutMove(workoutMove);
  }

  void _updateLoad(double loadAmount, LoadUnit loadUnit) {
    workoutMove.loadAmount = loadAmount;
    workoutMove.loadUnit = loadUnit;
    updateWorkoutMove(workoutMove);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: context.theme.primary.withOpacity(0.3)))),
                  child: MyText(
                    '${index + 1}',
                    size: FONTSIZE.two,
                    subtext: true,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      NumberPickerInt(
                          suffix: const MyText('reps'),
                          modalTitle: 'Reps',
                          fontSize: FONTSIZE.eight,
                          number: workoutMove.reps.round(),
                          saveValue: _updateReps),
                    ],
                  ),
                ),
                if (workoutMove.equipment != null &&
                    !workoutMove.equipment!.isBodyweight)
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LoadPickerDisplay(
                          loadAmount: workoutMove.loadAmount,
                          fontSize: FONTSIZE.eight,
                          loadUnit: workoutMove.loadUnit,
                          updateLoad: _updateLoad,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          CupertinoButton(
              onPressed: index != 0 ? deleteWorkoutMove : null,
              child: Opacity(
                  opacity: index != 0 ? 1 : 0,
                  child: const Icon(CupertinoIcons.delete, size: 18)))
        ],
      ),
    );
  }
}
