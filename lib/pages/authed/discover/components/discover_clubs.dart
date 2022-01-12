import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/club_card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:auto_route/auto_route.dart';

class DiscoverClubs extends StatelessWidget {
  const DiscoverClubs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 6.0, top: 16, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MyHeaderText(
                        'Clubs',
                      ),
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
                    loadingIndicator: const ShimmerCardList(
                      itemCount: 8,
                      cardHeight: 180,
                    ),
                    builder: (data) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.publicClubs.length,
                        shrinkWrap: true,
                        itemBuilder: (c, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                            onTap: () => context.navigateTo(
                                ClubDetailsRoute(id: data.publicClubs[i].id)),
                            child: ClubCard(
                              club: data.publicClubs[i],
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ));
  }
}
