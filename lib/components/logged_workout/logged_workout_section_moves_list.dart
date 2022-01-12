import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

/// Read only log moves list - lap / split times.
class LoggedWorkoutSectionMovesList extends StatefulWidget {
  final LoggedWorkoutSection loggedWorkoutSection;
  const LoggedWorkoutSectionMovesList(
      {Key? key, required this.loggedWorkoutSection})
      : super(key: key);

  @override
  _LoggedWorkoutSectionMovesListState createState() =>
      _LoggedWorkoutSectionMovesListState();
}

class _LoggedWorkoutSectionMovesListState
    extends State<LoggedWorkoutSectionMovesList> {
  bool _showSets = true;

  @override
  Widget build(BuildContext context) {
    final loggedWorkoutSection = widget.loggedWorkoutSection;

    /// TODO: New structure.

    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Moves List and Lap Times'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  loggedWorkoutSection.workoutSectionType.name,
                  size: FONTSIZE.five,
                ),
                ContentBox(
                  padding: EdgeInsets.zero,
                  backgroundColor: context.theme.cardBackground,
                  child: _DurationDisplay(
                    fontSize: FONTSIZE.four,
                    duration: Duration(
                        seconds: loggedWorkoutSection.timeTakenSeconds),
                  ),
                )
              ],
            ),
          ),
          const HorizontalLine(),
          CupertinoSwitchRow(
              title: 'Show Sets',
              updateValue: (v) => setState(() => _showSets = v),
              value: _showSets),
          const HorizontalLine(),

          /// TODO
          MyText('New UI based on new data structure'),
        ],
      ),
    );
  }
}

// class _SingleRoundData extends StatelessWidget {
//   final int sectionIndex;
//   final int roundIndex;
//   final bool showSets;
//   final WorkoutSectionRoundData roundData;
//   const _SingleRoundData(
//       {Key? key,
//       required this.roundData,
//       required this.sectionIndex,
//       required this.roundIndex,
//       required this.showSets})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final sets = roundData.sets;
//     return ContentBox(
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               MyText('ROUND ${roundIndex + 1}'),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   _DurationDisplay(
//                     duration: Duration(seconds: roundData.timeTakenSeconds),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         GrowInOut(
//           show: showSets,
//           child: ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: sets.length,
//               itemBuilder: (c, i) => Container(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom:
//                                 BorderSide(color: context.theme.background))),
//                     child: _SingleSetData(
//                       index: i,
//                       setData: roundData.sets[i],
//                     ),
//                   )),
//         ),
//       ]),
//     );
//   }
// }

// class _SingleSetData extends StatelessWidget {
//   final int index;
//   final WorkoutSectionRoundSetData setData;
//   const _SingleSetData({
//     Key? key,
//     required this.index,
//     required this.setData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final movesList = setData.moves.split(',');

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 3.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: movesList
//                   .map(
//                     (m) => Padding(
//                       padding: const EdgeInsets.only(top: 2, bottom: 6.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               child: MyText(
//                             m,
//                             size: FONTSIZE.two,
//                           )),
//                         ],
//                       ),
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               _DurationDisplay(
//                 duration: Duration(seconds: setData.timeTakenSeconds),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class _DurationDisplay extends StatelessWidget {
  final Duration duration;
  final FONTSIZE fontSize;
  const _DurationDisplay(
      {Key? key, required this.duration, this.fontSize = FONTSIZE.three})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyText(
      duration.compactDisplay,
      size: fontSize,
    );
  }
}
