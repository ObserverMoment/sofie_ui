// import 'package:flutter/cupertino.dart';
// import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
// import 'package:implicitly_animated_reorderable_list/transitions.dart';
// import 'package:provider/provider.dart';
// import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
// import 'package:sofie_ui/components/animated/mounting.dart';
// import 'package:sofie_ui/components/creators/workout_creator/workout_section_creator/workout_set_generator_creator.dart';
// import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_move_creator.dart';
// import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_set_creator_ui.dart';
// import 'package:sofie_ui/components/fab_page.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
// import 'package:sofie_ui/components/user_input/pickers/round_picker.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/extensions/data_type_extensions.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/services/repos/core_data_repo.dart';
// import 'package:sofie_ui/services/default_object_factory.dart';
// import 'package:sofie_ui/services/repos/move_data.repo.dart';
// import 'package:uuid/uuid.dart';

// /// Make modifications to the structure of the section before starting.
// class DoWorkoutSectionModifications extends StatelessWidget {
//   final int sectionIndex;
//   const DoWorkoutSectionModifications({Key? key, required this.sectionIndex})
//       : super(key: key);

//   /// For ARMAP Only (Sept 2021).
//   void _updateSectionTimecap(BuildContext context, int seconds) {
//     context
//         .read<DoWorkoutBloc>()
//         .updateWorkoutSectionTimecap(sectionIndex, seconds);
//   }

//   void _updateSectionRounds(BuildContext context, int rounds) {
//     context
//         .read<DoWorkoutBloc>()
//         .updateWorkoutSectionRounds(sectionIndex, rounds);
//   }

//   void _updateDuration(
//       {required BuildContext context,
//       required int setIndex,
//       required Duration duration,
//       required bool copyToAll,
//       required bool isRestSet}) {
//     if (copyToAll) {
//       context.read<DoWorkoutBloc>().updateAllSetDurations(
//           sectionIndex,
//           duration.inSeconds,
//           isRestSet ? DurationUpdateType.rests : DurationUpdateType.sets);
//     } else {
//       context
//           .read<DoWorkoutBloc>()
//           .updateWorkoutSetDuration(sectionIndex, setIndex, duration.inSeconds);
//     }
//   }

//   void _openAddWorkoutMoveToSet(
//       {required BuildContext context,
//       required int setIndex,
//       required int nextWorkoutMoveSortPosition}) {
//     context.push(
//         child: WorkoutMoveCreator(
//       pageTitle: 'Add Move To Set',
//       saveWorkoutMove: (workoutMove) {
//         context
//             .read<DoWorkoutBloc>()
//             .addWorkoutMoveToSet(sectionIndex, setIndex, workoutMove);
//       },
//       sortPosition: nextWorkoutMoveSortPosition,
//     ));
//   }

//   void _openEditWorkoutMove(
//       {required BuildContext context,
//       required int setIndex,
//       required WorkoutMove originalWorkoutMove,
//       required bool ignoreReps}) {
//     context.push(
//         child: WorkoutMoveCreator(
//       pageTitle: 'Edit Move',
//       workoutMove: originalWorkoutMove,
//       ignoreReps: ignoreReps,
//       saveWorkoutMove: (workoutMove) {
//         context
//             .read<DoWorkoutBloc>()
//             .updateWorkoutMove(sectionIndex, setIndex, workoutMove);
//       },
//       sortPosition: originalWorkoutMove.sortPosition,
//     ));
//   }

//   /// When adding a new set the user selects the move etc first, then we create a set to be its parent once they are done.
//   Future<void> _openWorkoutMoveCreator(
//       {required BuildContext context,
//       required int nextSetSortPosition,
//       bool ignoreReps = false,
//       int? duration,
//       String screenTitle = 'Add Set'}) async {
//     await context.push(
//         child: WorkoutMoveCreator(
//       pageTitle: screenTitle,
//       // If they have selected a the move as rest then this will become a 'rest set' (i.e. a set with only one move in it which is a resrt move.). The set will use set.duration as its length, so we take workoutMove and extract the time the user has entered, then set this as set.duration.
//       saveWorkoutMove: (workoutMove) => workoutMove.move.id == kRestMoveId
//           ? _createSetAndAddWorkoutMove(
//               context: context,
//               workoutMove: workoutMove,
//               nextSetSortPosition: nextSetSortPosition,
//               duration: workoutMove.moveTimeInSeconds)
//           : _createSetAndAddWorkoutMove(
//               context: context,
//               workoutMove: workoutMove,
//               nextSetSortPosition: nextSetSortPosition,
//               duration: duration),
//       sortPosition: 0,
//       ignoreReps: ignoreReps,
//     ));
//   }

//   Future<void> _openWorkoutSetGeneratorCreator(
//       {required BuildContext context, required int nextSetSortPosition}) async {
//     await context.push(
//         child: WorkoutSetGeneratorCreator(
//       handleGeneratedSet: (workoutSet) {
//         context
//             .read<DoWorkoutBloc>()
//             .addWorkoutSetToSection(sectionIndex, workoutSet);
//         context.pop();
//       },
//       newSetSortPosition: nextSetSortPosition,
//     ));
//   }

