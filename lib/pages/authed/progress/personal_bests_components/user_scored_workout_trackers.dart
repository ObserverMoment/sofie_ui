import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

class UserScoredWorkoutTrackers extends StatelessWidget {
  const UserScoredWorkoutTrackers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserScoredWorkoutTrackersQuery();
    return QueryObserver<UserScoredWorkoutTrackers$Query,
            json.JsonSerializable>(
        key: Key('UserScoredWorkoutTrackers - ${query.operationName}'),
        loadingIndicator: Container(),
        query: query,
        builder: (data) {
          final trackers = data.userScoredWorkoutTrackers;
          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: trackers.map((t) => MyText(t.toString())).toList(),
          );
        });
  }
}
