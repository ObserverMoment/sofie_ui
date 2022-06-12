// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/components/animated/mounting.dart';
// import 'package:sofie_ui/components/buttons.dart';
// import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_set_definition.dart';
// import 'package:sofie_ui/components/indicators.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/click_to_edit/number_picker_row_tap_to_edit.dart';
// import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
// import 'package:sofie_ui/components/user_input/pickers/load_picker.dart';
// import 'package:sofie_ui/components/user_input/pickers/rep_picker.dart';
// import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
// import 'package:sofie_ui/components/user_input/selectors/move_selector.dart';
// import 'package:sofie_ui/components/workout/workout_move_display.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/extensions/data_type_extensions.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/extensions/enum_extensions.dart';
// import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
// import 'package:sofie_ui/services/utils.dart';
// import 'package:collection/collection.dart';
// import 'package:uuid/uuid.dart';

// class MoveRepData {
//   double initialReps;
//   WorkoutMoveRepType repType;
//   DistanceUnit distanceUnit;
//   TimeUnit timeUnit;
//   double perSetRepAdjust;
//   bool enableLadder;
//   MoveRepData(
//       {this.initialReps = 10.0,
//       this.repType = WorkoutMoveRepType.reps,
//       this.distanceUnit = DistanceUnit.metres,
//       this.timeUnit = TimeUnit.seconds,
//       this.perSetRepAdjust = 0.0,
//       this.enableLadder = false});
// }

// class MoveLoadData {
//   double initialLoadAmount;
//   LoadUnit loadUnit;
//   double perSetLoadAdjust;
//   bool enableLadder;
//   MoveLoadData(
//       {this.initialLoadAmount = 0.0,
//       this.loadUnit = LoadUnit.kg,
//       this.perSetLoadAdjust = 0.0,
//       this.enableLadder = false});
// }

// class WorkoutSetGeneratorCreator extends StatefulWidget {
//   /// Only moves that have these as valid reps will be selectable.
//   final List<WorkoutMoveRepType> validRepTypes;
//   final void Function(WorkoutSet workoutSet) handleGeneratedSet;
//   final int newSetSortPosition;
//   const WorkoutSetGeneratorCreator(
//       {Key? key,
//       this.validRepTypes = const [],
//       required this.handleGeneratedSet,
//       required this.newSetSortPosition})
//       : super(key: key);

//   @override
//   State<WorkoutSetGeneratorCreator> createState() =>
//       _WorkoutSetGeneratorCreatorState();
// }

// class _WorkoutSetGeneratorCreatorState
//     extends State<WorkoutSetGeneratorCreator> {
//   int _activePageIndex = 0;
//   final PageController _controller = PageController();

//   /// If the user has only chosen moves with no equipment.
//   bool _equipmentSelectorRequired = false;

//   /// If the user has only chosen equipment where not [loadAdjustable]
//   bool _loadSelectorRequired = false;

//   /// Will be 5 if [_equipmentSelectorRequired] and [_loadSelectorRequired] are both true.
//   int _numActivePages = 3;

//   void _changeTab(int index) {
//     Utils.hideKeyboard(context);
//     _controller.toPage(index);
//     setState(() => _activePageIndex = index);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _validRepTypes = widget.validRepTypes.isNotEmpty
//         ? widget.validRepTypes
//         : WorkoutMoveRepType.values
//             .where((v) => v != WorkoutMoveRepType.artemisUnknown)
//             .toList();
//   }

//   late List<WorkoutMoveRepType> _validRepTypes;

//   // Page 1
//   // For supersets user can pick multiple moves.
//   final List<Move> _moves = [];
//   // Page 2
//   // Must be same length as moves array. Store selected equipment here.
//   final Map<Move, Equipment?> _equipmentForMoves = <Move, Equipment?>{};
//   // Page 3
//   // Must be same length as moves array. Store loads for selected equipment here if appropriate.
//   final Map<Move, MoveLoadData> _loadDataForMoves = <Move, MoveLoadData>{};
//   // Page 4
//   int _numSetsPerMove = 3;
//   final Map<Move, MoveRepData> _repDataForMoves = <Move, MoveRepData>{};

