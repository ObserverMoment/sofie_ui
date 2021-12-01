import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/tag_managers/progress_journal_goal_tags_manager.dart';
import 'package:sofie_ui/components/user_input/tag_managers/user_benchmark_tags_manager.dart';
import 'package:sofie_ui/components/user_input/tag_managers/workout_tags_manager.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:auto_route/auto_route.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _loading = false;
  Widget _spacer() => const SizedBox(height: 10);

  /// Don't show toast when clearing cache before signing out - only when just clearing cache.
  Future<void> _clearCache(BuildContext context, bool showToast) async {
    setState(() => _loading = true);
    await context.graphQLStore.clear();
    setState(() => _loading = false);
    if (showToast) {
      context.showToast(message: 'Cache cleared.');
    }
  }

  Future<void> _updateUserProfileScope(
      String userId, UserProfileScope scope) async {
    final variables = UpdateUserArguments(data: UpdateUserInput());

    await context.graphQLStore.mutate(
      mutation: UpdateUserMutation(variables: variables),
      customVariablesMap: {
        'data': {'userProfileScope': scope.apiValue}
      },
      broadcastQueryIds: [AuthedUserQuery().operationName],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color _headingColor =
        CupertinoTheme.of(context).primaryColor.withOpacity(0.70);

    return MyPageScaffold(
        navigationBar: const MyNavBar(
          middle: NavBarTitle('Settings'),
        ),
        child: QueryObserver<AuthedUser$Query, json.JsonSerializable>(
            key: Key('SettingsPage - ${AuthedUserQuery().operationName}'),
            query: AuthedUserQuery(),
            loadingIndicator: const ShimmerCardList(
              itemCount: 20,
              cardHeight: 80,
            ),
            builder: (data) {
              final User user = data.authedUser;

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MyText(
                          'Dark Mode',
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
                  _spacer(),
                  MyText('ACCOUNT', color: _headingColor),
                  UserInputContainer(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const MyText(
                              'Profile Privacy',
                            ),
                            MySlidingSegmentedControl<UserProfileScope>(
                                value: user.userProfileScope,
                                children: {
                                  for (final v in UserProfileScope.values.where(
                                      (v) =>
                                          v != UserProfileScope.artemisUnknown))
                                    v: v.display.capitalize
                                },
                                updateValue: (scope) =>
                                    _updateUserProfileScope(user.id, scope)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: AnimatedSwitcher(
                              duration: kStandardAnimationDuration,
                              child: MyText(
                                user.userProfileScope ==
                                        UserProfileScope.private
                                    ? 'Your profile will not be discoverable or visible to the community.'
                                    : 'Your profile will be visible to and discoverable by anyone in the community.',
                                textAlign: TextAlign.start,
                                size: FONTSIZE.two,
                                maxLines: 3,
                                subtext: true,
                                lineHeight: 1.2,
                              )),
                        )
                      ],
                    ),
                  ),
                  _spacer(),
                  MyText(
                    'MANAGE TAGS',
                    color: _headingColor,
                  ),
                  _spacer(),
                  PageLink(
                    linkText: 'Workout Tags',
                    icon: const Icon(CupertinoIcons.tag, size: 20),
                    onPress: () => context.push(
                        child: const WorkoutTagsManager(
                            allowCreateTagOnly: false)),
                  ),
                  PageLink(
                    linkText: 'Journal Goal Tags',
                    icon: const Icon(CupertinoIcons.tag, size: 20),
                    onPress: () => context.push(
                        child: const ProgressJournalGoalTagsManager(
                            allowCreateTagOnly: false)),
                  ),
                  PageLink(
                    linkText: 'Personal Best Tags',
                    icon: const Icon(CupertinoIcons.tag, size: 20),
                    onPress: () => context.push(
                        child: const UserBenchmarkTagsManager(
                            allowCreateTagOnly: false)),
                  ),
                  _spacer(),
                  MyText(
                    'DATA',
                    color: _headingColor,
                  ),
                  _spacer(),
                  PageLink(
                    linkText: 'View Archive',
                    onPress: () => context.navigateTo(const ArchiveRoute()),
                    icon: const Icon(CupertinoIcons.archivebox, size: 20),
                  ),
                  PageLink(
                    linkText: 'Clear cache',
                    onPress: () => _clearCache(context, true),
                    icon: const Icon(Icons.cached_rounded, size: 20),
                    loading: _loading,
                  ),
                  _spacer(),
                  PageLink(
                      linkText: 'Sign out',
                      onPress: () async {
                        await _clearCache(context, false);
                        await GetIt.I<AuthBloc>().signOut();
                      },
                      icon: const Icon(CupertinoIcons.square_arrow_right,
                          size: 20))
                ],
              );
            }));
  }
}
