import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ProgressJournalGoalsSummaryCard extends StatefulWidget {
  final List<ProgressJournalGoal> goals;
  final bool initMinimized;
  const ProgressJournalGoalsSummaryCard(
      {Key? key, required this.goals, this.initMinimized = true})
      : super(key: key);
  @override
  _ProgressJournalGoalsSummaryCardState createState() =>
      _ProgressJournalGoalsSummaryCardState();
}

class _ProgressJournalGoalsSummaryCardState
    extends State<ProgressJournalGoalsSummaryCard> {
  late bool _minimized = true;

  @override
  void initState() {
    _minimized = widget.initMinimized;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final generalTag = ProgressJournalGoalTag()
      ..id = 'generalTag'
      ..createdAt = DateTime.now()
      ..hexColor = '#686868'
      ..tag = 'Other';

    final goalsByTag = widget.goals
        .fold<Map<ProgressJournalGoalTag, List<ProgressJournalGoal>>>({},
            (obj, goal) {
      if (goal.progressJournalGoalTags.isEmpty) {
        if (obj[generalTag] != null) {
          obj[generalTag]!.add(goal);
        } else {
          obj[generalTag] = [goal];
        }
      } else {
        for (final tag in goal.progressJournalGoalTags) {
          if (obj[tag] != null) {
            obj[tag]!.add(goal);
          } else {
            obj[tag] = [goal];
          }
        }
      }

      return obj;
    });

    final completedGoals =
        widget.goals.where((g) => g.completedDate != null).toList();

    return Card(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  '${completedGoals.length} of ${widget.goals.length} goals completed',
                ),
                ShowHideDetailsButton(
                  onPressed: () => setState(() => _minimized = !_minimized),
                  showDetails: !_minimized,
                  showText: 'Show',
                  hideText: 'Hide',
                )
              ],
            ),
          ),
          GrowInOut(
              show: !_minimized,
              child: Column(
                children: [
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: goalsByTag.entries
                              .map((e) => GoalTagProgressIndicator(
                                    tag: e.key,
                                    goals: e.value,
                                  ))
                              .toList()),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class GoalTagProgressIndicator extends StatelessWidget {
  final ProgressJournalGoalTag tag;
  final List<ProgressJournalGoal> goals;
  const GoalTagProgressIndicator(
      {Key? key, required this.tag, required this.goals})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numComplete = goals.where((g) => g.completedDate != null).length;
    final fractionComplete = numComplete / goals.length;

    final color = HexColor.fromHex(tag.hexColor);
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularPercentIndicator(
                startAngle: 180,
                backgroundColor: color.withOpacity(0.1),
                circularStrokeCap: CircularStrokeCap.butt,
                radius: 60.0,
                lineWidth: 30.0,
                percent: fractionComplete,
                progressColor: color,
              ),
              if (fractionComplete == 1)
                const FadeIn(
                    child: Icon(
                  CupertinoIcons.checkmark_alt,
                  color: Styles.white,
                  size: 28,
                ))
            ],
          ),
          const SizedBox(height: 4),
          MyText(
            tag.tag,
            size: FONTSIZE.two,
            lineHeight: 1.4,
          ),
          MyText(
            '$numComplete of ${goals.length}',
            size: FONTSIZE.one,
            lineHeight: 1.4,
          ),
        ],
      ),
    );
  }
}
