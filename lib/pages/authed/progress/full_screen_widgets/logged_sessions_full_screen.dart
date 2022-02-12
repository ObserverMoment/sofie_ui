import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/router.gr.dart';

class LoggedSessionsFullScreen extends StatelessWidget {
  final String widgetId;
  final List<LoggedWorkout> loggedWorkouts;
  const LoggedSessionsFullScreen(
      {Key? key, required this.widgetId, required this.loggedWorkouts})
      : super(key: key);

  int get _numMonths => 6;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    final logsByMonth = loggedWorkouts
        .groupListsBy((l) => DateTime(l.completedOn.year, l.completedOn.month));

    return CupertinoPageScaffold(
        backgroundColor: context.theme.cardBackground,
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  MySliverNavbar(
                    title: 'Sessions Logged',
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
                    loggedWorkouts: logsByMonth[monthToDisplay] ?? [],
                  );
                })));
  }
}

class _MonthDisplay extends StatelessWidget {
  final DateTime dateAsMonth;
  final List<LoggedWorkout> loggedWorkouts;
  const _MonthDisplay(
      {Key? key, required this.dateAsMonth, required this.loggedWorkouts})
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

    List<List<LoggedWorkout>> emptyList =
        List.generate(daysInMonth, (index) => [], growable: false);

    /// TODO: Consider using this in min size widget as well.
    /// Logs are inserted at their day index - 1.
    final logListsIndexedByDay =
        loggedWorkouts.fold<List<List<LoggedWorkout>>>(emptyList, (acum, next) {
      final completedOnDayNumber = next.completedOn.day;
      acum[completedOnDayNumber - 1].add(next);
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
                        : logListsIndexedByDay[dayNumber - 1].isNotEmpty,
                    hasLogDayAfter: dayNumber == daysInMonth - 1
                        ? false
                        : logListsIndexedByDay[dayNumber + 1].isNotEmpty,
                    date: date,
                    loggedWorkouts: logListsIndexedByDay[dayNumber]);
              }
            }),
      ],
    );
  }
}

class _DayDisplay extends StatelessWidget {
  final DateTime date;
  final List<LoggedWorkout> loggedWorkouts;

  /// For streaking
  final bool hasLogDayBefore;
  final bool hasLogDayAfter;
  const _DayDisplay(
      {Key? key,
      required this.date,
      required this.loggedWorkouts,
      required this.hasLogDayBefore,
      required this.hasLogDayAfter})
      : super(key: key);

  /// TODO: Exact duplicate of the widget / minimized version of this widget.
  void _handleDayTap(
      {required BuildContext context,
      required List<LoggedWorkout>? logsOnDay,
      required bool isTodayOrFuture,
      required DateTime date}) {
    openBottomSheetMenu(
        context: context,
        child: BottomSheetMenu(
            header: BottomSheetMenuHeader(
              name: date.compactDateString,
            ),
            items: [
              if (isTodayOrFuture)
                BottomSheetMenuItem(
                    text: 'Schedule a Workout',
                    icon: CupertinoIcons.calendar_badge_plus,
                    onPressed: () => context
                        .navigateTo(YourScheduleRoute(openAtDate: date))),
              ...(logsOnDay ?? [])
                  .map((l) => BottomSheetMenuItem(
                      text: 'View Log: ${l.name}',
                      onPressed: () => context
                          .navigateTo(LoggedWorkoutDetailsRoute(id: l.id))))
                  .toList(),
            ]));
  }

  Radius get _radius => const Radius.circular(40);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = today.isSameDate(date);
    final isTodayOrFuture = isToday || date.isAfter(today);

    final numLogsOnDay = loggedWorkouts.length;
    final hasLogOnDay = numLogsOnDay > 0;

    final isStreakDay = hasLogOnDay && (hasLogDayBefore || hasLogDayAfter);

    final firstDayOfStreak = hasLogOnDay && !hasLogDayBefore && hasLogDayAfter;
    final lastDayOfStreak = hasLogOnDay && hasLogDayBefore && !hasLogDayAfter;

    BorderRadius? borderRadius = firstDayOfStreak
        ? BorderRadius.only(topLeft: _radius, bottomLeft: _radius)
        : lastDayOfStreak
            ? BorderRadius.only(topRight: _radius, bottomRight: _radius)
            : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
        onTap: hasLogOnDay || isTodayOrFuture
            ? () => _handleDayTap(
                context: context,
                logsOnDay: loggedWorkouts,
                isTodayOrFuture: isTodayOrFuture,
                date: date)
            : null,
        child: Container(
          decoration: BoxDecoration(
            border: isToday
                ? Border.all(color: Styles.primaryAccent, width: 2)
                : null,
            shape: BoxShape.circle,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (isStreakDay)
                Opacity(
                  opacity: 0.3,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: Styles.primaryAccent),
                  ),
                ),
              Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: hasLogOnDay ? Styles.primaryAccentGradient : null,
                ),
              ),
              if (hasLogOnDay)
                const Opacity(
                    opacity: 0.25,
                    child: Icon(MyCustomIcons.medal,
                        size: 21, color: Styles.white)),
              if (hasLogOnDay)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 2,
                      runSpacing: 2,
                      children: List.generate(
                          numLogsOnDay,
                          (i) => const Dot(
                                diameter: 5,
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
              if (isStreakDay)
                const Positioned(
                    top: 4,
                    right: 6,
                    child: Icon(
                      CupertinoIcons.flame_fill,
                      color: Styles.secondaryAccent,
                      size: 12,
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