//   /// Check data from each page is valid.
//   List<String> get _pageOneErrors {
//     final errors = <String>[];
//     if (_moves.isEmpty) {
//       errors.add('Moves: You need to select some moves.');
//     }
//     if (_moves.toSet().length != _moves.length) {
//       errors.add(
//           'Moves: You should not add the same move twice into a superset.');
//     }
//     return errors;
//   }

//   List<String> get _pageTwoErrors {
//     final errors = <String>[];
//     if (_moves.length != _equipmentForMoves.keys.length ||
//         !_equipmentForMoves.entries.every(
//             (e) => e.key.selectableEquipments.isEmpty || e.value != null)) {
//       errors.add('Equipment: Some moves do not have equipment selected.');
//     }

//     return errors;
//   }

//   List<String> get _errors => [..._pageOneErrors, ..._pageTwoErrors];

//   final bool _savingToDB = false;

//   void _selectMove(Move move) {
//     setState(() {
//       _moves.add(move);
//       _equipmentForMoves[move] = null;
//       _repDataForMoves[move] = MoveRepData(repType: move.initialRepType);
//       _loadDataForMoves[move] = MoveLoadData();
//     });
//     _checkIfEquipmentAndLoadSelectorsRequired();
//   }

//   void _removeMove(Move move) {
//     _moves.remove(move);
//     _equipmentForMoves.remove(move);
//     _repDataForMoves.remove(move);
//     _loadDataForMoves.remove(move);
//     _checkIfEquipmentAndLoadSelectorsRequired();
//   }

//   void _updateEquipment(Move move, Equipment equipment) {
//     _equipmentForMoves[move] = equipment;
//     _checkIfEquipmentAndLoadSelectorsRequired();
//   }

//   void _checkIfEquipmentAndLoadSelectorsRequired() {
//     setState(() {
//       _equipmentSelectorRequired =
//           _moves.any((m) => m.selectableEquipments.isNotEmpty);

//       _loadSelectorRequired = _moves
//               .any((m) => m.requiredEquipments.any((e) => e.loadAdjustable)) ||
//           _equipmentForMoves.values.any((e) => e != null && e.loadAdjustable);

//       _equipmentForMoves.values.any((e) => e != null && e.loadAdjustable);

//       _numActivePages = _equipmentSelectorRequired && _loadSelectorRequired
//           ? 5
//           : _equipmentSelectorRequired || _loadSelectorRequired
//               ? 4
//               : 3;
//     });
//   }

//   void _updateLoad(Move move, double loadAmount, LoadUnit loadUnit) {
//     setState(() {
//       _loadDataForMoves[move]!.initialLoadAmount = loadAmount;
//       _loadDataForMoves[move]!.loadUnit = loadUnit;
//     });
//   }

//   void _updateEnableLoadLadder(Move move, bool enableLadder) =>
//       setState(() => _loadDataForMoves[move]!.enableLadder = enableLadder);

//   void _updatePerSetLoadAdjust(Move move, double perSetLoadAdjust) =>
//       setState(() {
//         _loadDataForMoves[move]!.perSetLoadAdjust = perSetLoadAdjust;
//       });

//   void _updateNumSetsPerMove(int numSets) =>
//       setState(() => _numSetsPerMove = numSets);

//   void _updateInitialReps(Move move, double reps) =>
//       setState(() => _repDataForMoves[move]!.initialReps = reps);

//   void _updatePerSetRepAdjust(Move move, double perSetRepAdjust) =>
//       setState(() => _repDataForMoves[move]!.perSetRepAdjust = perSetRepAdjust);

//   void _updateRepType(Move move, WorkoutMoveRepType repType) =>
//       setState(() => _repDataForMoves[move]!.repType = repType);

//   void _updateDistanceUnit(Move move, DistanceUnit distanceUnit) =>
//       setState(() => _repDataForMoves[move]!.distanceUnit = distanceUnit);

//   void _updateTimeUnit(Move move, TimeUnit timeUnit) =>
//       setState(() => _repDataForMoves[move]!.timeUnit = timeUnit);

//   void _updateEnableRepLadder(Move move, bool enableLadder) =>
//       setState(() => _repDataForMoves[move]!.enableLadder = enableLadder);

