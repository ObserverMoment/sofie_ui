import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfileSummary profileSummary;
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
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: avatarSize / 2,
                    child: _statDisplayContainer(
                        profileSummary.workoutCount, 'workouts'),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: avatarSize / 2,
                      child: _statDisplayContainer(
                          profileSummary.planCount, 'plans')),
                ],
              ),
              if (profileSummary.skills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: profileSummary.skills
                        .take(4)
                        .map((s) => Tag(
                            tag: s,
                            fontSize: FONTSIZE.one,
                            fontWeight: FontWeight.bold))
                        .toList(),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
