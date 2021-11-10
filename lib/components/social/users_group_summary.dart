import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

/// Displays a horizontal list of small user avatars, up to a maximum, then + more indicator.
/// Standard for showing members of a group / enrolments etc.
class UsersGroupSummary extends StatelessWidget {
  final List<UserSummary> users;
  final int showMax;
  final String? subtitle;
  final double avatarSize;
  const UsersGroupSummary(
      {Key? key,
      required this.users,
      this.showMax = 5,
      this.subtitle,
      this.avatarSize = 30.0})
      : super(key: key);

  /// Less than one means an overlap.
  double get kAvatarWidthFactor => 0.6;

  @override
  Widget build(BuildContext context) {
    return users.isEmpty
        ? const MyText(
            'No members yet',
            size: FONTSIZE.one,
            weight: FontWeight.bold,
            subtext: true,
          )
        : Column(
            children: [
              Row(children: [
                ...users
                    .take(showMax)
                    .map((u) => Align(
                          widthFactor: kAvatarWidthFactor,
                          child: UserAvatar(
                            avatarUri: u.avatarUri,
                            size: avatarSize,
                            borderWidth: 1,
                            border: true,
                          ),
                        ))
                    .toList(),
                Align(
                  widthFactor: kAvatarWidthFactor,
                  child: UserCountDisplay(
                    size: avatarSize,
                    count: users.length,
                    fontSize: FONTSIZE.one,
                  ),
                )
              ]),
              if (Utils.textNotNull(subtitle))
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 1),
                  child: MyText(
                    subtitle!,
                    size: FONTSIZE.one,
                    weight: FontWeight.bold,
                    subtext: true,
                  ),
                ),
            ],
          );
  }
}
