import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/profile/components/user_avatar.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/utils.dart';

class ProfileSettingsDrawer extends StatelessWidget {
  const ProfileSettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserProfileQuery(
        variables:
            UserProfileArguments(userId: GetIt.I<AuthBloc>().authedUser!.id));

    return QueryObserver<UserProfile$Query, UserProfileArguments>(
        key: Key('ProfileSettingsDrawer - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final profile = data.userProfile;
          return material.Drawer(
            backgroundColor: context.theme.background,
            child: Column(
              children: [
                Container(
                  color: context.theme.barBackground,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                iconData: CupertinoIcons.clear,
                                onPressed: context.pop),
                            const SizedBox(width: 10)
                          ],
                        ),
                        UserAvatar(
                          avatarUri: profile?.avatarUri,
                          size: 100,
                        ),
                        const SizedBox(height: 16),
                        if (Utils.textNotNull(profile?.displayName))
                          MyHeaderText(profile!.displayName),
                        const SizedBox(height: 16)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 8),
                      PageLink(
                          linkText: 'View Profile',
                          icon: CupertinoIcons.person,
                          onPress: () {
                            context.pop();
                            context.navigateTo(const ProfileRoute());
                          }),
                      PageLink(
                          linkText: 'Edit Profile',
                          icon: CupertinoIcons.pencil,
                          onPress: () {
                            context.pop();
                            context.navigateTo(const EditProfileRoute());
                          }),
                      PageLink(
                          linkText: 'Settings',
                          icon: CupertinoIcons.gear,
                          onPress: () {
                            context.pop();
                            context.navigateTo(const SettingsRoute());
                          }),
                      PageLink(
                          linkText: 'Gym Profiles',
                          icon: MyCustomIcons.clubsIcon,
                          onPress: () {
                            context.pop();
                            context.navigateTo(const GymProfilesRoute());
                          }),
                      PageLink(
                          linkText: 'Social Links',
                          icon: CupertinoIcons.link,
                          onPress: () {
                            context.pop();
                            context.navigateTo(const SettingsRoute());
                          }),
                      PageLink(
                          linkText: 'Skills',
                          icon: MyCustomIcons.certificateIcon,
                          onPress: () {
                            context.pop();
                            context.navigateTo(const SkillsRoute());
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const MyHeaderText(
                              'Theme',
                            ),
                            MySlidingSegmentedControl<ThemeName>(
                                value: context.watch<ThemeBloc>().themeName,
                                children: const {
                                  ThemeName.dark: 'Dark',
                                  ThemeName.light: 'Light',
                                },
                                updateValue: (themeName) => context
                                    .read<ThemeBloc>()
                                    .switchToTheme(themeName)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
