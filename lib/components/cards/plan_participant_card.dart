import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/modules/profile/components/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout_plan_enrolment/workout_plan_enrolment_progress_summary.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';

class ParticipantCard extends StatelessWidget {
  final WorkoutPlanEnrolment enrolment;
  final int totalWorkouts;
  const ParticipantCard(
      {Key? key, required this.enrolment, required this.totalWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = enrolment.user;
    return Card(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.navigateTo(
                            UserPublicProfileDetailsRoute(userId: user.id)),
                        child: UserAvatar(
                          size: 40,
                          avatarUri: user.avatarUri,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                MyText(
                                  user.displayName,
                                  size: FONTSIZE.four,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            WorkoutPlanEnrolmentProgressSummary(
              completed: enrolment.completedWorkoutPlanDayWorkouts.length,
              startedOn: enrolment.startDate,
              total: totalWorkouts,
            ),
          ],
        ));
  }
}
