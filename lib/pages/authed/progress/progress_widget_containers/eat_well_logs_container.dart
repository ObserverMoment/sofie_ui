import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

/// Data retrieval wrapper for both the full screen and minimised version of the widget.
class EatWellLogsContainer extends StatelessWidget {
  final Widget loadingShimmer;
  final Widget Function(List<UserEatWellLog> userEatWellLogs) builder;
  const EatWellLogsContainer(
      {Key? key, required this.builder, required this.loadingShimmer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserEatWellLogsQuery();

    return QueryObserver<UserEatWellLogs$Query, json.JsonSerializable>(
        key: Key('EatWellLogsContainer - ${query.operationName}'),
        query: query,
        loadingIndicator: loadingShimmer,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          return builder(data.userEatWellLogs);
        });
  }
}
