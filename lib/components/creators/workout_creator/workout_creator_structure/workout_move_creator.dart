import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/dialog_menu.dart';
import 'package:sofie_ui/components/user_input/pickers/load_picker.dart';
import 'package:sofie_ui/components/user_input/pickers/rep_picker.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/move_selector.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

/// UI will be fixed to these values and will not allow user to adjust them.
class FixedTimeReps {
  final double reps;
  final TimeUnit timeUnit;
  FixedTimeReps({required this.reps, this.timeUnit = TimeUnit.seconds});
}

/// Handles state internally the user is ready to save it and add it to the section.
class WorkoutMoveCreator extends StatefulWidget {
  final String? pageTitle;
  final int sortPosition;
  final WorkoutMove? workoutMove;

  /// Do not display any rep pickers - use for section types where the reps are ignored (HIIT Circuit and Tabata etc).
  final bool ignoreReps;
  final FixedTimeReps? fixedTimeReps;
  final void Function(WorkoutMove workoutMove) saveWorkoutMove;
  const WorkoutMoveCreator(
      {Key? key,
      required this.sortPosition,
      required this.saveWorkoutMove,
      this.pageTitle,
      this.ignoreReps = false,
      this.fixedTimeReps,
      this.workoutMove})
      : super(key: key);

  @override
  _WorkoutMoveCreatorState createState() => _WorkoutMoveCreatorState();
}

class _WorkoutMoveCreatorState extends State<WorkoutMoveCreator> {
  WorkoutMove? _activeWorkoutMove;

