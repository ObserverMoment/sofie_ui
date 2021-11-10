import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';

class ParticipantCard extends StatelessWidget {
  final UserSummary userSummary;
  const ParticipantCard({Key? key, required this.userSummary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  UserAvatar(
                    size: 40,
                    avatarUri: userSummary.avatarUri,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            MyText(
                              userSummary.displayName,
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
            if (userSummary.userProfileScope == UserProfileScope.public)
              BorderButton(
                  mini: true,
                  text: 'Profile',
                  onPressed: () => context.navigateTo(
                      UserPublicProfileDetailsRoute(userId: userSummary.id)))
          ],
        ));
  }
}
