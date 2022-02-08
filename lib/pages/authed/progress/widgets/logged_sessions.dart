import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/components/widget_header.dart';

/// For the last [numDays] days - is there a loggedWorkout on that day. If there is then fill the dot.
class LoggedSessionsWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const LoggedSessionsWidget({Key? key, required this.loggedWorkouts})
      : super(key: key);

  final numDays = 28;

  DateTime _getDateXDaysAgo(DateTime now, int days) {
    return DateTime(now.year, now.month, now.day - days);
  }

  Widget _buildDayHeader(DateTime date) => MyHeaderText(
        DateFormat(DateFormat.ABBR_WEEKDAY).format(date),
        textAlign: TextAlign.center,
        subtext: true,
        weight: FontWeight.normal,
        size: FONTSIZE.one,
      );

  Widget _buildDay(
    BuildContext context,
    Map<DateTime, List<LoggedWorkout>> logsByDay,
    DateTime now,
    DateTime date,
  ) {
    final isToday = now.isSameDate(date);

    final numLogsOnDay = logsByDay[date]?.length ?? 0;
    final hasLogOnDay = numLogsOnDay > 0;

    return Container(
      decoration: BoxDecoration(
          border: isToday
              ? Border.all(color: Styles.primaryAccent, width: 2)
              : null,
          borderRadius: BorderRadius.circular(60)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  hasLogOnDay ? null : context.theme.primary.withOpacity(0.1),
              gradient: hasLogOnDay ? Styles.primaryAccentGradient : null,
            ),
          ),
          if (hasLogOnDay)
            const Opacity(
                opacity: 0.25,
                child: Icon(MyCustomIcons.medal, color: Styles.white)),
          if (numLogsOnDay > 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 1,
                  runSpacing: 1,
                  children: List.generate(
                      numLogsOnDay,
                      (i) => const Dot(
                            diameter: 4,
                            color: Styles.white,
                          )),
                ),
              ),
            ),
          MyText(
            date.day.toString(),
            size: FONTSIZE.one,
            color: hasLogOnDay ? Styles.white : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    /// [startDay] should be the Monday 3 and a bit weeks ago.
    /// You show 4 weeks - including the week the user is currently in.
    final weekDayNumber = now.weekday;
    final daysBeforeToday = 21 + (weekDayNumber - 1);
    final startDay = DateTime(now.year, now.month, now.day - daysBeforeToday);

    final logsByDay = loggedWorkouts
        .where((l) => l.completedOn.isAfter(startDay))
        .groupListsBy((l) => DateTime(
            l.completedOn.year, l.completedOn.month, l.completedOn.day));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetHeader(
          icon: MyCustomIcons.dumbbell,
          title: 'Sessions Logged',
          actions: [
            WidgetHeaderAction(
                icon: CupertinoIcons.rectangle_expand_vertical,
                onPressed: () => print('view full screen')),
            WidgetHeaderAction(
                icon: CupertinoIcons.settings,
                onPressed: () => print('settings')),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 7,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3,
          shrinkWrap: true,
          children: List.generate(7,
              (index) => _buildDayHeader(startDay.add(Duration(days: index)))),
        ),
        GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            shrinkWrap: true,
            children: List.generate(
                28,
                (index) => _buildDay(context, logsByDay, now,
                    _getDateXDaysAgo(now, daysBeforeToday - index)))),
      ],
    );
  }
}