//   void _saveGeneratedSet(WorkoutSet workoutSet) {
//     if (_errors.isEmpty) {
//       widget.handleGeneratedSet(workoutSet);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MyPageScaffold(
//       navigationBar: MyNavBar(
//         customLeading: NavBarCancelButton(context.pop),
//         middle: const NavBarLargeTitle('Generate Set'),
//         trailing: _savingToDB
//             ? const NavBarTrailingRow(children: [NavBarLoadingIndicator()])
//             : null,
//       ),
//       child: Column(
//         children: [
//           Expanded(
//             child: PageView(
//               onPageChanged: _changeTab,
//               controller: _controller,
//               children: [
//                 _MoveSelectorUI(
//                   moves: _moves,
//                   removeMove: _removeMove,
//                   selectMove: _selectMove,
//                   validRepTypes: _validRepTypes,
//                 ),
//                 if (_equipmentSelectorRequired)
//                   _EquipmentSelectorUI(
//                     equipmentForMoves: _equipmentForMoves,
//                     moves: _moves,
//                     updateEquipment: _updateEquipment,
//                   ),
//                 if (_loadSelectorRequired)
//                   _EquipmentLoadSelectorUI(
//                     loadDataForMoves: _loadDataForMoves,
//                     equipmentForMoves: _equipmentForMoves,
//                     moves: _moves,
//                     updateLoad: _updateLoad,
//                     updatePerSetLoadAdjust: _updatePerSetLoadAdjust,
//                     updateEnableLoadLadder: _updateEnableLoadLadder,
//                   ),
//                 _NumSetsAndRepsSelectorUI(
//                   repDataForMoves: _repDataForMoves,
//                   numSetsPerMove: _numSetsPerMove,
//                   updateNumSetsPerMove: _updateNumSetsPerMove,
//                   updatePerSetRepAdjust: _updatePerSetRepAdjust,
//                   updateDistanceUnit: _updateDistanceUnit,
//                   updateInitialReps: _updateInitialReps,
//                   updateRepType: _updateRepType,
//                   updateTimeUnit: _updateTimeUnit,
//                   validRepTypes: _validRepTypes,
//                   equipmentForMoves: _equipmentForMoves,
//                   updateEnableRepLadder: _updateEnableRepLadder,
//                 ),
//                 _GeneratedSetPreview(
//                   moves: _moves,
//                   equipmentForMoves: _equipmentForMoves,
//                   loadDataForMoves: _loadDataForMoves,
//                   numSetsPerMove: _numSetsPerMove,
//                   repDataForMoves: _repDataForMoves,
//                   errors: _errors,
//                   saveGeneratedSet: _saveGeneratedSet,
//                   newSetSortPosition: widget.newSetSortPosition,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: 80,
//                   child: _activePageIndex == 0
//                       ? Container()
//                       : TertiaryButton(
//                           text: 'Prev',
//                           onPressed: () => _changeTab(_activePageIndex - 1)),
//                 ),
//                 BasicProgressDots(
//                     numDots: _numActivePages, currentIndex: _activePageIndex),
//                 SizedBox(
//                   width: 80,
//                   child: _activePageIndex == _numActivePages - 1
//                       ? Container()
//                       : TertiaryButton(
//                           text: 'Next',
//                           onPressed: () => _changeTab(_activePageIndex + 1)),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// /// Allows the user to select one (set) or many (superset+) moves one by one.
// class _MoveSelectorUI extends StatelessWidget {
//   final List<Move> moves;
//   final void Function(Move move) selectMove;
//   final void Function(Move move) removeMove;
//   final List<WorkoutMoveRepType> validRepTypes;
//   const _MoveSelectorUI(
//       {Key? key,
//       required this.moves,
//       required this.selectMove,
//       required this.removeMove,
//       required this.validRepTypes})
//       : super(key: key);

//   void _addMove(BuildContext context) => context.push(
//       child: MoveSelector(
//           customFilter: (movesList) => movesList
//               .where((m) =>
//                   !moves.contains(m) &&
//                   m.validRepTypes.any((r) => validRepTypes.contains(r)))
//               .toList(),
//           selectMove: (m) {
//             selectMove(m);
//             context.pop();
//           },
//           onCancel: context.pop));