  /// 0 = MoveSelector
  /// 1 = Reps etc editor
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _activeWorkoutMove = widget.workoutMove != null
        ? WorkoutMove.fromJson(widget.workoutMove!.toJson())
        : null;
    _activeTabIndex = _activeWorkoutMove == null ? 0 : 1;
  }

  void _changeTab(int index) {
    Utils.hideKeyboard(context);
    setState(() => _activeTabIndex = index);
  }

  void _selectMove(Move move) {
    if (_activeWorkoutMove != null) {
      // Update previous selection.
      // Fields will need to be reselected by the ueser if not valid for the new move.
      _activeWorkoutMove = WorkoutMove()
        ..id = _activeWorkoutMove!.id
        ..sortPosition = widget.sortPosition
        ..equipment =
            move.selectableEquipments.contains(_activeWorkoutMove!.equipment)
                ? _activeWorkoutMove!.equipment
                : null
        ..reps = _activeWorkoutMove!.reps
        ..repType = move.validRepTypes.contains(_activeWorkoutMove!.repType)
            ? _activeWorkoutMove!.repType
            : move.validRepTypes.contains(WorkoutMoveRepType.reps)
                ? WorkoutMoveRepType.reps
                : move.validRepTypes.first
        ..distanceUnit = _activeWorkoutMove!.distanceUnit
        ..loadUnit = _activeWorkoutMove!.loadUnit
        ..timeUnit = _activeWorkoutMove!.timeUnit
        ..loadAmount =
            move.isLoadAdjustable ? _activeWorkoutMove!.loadAmount : 0
        ..move = move;
    } else {
      // Initial selection.
      _activeWorkoutMove = WorkoutMove()
        ..id = 'tempId'
        ..sortPosition = widget.sortPosition
        ..equipment = null
        ..reps = widget.fixedTimeReps != null
            ? widget.fixedTimeReps!.reps
            : _activeWorkoutMove?.reps ?? 10
        ..repType = widget.fixedTimeReps != null
            ? WorkoutMoveRepType.time
            : move.validRepTypes.contains(WorkoutMoveRepType.reps)
                ? WorkoutMoveRepType.reps
                : move.validRepTypes.first
        ..distanceUnit = DistanceUnit.metres
        ..loadUnit = LoadUnit.kg
        ..timeUnit = widget.fixedTimeReps != null
            ? widget.fixedTimeReps!.timeUnit
            : TimeUnit.seconds
        ..loadAmount = 0
        ..move = move;
    }

    setState(() {
      _activeTabIndex = 1;
    });
  }

  /// [_activeWorkoutMove] must be non null before calling this.
  void _updateWorkoutMove(Map<String, dynamic> data) {
    setState(() {
      _activeWorkoutMove =
          WorkoutMove.fromJson({..._activeWorkoutMove!.toJson(), ...data});
    });
  }

  bool _validToSave() {
    if (_activeWorkoutMove == null) {
      return false;
    }
    return _activeWorkoutMove!.move.selectableEquipments.isEmpty ||
        _activeWorkoutMove!.equipment != null;
  }

  bool _workoutMoveNeedsLoad() =>
      (_activeWorkoutMove?.equipment != null &&
          _activeWorkoutMove!.equipment!.loadAdjustable) ||
      (_activeWorkoutMove!.move.requiredEquipments.isNotEmpty &&
          _activeWorkoutMove!.move.requiredEquipments
              .any((e) => e.loadAdjustable));

  void _checkLoadAmount() {
    if (_workoutMoveNeedsLoad() && _activeWorkoutMove!.loadAmount == 0) {
      context.showDialogMenu(
        title: 'Load Amount is Zero',
        message: 'Is this intentional?',
        actions: [
          DialogMenuItem(text: 'Yes, save it', onPressed: _saveWorkoutMove),
          DialogMenuItem(text: 'No, change it', onPressed: () {}),
        ],
      );
    } else {
      _saveWorkoutMove();
    }
  }

  void _saveWorkoutMove() {
    if (_activeWorkoutMove != null && _validToSave()) {
      // Ensure load is zero if the move does not require it.
      _activeWorkoutMove!.loadAmount =
          _workoutMoveNeedsLoad() ? _activeWorkoutMove!.loadAmount : 0;

      widget.saveWorkoutMove(_activeWorkoutMove!);
    }
    context.pop();
  }

  bool _showLoadPicker() {
    if (_activeWorkoutMove?.move == null) {
      return false;
    } else if (_activeWorkoutMove!.equipment != null) {
      /// If user has selected bodyweight, do not show.
      /// Else Check for any selected or required equipment being true for [loadAdjustable].
      return _activeWorkoutMove!.equipment!.id != kBodyweightEquipmentId &&
          _activeWorkoutMove!.move.isLoadAdjustable;
    } else {
      /// Equipment not yet selected.
      /// Check for any possible equipment being true for [loadAdjustable]..
      return _activeWorkoutMove!.move.isLoadAdjustable;
    }
  }

  /// Also sorts non bodyweight options alphabetically.
  List<Equipment> _equipmentsWithBodyWeightFirst(List<Equipment> equipments) {
    final sortedEquipments = equipments.sortedBy<String>((e) => e.name);
    final bodyweight = sortedEquipments
        .firstWhereOrNull((e) => e.id == kBodyweightEquipmentId);
    return bodyweight == null
        ? sortedEquipments
        : [
            bodyweight,
            ...sortedEquipments.where((e) => e.id != kBodyweightEquipmentId),
          ];
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(index: _activeTabIndex, children: [
      MoveSelector(
          move: _activeWorkoutMove?.move,
          selectMove: _selectMove,
          onCancel: () =>
              _activeWorkoutMove?.move == null ? context.pop() : _changeTab(1)),
      MyPageScaffold(
          navigationBar: MyNavBar(
            customLeading: NavBarCancelButton(context.pop),
            middle: NavBarTitle(widget.pageTitle ?? 'Set'),
            trailing: _validToSave()
                ? FadeIn(
                    child: NavBarSaveButton(
                    _checkLoadAmount,
                  ))
                : null,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: _activeWorkoutMove == null
                ? [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BorderButton(
                            mini: true,
                            prefix: Icon(
                              CupertinoIcons.arrow_left_right_square,
                              color: context.theme.background,
                              size: 20,
                            ),
                            text: 'Select a move',
                            onPressed: () => _changeTab(0))
                      ],
                    )
                  ]
                : [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: MyHeaderText(_activeWorkoutMove!.move.name)),
                        const SizedBox(
                          width: 16,
                        ),
                        BorderButton(
                            mini: true,
                            prefix: const Icon(
                              CupertinoIcons.arrow_left_right,
                              size: 20,
                            ),
                            text: 'Change',
                            onPressed: () => _changeTab(0))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Wrap(
                        spacing: 30,
                        runSpacing: 10,
                        alignment: WrapAlignment.spaceEvenly,
                        runAlignment: WrapAlignment.spaceEvenly,
                        children: [
                          if (!widget.ignoreReps &&
                              widget.fixedTimeReps == null)
                            RepPickerDisplay(
                              expandPopup: true,
                              reps: _activeWorkoutMove!.reps,
                              validRepTypes:
                                  _activeWorkoutMove!.move.validRepTypes,
                              repType: _activeWorkoutMove!.repType,
                              updateReps: (reps) =>
                                  _updateWorkoutMove({'reps': reps}),
                              updateRepType: (repType) => _updateWorkoutMove(
                                  {'repType': repType.apiValue}),
                              distanceUnit: _activeWorkoutMove!.distanceUnit,
                              updateDistanceUnit: (distanceUnit) =>
                                  _updateWorkoutMove(
                                      {'distanceUnit': distanceUnit.apiValue}),
                              timeUnit: _activeWorkoutMove!.timeUnit,
                              updateTimeUnit: (timeUnit) => _updateWorkoutMove(
                                  {'timeUnit': timeUnit.apiValue}),
                            ),
                          if (_showLoadPicker())
                            FadeIn(
                              child: LoadPickerDisplay(
                                expandPopup: true,
                                loadAmount: _activeWorkoutMove!.loadAmount,
                                loadUnit: _activeWorkoutMove!.loadUnit,
                                updateLoad: (loadAmount, loadUnit) =>
                                    _updateWorkoutMove({
                                  'loadAmount': loadAmount,
                                  'loadUnit': loadUnit.apiValue
                                }),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (_activeWorkoutMove!.move.requiredEquipments.isNotEmpty)
                      Column(
                        children: [
                          const MyText('Required'),
                          const SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                _activeWorkoutMove!.move.requiredEquipments
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
                    if (_activeWorkoutMove!
                        .move.selectableEquipments.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: MyText('And select one from...',
                                  color: _activeWorkoutMove?.equipment == null
                                      ? Styles.errorRed
                                      : null,
                                  lineHeight: 1.4),
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 6,
                              runSpacing: 6,
                              children: _equipmentsWithBodyWeightFirst(
                                      _activeWorkoutMove!
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
                                                isSelected: _activeWorkoutMove!
                                                        .equipment ==
                                                    e)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                  ],
          ))
    ]);
  }
}
