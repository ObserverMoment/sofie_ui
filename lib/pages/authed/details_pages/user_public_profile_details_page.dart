import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/profile/components/user_profile_display.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class UserPublicProfileDetailsPage extends StatelessWidget {
  final String userId;
  const UserPublicProfileDetailsPage(
      {Key? key, @PathParam('userId') required this.userId})
      : super(key: key);

  Future<void> _shareUserProfile(UserProfile userPublicProfile) async {
    await SharingAndLinking.shareLink(
        'profile/${userPublicProfile.id}', 'Check out this profile!');
  }

  @override
  Widget build(BuildContext context) {
    final query =
        UserProfileQuery(variables: UserProfileArguments(userId: userId));

    return QueryObserver<UserProfile$Query, UserProfileArguments>(
        key: Key(
            'UserPublicProfileDetailsPage - ${query.operationName}-$userId'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          if (data.userProfile == null) {
            return const ObjectNotFoundIndicator(
              notFoundItemName: "this User's profile",
            );
          }
          final userPublicProfile = data.userProfile!;

          final profileIsPublic =
              userPublicProfile.userProfileScope == UserProfileScope.public;

          return MyPageScaffold(
              navigationBar: MyNavBar(
                middle: MyHeaderText(
                  userPublicProfile.displayName,
                ),
                trailing: profileIsPublic
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.ellipsis),
                        onPressed: () => openBottomSheetMenu(
                            context: context,
                            child: BottomSheetMenu(
                                header: BottomSheetMenuHeader(
                                  name: userPublicProfile.displayName,
                                  subtitle: 'Profile',
                                  imageUri: userPublicProfile.avatarUri,
                                ),
                                items: [
                                  BottomSheetMenuItem(
                                      text: 'Share',
                                      icon: CupertinoIcons.paperplane,
                                      onPressed: () =>
                                          _shareUserProfile(userPublicProfile)),
                                ])),
                      )
                    : null,
              ),
              child: UserProfileDisplay(profile: userPublicProfile));
        });
  }
}
