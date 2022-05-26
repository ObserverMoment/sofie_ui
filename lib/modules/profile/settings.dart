import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/tag_managers/workout_tags_manager.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _appName;
  String? _version;
  String? _buildNumber;

  @override
  void initState() {
    super.initState();
    _getVersionInfo();
  }

  Future<void> _getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _appName = packageInfo.appName;
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
    setState(() {});
  }

  bool _loading = false;
  Widget _spacer() => const SizedBox(height: 16);

  /// Don't show toast when clearing cache before signing out - only when just clearing cache.
  Future<void> _clearCache(BuildContext context, bool showToast) async {
    setState(() => _loading = true);
    await context.graphQLStore.clear();
    setState(() => _loading = false);
    if (showToast) {
      context.showToast(message: 'Cache cleared.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color headingColor =
        CupertinoTheme.of(context).primaryColor.withOpacity(0.70);

    return CupertinoPageScaffold(
        navigationBar: const MyNavBar(
          middle: NavBarLargeTitle('Settings'),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            _spacer(),
            ContentBox(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyHeaderText(
                  'DATA',
                  color: headingColor,
                ),
                _spacer(),
                PageLink(
                  linkText: 'Workout Tags',
                  icon: CupertinoIcons.tag,
                  onPress: () => context.push(
                      child:
                          const WorkoutTagsManager(allowCreateTagOnly: false)),
                ),
                PageLink(
                  linkText: 'View Archive',
                  onPress: () => context.navigateTo(const ArchiveRoute()),
                  icon: CupertinoIcons.archivebox,
                ),
                PageLink(
                  linkText: 'Clear cache',
                  onPress: () => _clearCache(context, true),
                  icon: Icons.cached_rounded,
                  loading: _loading,
                  separator: false,
                ),
              ],
            )),
            // MyText(text)
            _spacer(),
            PageLink(
                linkText: 'Sign out',
                onPress: () async {
                  await _clearCache(context, false);
                  await GetIt.I<AuthBloc>().signOut();
                },
                icon: CupertinoIcons.square_arrow_right),
            if (_appName != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    _appName!.toUpperCase(),
                    size: FONTSIZE.two,
                    subtext: true,
                  ),
                  MyText(
                    ' - VERSION $_version',
                    size: FONTSIZE.two,
                    subtext: true,
                  ),
                  const SizedBox(width: 4),
                  MyText(
                    '($_buildNumber)',
                    size: FONTSIZE.two,
                    subtext: true,
                  ),
                ],
              )
          ],
        ));
  }
}
