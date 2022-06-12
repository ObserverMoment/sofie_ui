// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' as material;
// import 'package:sofie_ui/components/animated/dragged_item.dart';
// import 'package:sofie_ui/components/animated/mounting.dart';
// import 'package:sofie_ui/components/buttons.dart';
// import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_set_definition.dart';
// import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_set_workout_move.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/lists.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/menus/nav_bar_ellipsis_menu.dart';
// import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
// import 'package:collection/collection.dart';

// class WorkoutSetCreatorUI extends StatelessWidget {
//   final WorkoutSet workoutSet;
//   final WorkoutSectionType workoutSectionType;
//   // Pass if you wantr user to be able to minimize set display size.
//   final VoidCallback? toggleMinimizeSetInfo;
//   final void Function(Duration duration, bool copyToAll) updateDuration;
//   final VoidCallback? moveWorkoutSetUpOne;
//   final VoidCallback? moveWorkoutSetDownOne;
//   final VoidCallback duplicateWorkoutSet;
//   final VoidCallback? generateSequenceForPyramid;
//   final VoidCallback deleteWorkoutSet;
//   final VoidCallback openAddWorkoutMoveToSet;
//   final void Function(WorkoutMove originalWorkoutMove, bool ignoreReps)
//       openEditWorkoutMove;
//   final void Function(int workoutMoveIndex) deleteWorkoutMove;
//   final void Function(int workoutMoveIndex) duplicateWorkoutMove;
//   final void Function(int from, int to) reorderWorkoutMoves;
//   final bool allowReorder;
//   final bool isMinimized;
//   const WorkoutSetCreatorUI(
//       {Key? key,
//       this.moveWorkoutSetUpOne,
//       this.moveWorkoutSetDownOne,
//       required this.duplicateWorkoutSet,
//       this.allowReorder = false,
//       required this.workoutSectionType,
//       this.generateSequenceForPyramid,
//       required this.deleteWorkoutSet,
//       this.isMinimized = false,
//       required this.workoutSet,
//       this.toggleMinimizeSetInfo,
//       required this.updateDuration,
//       required this.openAddWorkoutMoveToSet,
//       required this.openEditWorkoutMove,
//       required this.deleteWorkoutMove,
//       required this.duplicateWorkoutMove,
//       required this.reorderWorkoutMoves})
//       : super(key: key);

//   Widget _minimizeExpandButton(bool isMinimized) => CupertinoButton(
//       padding: isMinimized ? EdgeInsets.zero : const EdgeInsets.only(right: 16),
//       onPressed: toggleMinimizeSetInfo,
//       child: Icon(
//           isMinimized
//               ? CupertinoIcons.fullscreen
//               : CupertinoIcons.fullscreen_exit,
//           size: 20));

//   Widget get _buildEllipsisMenu => NavBarEllipsisMenu(items: [
//         if (moveWorkoutSetUpOne != null)
//           ContextMenuItem(
//               text: 'Move Up',
//               iconData: CupertinoIcons.up_arrow,
//               onTap: moveWorkoutSetUpOne!),
//         if (moveWorkoutSetDownOne != null)
//           ContextMenuItem(
//               text: 'Move Down',
//               iconData: CupertinoIcons.down_arrow,
//               onTap: moveWorkoutSetDownOne!),
//         ContextMenuItem(
//             text: 'Duplicate',
//             iconData: CupertinoIcons.plus_rectangle_on_rectangle,
//             onTap: duplicateWorkoutSet),
//         if (generateSequenceForPyramid != null && workoutSectionType.canPyramid)
//           ContextMenuItem(
//               text: 'Pyramid',
//               iconData: CupertinoIcons.triangle_righthalf_fill,
//               onTap: generateSequenceForPyramid!),
//         ContextMenuItem(
//           text: 'Delete',
//           iconData: CupertinoIcons.delete_simple,
//           onTap: deleteWorkoutSet,
//           destructive: true,
//         ),
//       ]);

//   @override
//   Widget build(BuildContext context) {
//     final sortedWorkoutMoves =
//         workoutSet.workoutMoves.sortedBy<num>((wMove) => wMove.sortPosition);
//     final uniqueMoves =
//         sortedWorkoutMoves.map((wm) => wm.move).toSet().toList();

//     if (isMinimized) {
//       return FadeIn(
//         child: ContentBox(
//             child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: CommaSeparatedList(uniqueMoves.map((m) => m.name).toList(),
//                   fontSize: FONTSIZE.three),
//             ),
//             Column(
//               children: [
//                 _buildEllipsisMenu,
//                 if (toggleMinimizeSetInfo != null)
//                   _minimizeExpandButton(isMinimized),
//               ],
//             )
//           ],
//         )),
//       );
//     }
//     // Don't show reps when user is doing a timed workout and when there is only one move in the set.
//     // The user will just do single workout move for as long as workoutSet.duration, so reps are ignored.
//     final ignoreReps = !workoutSectionType.showReps(workoutSet);

//     final isMultiMoveSet = workoutSet.isMultiMoveSet;

//     return ContentBox(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   if (workoutSectionType.isTimed || workoutSet.isRestSet)
//                     CupertinoButton(
//                         padding: const EdgeInsets.all(4),
//                         onPressed: () => context.showActionSheetPopup(
//                             child: WorkoutSetDurationPicker(
//                                 switchTitle: workoutSet.isRestSet
//                                     ? 'Copy new time to all rest sets'
//                                     : 'Copy new time to all sets',
//                                 duration:
//                                     Duration(seconds: workoutSet.duration),
//                                 updateDuration: updateDuration)),
//                         child: Row(
//                           children: [
//                             const Icon(CupertinoIcons.timer, size: 18),
//                             const SizedBox(width: 5),
//                             MyText(
//                               Duration(seconds: workoutSet.duration)
//                                   .displayString,
//                               size: FONTSIZE.four,
//                             )
//                           ],
//                         )),
//                   if (!workoutSet.isRestSet && isMultiMoveSet)
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: WorkoutSetDefinition(workoutSet: workoutSet),
//                     ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 10.0),
//                     child: workoutSet.isRestSet
//                         ? const MyText(
//                             'REST',
//                             size: FONTSIZE.four,
//                           )
//                         : IconButton(
//                             iconData: CupertinoIcons.add,
//                             size: 22,
//                             onPressed: openAddWorkoutMoveToSet,
//                           ),
//                   ),
//                   if (toggleMinimizeSetInfo != null)
//                     _minimizeExpandButton(isMinimized),
//                   _buildEllipsisMenu
//                 ],
//               )
//             ],
//           ),
//           if (!workoutSet.isRestSet)
//             material.ReorderableListView.builder(
//                 proxyDecorator: (child, index, animation) =>
//                     DraggedItem(child: child),
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: sortedWorkoutMoves.length,
//                 itemBuilder: (context, index) => WorkoutSetWorkoutMove(
//                     key: Key(
//                         '$index-workout_set_creator-ui-${sortedWorkoutMoves[index].id}'),
//                     workoutMove: sortedWorkoutMoves[index],
//                     deleteWorkoutMove: deleteWorkoutMove,
//                     duplicateWorkoutMove: duplicateWorkoutMove,
//                     openEditWorkoutMove: (wm) =>
//                         openEditWorkoutMove(wm, ignoreReps),
//                     showReps: !ignoreReps,
//                     isLast: index == sortedWorkoutMoves.length - 1,
//                     isPartOfSuperSet: isMultiMoveSet),
//                 onReorder: reorderWorkoutMoves)
//           else
//             Container()
//         ],
//       ),
//     );
//   }
// }
