import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

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

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SummaryStatDisplay(
                label: 'SESSIONS',
                number: sessionsLogged,
              ),
              SummaryStatDisplay(
                label: 'MINUTES',
                number: minutesWorked,
              ),
            ],
          );
        });
  }
}

class SummaryStatDisplay extends StatelessWidget {
  final String label;
  final int number;
  final Color? backgroundColor;
  const SummaryStatDisplay(
      {Key? key,
      required this.label,
      required this.number,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      backgroundColor: backgroundColor,
      child: Column(
        children: [
          MyText(
            number.toString(),
            size: FONTSIZE.five,
          ),
          MyText(
            label,
            size: FONTSIZE.one,
            subtext: true,
            lineHeight: 1.4,
          ),
        ],
      ),
    );
  }
}
