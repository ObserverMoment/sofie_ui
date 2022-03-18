import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

/// Data wrapper which gets [userFitnessBenchmarks] and [UsxerProfile.activeFitnessBenchmarks] from store / network and passes to a builder function.
/// Most components that display benchmarking related UI require data from both these queries.
class ActiveSettingsAndBenchmarksContainer extends StatelessWidget {
  final Widget Function(
          List<String> activeBenchmarkIds, List<FitnessBenchmark> allBenchmarks)
      builder;
  const ActiveSettingsAndBenchmarksContainer({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userFitnessBenchmarksQuery = UserFitnessBenchmarksQuery();

    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    final userProfileQuery =
        UserProfileQuery(variables: UserProfileArguments(userId: authedUserId));

    return QueryObserver<UserProfile$Query, UserProfileArguments>(
        key: Key(
            'ActiveSettingsAndBenchmarksContainer - ${userProfileQuery.operationName}'),
        query: userProfileQuery,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        loadingIndicator: const ShimmerCardGridCount(
          itemCount: 9,
          crossAxisCount: 3,
        ),
        parameterizeQuery: true,
        builder: (userData) {
          if (userData.userProfile == null) {
            return const ObjectNotFoundIndicator();
          }

          final activeBenchmarkIds =
              userData.userProfile?.activeFitnessBenchmarks ?? [];

          return QueryObserver<UserFitnessBenchmarks$Query,
                  json.JsonSerializable>(
              key: Key(
                  'ActiveSettingsAndBenchmarksContainer - ${userFitnessBenchmarksQuery.operationName}'),
              query: userFitnessBenchmarksQuery,
              loadingIndicator: const ShimmerCardGridCount(
                itemCount: 9,
                crossAxisCount: 3,
              ),
              builder: (benchmarksData) {
                final benchmarks = benchmarksData.userFitnessBenchmarks
                    .sortedBy<String>((b) => b.name);

                return builder(activeBenchmarkIds, benchmarks);
              });
        });
  }
}
