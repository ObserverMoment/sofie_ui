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
          return data.logCountByWorkout > 0
              ? LogCountByWorkoutOverlayDisplay(count: data.logCountByWorkout)
              : Container();
        });
  }
}

class LogCountByWorkoutOverlayDisplay extends StatelessWidget {
  final int count;
  final double opacity;
  const LogCountByWorkoutOverlayDisplay(
      {Key? key, required this.count, this.opacity = 0.75})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
        child: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: context.theme.background.withOpacity(opacity)),
      child: Column(
        children: [
          MyText(
            count.displayLong,
            size: FONTSIZE.four,
          ),
          const MyText(
            'sessions',
            size: FONTSIZE.one,
          ),
        ],
      ),
    ));
  }
}

class LogCountByWorkoutTextDisplay extends StatelessWidget {
  final int count;
  const LogCountByWorkoutTextDisplay({Key? key, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.theme.background.withOpacity(0.2)),
      child: Column(
        children: [
          MyText(
            'Logged ${count.displayLong} times',
            size: FONTSIZE.four,
          ),
          const MyText(
            'worldwide',
            size: FONTSIZE.one,
          ),
        ],
      ),
    );
  }
}
