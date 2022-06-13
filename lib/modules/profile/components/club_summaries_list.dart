import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/modules/circles/components/circle_card-deprecated.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';

class ClubSummariesList extends StatelessWidget {
  final List<ClubSummary> clubs;
  const ClubSummariesList({Key? key, required this.clubs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: clubs
          .map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                    onTap: () => context.navigateTo(ClubDetailsRoute(id: c.id)),
                    child: CircleCard(club: c)),
              ))
          .toList(),
    );
  }
}
