// import 'package:collection/collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/components/cards/card.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/workout/move_details.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
// import 'package:sofie_ui/pages/authed/progress/logged_workouts/widget_header.dart';
// import 'package:sofie_ui/extensions/data_type_extensions.dart';

// class MostLoggedMovesWidget extends StatelessWidget {
//   final List<LoggedWorkout> loggedWorkouts;
//   const MostLoggedMovesWidget({Key? key, required this.loggedWorkouts})
//       : super(key: key);

//   int get _movesPerCard => 4;
//   double get _cardHeight => 50.0;
//   double get _cardMargin => 4.0;
//   double get _cardHeightWithMargin => _cardHeight + (_cardMargin * 2);
//   int _nextIndex(int i) => (i * _movesPerCard) + _movesPerCard;
//   int? _clampedIndex(int i, int max) =>
//       _nextIndex(i) > max ? null : _nextIndex(i);

//   @override
//   Widget build(BuildContext context) {
//     final allMoves = loggedWorkouts.fold<List<Move>>(
//         [], (acum, next) => [...acum, ...next.allMoves]).toList();

//     final counts = allMoves
//         .where((m) => m.id != kRestMoveId)
//         .fold<Map<Move, int>>({}, (acum, next) {
//       if (acum[next] == null) {
//         acum[next] = 1;
//       } else {
//         acum[next] = acum[next]! + 1;
//       }

//       return acum;
//     });

//     final entries = counts.entries
//         .map((e) => _LoggedMoveCount(e.key, e.value, e.value / allMoves.length))
//         .sortedBy<num>((d) => d.count)
//         .reversed
//         .toList();

//     final onlyOneCard = entries.length <= _movesPerCard;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const LogAnalysisWidgetHeader(
//           heading: 'Most Logged Moves',
//         ),
//         Container(
//           padding: EdgeInsets.only(
//               left: onlyOneCard ? 10.0 : 0, right: onlyOneCard ? 10 : 0),
//           height: entries.length < _movesPerCard
//               ? _cardHeightWithMargin * entries.length
//               : _cardHeightWithMargin * _movesPerCard,
//           child: PageView.builder(
//             itemCount: (entries.length / _movesPerCard).ceil(),
//             controller:
//                 PageController(viewportFraction: onlyOneCard ? 1 : 0.95),
//             itemBuilder: (c, i) => ListView(
//               padding: EdgeInsets.zero,
//               physics: const NeverScrollableScrollPhysics(),
//               children: entries
//                   .slice(i * _movesPerCard, _clampedIndex(i, entries.length))
//                   .map((e) => Padding(
//                         padding: EdgeInsets.all(_cardMargin),
//                         child: GestureDetector(
//                           onTap: () => context.push(
//                               fullscreenDialog: true,
//                               child: MoveDetails(e.move)),
//                           child: Card(
//                               margin: EdgeInsets.zero,
//                               height: _cardHeight,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       MyText(e.move.name),
//                                       const SizedBox(height: 4),
//                                       MyText(
//                                         e.move.moveType.name,
//                                         size: FONTSIZE.one,
//                                         color: Styles.primaryAccent,
//                                       ),
//                                     ],
//                                   ),
//                                   MyText(
//                                       '${e.count} ${e.count == 1 ? "time" : "times"}'),
//                                 ],
//                               )),
//                         ),
//                       ))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _LoggedMoveCount {
//   final Move move;
//   final int count;
//   final double fraction;
//   _LoggedMoveCount(this.move, this.count, this.fraction);
// }
