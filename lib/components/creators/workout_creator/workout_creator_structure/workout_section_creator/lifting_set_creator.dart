import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/dialog_menu.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/move_selector.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:collection/collection.dart';

/// Creates / generates a list of WorkoutMoves which are returned to the calling widget.
/// Shares a lot of functionality with [WorkoutMoveCreator] so may be worth abstracting at some point.
class LiftingSetCreator extends StatefulWidget {
  final WorkoutSet? workoutSet;
  final void Function(List<WorkoutMove> workoutMoves) saveWorkoutMoves;
  const LiftingSetCreator(
      {Key? key, this.workoutSet, required this.saveWorkoutMoves})
      : super(key: key);

  @override
  State<LiftingSetCreator> createState() => _LiftingSetCreatorState();
}

class _LiftingSetCreatorState extends State<LiftingSetCreator> {
  List<WorkoutMove> _activeWorkoutMoves = [];
  Move? _activeMove;

  /// 0 = MoveSelector
  /// 1 = Reps etc editor
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _activeWorkoutMoves =
        widget.workoutSet != null && widget.workoutSet!.workoutMoves.isNotEmpty
            ? widget.workoutSet!.workoutMoves
                .map((wm) => WorkoutMove.fromJson(wm.toJson()))
                .toList()
            : [];

    _activeMove =
        _activeWorkoutMoves.isNotEmpty ? _activeWorkoutMoves[0].move : null;

    _activeTabIndex = _activeMove == null ? 0 : 1;
  }

  void _changeTab(int index) {
    Utils.hideKeyboard(context);
    setState(() => _activeTabIndex = index);
  }

  /// [_activeWorkoutMove] must be non null before calling this.
  /// Updates all of the workout moves  in the list. Use this to change equipment.
  void _updateWorkoutMove(Map<String, dynamic> data) {
    setState(() {
      _activeWorkoutMoves = _activeWorkoutMoves
          .map((wm) => WorkoutMove.fromJson({...wm.toJson(), ...data}))
          .toList();
    });
  }

  /// Duplicate the last workoutMove in the list.
  void _addWorkoutMove() {
    final copy = WorkoutMove.fromJson(_activeWorkoutMoves.last.toJson());
    _activeWorkoutMoves.add(copy);
    _updateSortPositions();
  }

  void _deleteWorkoutMove(int index) {
    _activeWorkoutMoves.removeAt(index);
    _updateSortPositions();
  }

  void _updateSortPositions() {
    _activeWorkoutMoves.asMap().forEach((index, wm) {
      wm.sortPosition = index;
    });
    setState(() {});
  }

  void _selectMove(Move move) {
    _activeMove = move;
    if (_activeWorkoutMoves.isNotEmpty) {
      /// Update each workoutMove with the new move.
      _activeWorkoutMoves = _activeWorkoutMoves
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
    } else {
      /// Create a single workoutmoves and add to [_activeWorkoutMoves]
      _activeWorkoutMoves.add(WorkoutMove()
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

  bool _validToSave() {
    if (_activeWorkoutMoves.isEmpty) {
      return false;
    }

    /// Just checking the first workoutMove as they will all have the same equipment requirements
    return _activeWorkoutMoves[0].move.selectableEquipments.isEmpty ||
        _activeWorkoutMoves[0].equipment != null;
  }

  bool _workoutMoveNeedsLoad(WorkoutMove wm) =>
      (wm.equipment != null && wm.equipment!.loadAdjustable) ||
      (wm.move.requiredEquipments.isNotEmpty &&
          wm.move.requiredEquipments.any((e) => e.loadAdjustable));

  /// Should never be called if [_activeWorkoutMoves] is empty
  void _checkLoadAmount() {
    final wm = _activeWorkoutMoves[0];
    if (_workoutMoveNeedsLoad(wm) && wm.loadAmount == 0) {
      context.showDialogMenu(
        title: 'Load Amount is Zero',
        message: 'Is this intentional?',
        actions: [
          DialogMenuItem(text: 'Yes, save it', onPressed: _saveWorkoutMoves),
          DialogMenuItem(text: 'No, change it', onPressed: () {}),
        ],
      );
    } else {
      _saveWorkoutMoves();
    }
  }

  void _saveWorkoutMoves() {}

  @override
  Widget build(BuildContext context) {
    /// All workout moves will be the same - just with varying reps and load amounts.
    final workoutMoveTemplate =
        _activeWorkoutMoves.isEmpty ? null : _activeWorkoutMoves[0];
    final selectedEquipment = workoutMoveTemplate?.equipment;
    return IndexedStack(
      index: _activeTabIndex,
      children: [
        MoveSelector(
            selectMove: _selectMove,
            onCancel: () =>
                _activeMove == null ? context.pop() : _changeTab(1)),
        MyPageScaffold(
          navigationBar: MyNavBar(
            customLeading: NavBarCancelButton(context.pop),
            middle: const NavBarTitle('Lifting'),
            trailing: _validToSave()
                ? FadeIn(
                    child: NavBarSaveButton(
                    _checkLoadAmount,
                  ))
                : null,
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
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 6,
                              runSpacing: 6,
                              children: DataUtils
                                      .sortEquipmentsWithBodyWeightFirst(
                                          workoutMoveTemplate
                                              .move.selectableEquipments)
                                  .map((e) => SizedBox(
                                        height: 86,
                                        width: 86,
                                        child: GestureDetector(
                                            onTap: () => _updateWorkoutMove({
                                                  'Equipment': e.toJson(),
                                                }),
                                            child: EquipmentTile(
                                                showIcon: true,
                                                equipment: e,
                                                withBorder: false,
                                                fontSize: FONTSIZE.two,
                                                isSelected:
                                                    selectedEquipment == e)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    if (workoutMoveTemplate != null)
                      MyText(
                          '${workoutMoveTemplate.move.name} with ${selectedEquipment?.name ?? ""}'),
                    ..._activeWorkoutMoves
                        .mapIndexed(
                          (i, wm) => _LiftSetWorkoutMoveEditor(
                            workoutMove: wm,
                            deleteWorkoutMove: () => _deleteWorkoutMove(i),
                          ),
                        )
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CreateTextIconButton(
                        text: 'Add Set',
                        onPressed: _addWorkoutMove,
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
  final WorkoutMove workoutMove;
  final VoidCallback deleteWorkoutMove;
  const _LiftSetWorkoutMoveEditor({
    Key? key,
    required this.workoutMove,
    required this.deleteWorkoutMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ContentBox(
            child: Row(
          children: [
            MyText(
              'Set x',
              size: FONTSIZE.five,
            ),
            MyText('10 reps'),
            MyText('65 kgs'),
          ],
        )),
        CupertinoButton(
            onPressed: deleteWorkoutMove, child: Icon(CupertinoIcons.delete))
      ],
    );
  }
}
