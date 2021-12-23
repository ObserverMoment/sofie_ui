import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';

class HorizontalUserAvatarsList extends StatelessWidget {
  final List<UserAvatarData> users;
  final double avatarSize;
  const HorizontalUserAvatarsList(
      {Key? key, required this.users, this.avatarSize = 70.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: avatarSize,
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: users.length,
          itemBuilder: (c, i) => GestureDetector(
            onTap: () => context
                .navigateTo(UserPublicProfileDetailsRoute(userId: users[i].id)),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: UserAvatar(
                size: avatarSize,
                avatarUri: users[i].avatarUri,
              ),
            ),
          ),
        ));
  }
}
