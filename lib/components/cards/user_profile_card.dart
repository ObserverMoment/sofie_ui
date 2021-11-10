import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class UserProfileCard extends StatelessWidget {
  final UserPublicProfileSummary profileSummary;
  final double avatarSize;
  const UserProfileCard(
      {Key? key, required this.profileSummary, required this.avatarSize})
      : super(key: key);

  String get _tagline => profileSummary.tagline ?? ' - ';

  Widget _statDisplayContainer(int number, String name) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            number.toString(),
            size: FONTSIZE.five,
            color: Styles.primaryAccent,
            weight: FontWeight.bold,
          ),
          MyText(
            name,
            size: FONTSIZE.two,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserAvatar(
          avatarUri: profileSummary.avatarUri,
          size: avatarSize,
          border: true,
          borderWidth: 2,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyHeaderText(
                profileSummary.displayName,
                size: FONTSIZE.two,
              ),
              const SizedBox(height: 4),
              MyText(
                _tagline,
                subtext: true,
                size: FONTSIZE.two,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: avatarSize / 2,
                    child: _statDisplayContainer(
                        profileSummary.numberPublicWorkouts, 'workouts'),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                      width: avatarSize / 2,
                      child: _statDisplayContainer(
                          profileSummary.numberPublicPlans, 'plans')),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
