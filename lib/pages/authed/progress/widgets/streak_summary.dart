import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/components/summary_stat_display.dart';
import 'package:sofie_ui/pages/authed/progress/components/widget_header.dart';
import 'package:timeline_tile/timeline_tile.dart';

class StreaksSummaryWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const StreaksSummaryWidget({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final logsByDay = loggedWorkouts.groupListsBy((l) =>
        DateTime(l.completedOn.year, l.completedOn.month, l.completedOn.day));

    final bool hasWorkedoutToday =
        logsByDay[DateTime(now.year, now.month, now.day)] != null;

    /// Sometimes the user will have no logs at all...
    final sortedLogDates = logsByDay.keys.sortedBy<DateTime>((k) => k);

    final earliestLogDate =
        sortedLogDates.isEmpty ? null : sortedLogDates.first;

    /// Select a date to work back to to check for streaks.
    /// Use two days before earliest log to allow final loop of the [while] clause below.
    final beforeEarlistLogDate = earliestLogDate != null
        ? DateTime(earliestLogDate.year, earliestLogDate.month,
            earliestLogDate.day - 2)
        : DateTime.now();

    final _StreakCalcData streakData = _StreakCalcData();

    int daysPast = hasWorkedoutToday
        ? 0
        : -1; // Start at yesterday and work backwards, unless they have logged a workout today, in which case start today.

    DateTime day = DateTime(now.year, now.month, now.day + daysPast);

    while (day.isAfter(beforeEarlistLogDate)) {
      if (logsByDay[day] != null) {
        streakData.streak++;
      } else {
        // The streak has ended.
        // Check if this is the end of the most recent streak.
        if (!streakData.currentDone) {
          streakData.current = streakData.streak;
          streakData.currentDone = true;
        }
        // Check if this is the longest streak we have found so far.
        if (streakData.streak > streakData.longest) {
          streakData.longest = streakData.streak;
        }

        // Reset the streak counter.
        streakData.streak = 0;
      }

      /// Move another day into the past.
      daysPast--;
      day = DateTime(now.year, now.month, now.day + daysPast);
    }

    final backgroundColor = context.theme.background.withOpacity(0.45);

    return Column(
      children: [
        WidgetHeader(
          icon: CupertinoIcons.flame,
          title: 'Streaks',
          actions: [
            WidgetHeaderAction(
                icon: CupertinoIcons.settings,
                onPressed: () => print('open something'))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: StreakSummaryStatDisplay(
                backgroundColor: backgroundColor,
                label: 'Days',
                sublabel: 'In a Row',
                number: streakData.current,
              ),
            ),
            Expanded(
              child: StreakSummaryStatDisplay(
                backgroundColor: backgroundColor,
                label: 'Weeks',
                sublabel: 'Hit Target',
                number: streakData.current,
              ),
            ),
            Expanded(
              child: StreakSummaryStatDisplay(
                backgroundColor: backgroundColor,
                label: 'Months',
                sublabel: 'Hit Target',
                number: streakData.current,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StreakSummaryStatDisplay extends StatelessWidget {
  final String label;
  final String sublabel;
  final int number;
  final Color? backgroundColor;
  const StreakSummaryStatDisplay(
      {Key? key,
      required this.label,
      required this.sublabel,
      required this.number,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ContentBox(
        backgroundColor: backgroundColor,
        child: Column(
          children: [
            MyText(
              number.toString(),
              size: FONTSIZE.six,
            ),
            const SizedBox(height: 4),
            MyText(label.toUpperCase(), size: FONTSIZE.two),
            const SizedBox(height: 4),
            MyText(
              sublabel,
              size: FONTSIZE.one,
              subtext: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCalcData {
  // used during the calculation. Increments while counting then resets to zero.
  int streak = 0;
  int current = 0;
  int longest = 0;
  // Once the initial streak - starting yesterday - is completed, mark this as true.
  bool currentDone = false;
}