//   Future<void> _addRestSet(
//       {required BuildContext context,
//       required Move restMove,
//       required int seconds,
//       required int nextSetSortPosition}) async {
//     final restWorkoutMove = DefaultObjectfactory.defaultRestWorkoutMove(
//         move: restMove,
//         sortPosition: 0,
//         timeAmount: seconds,
//         timeUnit: TimeUnit.seconds);

//     await _createSetAndAddWorkoutMove(
//         context: context,
//         workoutMove: restWorkoutMove,
//         nextSetSortPosition: nextSetSortPosition,
//         duration: seconds);
//   }

//   Future<void> _createSetAndAddWorkoutMove(
//       {required BuildContext context,
//       required WorkoutMove workoutMove,
//       required int nextSetSortPosition,
//       int? duration}) async {
//     final newWorkoutSet = WorkoutSet()
//       ..id = const Uuid().v1()
//       ..sortPosition = nextSetSortPosition
//       ..duration = 60
//       ..workoutMoves = [workoutMove];

//     context
//         .read<DoWorkoutBloc>()
//         .addWorkoutSetToSection(sectionIndex, newWorkoutSet);
//   }

//   Widget _floatingButton({
//     required String text,
//     required VoidCallback onTap,
//   }) =>
//       FloatingTextButton(
//         text: text,
//         iconSize: 19,
//         icon: CupertinoIcons.add,
//         onTap: onTap,
//       );

//   @override
//   Widget build(BuildContext context) {
//     final activeWorkoutSection = context.select<DoWorkoutBloc, WorkoutSection>(
//         (b) => b.activeWorkout.workoutSections[sectionIndex]);

//     final workoutSectionType = activeWorkoutSection.workoutSectionType;

//     final sectionHasStarted = context.select<DoWorkoutBloc, bool>(
//         (b) => b.getControllerForSection(sectionIndex).sectionHasStarted);

//     /// Need to get the Move [Rest] for use when user taps [+ Add Rest]
//     final restMove = context
//         .watch<MoveDataRepo>()
//         .standardMoves
//         .firstWhere((m) => m.id == kRestMoveId);

//     final allowSetsReorder = activeWorkoutSection.workoutSets.length > 1;

//     final nextSetSortPosition = activeWorkoutSection.workoutSets.length;

