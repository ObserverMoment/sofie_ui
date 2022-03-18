import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class LoggedMeditationsWidget extends StatelessWidget {
  final List<UserMeditationLog> userMeditationLogs;
  const LoggedMeditationsWidget({Key? key, required this.userMeditationLogs})
      : super(key: key);

  Color get _highlightColor => const Color.fromARGB(255, 192, 104, 176);

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
    Map<DateTime, UserMeditationLog> logsByDay,
    DateTime today,
    DateTime date,
  ) {
    final isToday = today.isSameDate(date);

    final hasLogOnDay = logsByDay[date] != null;

    return Container(
      decoration: BoxDecoration(
        border: isToday ? Border.all(color: _highlightColor, width: 2) : null,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasLogOnDay ? _highlightColor.withOpacity(0.2) : null,
            ),
          ),
          if (hasLogOnDay)
            Icon(
              MyCustomIcons.mindfulnessIcon,
              color: _highlightColor,
              size: 20,
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
    /// You show 3 weeks - including the week the user is currently in.

    final weekDayNumber = now.weekday;
    final numDaysBeforeToday = (_numDays - 7) + (weekDayNumber - 1);
    final startDay =
        DateTime(now.year, now.month, now.day - numDaysBeforeToday);
    final startDayNumber = todayDayNumber - numDaysBeforeToday;

    /// Should only be one log per dayNumber.
    final logsByDay = userMeditationLogs
        .where((l) => l.dayNumber >= startDayNumber)
        .fold<Map<DateTime, UserMeditationLog>>({}, (acum, next) {
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
                  context.navigateTo(UserMeditationLogCreatorRoute(
                      year: log == null ? date.year : null,
                      dayNumber: log == null ? date.dayNumberInYear : null,
                      userMeditationLog: logsByDay[date]));
                },
                child: _buildDay(context, logsByDay, now, date),
              );
            }),
      ],
    );
  }
}
