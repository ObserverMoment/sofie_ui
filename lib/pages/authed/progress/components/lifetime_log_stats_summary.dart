import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/extensions/type_extensions.dart';

class LifetimeLogStatsWrapper extends StatelessWidget {
  const LifetimeLogStatsWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query =
        UserLoggedWorkoutsQuery(variables: UserLoggedWorkoutsArguments());
    return QueryObserver<UserLoggedWorkouts$Query, json.JsonSerializable>(
        key: Key('LoggedWorkoutsPage - ${query.operationName}'),
        query: query,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final logs = data.userLoggedWorkouts;

          final sessionsLogged = logs.length;

          final minutesWorked = logs.fold<int>(0, (acum, nextLog) {
            return acum +
                nextLog.loggedWorkoutSections.fold<int>(0, (acum, nextSection) {
                  return acum + nextSection.timeTakenSeconds;
                });
          });

          return LifetimeLogStatsSummaryDisplay(
            sessionsLogged: sessionsLogged,
            minutesWorked: minutesWorked,
          );
        });
  }
}

class LifetimeLogStatsSummaryDisplay extends StatelessWidget {
  final int sessionsLogged;
  final int minutesWorked;
  const LifetimeLogStatsSummaryDisplay(
      {Key? key, required this.sessionsLogged, required this.minutesWorked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutesFormatted = minutesWorked.displayLong;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ContentBox(
          child: Column(
            children: [
              MyText(
                sessionsLogged.toString(),
                size: FONTSIZE.six,
              ),
              const MyText(
                'SESSIONS',
                size: FONTSIZE.one,
                subtext: true,
                lineHeight: 1.4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ContentBox(
          child: Column(
            children: [
              MyText(
                minutesFormatted,
                size: FONTSIZE.six,
              ),
              const MyText(
                'MINUTES',
                size: FONTSIZE.one,
                subtext: true,
                lineHeight: 1.4,
              ),
            ],
          ),
        )
      ],
    );
  }
}
