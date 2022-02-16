import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

/// Date retrieval wrapper for both the full screen and minimised version of the widget.
class LoggedMeditationsContainer extends StatelessWidget {
  final Widget loadingShimmer;
  final Widget Function(List<UserMeditationLog> userMeditationLogs) builder;
  const LoggedMeditationsContainer(
      {Key? key, required this.builder, required this.loadingShimmer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserMeditationLogsQuery();

    return QueryObserver<UserMeditationLogs$Query, json.JsonSerializable>(
        key: Key('LoggedMeditationsContainer - ${query.operationName}'),
        query: query,
        loadingIndicator: loadingShimmer,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          return builder(data.userMeditationLogs);
        });
  }
}
