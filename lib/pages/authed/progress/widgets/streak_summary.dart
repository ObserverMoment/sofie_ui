import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/components/widget_header.dart';
import 'package:sofie_ui/services/utils.dart';

class StreaksSummaryWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  final UserProfile userProfile;
  const StreaksSummaryWidget(
      {Key? key, required this.loggedWorkouts, required this.userProfile})
      : super(key: key);

  String _yearWeekKey(DateTime date) => '${date.year}:${date.weekNumberInYear}';

  int get _weekStreakCount {
    final now = DateTime.now();

    final perWeekTarget = userProfile.workoutsPerWeekTarget;

    if (perWeekTarget == null) {
      printLog(
          'Sorry, cannot calculate a week streak number without [perWeekTarget] value');
      return 0;
    }

    /// Go back through week grouped logs starting from last week. Increment count for each week where count >= [perWeekTarget].
    final currentWeek = now.weekNumberInYear;
    final currentYear = now.year;

    /// Keys are formatted like [year:week]
    final logsByWeekAndYear =
        loggedWorkouts.groupListsBy((l) => _yearWeekKey(l.completedOn));

    int weekStreakCount = 0;

    /// Start from last week.
    int weekCursor = currentWeek;
    int yearCursor = currentYear;

    while (true) {
      final logs = logsByWeekAndYear['$yearCursor:$weekCursor'];

      if (logs != null && logs.length >= perWeekTarget) {
        weekStreakCount++;
        if (weekCursor == 1) {
          weekCursor = 52;
          yearCursor--;
        } else {
          weekCursor--;
        }
      } else {
        break;
      }
    }

    return weekStreakCount;
  }

  int get _dailyStreakCount {
    final now = DateTime.now();

    final logsByDate = loggedWorkouts.groupListsBy((l) =>
        DateTime(l.completedOn.year, l.completedOn.month, l.completedOn.day));

    final today = DateTime(now.year, now.month, now.day);

    final bool hasWorkedoutToday = logsByDate[today] != null;

    /// Start from yesterday.
    DateTime dateCursor = today.subtract(const Duration(days: 1));
    int dayStreakCount = hasWorkedoutToday ? 1 : 0;

    while (true) {
      final logs = logsByDate[dateCursor];

      if (logs != null && logs.isNotEmpty) {
        dayStreakCount++;
        dateCursor = dateCursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return dayStreakCount;
  }

  @override
  Widget build(BuildContext context) {
    final daily = _dailyStreakCount;
    final weekly = _weekStreakCount;
    final perWeekTarget = userProfile.workoutsPerWeekTarget;

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
            StatContainer(
              count: daily,
              label: 'Days in a Row',
            ),
            StatContainer(
              count: weekly,
              label: 'On Target Weeks',
            ),
          ],
        ),
        if (perWeekTarget != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(CupertinoIcons.scope, size: 14),
                const SizedBox(width: 3),
                MyText(
                  'Target = $perWeekTarget workouts per week'.toUpperCase(),
                  size: FONTSIZE.one,
                )
              ],
            ),
          )
      ],
    );
  }
}

class StatContainer extends StatelessWidget {
  final int count;
  final String label;
  const StatContainer({
    Key? key,
    required this.count,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.background.withOpacity(0.45);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const SizedBox(height: 6),
          MyHeaderText(
            label,
            size: FONTSIZE.two,
            weight: FontWeight.normal,
          ),
          const SizedBox(height: 6),
          Card(
            elevation: 1,
            borderRadius: BorderRadius.circular(10),
            child: MyText(
              count == 0 ? '-' : count.toString(),
              size: FONTSIZE.seven,
              color: Styles.secondaryAccent,
            ),
          ),
        ],
      ),
    );
  }
}
