import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_move_creator.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/logged_workout/logged_workout_move_display.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_model_converters/workout_to_logged_workout.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';

/// Editable moves list _ lap / split times. Most code is duplicated in [LoggedWorkoutSectionMovesList].
class LoggedWorkoutCreatorSectionMovesList extends StatefulWidget {
  final int sectionIndex;
  const LoggedWorkoutCreatorSectionMovesList(
      {Key? key, required this.sectionIndex})
      : super(key: key);

  @override
  State<LoggedWorkoutCreatorSectionMovesList> createState() =>
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
    final bloc = context.read<LoggedWorkoutCreatorBloc>();
    final timeTakenSeconds = loggedWorkoutSets.fold<int>(
        0, (acum, next) => acum + (next.timeTakenSeconds ?? 0));

    /// Lifting section should only ever have one round (no rounds in a lifting section).
    /// So no need to display the round number header or split time (as the split time will be the same as that for the total workout).
    final isLiftingSection = workoutSectionType.isLifting;

    return ContentBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (!isLiftingSection)
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
                      loggedWorkoutSet: loggedWorkoutSets[i],
                      updateDuration: (d) => bloc.updateSetTimeTakenSeconds(
                          sectionIndex: sectionIndex,
                          setId: loggedWorkoutSets[i].id,
                          seconds: d.inSeconds),
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
  final void Function(Duration duration) updateDuration;
  const _SingleSetData(
      {Key? key,
      required this.index,
      required this.loggedWorkoutSet,
      required this.updateDuration,
      required this.workoutSectionType})
      : super(key: key);

  void _openEditLoggedMove(BuildContext context, LoggedWorkoutMove lwm) {
    final bloc = context.read<LoggedWorkoutCreatorBloc>();
    context.push(
        child: WorkoutMoveCreator(
            pageTitle: 'Edit Logged Set',
            workoutMove: workoutMoveFromLoggedWorkoutMove(lwm),
            sortPosition: lwm.sortPosition,
            saveWorkoutMove: (updated) => bloc.updateLoggedWorkoutMove(
                sectionIndex: index,
                loggedSetId: loggedWorkoutSet.id,
                updatedLoggedWorkoutMove:
                    loggedWorkoutMoveFromWorkoutMove(updated))));
  }

  void _confirmDeleteLoggedMove(BuildContext context, LoggedWorkoutMove lwm) {
    final bloc = context.read<LoggedWorkoutCreatorBloc>();
    context.showConfirmDeleteDialog(
        message:
            'This cannot be undone and will affect your workout stats and data.',
        itemType: 'Logged Set',
        onConfirm: () {
          bloc.deleteLoggedWorkoutMove(
              sectionIndex: index,
              loggedSetId: loggedWorkoutSet.id,
              loggedMoveId: lwm.id);
        });
  }

  @override
  Widget build(BuildContext context) {
    /// Ensure sort position 0 goes at the top.
    final sortedMoves = loggedWorkoutSet.loggedWorkoutMoves.toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sortedMoves
                .map(
                  (lwm) => PopoverMenu(
                    button: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6.0),
                      child: LoggedWorkoutMoveDisplay(
                        loggedWorkoutMove: lwm,
                        loggedWorkoutSet: loggedWorkoutSet,
                        workoutSectionType: workoutSectionType,
                      ),
                    ),
                    items: [
                      PopoverMenuItem(
                          iconData: CupertinoIcons.pencil,
                          text: 'Edit',
                          onTap: () => _openEditLoggedMove(context, lwm)),
                      PopoverMenuItem(
                          iconData: CupertinoIcons.delete_simple,
                          destructive: true,
                          text: 'Delete',
                          onTap: () => _confirmDeleteLoggedMove(context, lwm)),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        Column(
          children: [
            MiniDurationPickerDisplay(
              duration:
                  Duration(seconds: loggedWorkoutSet.timeTakenSeconds ?? 0),
              updateDuration: updateDuration,
            ),
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