//   @override
//   Widget build(BuildContext context) {
//     return moves.isEmpty
//         ? ContentEmptyPlaceholder(
//             message: 'Set Generator!',
//             explainer:
//                 'The set generator allow you to easily create more complex sets such as supersets, rep ladders and load ladders. Select your moves, choose your equipment, enter reps and load info and then hit generate!',
//             showIcon: false,
//             actions: [
//                 EmptyPlaceholderAction(
//                     action: () => _addMove(context),
//                     buttonIcon: CupertinoIcons.add,
//                     buttonText: 'Add First Move'),
//               ])
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(left: 8.0, bottom: 8, top: 8),
//                 child: MyHeaderText(
//                   'SELECT MOVES',
//                 ),
//               ),
//               if (moves.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: MyText(
//                     getWorkoutSetDefinitionText(moves.length) ?? '',
//                     color: Styles.primaryAccent,
//                   ),
//                 ),
//               if (moves.isNotEmpty)
//                 Flexible(
//                   child: FadeInUp(
//                     child: ListView(
//                       shrinkWrap: true,
//                       children: moves
//                           .mapIndexed((i, m) => Row(
//                                 children: [
//                                   MyText((i + 1).toString(), subtext: true),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: ContentBox(
//                                         child: MyText(m.name,
//                                             size: FONTSIZE.four)),
//                                   ),
//                                   CupertinoButton(
//                                     onPressed: () => removeMove(m),
//                                     child: const Icon(CupertinoIcons.delete,
//                                         size: 18),
//                                   )
//                                 ],
//                               ))
//                           .toList(),
//                     ),
//                   ),
//                 ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: CreateTextIconButton(
//                         text: 'Add Move', onPressed: () => _addMove(context)),
//                   ),
//                 ],
//               ),
//             ],
//           );
//   }
// }

