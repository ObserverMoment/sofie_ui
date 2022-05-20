import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_progress_overlay.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/name_and_repscore.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/workout_section_simple_timer.dart';
import 'package:sofie_ui/components/workout/workout_set_display.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Used for everything except Free Session.
class MainMovesList extends StatefulWidget {
  final WorkoutSection workoutSection;
  final WorkoutSectionProgressState state;
  const MainMovesList(
      {Key? key, required this.workoutSection, required this.state})
      : super(key: key);

  @override
  _MainMovesListState createState() => _MainMovesListState();
}

class _MainMovesListState extends State<MainMovesList> {
  late AutoScrollController _autoScrollController;

  /// This list will auto scroll downwards as the workout progresses, with the current set at the top of the visible list.
  /// When the user interacts we start a ?? second timer. During this time autoscroll is disabled, allowing the user to check whichever part of the workout they need to.
  /// After ?? seconds we re-enable autoscroll and rejoin the flow of the workout.
  bool _disableAutoScroll = false;
  Timer? _enableAutoScrollTimer;

  @override
  void initState() {
    super.initState();
    _autoScrollController = AutoScrollController();
  }

  @override
  void didUpdateWidget(MainMovesList oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// When reaching the end of the section [state.currentRoundIndex] will be greater than the total [workoutSection.rounds] and will cause [AutoScrollController] to throw an error.
    if (!_disableAutoScroll &&
        widget.state.currentRoundIndex < widget.workoutSection.rounds) {
      _autoScrollController.scrollToIndex(
          _setIndexForScrollPosition(
              widget.state.currentRoundIndex, widget.state.currentSetIndex),
          preferPosition: AutoScrollPosition.begin);
    }
  }

  void _handleUserScroll() {
    setState(() => _disableAutoScroll = true);
    _enableAutoScrollTimer = Timer(const Duration(seconds: 10), () {
      setState(() => _disableAutoScroll = false);
      _enableAutoScrollTimer!.cancel();
    });
  }

  int _setIndexForScrollPosition(int roundNumber, int workoutSetIndex) =>
      roundNumber * widget.workoutSection.workoutSets.length + workoutSetIndex;

  @override
  void dispose() {
    _enableAutoScrollTimer?.cancel();
    _autoScrollController.dispose();
    super.dispose();
  }

  List<Widget> _movesList(int roundIndex) => [
        ...widget.workoutSection.workoutSets.map((workoutSet) {
          final listItemIndex =
              _setIndexForScrollPosition(roundIndex, workoutSet.sortPosition);

          return AutoScrollTag(
            controller: _autoScrollController,
            index: listItemIndex,
            key: Key(listItemIndex.toString()),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: _WorkoutSetInMovesList(
                workoutSet: workoutSet,
                roundIndex: roundIndex,
                workoutSectionType: widget.workoutSection.workoutSectionType,
                state: widget.state,
              ),
            ),
          );
        }).toList(),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NameAndRepScore(workoutSection: widget.workoutSection),
              WorkoutSectionSimpleTimer(
                workoutSection: widget.workoutSection,
                showElapsedLabel: false,
              ),
            ],
          ),
        ),
        LinearPercentIndicator(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          lineHeight: 4,
          percent: widget.state.percentComplete,
          backgroundColor: context.theme.primary.withOpacity(0.07),
          linearGradient: Styles.primaryAccentGradient,
          barRadius: const Radius.circular(30),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              // https://stackoverflow.com/questions/57841166/how-to-detect-if-the-user-started-scrolling-the-listview-builder-vertically
              // https://api.flutter.dev/flutter/widgets/ScrollStartNotification-class.html
              if (notification is ScrollStartNotification &&
                  notification.dragDetails != null) {
                // Disable the auto scroll to stop bouncing the user around as they search the workout.
                _handleUserScroll();
              }
              // Returning false to
              // "allow the notification to continue to be dispatched to further ancestors".
              return false;
            },
            child: ListView(
                shrinkWrap: true,
                controller: _autoScrollController,
                children: List.generate(widget.workoutSection.rounds,
                        (roundNumber) => _movesList(roundNumber))
                    .expand((x) => x)
                    .toList()),
          ),
        ),
      ],
    );
  }
}

class _WorkoutSetInMovesList extends StatelessWidget {
  final WorkoutSet workoutSet;
  final int roundIndex;
  final WorkoutSectionType workoutSectionType;
  final WorkoutSectionProgressState state;
  const _WorkoutSetInMovesList(
      {Key? key,
      required this.state,
      required this.workoutSet,
      required this.workoutSectionType,
      required this.roundIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int setIndex = workoutSet.sortPosition;

    /// AMRAP should always just have one round so it is always the current round.
    final bool isCurrentRound =
        workoutSectionType.isAMRAP || state.currentRoundIndex == roundIndex;

    final bool isCurrentSet =
        isCurrentRound && state.currentSetIndex == setIndex;

    /// AMRAP only a single round which repeats so need to unfade completed sets once a round is finished.
    final isCompletedSet =
        (!workoutSectionType.isAMRAP && state.currentRoundIndex > roundIndex) ||
            (isCurrentRound && state.currentSetIndex > setIndex);

    return AnimatedOpacity(
      opacity: isCompletedSet ? 0.6 : 1,
      duration: kStandardAnimationDuration,
      child: AnimatedContainer(
        duration: kStandardAnimationDuration,
        decoration: BoxDecoration(
            borderRadius: kStandardCardBorderRadius,
            border: Border.all(
                color: isCurrentSet
                    ? Styles.primaryAccent
                    : material.Colors.transparent)),
        child: state.secondsToNextCheckpoint != null &&
                workoutSectionType.isTimed &&
                isCurrentSet
            ? AnimatedProgressOverlay(
                percent: 1 -
                    (state.secondsToNextCheckpoint! / (workoutSet.duration)),
                child: WorkoutSetDisplay(
                    workoutSet: workoutSet,
                    workoutSectionType: workoutSectionType),
              )
            : WorkoutSetDisplay(
                workoutSet: workoutSet, workoutSectionType: workoutSectionType),
      ),
    );
  }
}
