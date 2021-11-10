import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/participant_card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class WorkoutPlanParticipants extends StatelessWidget {
  final List<UserSummary> userSummaries;
  const WorkoutPlanParticipants({Key? key, required this.userSummaries})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        child: userSummaries.isEmpty
            ? const Center(
                child: MyText(
                'No participants yet',
                subtext: true,
              ))
            : ListView(
                children: [
                  ...userSummaries
                      .map((u) => ParticipantCard(userSummary: u))
                      .toList(),
                  const SizedBox(height: kAssumedFloatingButtonHeight),
                ],
              ));
  }
}
