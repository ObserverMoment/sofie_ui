import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

class UserMaxLoadExerciseTrackers extends StatelessWidget {
  const UserMaxLoadExerciseTrackers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserMaxLoadExerciseTrackersQuery();
    return QueryObserver<UserMaxLoadExerciseTrackers$Query,
            json.JsonSerializable>(
        key: Key('UserMaxLoadExerciseTrackers - ${query.operationName}'),
        query: query,
        loadingIndicator: Container(),
        builder: (data) {
          final trackers = data.userMaxLoadExerciseTrackers;
          return MyText(trackers.length.toString());
        });
  }
}
