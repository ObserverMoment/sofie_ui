import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/utils.dart';

/// Displays a grid of all the users in the club.
/// Shows tags on the owner and the admins.
class ClubMembersGridList extends StatelessWidget {
  final UserSummary owner;
  final List<UserSummary> admins;
  final List<UserSummary> members;
  final ScrollPhysics? scrollPhysics;
  final void Function(String userId, ClubMemberType memberType) onTapAvatar;
  const ClubMembersGridList(
      {Key? key,
      required this.members,
      required this.owner,
      required this.admins,
      this.scrollPhysics,
      required this.onTapAvatar})
      : super(key: key);

  Widget _buildPositionedOwnerTag(String text) => Positioned(
      bottom: 8,
      child: Tag(
        tag: text,
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
        color: Styles.secondaryAccent,
        textColor: Styles.white,
        fontSize: FONTSIZE.one,
      ));

  Widget _buildPositionedAdminTag(String text) => Positioned(
      bottom: 8,
      child: Tag(
        tag: text,
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
        fontSize: FONTSIZE.one,
      ));

  Widget _buildDisplayName(String? name) => Utils.textNotNull(name)
      ? MyText(
          name!,
          size: FONTSIZE.one,
        )
      : Container();

  Widget _gestureDetectorWrap(
          {required BuildContext context,
          required String userId,
          required Widget child,
          required ClubMemberType memberType}) =>
      GestureDetector(
        onTap: () => onTapAvatar(userId, memberType),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: scrollPhysics,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 0.6,
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _gestureDetectorWrap(
          context: context,
          userId: owner.id,
          memberType: ClubMemberType.owner,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  UserAvatar(
                    avatarUri: owner.avatarUri,
                  ),
                  _buildPositionedOwnerTag('Owner'),
                ],
              ),
              _buildDisplayName(owner.displayName),
            ],
          ),
        ),
        ...admins
            .map((a) => _gestureDetectorWrap(
                  context: context,
                  userId: a.id,
                  memberType: ClubMemberType.admin,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          UserAvatar(
                            avatarUri: a.avatarUri,
                          ),
                          _buildPositionedAdminTag('Admin'),
                        ],
                      ),
                      _buildDisplayName(a.displayName),
                    ],
                  ),
                ))
            .toList(),
        ...members
            .map((m) => _gestureDetectorWrap(
                  context: context,
                  userId: m.id,
                  memberType: ClubMemberType.member,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserAvatar(
                        avatarUri: m.avatarUri,
                      ),
                      _buildDisplayName(m.displayName),
                    ],
                  ),
                ))
            .toList()
      ],
    );
  }
}
