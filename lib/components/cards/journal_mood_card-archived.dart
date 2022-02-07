// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' as material;
// import 'package:sofie_ui/blocs/theme_bloc.dart';
// import 'package:sofie_ui/components/cards/card.dart';
// import 'package:sofie_ui/components/creators/journal_creators/journal_mood_creator_page.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/tags.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:collection/collection.dart';
// import 'package:sofie_ui/services/utils.dart';

// class JournalMoodCard extends StatelessWidget {
//   final JournalMood journalMood;
//   const JournalMoodCard({
//     Key? key,
//     required this.journalMood,
//   }) : super(key: key);

//   int get kMaxScore => 4;

//   double get kScoreDisplayDiameter => 60.0;

//   List<Widget> _buildScoreIndicators(BuildContext context) {
//     final tags = ['Mood', 'Energy'];

//     return [
//       journalMood.moodScore,
//       journalMood.energyScore,
//     ]
//         .mapIndexed((index, score) => Column(
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3),
//                   child: ClipOval(
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Container(
//                           height: kScoreDisplayDiameter,
//                           width: kScoreDisplayDiameter,
//                           color: context.theme.background,
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           child: Container(
//                             height: kScoreDisplayDiameter * (score / kMaxScore),
//                             width: kScoreDisplayDiameter,
//                             color: Color.lerp(kBadScoreColor, kGoodScoreColor,
//                                 score / kMaxScore),
//                           ),
//                         ),
//                         Opacity(
//                           opacity: 0.6,
//                           child: score > 2
//                               ? const Icon(CupertinoIcons.checkmark_alt)
//                               : score == 2
//                                   ? null
//                                   : const Icon(
//                                       CupertinoIcons
//                                           .exclamationmark_triangle_fill,
//                                       color: Styles.errorRed,
//                                     ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 MyText(
//                   tags[index],
//                 ),
//               ],
//             ))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ContentBox(
//                   backgroundColor: context.theme.background,
//                   child: MyText(
//                     journalMood.createdAt.minimalDateString,
//                   ),
//                 ),
//                 Wrap(
//                   alignment: WrapAlignment.spaceEvenly,
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: _buildScoreIndicators(context),
//                 ),
//               ],
//             ),
//           ),
//           if (journalMood.tags.isNotEmpty)
//             Column(
//               children: [
//                 const HorizontalLine(),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 4.0, top: 16, right: 4, bottom: 4),
//                   child: Wrap(
//                     alignment: WrapAlignment.spaceEvenly,
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: journalMood.tags
//                         .map((t) => kGoodFeelings.contains(t)
//                             ? Tag(
//                                 textColor: Styles.white,
//                                 color: kGoodScoreColor,
//                                 fontSize: FONTSIZE.three,
//                                 tag: t,
//                               )
//                             : Tag(
//                                 tag: t,
//                                 color: material.Colors.transparent,
//                                 textColor: context.theme.primary,
//                               ))
//                         .toList(),
//                   ),
//                 ),
//               ],
//             ),
//           if (Utils.textNotNull(journalMood.textNote))
//             Column(
//               children: [
//                 const HorizontalLine(
//                   verticalPadding: 12,
//                 ),
//                 MyText(
//                   journalMood.textNote!,
//                   maxLines: 4,
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             )
//         ],
//       ),
//     );
//   }
// }
