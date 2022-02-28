import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

class UserFastestTimeExerciseTrackers extends StatelessWidget {
  const UserFastestTimeExerciseTrackers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserFastestTimeExerciseTrackersQuery();
    return QueryObserver<UserFastestTimeExerciseTrackers$Query,
            json.JsonSerializable>(
        key: Key('UserFastestTimeExerciseTrackers - ${query.operationName}'),
        query: query,
        loadingIndicator: Container(),
        builder: (data) {
          final trackers = data.userFastestTimeExerciseTrackers;
          return MyText(trackers.length.toString());
        });
  }
}
