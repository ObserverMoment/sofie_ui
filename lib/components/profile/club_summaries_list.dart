import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/club_card.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';

class ClubSummariesList extends StatelessWidget {
  final List<ClubSummary> clubs;
  const ClubSummariesList({Key? key, required this.clubs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return clubs.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              YourContentEmptyPlaceholder(
                  message: 'No clubs to display', actions: []),
            ],
          )
        : ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: clubs
                .map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                          onTap: () =>
                              context.navigateTo(ClubDetailsRoute(id: c.id)),
                          child: ClubCard(club: c)),
                    ))
                .toList(),
          );
  }
}
