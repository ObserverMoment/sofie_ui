import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/components/widget_header.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class SleepWellLogWidget extends StatelessWidget {
  const SleepWellLogWidget({Key? key}) : super(key: key);

  final _numDays = 28;

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
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasLogOnDay ? rating!.color : null,
            ),
          ),
          MyText(
            date.day.toString(),
            size: FONTSIZE.zero,
            color: hasLogOnDay ? Styles.white : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = UserSleepWellLogsQuery();

    return QueryObserver<UserSleepWellLogs$Query, json.JsonSerializable>(
        key: Key('SleepWellLogWidget - ${query.operationName}'),
        query: query,
        loadingIndicator: const ShimmerCard(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final now = DateTime.now();
          final todayDayNumber = now.dayNumberInYear;

          /// [startDay] should be the Monday 3 and a bit weeks ago.
          /// You show 4 weeks - including the week the user is currently in.

          final weekDayNumber = now.weekday;
          final numDaysBeforeToday = (_numDays - 7) + (weekDayNumber - 1);
          final startDay = DateTime(
              now.year, now.month, todayDayNumber - numDaysBeforeToday);
          final startDayNumber = todayDayNumber - numDaysBeforeToday;

          /// Should only be one log per dayNumber.
          final logsByDay = data.userSleepWellLogs
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
                children: List.generate(
                    7,
                    (index) =>
                        _buildDayHeader(startDay.add(Duration(days: index)))),
              ),
              GridView.count(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 7,
                  childAspectRatio: 1.4,
                  shrinkWrap: true,
                  children: List.generate(_numDays, (index) {
                    final date =
                        _getDateXDaysAgo(now, numDaysBeforeToday - index);

                    return GestureDetector(
                      onTap: () {
                        final log = logsByDay[date];
                        context.navigateTo(UserSleepWellLogCreatorRoute(
                            year: log == null ? date.year : null,
                            dayNumber:
                                log == null ? date.dayNumberInYear : null,
                            userSleepWellLog: logsByDay[date]));
                      },
                      child: _buildDay(context, logsByDay, now, date),
                    );
                  })),
            ],
          );
        });
  }
}
