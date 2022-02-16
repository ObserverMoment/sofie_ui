import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class SleepWellLogWidget extends StatelessWidget {
  final List<UserSleepWellLog> userSleepWellLogs;
  const SleepWellLogWidget({Key? key, required this.userSleepWellLogs})
      : super(key: key);

  final _numDays = 21;

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
    Map<DateTime, UserSleepWellLog> logsByDay,
    DateTime today,
    DateTime date,
  ) {
    final isToday = today.isSameDate(date);

    final log = logsByDay[date];
    final hasLogOnDay = log != null;

    final rating = log?.rating;

    return Container(
      decoration: BoxDecoration(
        border:
            isToday ? Border.all(color: Styles.primaryAccent, width: 2) : null,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasLogOnDay ? rating!.color.withOpacity(0.1) : null,
            ),
          ),
          if (hasLogOnDay)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.bed_double,
                  color: rating!.color,
                  size: 18,
                ),
                if (log!.minutesSlept != null)
                  MyText(
                    '${(log.minutesSlept! / 60).stringMyDouble()} hr',
                    size: FONTSIZE.one,
                  ),
              ],
            ),
          if (!hasLogOnDay)
            MyText(
              date.day.toString(),
              size: FONTSIZE.zero,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayDayNumber = now.dayNumberInYear;

    /// [startDay] should be the Monday 3 and a bit weeks ago.
    /// You show 4 weeks - including the week the user is currently in.

    final weekDayNumber = now.weekday;
    final numDaysBeforeToday = (_numDays - 7) + (weekDayNumber - 1);
    final startDay =
        DateTime(now.year, now.month, todayDayNumber - numDaysBeforeToday);
    final startDayNumber = todayDayNumber - numDaysBeforeToday;

    /// Should only be one log per dayNumber.
    final logsByDay = userSleepWellLogs
        .where((l) => l.dayNumber >= startDayNumber)
        .fold<Map<DateTime, UserSleepWellLog>>({}, (acum, next) {
      acum[DateTime(next.year, 1, next.dayNumber)] = next;
      return acum;
    });

    return Column(
      children: [
        GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 7,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3,
          shrinkWrap: true,
          children: List.generate(7,
              (index) => _buildDayHeader(startDay.add(Duration(days: index)))),
        ),
        GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisExtent: 40),
            itemCount: _numDays,
            itemBuilder: (c, i) {
              final date = _getDateXDaysAgo(now, numDaysBeforeToday - i);

              return GestureDetector(
                onTap: () {
                  final log = logsByDay[date];
                  context.navigateTo(UserSleepWellLogCreatorRoute(
                      year: log == null ? date.year : null,
                      dayNumber: log == null ? date.dayNumberInYear : null,
                      userSleepWellLog: logsByDay[date]));
                },
                child: _buildDay(context, logsByDay, now, date),
              );
            }),
      ],
    );
  }
}
