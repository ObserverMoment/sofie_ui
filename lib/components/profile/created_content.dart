import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:auto_route/auto_route.dart';

class CreatedContent extends StatelessWidget {
  final bool isAuthedUserProfile;
  final String profileId;
  final String? userDisplayName;
  final int workoutCount;
  final int planCount;
  const CreatedContent(
      {Key? key,
      required this.isAuthedUserProfile,
      required this.workoutCount,
      required this.planCount,
      required this.profileId,
      this.userDisplayName})
      : super(key: key);

  /// On tap will open up the users public workouts - used when this is not the logged in user's profile.
  Widget _contentCountButton(String title, int count, VoidCallback onTap) =>
      TertiaryButton(
        onPressed: onTap,
        text: '$count $title',
        suffixIconData: CupertinoIcons.chevron_right,
        fontSize: FONTSIZE.four,
        iconSize: 17,
        textColor: Styles.primaryAccent,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              MyHeaderText('Created'),
            ],
          ),
        ),
        isAuthedUserProfile
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CommaSeparatedList(
                  [
                    '$workoutCount workouts',
                    '$planCount plans',
                  ],
                  fontSize: FONTSIZE.four,
                  withFullStop: true,
                ),
              )
            : SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: ListView(
                    padding: const EdgeInsets.only(left: 6),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: _contentCountButton(
                            'Workouts',
                            workoutCount,
                            () => context.navigateTo(ProfilePublicWorkoutsRoute(
                                userId: profileId,
                                userDisplayName: userDisplayName))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: _contentCountButton(
                            'Plans',
                            planCount,
                            () => context.navigateTo(
                                ProfilePublicWorkoutPlansRoute(
                                    userId: profileId,
                                    userDisplayName: userDisplayName))),
                      ),
                    ],
                  ),
                ),
              ),
        const SizedBox(height: 10)
      ],
    );
  }
}
