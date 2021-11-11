import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/comma_separated_list_generator.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Editable moves list _ lap / split times.
class LoggedWorkoutCreatorSectionMovesList extends StatefulWidget {
  final int sectionIndex;
  const LoggedWorkoutCreatorSectionMovesList(
      {Key? key, required this.sectionIndex})
      : super(key: key);

  @override
  _LoggedWorkoutCreatorSectionMovesListState createState() =>
      _LoggedWorkoutCreatorSectionMovesListState();
}

class _LoggedWorkoutCreatorSectionMovesListState
    extends State<LoggedWorkoutCreatorSectionMovesList> {
  bool _showSets = true;

  @override
  Widget build(BuildContext context) {
    /// Brute force bloc listener - will cause rebuild whenever bloc calls notifyListeners.
    /// Could not make [select<>()] workout because LoggedWorkoutSection extends Equatable and Equatable was not noticing differences to nested fields within [LoggedWorkoutSectionData] object (i.e. rounds and sets).
    final loggedWorkoutSection = context
        .watch<LoggedWorkoutCreatorBloc>()
        .loggedWorkout
        .loggedWorkoutSections[widget.sectionIndex];

    final roundData =
        loggedWorkoutSection.loggedWorkoutSectionData?.rounds ?? [];

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
                  child: DurationPickerDisplay(
                      modalTitle: 'Time Taken',
                      duration: Duration(
                          seconds: loggedWorkoutSection.timeTakenSeconds),
                      updateDuration: (duration) => context
                          .read<LoggedWorkoutCreatorBloc>()
                          .updateTimeTakenSeconds(
                              widget.sectionIndex, duration.inSeconds)),
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
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: roundData.length + 1,
                itemBuilder: (c, i) => i == roundData.length
                    ? CreateTextIconButton(
                        text: 'Add Round',
                        onPressed: () => context
                            .read<LoggedWorkoutCreatorBloc>()
                            .addRoundToSection(
                              widget.sectionIndex,
                            ))
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: _SingleRoundData(
                          sectionIndex: loggedWorkoutSection.sortPosition,
                          roundIndex: i,
                          roundData: roundData[i],
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
  final WorkoutSectionRoundData roundData;
  const _SingleRoundData(
      {Key? key,
      required this.roundData,
      required this.sectionIndex,
      required this.roundIndex,
      required this.showSets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoggedWorkoutCreatorBloc>();
    final sets = roundData.sets;
    return ContentBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText('ROUND ${roundIndex + 1}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MiniDurationPickerDisplay(
                  duration: Duration(seconds: roundData.timeTakenSeconds),
                  updateDuration: (d) => bloc.updateRoundTimeTakenSeconds(
                      sectionIndex: sectionIndex,
                      roundIndex: roundIndex,
                      seconds: d.inSeconds),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.only(left: 8),
                  onPressed: () =>
                      bloc.removeRoundFromSection(sectionIndex, roundIndex),
                  child: const Icon(
                    CupertinoIcons.delete_simple,
                    size: 20,
                  ),
                )
              ],
            ),
          ],
        ),
        GrowInOut(
          show: showSets,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sets.length + 1,
              itemBuilder: (c, i) => i == sets.length
                  ? CreateTextIconButton(
                      text: 'Add Set',
                      onPressed: () => context
                          .read<LoggedWorkoutCreatorBloc>()
                          .addSetToSectionRound(sectionIndex, roundIndex),
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.push(
                          child: CommaSeparatedListGenerator(
                              title: 'Set Moves',
                              list: sets[i].moves,
                              updateList: (moves) => bloc.updateSetMovesList(
                                  sectionIndex: sectionIndex,
                                  roundIndex: roundIndex,
                                  setIndex: i,
                                  moves: moves))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: context.theme.background
                                        .withOpacity(0.7)))),
                        child: _SingleSetData(
                            index: i,
                            setData: roundData.sets[i],
                            updateDuration: (d) =>
                                bloc.updateSetTimeTakenSeconds(
                                    sectionIndex: sectionIndex,
                                    roundIndex: roundIndex,
                                    setIndex: i,
                                    seconds: d.inSeconds),
                            removeSetFromRound: () =>
                                bloc.removeSetFromSectionRound(
                                    sectionIndex, roundIndex, i)),
                      ),
                    )),
        ),
      ]),
    );
  }
}

class _SingleSetData extends StatelessWidget {
  final int index;
  final WorkoutSectionRoundSetData setData;
  final void Function(Duration duration) updateDuration;
  final VoidCallback removeSetFromRound;
  const _SingleSetData(
      {Key? key,
      required this.index,
      required this.setData,
      required this.updateDuration,
      required this.removeSetFromRound})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movesList = setData.moves.split(',');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: movesList
                .map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: MyText(
                          m,
                          size: FONTSIZE.two,
                        )),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MiniDurationPickerDisplay(
              duration: Duration(seconds: setData.timeTakenSeconds),
              updateDuration: updateDuration,
            ),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 8),
              onPressed: removeSetFromRound,
              child: const Icon(
                CupertinoIcons.delete_simple,
                size: 20,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class MiniDurationPickerDisplay extends StatelessWidget {
  final Duration duration;
  final void Function(Duration duration) updateDuration;
  const MiniDurationPickerDisplay(
      {Key? key, required this.duration, required this.updateDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => context.showActionSheetPopup(
                child: DurationPicker(
              duration: duration,
              updateDuration: updateDuration,
              title: 'Time Taken',
            )),
        child: ContentBox(
          backgroundColor: context.theme.background,
          child: MyText(duration.compactDisplay),
        ));
  }
}