//     return MyPageScaffold(
//       navigationBar: const MyNavBar(
//         middle: NavBarTitle(
//           'View / Modify',
//         ),
//       ),
//       child: FABPage(
//         rowButtonsAlignment: MainAxisAlignment.spaceEvenly,
//         rowButtons: [
//           if (activeWorkoutSection.isLifting ||
//               activeWorkoutSection.isCustomSession)
//             _floatingButton(
//               text: 'Add Exercise',
//               onTap: () => _openWorkoutMoveCreator(
//                   context: context, nextSetSortPosition: nextSetSortPosition),
//             ),
//           if ([kAMRAPName, kForTimeName].contains(workoutSectionType.name))
//             _floatingButton(
//               text: 'Add Set',
//               onTap: () => _openWorkoutMoveCreator(
//                   context: context, nextSetSortPosition: nextSetSortPosition),
//             ),
//           if (kHIITCircuitName == workoutSectionType.name)
//             _floatingButton(
//               text: 'Add Station',
//               onTap: () => _openWorkoutMoveCreator(
//                   context: context,
//                   nextSetSortPosition: nextSetSortPosition,
//                   duration: 60,
//                   ignoreReps: true,
//                   screenTitle: 'Add Station'),
//             ),
//           if (kHIITCircuitName == workoutSectionType.name)
//             _floatingButton(
//               text: 'Add Rest',
//               onTap: () => _addRestSet(
//                   context: context,
//                   restMove: restMove,
//                   seconds: 30,
//                   nextSetSortPosition: nextSetSortPosition),
//             ),
//           if (kEMOMName == workoutSectionType.name)
//             _floatingButton(
//               text: 'Add Period',
//               onTap: () => _openWorkoutMoveCreator(
//                   context: context,
//                   nextSetSortPosition: nextSetSortPosition,
//                   duration: 60,
//                   screenTitle: 'Add Period'),
//             ),
//           if (kTabataName == workoutSectionType.name)
//             _floatingButton(
//               text: 'Add Set',
//               onTap: () => _openWorkoutMoveCreator(
//                   context: context,
//                   nextSetSortPosition: nextSetSortPosition,
//                   duration: 20,
//                   ignoreReps: true),
//             ),
//           if (kTabataName == workoutSectionType.name)
//             _floatingButton(
//               text: 'Add Rest',
//               onTap: () => _addRestSet(
//                 context: context,
//                 restMove: restMove,
//                 seconds: 10,
//                 nextSetSortPosition: nextSetSortPosition,
//               ),
//             ),
//           if (!workoutSectionType.isTimed)
//             _floatingButton(
//               text: 'Set Generator',
//               onTap: () => _openWorkoutSetGeneratorCreator(
//                 context: context,
//                 nextSetSortPosition: nextSetSortPosition,
//               ),
//             ),
//         ],
//         child: ListView(
//           children: [
//             MyHeaderText(
//               activeWorkoutSection.nameOrTypeForDisplay,
//               size: FONTSIZE.four,
//               textAlign: TextAlign.center,
//             ),
//             if (activeWorkoutSection.isTimed)
//               Padding(
//                 padding: const EdgeInsets.only(top: 16),
//                 child: MyText(
//                   'Total Time: ${activeWorkoutSection.timedSectionDuration.displayString}',
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             GrowInOut(
//               show: sectionHasStarted,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(CupertinoIcons.exclamationmark_circle,
//                             color: Styles.errorRed, size: 26),
//                         SizedBox(width: 6),
//                         MyText('You have already started this section.',
//                             size: FONTSIZE.four,
//                             maxLines: 3,
//                             color: Styles.errorRed)
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     const MyText(
//                         'Making modifications here will cause the section to reset.',
//                         size: FONTSIZE.four,
//                         maxLines: 3,
//                         textAlign: TextAlign.center,
//                         color: Styles.errorRed)
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   if (activeWorkoutSection.roundsInputAllowed)
//                     ContentBox(
//                       child: RoundPicker(
//                         rounds: activeWorkoutSection.rounds,
//                         saveValue: (rounds) =>
//                             _updateSectionRounds(context, rounds),
//                       ),
//                     ),
//                   if (activeWorkoutSection.isAMRAP)
//                     ContentBox(
//                       child: DurationPickerDisplay(
//                         modalTitle: 'AMRAP Timecap',
//                         duration:
//                             Duration(seconds: activeWorkoutSection.timecap),
//                         updateDuration: (duration) =>
//                             _updateSectionTimecap(context, duration.inSeconds),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             ImplicitlyAnimatedList<WorkoutSet>(
//               // Added [activeWorkoutSection.hashCode] key here as a fix to strange flickering when re-ordering workoutMoves.
//               // Assumed to be caused by [sectionHasStarted] context.select triggering a rebuild just before the activeSection context.select...never confirmed but this did fix the issue.
//               // Assumed that adding [activeWorkoutSection] hashCode means that this list is only rebuild when a new section object is being rendered. DoWorkoutBloc creates a new section when it does any update.
//               key: Key(activeWorkoutSection.hashCode.toString()),
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               padding: const EdgeInsets.only(bottom: 80),
//               items: activeWorkoutSection.workoutSets,
//               itemBuilder: (context, animation, item, setIndex) =>
//                   SizeFadeTransition(
//                 sizeFraction: 0.7,
//                 curve: Curves.easeInOut,
//                 animation: animation,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 6.0),
//                   // No minimize / expand functionality here (unlike WorkoutCreator).
//                   child: WorkoutSetCreatorUI(
//                     workoutSectionType: workoutSectionType,
//                     workoutSet: item,
//                     moveWorkoutSetUpOne: () => context
//                         .read<DoWorkoutBloc>()
//                         .reorderWorkoutSets(
//                             sectionIndex, setIndex, setIndex - 1),
//                     moveWorkoutSetDownOne: () => context
//                         .read<DoWorkoutBloc>()
//                         .reorderWorkoutSets(
//                             sectionIndex, setIndex, setIndex + 1),
//                     updateDuration: (duration, copyToAll) => _updateDuration(
//                         context: context,
//                         copyToAll: copyToAll,
//                         duration: duration,
//                         isRestSet: item.isRestSet,
//                         setIndex: setIndex),
//                     deleteWorkoutSet: () => context
//                         .read<DoWorkoutBloc>()
//                         .deleteWorkoutSet(sectionIndex, setIndex),
//                     duplicateWorkoutSet: () => context
//                         .read<DoWorkoutBloc>()
//                         .duplicateWorkoutSet(sectionIndex, setIndex),
//                     openAddWorkoutMoveToSet: () => _openAddWorkoutMoveToSet(
//                         context: context,
//                         nextWorkoutMoveSortPosition: item.workoutMoves.length,
//                         setIndex: setIndex),
//                     openEditWorkoutMove: (originalWorkoutMove, ignoreReps) =>
//                         _openEditWorkoutMove(
//                             context: context,
//                             ignoreReps: ignoreReps,
//                             originalWorkoutMove: originalWorkoutMove,
//                             setIndex: setIndex),
//                     reorderWorkoutMoves: (int from, int to) => context
//                         .read<DoWorkoutBloc>()
//                         .reorderWorkoutMoves(sectionIndex, setIndex, from, to),
//                     duplicateWorkoutMove: (workoutMoveIndex) => context
//                         .read<DoWorkoutBloc>()
//                         .duplicateWorkoutMove(
//                             sectionIndex, setIndex, workoutMoveIndex),
//                     deleteWorkoutMove: (workoutMoveIndex) => context
//                         .read<DoWorkoutBloc>()
//                         .deleteWorkoutMove(
//                             sectionIndex, setIndex, workoutMoveIndex),
//                     allowReorder: allowSetsReorder,
//                   ),
//                 ),
//               ),
//               areItemsTheSame: (a, b) => a.id == b.id,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
