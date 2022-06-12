// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/components/animated/mounting.dart';
// import 'package:sofie_ui/components/buttons.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/filters/blocs/workout_filters_bloc.dart';
// import 'package:sofie_ui/components/user_input/selectors/move_selector.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';

// class WorkoutFiltersMoves extends StatelessWidget {
//   const WorkoutFiltersMoves({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final requiredMoves = context
//         .select<WorkoutFiltersBloc, List<Move>>((b) => b.filters.requiredMoves);
//     final excludedMoves = context
//         .select<WorkoutFiltersBloc, List<Move>>((b) => b.filters.excludedMoves);

//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 10),
//           UserInputContainer(
//             child: WorkoutFilterMovesList(
//               moves: requiredMoves,
//               title: 'Required',
//               subtitle: 'Workouts must include these moves',
//               updateMoves: (moves) => context
//                   .read<WorkoutFiltersBloc>()
//                   .updateFilters(
//                       {'requiredMoves': moves.map((m) => m.toJson()).toList()}),
//             ),
//           ),
//           const SizedBox(height: 10),
//           UserInputContainer(
//             child: WorkoutFilterMovesList(
//               moves: excludedMoves,
//               title: 'Excluded',
//               subtitle: 'Workouts cannot include these moves',
//               updateMoves: (moves) => context
//                   .read<WorkoutFiltersBloc>()
//                   .updateFilters(
//                       {'excludedMoves': moves.map((m) => m.toJson()).toList()}),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Displays a list of selected moves for either [requiredMoves] or [excludedMoves] filtering.
// /// Used in Workout and WorkoutProgram filtering.
// class WorkoutFilterMovesList extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final List<Move> moves;
//   final Function(List<Move>) updateMoves;
//   const WorkoutFilterMovesList(
//       {Key? key,
//       required this.moves,
//       required this.updateMoves,
//       required this.title,
//       required this.subtitle})
//       : super(key: key);

//   void _handleAdd(BuildContext context, Move move) {
//     if (!moves.contains(move)) {
//       updateMoves([...moves, move]);
//     }
//     context.pop(); // The move selector.
//   }

//   void _handleRemove(Move move) {
//     updateMoves([...moves.where((Move m) => m.id != move.id)]);
//   }

//   void _handleClearAll() {
//     updateMoves(<Move>[]);
//   }

//   Widget _buildMovePill(BuildContext context, Move move) {
//     return GestureDetector(
//       onTap: () => _handleRemove(move),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//             color: context.theme.primary,
//             borderRadius: BorderRadius.circular(4)),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             MyText(move.name, color: context.theme.background),
//             const SizedBox(width: 8),
//             Icon(
//               CupertinoIcons.xmark_square_fill,
//               color: context.theme.background,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   H3(title),
//                   const SizedBox(height: 8),
//                   MyText(
//                     subtitle,
//                     subtext: true,
//                     lineHeight: 1.3,
//                   )
//                 ],
//               ),
//               CreateTextIconButton(
//                 text: 'Add',
//                 onPressed: () => context.push(
//                   child: MoveSelector(
//                     includeCustomMoves: false,
//                     showCreateCustomMoveButton: false,
//                     selectMove: (move) => _handleAdd(context, move),
//                     onCancel: context.pop,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: moves.isEmpty
//               ? const Opacity(opacity: 0.7, child: MyText('None selected'))
//               : Wrap(
//                   alignment: WrapAlignment.center,
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   spacing: 7,
//                   runSpacing: 7,
//                   children: [
//                     ...moves
//                         .map((Move move) => _buildMovePill(context, move))
//                         .toList()
//                   ],
//                 ),
//         ),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           GrowInOut(
//             show: moves.isNotEmpty,
//             child: TertiaryButton(
//               text: 'Clear all',
//               onPressed: _handleClearAll,
//               textColor: Styles.errorRed,
//             ),
//           ),
//         ])
//       ],
//     );
//   }
// }
