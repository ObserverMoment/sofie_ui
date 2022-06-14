import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/modules/circles_tab/components/circle_card-deprecated.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

/// Will probably evolve to become a ClubFinder in the same style as the WorkoutFinder.
class DiscoverClubsPage extends StatelessWidget {
  const DiscoverClubsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<PublicClubs$Query, json.JsonSerializable>(
        key: Key('DiscoverClubs- ${PublicClubsQuery().operationName}'),
        query: PublicClubsQuery(),
        builder: (data) {
          final clubSummaries = data.publicClubs;
          return MyPageScaffold(
            child: NestedScrollView(
                headerSliverBuilder: (c, i) =>
                    [const MySliverNavbar(title: 'Discover Clubs')],
                body: ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: clubSummaries.length,
                  shrinkWrap: true,
                  itemBuilder: (c, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () => context.navigateTo(
                          ClubDetailsRoute(id: clubSummaries[i].id)),
                      child: CircleCard(
                        club: clubSummaries[i],
                      ),
                    ),
                  ),
                )),
          );
        });
  }
}
