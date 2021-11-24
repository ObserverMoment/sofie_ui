import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

/// Standalone widget which gets and displays the number of logs submitted for a given workout.
class LogCountByWorkout extends StatelessWidget {
  final String workoutId;
  const LogCountByWorkout({Key? key, required this.workoutId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logCountByWorkoutIdQuery = LogCountByWorkoutQuery(
        variables: LogCountByWorkoutArguments(id: workoutId));
    return QueryObserver<LogCountByWorkout$Query, LogCountByWorkoutArguments>(
        key: Key(
            'LogCountByWorkout - ${logCountByWorkoutIdQuery.operationName}-$workoutId'),
        query: logCountByWorkoutIdQuery,
        fetchPolicy: QueryFetchPolicy.networkOnly,
        loadingIndicator: Container(),
        parameterizeQuery: true,
        builder: (data) {
          return data.logCountByWorkout == 0
              ? FadeInUp(
                  child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.theme.background.withOpacity(0.2)),
                  child: Column(
                    children: [
                      MyText(
                        data.logCountByWorkout.displayLong,
                        size: FONTSIZE.five,
                      ),
                      const MyText(
                        'sessions',
                        size: FONTSIZE.one,
                      ),
                    ],
                  ),
                ))
              : Container();
        });
  }
}