// class _EquipmentSelectorUI extends StatelessWidget {
//   final List<Move> moves;
//   final Map<Move, Equipment?> equipmentForMoves;
//   final void Function(Move move, Equipment equipment) updateEquipment;
//   const _EquipmentSelectorUI(
//       {Key? key,
//       required this.moves,
//       required this.equipmentForMoves,
//       required this.updateEquipment})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(left: 8.0, bottom: 16, top: 8),
//           child: MyHeaderText(
//             'SELECT EQUIPMENT',
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             shrinkWrap: true,
//             children: moves
//                 .where((m) => m.selectableEquipments.isNotEmpty)
//                 .map((m) => Padding(
//                       padding: const EdgeInsets.only(bottom: 24.0),
//                       child: Column(
//                         children: [
//                           ContentBox(
//                               child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               MyText(m.name),
//                               MyText(
//                                 equipmentForMoves[m] != null
//                                     ? ' - ${equipmentForMoves[m]!.name}'
//                                     : '',
//                                 color: Styles.primaryAccent,
//                               )
//                             ],
//                           )),
//                           const SizedBox(height: 16),
//                           // EquipmentSelectorList(
//                           //     tileSize: 90,
//                           //     selectedEquipments: equipmentForMoves[m] != null
//                           //         ? [equipmentForMoves[m]!]
//                           //         : [],
//                           //     equipments: m.selectableEquipments
//                           //         .sortedBy<String>((e) => e.name),
//                           //     handleSelection: (e) => updateEquipment(m, e)),
//                         ],
//                       ),
//                     ))
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _EquipmentLoadSelectorUI extends StatelessWidget {
//   final List<Move> moves;
//   final Map<Move, Equipment?> equipmentForMoves;
//   final Map<Move, MoveLoadData> loadDataForMoves;
//   final void Function(Move move, double perSetLoadAdjust)
//       updatePerSetLoadAdjust;
//   final void Function(Move move, double loadAmount, LoadUnit loadUnit)
//       updateLoad;
//   final void Function(Move move, bool enableLadder) updateEnableLoadLadder;
//   const _EquipmentLoadSelectorUI(
//       {Key? key,
//       required this.loadDataForMoves,
//       required this.moves,
//       required this.equipmentForMoves,
//       required this.updateLoad,
//       required this.updatePerSetLoadAdjust,
//       required this.updateEnableLoadLadder})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(left: 8.0, bottom: 16, top: 8),
//           child: MyHeaderText(
//             'SELECT LOAD',
//           ),
//         ),
//         // ListView(
//         //   shrinkWrap: true,
//         //   children: moves
//         //       .where((m) =>
//         //           (equipmentForMoves[m] != null &&
//         //               equipmentForMoves[m]!.loadAdjustable) ||
//         //           m.requiredEquipments.any((e) => e.loadAdjustable))
//         //       .map((m) => Padding(
//         //             padding: const EdgeInsets.only(bottom: 24.0),
//         //             child: Column(
//         //               children: [
//         //                 ContentBox(
//         //                     child: Row(
//         //                   mainAxisAlignment: MainAxisAlignment.center,
//         //                   children: [
//         //                     MyText(m.name),
//         //                     MyText(
//         //                       equipmentForMoves[m] != null
//         //                           ? ' - ${equipmentForMoves[m]!.name}'
//         //                           : '',
//         //                       color: Styles.primaryAccent,
//         //                     )
//         //                   ],
//         //                 )),
//         //                 const SizedBox(height: 16),
//         //                 Row(
//         //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                   children: [
//         //                     Row(
//         //                       children: [
//         //                         SizedBox(
//         //                             width: 100,
//         //                             child: AnimatedSwitcher(
//         //                                 duration: kStandardAnimationDuration,
//         //                                 child: loadDataForMoves[m]!.enableLadder
//         //                                     ? const MyText('Initial Load',
//         //                                         textAlign: TextAlign.start)
//         //                                     : const MyText('Load',
//         //                                         textAlign: TextAlign.start))),
//         //                         LoadPickerDisplay(
//         //                             loadAmount:
//         //                                 loadDataForMoves[m]!.initialLoadAmount,
//         //                             updateLoad: (amount, unit) =>
//         //                                 updateLoad(m, amount, unit),
//         //                             loadUnit: loadDataForMoves[m]!.loadUnit,
//         //                             valueFontSize: FONTSIZE.six,
//         //                             suffixFontSize: FONTSIZE.three),
//         //                       ],
//         //                     ),
//         //                     CupertinoSwitchRow(
//         //                         title: 'Ladder',
//         //                         updateValue: (v) =>
//         //                             updateEnableLoadLadder(m, v),
//         //                         value: loadDataForMoves[m]!.enableLadder),
//         //                   ],
//         //                 ),
//         //                 GrowInOut(
//         //                   show: loadDataForMoves[m]!.enableLadder,
//         //                   child: Padding(
//         //                     padding: const EdgeInsets.symmetric(
//         //                         vertical: 6.0, horizontal: 16),
//         //                     child: DoublePickerRowTapToEdit(
//         //                       value: loadDataForMoves[m]!.perSetLoadAdjust,
//         //                       saveValue: (adjustBy) =>
//         //                           updatePerSetLoadAdjust(m, adjustBy),
//         //                       title: 'Each round adjust ',
//         //                       allowNegative: true,
//         //                       suffix: loadDataForMoves[m]!.loadUnit.display,
//         //                     ),
//         //                   ),
//         //                 ),
//         //               ],
//         //             ),
//         //           ))
//         //       .toList(),
//         // )
//       ],
//     );
//   }
// }

// class _NumSetsAndRepsSelectorUI extends StatelessWidget {
//   final int numSetsPerMove;
//   final void Function(int numSets) updateNumSetsPerMove;
//   final Map<Move, MoveRepData> repDataForMoves;
//   final Map<Move, Equipment?> equipmentForMoves;
//   final void Function(Move move, double perSetRepAdjust) updatePerSetRepAdjust;
//   final void Function(Move move, double initialReps) updateInitialReps;
//   final void Function(Move move, WorkoutMoveRepType repType) updateRepType;
//   final void Function(Move move, DistanceUnit distanceUnit) updateDistanceUnit;
//   final void Function(Move move, TimeUnit timeUnit) updateTimeUnit;
//   final void Function(Move move, bool enableLadder) updateEnableRepLadder;
//   final List<WorkoutMoveRepType> validRepTypes;
//   const _NumSetsAndRepsSelectorUI(
//       {Key? key,
//       required this.numSetsPerMove,
//       required this.updateNumSetsPerMove,
//       required this.updateRepType,
//       required this.updateDistanceUnit,
//       required this.updateTimeUnit,
//       required this.repDataForMoves,
//       required this.updateInitialReps,
//       required this.updatePerSetRepAdjust,
//       required this.validRepTypes,
//       required this.equipmentForMoves,
//       required this.updateEnableRepLadder})
//       : super(key: key);

//   String _buildRepAdjustSuffix(WorkoutMoveRepType repType, double reps,
//       DistanceUnit distanceUnit, TimeUnit timeUnit) {
//     switch (repType) {
//       case WorkoutMoveRepType.distance:
//         return describeEnum(distanceUnit);
//       case WorkoutMoveRepType.time:
//         return describeEnum(timeUnit);
//       case WorkoutMoveRepType.reps:
//         return reps == 1 ? 'rep' : 'reps';
//       case WorkoutMoveRepType.calories:
//         return reps == 1 ? 'cal' : 'cals';
//       default:
//         return describeEnum(repType);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(left: 8.0, top: 8),
//           child: MyHeaderText(
//             'DEFINE REPS',
//           ),
//         ),
//         const HorizontalLine(),
//         Expanded(
//           child: ListView(
//             shrinkWrap: true,
//             children: [
//               Container(
//                   padding: const EdgeInsets.all(8),
//                   child: Column(
//                     children: [
//                       IntPickerRowTapToEdit(
//                         value: numSetsPerMove,
//                         min: 1,
//                         max: 50,
//                         saveValue: updateNumSetsPerMove,
//                         title: 'Number of Sets',
//                       ),
//                       const SizedBox(height: 8),
//                       const MyText(
//                         'Eg. For a superset of two moves you would do both moves this many times',
//                         size: FONTSIZE.two,
//                         maxLines: 3,
//                         subtext: true,
//                       ),
//                     ],
//                   )),
//               const HorizontalLine(),
//               ...repDataForMoves.entries.map((e) => Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: Column(
//                       children: [
//                         ContentBox(
//                             child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             MyText(e.key.name),
//                             MyText(
//                               equipmentForMoves[e.key] != null
//                                   ? ' - ${equipmentForMoves[e.key]!.name}'
//                                   : '',
//                               color: Styles.primaryAccent,
//                             )
//                           ],
//                         )),
//                         const SizedBox(height: 16),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     SizedBox(
//                                         width: 80,
//                                         child: AnimatedSwitcher(
//                                             duration:
//                                                 kStandardAnimationDuration,
//                                             child: e.value.enableLadder
//                                                 ? const MyText('First Set',
//                                                     textAlign: TextAlign.start)
//                                                 : const MyText('Set Reps',
//                                                     textAlign:
//                                                         TextAlign.start))),
//                                     // RepPickerDisplay(
//                                     //     validRepTypes: validRepTypes
//                                     //         .where((r) =>
//                                     //             e.key.validRepTypes.contains(r))
//                                     //         .toList(),
//                                     //     reps: e.value.initialReps,
//                                     //     updateReps: (reps) =>
//                                     //         updateInitialReps(e.key, reps),
//                                     //     repType: e.value.repType,
//                                     //     updateRepType: (repType) =>
//                                     //         updateRepType(e.key, repType),
//                                     //     distanceUnit: e.value.distanceUnit,
//                                     //     updateDistanceUnit: (distanceUnit) =>
//                                     //         updateDistanceUnit(
//                                     //             e.key, distanceUnit),
//                                     //     timeUnit: e.value.timeUnit,
//                                     //     updateTimeUnit: (timeUnit) =>
//                                     //         updateTimeUnit(e.key, timeUnit),
//                                     //     valueFontSize: FONTSIZE.six,
//                                     //     suffixFontSize: FONTSIZE.three),
//                                   ],
//                                 ),
//                                 CupertinoSwitchRow(
//                                     title: 'Ladder',
//                                     updateValue: (v) =>
//                                         updateEnableRepLadder(e.key, v),
//                                     value: e.value.enableLadder),
//                               ],
//                             ),
//                             GrowInOut(
//                               show: e.value.enableLadder,
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 6.0, horizontal: 16),
//                                 child: DoublePickerRowTapToEdit(
//                                   value: e.value.perSetRepAdjust,
//                                   saveValue: (adjustBy) =>
//                                       updatePerSetRepAdjust(e.key, adjustBy),
//                                   title: 'After each round adjust by',
//                                   allowNegative: true,
//                                   suffix: _buildRepAdjustSuffix(
//                                       e.value.repType,
//                                       e.value.perSetRepAdjust,
//                                       e.value.distanceUnit,
//                                       e.value.timeUnit),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _GeneratedSetPreview extends StatelessWidget {
//   final int numSetsPerMove;
//   final List<Move> moves;
//   final Map<Move, Equipment?> equipmentForMoves;
//   final Map<Move, MoveRepData> repDataForMoves;
//   final Map<Move, MoveLoadData> loadDataForMoves;
//   final List<String> errors;
//   final void Function(WorkoutSet workoutSet) saveGeneratedSet;
//   final int newSetSortPosition;
//   const _GeneratedSetPreview(
//       {Key? key,
//       required this.numSetsPerMove,
//       required this.equipmentForMoves,
//       required this.repDataForMoves,
//       required this.loadDataForMoves,
//       required this.moves,
//       required this.errors,
//       required this.saveGeneratedSet,
//       required this.newSetSortPosition})
//       : super(key: key);

