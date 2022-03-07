import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';

class LoggedMeditationsFullScreen extends StatelessWidget {
  final String widgetId;
  final List<UserMeditationLog> userMeditationLogs;
  const LoggedMeditationsFullScreen(
      {Key? key, required this.widgetId, required this.userMeditationLogs})
      : super(key: key);

  int get _numMonths => 6;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    final logsByMonth = userMeditationLogs.groupListsBy((l) {
      final date = DateTime(l.year, 1, l.dayNumber);
      return DateTime(date.year, date.month);
    });

    return CupertinoPageScaffold(
        backgroundColor: context.theme.cardBackground,
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  MySliverNavbar(
                    title: 'Mindfulness',
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
                    meditationLogs: logsByMonth[monthToDisplay] ?? [],
                  );
                })));
  }
}

class _MonthDisplay extends StatelessWidget {
  final DateTime dateAsMonth;
  final List<UserMeditationLog> meditationLogs;
  const _MonthDisplay(
      {Key? key, required this.dateAsMonth, required this.meditationLogs})
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

    List<UserMeditationLog?> emptyList =
        List.generate(daysInMonth, (index) => null, growable: false);

    /// NOTE: Consider using this in min size widget as well.
    /// Logs are inserted at their day index - 1.
    final logsIndexedByDay =
        meditationLogs.fold<List<UserMeditationLog?>>(emptyList, (acum, next) {
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
                    hasLogDayBefore: dayNumber == 0
                        ? false
                        : logsIndexedByDay[dayNumber - 1] != null,
                    hasLogDayAfter: dayNumber == daysInMonth - 1
                        ? false
                        : logsIndexedByDay[dayNumber + 1] != null,
                    date: date,
                    meditationLog: logsIndexedByDay[dayNumber]);
              }
            }),
      ],
    );
  }
}

class _DayDisplay extends StatelessWidget {
  final DateTime date;
  final UserMeditationLog? meditationLog;

  /// For streaking
  final bool hasLogDayBefore;
  final bool hasLogDayAfter;
  const _DayDisplay(
      {Key? key,
      required this.date,
      required this.meditationLog,
      required this.hasLogDayBefore,
      required this.hasLogDayAfter})
      : super(key: key);

  double get _r => 40.0;
  Radius get _radius => Radius.circular(_r);
  Color get _highlightColor => const Color.fromARGB(255, 192, 104, 176);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = today.isSameDate(date);

    final hasLogOnDay = meditationLog != null;

    final isStreakDay = hasLogOnDay && (hasLogDayBefore || hasLogDayAfter);

    final firstDayOfStreak = hasLogOnDay && !hasLogDayBefore && hasLogDayAfter;
    final lastDayOfStreak = hasLogOnDay && hasLogDayBefore && !hasLogDayAfter;

    BorderRadius? borderRadius = firstDayOfStreak
        ? BorderRadius.only(topLeft: _radius, bottomLeft: _radius)
        : lastDayOfStreak
            ? BorderRadius.only(topRight: _radius, bottomRight: _radius)
            : isStreakDay
                ? null
                : BorderRadius.circular(_r);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
        onTap: () {
          context.navigateTo(UserMeditationLogCreatorRoute(
              year: meditationLog == null ? date.year : null,
              dayNumber: meditationLog == null ? date.dayNumberInYear : null,
              userMeditationLog: meditationLog));
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (hasLogOnDay)
                  Opacity(
                    opacity: 0.3,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: borderRadius, color: _highlightColor),
                    ),
                  ),
                if (hasLogOnDay)
                  Icon(MyCustomIcons.mindfulnessIcon,
                      size: 28, color: _highlightColor),
                if (!hasLogOnDay)
                  MyText(
                    date.day.toString(),
                    size: FONTSIZE.one,
                    color: hasLogOnDay ? Styles.white : null,
                  ),
              ],
            ),
            if (isToday)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: _highlightColor, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
            if (hasLogOnDay)
              Positioned(
                  bottom: -6,
                  child: ContentBox(
                    backgroundColor: context.theme.background,
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Row(
                      children: [
                        MyText(
                          meditationLog!.minutesLogged.toString(),
                          size: FONTSIZE.one,
                        ),
                        const MyText(
                          ' min',
                          size: FONTSIZE.zero,
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
