import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/logged_workout/logged_workout_move_display.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:supercharged/supercharged.dart';

/// Read only log moves list - lap / split times.
/// Most code is duplicated in [LoggedWorkoutCreatorSectionMovesList].
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

    final loggedSetsByRound = loggedWorkoutSection.loggedWorkoutSets
        .groupBy<int, LoggedWorkoutSet>((wSet) => wSet.sectionRoundNumber);

    final numRounds = loggedSetsByRound.keys.length;

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
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: numRounds,
                itemBuilder: (c, i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: _SingleRoundData(
                        sectionIndex: loggedWorkoutSection.sortPosition,
                        roundIndex: i,
                        workoutSectionType:
                            loggedWorkoutSection.workoutSectionType,
                        loggedWorkoutSets: loggedSetsByRound[i]!,
                        showSets: _showSets,
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}

class _SingleRoundData extends StatelessWidget {
  final int sectionIndex;
  final int roundIndex;
  final bool showSets;
  final WorkoutSectionType workoutSectionType;
  final List<LoggedWorkoutSet> loggedWorkoutSets;
  const _SingleRoundData(
      {Key? key,
      required this.loggedWorkoutSets,
      required this.sectionIndex,
      required this.roundIndex,
      required this.showSets,
      required this.workoutSectionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeTakenSeconds = loggedWorkoutSets.fold<int>(
        0, (acum, next) => acum + (next.timeTakenSeconds ?? 0));

    /// Ensure sort position 0 goes at the top.
    final sortedSets = loggedWorkoutSets.reversed.toList();

    return ContentBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText('ROUND ${roundIndex + 1}'),
              CompactTimerIcon(duration: Duration(seconds: timeTakenSeconds)),
            ],
          ),
        ),
        GrowInOut(
          show: showSets,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: loggedWorkoutSets.length,
              itemBuilder: (c, i) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color:
                                    context.theme.primary.withOpacity(0.1)))),
                    child: _SingleSetData(
                      index: i,
                      workoutSectionType: workoutSectionType,
                      loggedWorkoutSet: sortedSets[i],
                    ),
                  )),
        ),
      ]),
    );
  }
}

class _SingleSetData extends StatelessWidget {
  final int index;
  final WorkoutSectionType workoutSectionType;
  final LoggedWorkoutSet loggedWorkoutSet;
  const _SingleSetData(
      {Key? key,
      required this.index,
      required this.loggedWorkoutSet,
      required this.workoutSectionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Ensure sort position 0 goes at the top.
    final sortedMoves = loggedWorkoutSet.loggedWorkoutMoves.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedMoves
          .map(
            (lwm) => Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6.0),
              child: LoggedWorkoutMoveDisplay(
                loggedWorkoutMove: lwm,
                loggedWorkoutSet: loggedWorkoutSet,
                workoutSectionType: workoutSectionType,
              ),
            ),
          )
          .toList(),
    );
  }
}

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