//   WorkoutSet _genWorkoutSet() => WorkoutSet()
//     ..id = 'tempId-${const Uuid().v1()}'
//     ..sortPosition = newSetSortPosition
//     ..duration = 0
//     ..workoutMoves = List.generate(
//         numSetsPerMove,
//         (round) => moves.mapIndexed((i, m) => _genWorkoutMove(
//             m,
//             equipmentForMoves[m],
//             repDataForMoves[m]!,
//             loadDataForMoves[m]!,
//             round,
//             i))).expand((x) => x).toList();

//   /// [round] is zero indexed
//   WorkoutMove _genWorkoutMove(Move m, Equipment? e, MoveRepData r,
//       MoveLoadData l, int round, int index) {
//     return WorkoutMove()
//       ..id = const Uuid().v1()
//       ..sortPosition = (round * moves.length) + index
//       ..move = m
//       ..equipment = e
//       ..reps = r.enableLadder
//           ? (r.initialReps + (r.perSetRepAdjust * round)).clamp(0.0, 1000.0)
//           : r.initialReps
//       ..repType = r.repType
//       ..timeUnit = r.timeUnit
//       ..distanceUnit = r.distanceUnit
//       ..loadAmount = l.enableLadder
//           ? (l.initialLoadAmount + (l.perSetLoadAdjust * round))
//               .clamp(0.0, 1000.0)
//           : l.initialLoadAmount
//       ..loadUnit = l.loadUnit;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return errors.isEmpty
//         ? Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 16.0, bottom: 8),
//                 child: Column(
//                   children: [
//                     PrimaryButton(
//                         onPressed: () => saveGeneratedSet(_genWorkoutSet()),
//                         text: 'Generate Set'),
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: MyText(
//                           'You can edit further after generating the set',
//                           size: FONTSIZE.two,
//                           subtext: true),
//                     )
//                   ],
//                 ),
//               ),
//               Expanded(
//                   child: ListView(
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                 shrinkWrap: true,
//                 children: List.generate(
//                     numSetsPerMove,
//                     (round) => moves.mapIndexed((i, m) => WorkoutMoveDisplay(
//                         _genWorkoutMove(
//                             m,
//                             equipmentForMoves[m],
//                             repDataForMoves[m]!,
//                             loadDataForMoves[m]!,
//                             round,
//                             i)))).expand((x) => x).toList(),
//               ))
//             ],
//           )
//         : ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: MyText(
//                   'You need to fix a few things before you can generate a set!',
//                   textAlign: TextAlign.center,
//                   maxLines: 3,
//                   lineHeight: 1.5,
//                 ),
//               ),
//               ...errors
//                   .map((e) => Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: ContentBox(
//                             child: Row(
//                           children: [
//                             Expanded(
//                                 child: MyText(e, maxLines: 3, lineHeight: 1.5))
//                           ],
//                         )),
//                       ))
//                   .toList()
//             ],
//           );
//   }
// }
