import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/discover_club_card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';

class ClubSummariesSlider extends StatelessWidget {
  final List<ClubSummary> clubs;
  const ClubSummariesSlider({Key? key, required this.clubs}) : super(key: key);

  double get cardHeight => 170.0;
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
                    children: const [
                      MyHeaderText('Clubs'),
                    ],
                  ),
                ),
                Container(
                  height: cardHeight,
                  padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                  child: ListView.builder(
                    itemCount: clubs.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (c, i) => GestureDetector(
                      onTap: () =>
                          context.navigateTo(ClubDetailsRoute(id: clubs[i].id)),
                      child: SizedBox(
                        width: cardWidth(constraints),
                        child: DiscoverClubCard(
                          club: clubs[i],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }
}
