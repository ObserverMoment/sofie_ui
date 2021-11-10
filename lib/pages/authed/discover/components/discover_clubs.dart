import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/discover_club_card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:auto_route/auto_route.dart';

class DiscoverClubs extends StatelessWidget {
  const DiscoverClubs({Key? key}) : super(key: key);

  double get cardHeight => 280.0;
  double cardWidth(BoxConstraints constraints) => constraints.maxWidth / 2.1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MyHeaderText('Clubs'),
                      IconButton(
                          iconData: CupertinoIcons.compass,
                          onPressed: () =>
                              context.navigateTo(const DiscoverClubsRoute()))
                    ],
                  ),
                ),
                QueryObserver<PublicClubs$Query, json.JsonSerializable>(
                    key: Key(
                        'DiscoverClubs- ${PublicClubsQuery().operationName}'),
                    query: PublicClubsQuery(),
                    loadingIndicator: Container(
                      height: cardHeight,
                      padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                      child: ShimmerHorizontalCardList(
                        cardWidth: cardWidth(constraints),
                      ),
                    ),
                    builder: (data) {
                      return Container(
                        height: cardHeight,
                        padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                        child: ListView.builder(
                          itemCount: data.publicClubs.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (c, i) => GestureDetector(
                            onTap: () => context.navigateTo(
                                ClubDetailsRoute(id: data.publicClubs[i].id)),
                            child: SizedBox(
                              width: cardWidth(constraints),
                              child: DiscoverClubCard(
                                club: data.publicClubs[i],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ));
  }
}
