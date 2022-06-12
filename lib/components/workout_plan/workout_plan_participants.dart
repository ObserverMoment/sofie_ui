import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/plan_participant_card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class WorkoutPlanParticipants extends StatelessWidget {
  final WorkoutPlan workoutPlan;
  const WorkoutPlanParticipants({Key? key, required this.workoutPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enrolments = workoutPlan.workoutPlanEnrolments;
    return enrolments.isEmpty
        ? const Center(
            child: MyText(
            'No participants yet',
            subtext: true,
          ))
        : ListView(
            children: [
              ...enrolments
                  .map(
                      (e) => ParticipantCard(enrolment: e, totalWorkouts: 9999))
                  .toList(),
              const SizedBox(height: kAssumedFloatingButtonHeight),
            ],
          );
  }
}
