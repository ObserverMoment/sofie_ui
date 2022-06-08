import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_set_definition.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/number_picker_row_tap_to_edit.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/move_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_sessions/resistance_session/components/resistance_rep_type_selector.dart';
import 'package:sofie_ui/modules/workout_sessions/resistance_session/display/resistance_set_display.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uuid/uuid.dart';

class MoveRepData {
  int initialReps;
  int perSetRepAdjust;
  bool enableLadder;
  ResistanceSetRepType repType;
  MoveRepData(
      {this.initialReps = 10,
      this.perSetRepAdjust = 0,
      this.enableLadder = false,
      this.repType = ResistanceSetRepType.reps});
}

class ResistanceExerciseGenerator extends StatefulWidget {
  final Function(ResistanceExercise resistanceExercise) onSave;
  const ResistanceExerciseGenerator({Key? key, required this.onSave})
      : super(key: key);

  @override
  State<ResistanceExerciseGenerator> createState() =>
      _ResistanceExerciseGeneratorState();
}

class _ResistanceExerciseGeneratorState
    extends State<ResistanceExerciseGenerator> {
  int _activePageIndex = 0;
  final PageController _controller = PageController();

  /// If the user has only chosen moves with no equipment.
  bool _equipmentSelectorRequired = false;

  /// Will be 4 if [_equipmentSelectorRequired] is true.
  int _numActivePages = 3;

  void _changeTab(int index) {
    Utils.hideKeyboard(context);
    _controller.toPage(index);
    setState(() => _activePageIndex = index);
  }

  // Page 1
  // For supersets user can pick multiple moves.
  final List<Move> _moves = [];
  // Page 2
  // Must be same length as moves array. Store selected equipment here.
  final Map<Move, Equipment?> _equipmentForMoves = <Move, Equipment?>{};
  // Page 3
  int _numSetsPerMove = 3;
  final Map<Move, MoveRepData> _repDataForMoves = <Move, MoveRepData>{};

  /// Check data from each page is valid.
  List<String> get _pageOneErrors {
    final errors = <String>[];
    if (_moves.isEmpty) {
      errors.add('Moves: You need to select some moves.');
    }
    if (_moves.toSet().length != _moves.length) {
      errors.add(
          'Moves: You should not add the same move twice into a superset.');
    }
    return errors;
  }

  List<String> get _pageTwoErrors {
    final errors = <String>[];
    if (_moves.length != _equipmentForMoves.keys.length ||
        !_equipmentForMoves.entries.every(
            (e) => e.key.selectableEquipments.isEmpty || e.value != null)) {
      errors.add('Equipment: Some moves do not have equipment selected.');
    }

    return errors;
  }

  List<String> get _errors => [..._pageOneErrors, ..._pageTwoErrors];

  final bool _savingToDB = false;

  void _selectMove(Move move) {
    setState(() {
      _moves.add(move);
      _equipmentForMoves[move] = null;
      _repDataForMoves[move] = MoveRepData();
    });
    _checkIfEquipmentSelectorsRequired();
  }

  void _removeMove(Move move) {
    _moves.remove(move);
    _equipmentForMoves.remove(move);
    _repDataForMoves.remove(move);
    _checkIfEquipmentSelectorsRequired();
  }

  void _updateEquipment(Move move, Equipment equipment) {
    _equipmentForMoves[move] = equipment;
    _checkIfEquipmentSelectorsRequired();
  }

  void _checkIfEquipmentSelectorsRequired() {
    setState(() {
      _equipmentSelectorRequired =
          _moves.any((m) => m.selectableEquipments.isNotEmpty);

      _equipmentForMoves.values.any((e) => e != null && e.loadAdjustable);

      _numActivePages = _equipmentSelectorRequired ? 4 : 3;
    });
  }

  void _updateNumSetsPerMove(int numSets) =>
      setState(() => _numSetsPerMove = numSets);

  void _updateRepType(Move move, ResistanceSetRepType repType) =>
      setState(() => _repDataForMoves[move]!.repType = repType);

  void _updateInitialReps(Move move, int reps) =>
      setState(() => _repDataForMoves[move]!.initialReps = reps);

  void _updateEnableRepLadder(Move move, bool enableLadder) =>
      setState(() => _repDataForMoves[move]!.enableLadder = enableLadder);

  void _updatePerSetRepAdjust(Move move, int perSetRepAdjust) =>
      setState(() => _repDataForMoves[move]!.perSetRepAdjust = perSetRepAdjust);

  void _saveGeneratedSet(ResistanceExercise resistanceExercise) {
    if (_errors.isEmpty) {
      widget.onSave(resistanceExercise);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(context.pop),
        middle: const NavBarLargeTitle('New Set'),
        trailing: _savingToDB ? const NavBarLoadingIndicator() : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 80,
                  child: _activePageIndex == 0
                      ? Container()
                      : TertiaryButton(
                          text: 'Prev',
                          onPressed: () => _changeTab(_activePageIndex - 1)),
                ),
                BasicProgressDots(
                    numDots: _numActivePages, currentIndex: _activePageIndex),
                SizedBox(
                  width: 80,
                  child: _activePageIndex == _numActivePages - 1
                      ? Container()
                      : TertiaryButton(
                          text: 'Next',
                          onPressed: () => _changeTab(_activePageIndex + 1)),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: _changeTab,
              controller: _controller,
              children: [
                _MoveSelectorUI(
                  moves: _moves,
                  removeMove: _removeMove,
                  selectMove: _selectMove,
                ),
                if (_equipmentSelectorRequired)
                  _EquipmentSelectorUI(
                    equipmentForMoves: _equipmentForMoves,
                    moves: _moves,
                    updateEquipment: _updateEquipment,
                  ),
                _NumSetsAndRepsSelectorUI(
                  repDataForMoves: _repDataForMoves,
                  numSetsPerMove: _numSetsPerMove,
                  updateNumSetsPerMove: _updateNumSetsPerMove,
                  updatePerSetRepAdjust: _updatePerSetRepAdjust,
                  updateInitialReps: _updateInitialReps,
                  updateRepType: _updateRepType,
                  equipmentForMoves: _equipmentForMoves,
                  updateEnableRepLadder: _updateEnableRepLadder,
                ),
                _GeneratedSetPreview(
                  moves: _moves,
                  equipmentForMoves: _equipmentForMoves,
                  numSetsPerMove: _numSetsPerMove,
                  repDataForMoves: _repDataForMoves,
                  errors: _errors,
                  onSave: _saveGeneratedSet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Allows the user to select one (set) or many (superset+) moves one by one.
class _MoveSelectorUI extends StatelessWidget {
  final List<Move> moves;
  final void Function(Move move) selectMove;
  final void Function(Move move) removeMove;
  const _MoveSelectorUI({
    Key? key,
    required this.moves,
    required this.selectMove,
    required this.removeMove,
  }) : super(key: key);

  void _addMove(BuildContext context) => context.push(
      child: MoveSelector(
          customFilter: (movesList) => movesList
              .where((m) =>
                  !moves.contains(m) &&
                  m.validRepTypes.contains(WorkoutMoveRepType.reps))
              .toList(),
          selectMove: (m) {
            selectMove(m);
            context.pop();
          },
          onCancel: context.pop));

  @override
  Widget build(BuildContext context) {
    return moves.isEmpty
        ? YourContentEmptyPlaceholder(
            message: 'Set Generator!',
            explainer:
                'The set generator allow you to easily create simple sets or more complex sets such as supersets and rep ladders. Select your moves, choose your equipment, enter rep info and then hit generate!',
            showIcon: false,
            actions: [
                EmptyPlaceholderAction(
                    action: () => _addMove(context),
                    buttonIcon: CupertinoIcons.add,
                    buttonText: 'Select Movement'),
              ])
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HorizontalLine(),
              if (moves.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        getWorkoutSetDefinitionText(moves.length) ?? '',
                      ),
                    ],
                  ),
                ),
              if (moves.isNotEmpty)
                Flexible(
                  child: FadeInUp(
                    child: ListView(
                      shrinkWrap: true,
                      children: moves
                          .mapIndexed((i, m) => Row(
                                children: [
                                  MyText((i + 1).toString(), subtext: true),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ContentBox(
                                        child: MyText(m.name,
                                            size: FONTSIZE.four)),
                                  ),
                                  CupertinoButton(
                                    onPressed: () => removeMove(m),
                                    child: const Icon(CupertinoIcons.delete,
                                        size: 18),
                                  )
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CreateTextIconButton(
                        text: 'Add Move', onPressed: () => _addMove(context)),
                  ),
                ],
              ),
            ],
          );
  }
}

class _EquipmentSelectorUI extends StatelessWidget {
  final List<Move> moves;
  final Map<Move, Equipment?> equipmentForMoves;
  final void Function(Move move, Equipment equipment) updateEquipment;
  const _EquipmentSelectorUI(
      {Key? key,
      required this.moves,
      required this.equipmentForMoves,
      required this.updateEquipment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HorizontalLine(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: moves
                .where((m) => m.selectableEquipments.isNotEmpty)
                .map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        children: [
                          ContentBox(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyText(m.name),
                              MyText(
                                equipmentForMoves[m] != null
                                    ? ' - ${equipmentForMoves[m]!.name}'
                                    : '',
                                color: Styles.primaryAccent,
                              )
                            ],
                          )),
                          const SizedBox(height: 16),
                          EquipmentSelectorList(
                              tileSize: 100,
                              selectedEquipments: equipmentForMoves[m] != null
                                  ? [equipmentForMoves[m]!]
                                  : [],
                              equipments: m.selectableEquipments
                                  .sortedBy<String>((e) => e.name),
                              handleSelection: (e) => updateEquipment(m, e)),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _NumSetsAndRepsSelectorUI extends StatelessWidget {
  final int numSetsPerMove;
  final void Function(int numSets) updateNumSetsPerMove;
  final Map<Move, MoveRepData> repDataForMoves;
  final Map<Move, Equipment?> equipmentForMoves;
  final void Function(Move move, int perSetRepAdjust) updatePerSetRepAdjust;
  final void Function(Move move, int initialReps) updateInitialReps;
  final void Function(Move move, ResistanceSetRepType repType) updateRepType;
  final void Function(Move move, bool enableLadder) updateEnableRepLadder;
  const _NumSetsAndRepsSelectorUI(
      {Key? key,
      required this.numSetsPerMove,
      required this.updateNumSetsPerMove,
      required this.repDataForMoves,
      required this.updateInitialReps,
      required this.updatePerSetRepAdjust,
      required this.equipmentForMoves,
      required this.updateEnableRepLadder,
      required this.updateRepType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HorizontalLine(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const MyText(
                            'How many sets?',
                            size: FONTSIZE.five,
                          ),
                          SizedBox(
                            width: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: MyStatefulNumberInput(
                                initialValue: numSetsPerMove,
                                textSize: 24,
                                update: (reps) =>
                                    updateNumSetsPerMove(reps.toInt()),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const MyText(
                        'Eg. For a superset made up of two moves you would do both moves this many times',
                        size: FONTSIZE.two,
                        maxLines: 3,
                        subtext: true,
                        lineHeight: 1.2,
                      ),
                    ],
                  )),
              const HorizontalLine(),
              ...repDataForMoves.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      children: [
                        ContentBox(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(e.key.name),
                            MyText(
                              equipmentForMoves[e.key] != null
                                  ? ' - ${equipmentForMoves[e.key]!.name}'
                                  : '',
                              color: Styles.primaryAccent,
                            )
                          ],
                        )),
                        const SizedBox(height: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: MyStatefulNumberInput(
                                          initialValue: e.value.initialReps,
                                          update: (reps) => updateInitialReps(
                                              e.key, reps.toInt()),
                                        ),
                                      ),
                                    ),
                                    ResistanceRepTypeSelector(
                                      resistanceSetRepType: e.value.repType,
                                      updateResistanceSetRepType: (repType) =>
                                          updateRepType(
                                        e.key,
                                        repType,
                                      ),
                                    )
                                  ],
                                ),
                                CupertinoSwitchRow(
                                    title: 'Ladder',
                                    updateValue: (v) =>
                                        updateEnableRepLadder(e.key, v),
                                    value: e.value.enableLadder),
                              ],
                            ),
                            GrowInOut(
                              show: e.value.enableLadder,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 8),
                                child: IntPickerRowTapToEdit(
                                    value: e.value.perSetRepAdjust,
                                    min: -20,
                                    max: 20,
                                    saveValue: (adjustBy) =>
                                        updatePerSetRepAdjust(e.key, adjustBy),
                                    title: 'Each round adjust by',
                                    suffix: e.value.repType.display),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}

class _GeneratedSetPreview extends StatelessWidget {
  final int numSetsPerMove;
  final List<Move> moves;
  final Map<Move, Equipment?> equipmentForMoves;
  final Map<Move, MoveRepData> repDataForMoves;
  final List<String> errors;
  final void Function(ResistanceExercise resistanceExercise) onSave;
  const _GeneratedSetPreview({
    Key? key,
    required this.numSetsPerMove,
    required this.equipmentForMoves,
    required this.repDataForMoves,
    required this.moves,
    required this.errors,
    required this.onSave,
  }) : super(key: key);

  ResistanceExercise _genExercise() {
    final now = DateTime.now();
    final resistanceSets = moves
        .mapIndexed(
            (i, m) => _genSet(m, equipmentForMoves[m], repDataForMoves[m]!, i))
        .toList();
    return ResistanceExercise()
      ..id = 'tempId-${const Uuid().v1()}'
      ..createdAt = now
      ..updatedAt = now
      ..sortPosition = 0
      ..resistanceSets = resistanceSets;
  }

  /// [round] is zero indexed
  ResistanceSet _genSet(Move m, Equipment? e, MoveRepData r, int index) {
    return ResistanceSet()
      ..id = const Uuid().v1()
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..sortPosition = index
      ..move = m
      ..equipment = e
      ..repType = r.repType
      ..reps = List.generate(
          numSetsPerMove, (i) => r.initialReps + (i * r.perSetRepAdjust));
  }

  @override
  Widget build(BuildContext context) {
    final isSuperSet = moves.length > 1;

    return errors.isEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                child: Column(
                  children: [
                    PrimaryButton(
                        onPressed: () => onSave(_genExercise()),
                        text: 'Generate Set'),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: MyText(
                          'You can edit further after generating the set',
                          size: FONTSIZE.two,
                          subtext: true),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shrinkWrap: true,
                      children: [
                    if (isSuperSet)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Tag(tag: 'SUPERSET'),
                          ],
                        ),
                      ),
                    ...moves
                        .mapIndexed((i, m) => ResistanceSetDisplay(
                            resistanceSet: _genSet(m, equipmentForMoves[m],
                                repDataForMoves[m]!, i)))
                        .toList()
                  ]))
            ],
          )
        : ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: MyText(
                  'You need to fix a few things before you can generate a set!',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  lineHeight: 1.5,
                ),
              ),
              ...errors
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ContentBox(
                            child: Row(
                          children: [
                            Expanded(
                                child: MyText(e, maxLines: 3, lineHeight: 1.5))
                          ],
                        )),
                      ))
                  .toList()
            ],
          );
  }
}
