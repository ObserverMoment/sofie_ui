import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';

class SleepWellLogsFullScreen extends StatelessWidget {
  final String widgetId;
  final List<UserSleepWellLog> userSleepWellLogs;
  const SleepWellLogsFullScreen(
      {Key? key, required this.widgetId, required this.userSleepWellLogs})
      : super(key: key);

  int get _numMonths => 6;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    final logsByMonth = userSleepWellLogs.groupListsBy((l) {
      final date = DateTime(l.year, 1, l.dayNumber);
      return DateTime(date.year, date.month);
    });

    return CupertinoPageScaffold(
        backgroundColor: context.theme.cardBackground,
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  MySliverNavbar(
                    title: 'Sleep Health',
                    leadingIcon: CupertinoIcons.chevron_down,
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: CircularBox(
                          padding: const EdgeInsets.all(10),
                          color: context.theme.background,
                          child: Icon(kWidgetIdToIconMap[widgetId], size: 20)),
                    ),
                    backgroundColor: context.theme.cardBackground,
                  ),
                ],
            body: ListView.separated(
                cacheExtent: 2000,
                padding: const EdgeInsets.all(8),
                itemCount: _numMonths,
                separatorBuilder: (c, i) => const SizedBox(height: 16),
                itemBuilder: (c, i) {
                  final monthToDisplay =
                      DateTime(currentMonth.year, currentMonth.month - i);

                  return _MonthDisplay(
                    dateAsMonth: monthToDisplay,
                    eatWellLogs: logsByMonth[monthToDisplay] ?? [],
                  );
                })));
  }
}

class _MonthDisplay extends StatelessWidget {
  final DateTime dateAsMonth;
  final List<UserSleepWellLog> eatWellLogs;
  const _MonthDisplay(
      {Key? key, required this.dateAsMonth, required this.eatWellLogs})
      : super(key: key);

  List<String> get _days => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(dateAsMonth.year, dateAsMonth.month + 1, 0).day;

    // What number day in the week does the month start on.
    final firstWeekDayOfMonth =
        DateTime(dateAsMonth.year, dateAsMonth.month, 1).weekday;

    final emptyWeekDaysRequired = firstWeekDayOfMonth - 1;

    List<UserSleepWellLog?> emptyList =
        List.generate(daysInMonth, (index) => null, growable: false);

    /// TODO: Consider using this in min size widget as well.
    /// Logs are inserted at their day index - 1.
    final logsIndexedByDay =
        eatWellLogs.fold<List<UserSleepWellLog?>>(emptyList, (acum, next) {
      final completedOnDayNumber = DateTime(next.year, 1, next.dayNumber).day;
      acum[completedOnDayNumber - 1] = next;
      return acum;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyText(
            DateFormat.yMMMM().format(dateAsMonth),
            size: FONTSIZE.four,
          ),
        ),
        GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisExtent: 30),
            itemCount: _days.length,
            itemBuilder: (c, i) => Center(
                    child: MyText(
                  _days[i].toUpperCase(),
                  size: FONTSIZE.two,
                  subtext: true,
                ))),
        GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisSpacing: 4),
            itemCount: emptyWeekDaysRequired + daysInMonth,
            itemBuilder: (c, i) {
              if (i <= emptyWeekDaysRequired - 1) {
                return Container();
              } else {
                final dayNumber = i - emptyWeekDaysRequired;
                final date = DateTime(dateAsMonth.year, dateAsMonth.month,
                    i - emptyWeekDaysRequired + 1);

                return _DayDisplay(
                    date: date, userSleepWellLog: logsIndexedByDay[dayNumber]);
              }
            }),
      ],
    );
  }
}

class _DayDisplay extends StatelessWidget {
  final DateTime date;
  final UserSleepWellLog? userSleepWellLog;

  const _DayDisplay({
    Key? key,
    required this.date,
    required this.userSleepWellLog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = today.isSameDate(date);

    final hasLogOnDay = userSleepWellLog != null;

    final rating = userSleepWellLog?.rating;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
          onTap: () {
            context.navigateTo(UserSleepWellLogCreatorRoute(
                year: userSleepWellLog == null ? date.year : null,
                dayNumber:
                    userSleepWellLog == null ? date.dayNumberInYear : null,
                userSleepWellLog: userSleepWellLog));
          },
          child: Container(
            decoration: BoxDecoration(
              border: isToday
                  ? Border.all(color: Styles.primaryAccent, width: 2)
                  : null,
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
                      if (userSleepWellLog?.minutesSlept != null)
                        MyText(
                          '${(userSleepWellLog!.minutesSlept! / 60).stringMyDouble()} hr',
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
          )),
    );
  }
}
