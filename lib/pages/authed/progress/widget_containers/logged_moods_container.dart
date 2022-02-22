import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

/// Data retrieval wrapper for both the full screen and minimised version of the widget.
class LoggedMoodsContainer extends StatelessWidget {
  final Widget loadingShimmer;
  final Widget Function(List<UserDayLogMood> userDayLogMoods) builder;
  const LoggedMoodsContainer(
      {Key? key, required this.builder, required this.loadingShimmer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserDayLogMoodsQuery();

    return QueryObserver<UserDayLogMoods$Query, json.JsonSerializable>(
        key: Key('LoggedMoodsContainer - ${query.operationName}'),
        query: query,
        loadingIndicator: loadingShimmer,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          return builder(data.userDayLogMoods);
        });
  }
}
