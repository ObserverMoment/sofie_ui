import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uni_links/uni_links.dart';

/// Scaffold for the main top level tabs view.
class MainTabsPage extends StatefulWidget {
  const MainTabsPage({Key? key}) : super(key: key);

  @override
  State<MainTabsPage> createState() => _MainTabsPageState();
}

class _MainTabsPageState extends State<MainTabsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await _handleInitialUri();
    });
  }

  /// NOTE: This was in AuthedRoutesWrapperPage but was not triggering the navigate correctly amidst all the initial setup.
  /// So, moved down a level (in terms of the AutoRouter) to run after all the initial setup is done.
  ///
  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    try {
      final uri = await getInitialUri();
      if (uri == null) {
        printLog('Uni_links: no initial uri');
      } else {
        _extractRouterPathNameAndPush(uri);
      }
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
      printLog('Uni_links: falied to get initial uri');
    } on FormatException catch (err) {
      printLog('Uni_links: malformed initial uri');
      printLog(err.toString());
    }
  }

  void _extractRouterPathNameAndPush(Uri uri) {
    context.navigateNamedTo(uri.toString().replaceFirst(kDeepLinkSchema, ''));
  }

  Widget _buildTabItem({
    required TabsRouter tabsRouter,
    required int tabIndex,
    required int activeIndex,
    required String label,
    required IconData inactiveIconData,
    required IconData activeIconData,
  }) {
    return TabIcon(
        inactiveIcon: Icon(
          inactiveIconData,
        ),
        activeIcon: Icon(
          activeIconData,
        ),
        label: label,
        isActive: activeIndex == tabIndex,
        onTap: () => tabsRouter.setActiveIndex(tabIndex));
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      // https://github.com/Milad-Akarie/auto_route_library/issues/619#issuecomment-945187688
      backgroundColor: context.theme.background,
      routes: const [
        DiscoverStack(),
        SocialRoute(),
        HomeStack(),
        ProgressStack(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (context, _tabsRouter) => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
              decoration: BoxDecoration(
                color: context.theme.cardBackground.withOpacity(0.84),
              ),
              height: EnvironmentConfig.bottomNavBarHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTabItem(
                      tabsRouter: _tabsRouter,
                      activeIndex: _tabsRouter.activeIndex,
                      tabIndex: 0,
                      label: 'Discover',
                      inactiveIconData: CupertinoIcons.compass,
                      activeIconData: CupertinoIcons.compass_fill),
                  _buildTabItem(
                      tabsRouter: _tabsRouter,
                      activeIndex: _tabsRouter.activeIndex,
                      tabIndex: 1,
                      label: 'Social',
                      inactiveIconData: CupertinoIcons.person_2_square_stack,
                      activeIconData:
                          CupertinoIcons.person_2_square_stack_fill),
                  _buildTabItem(
                      tabsRouter: _tabsRouter,
                      activeIndex: _tabsRouter.activeIndex,
                      tabIndex: 2,
                      label: 'My Studio',
                      inactiveIconData: CupertinoIcons.square_grid_2x2,
                      activeIconData: CupertinoIcons.square_grid_2x2_fill),
                  _buildTabItem(
                      tabsRouter: _tabsRouter,
                      activeIndex: _tabsRouter.activeIndex,
                      tabIndex: 3,
                      label: 'Progress',
                      inactiveIconData: CupertinoIcons.graph_square,
                      activeIconData: CupertinoIcons.graph_square_fill),
                  _buildTabItem(
                      tabsRouter: _tabsRouter,
                      activeIndex: _tabsRouter.activeIndex,
                      tabIndex: 4,
                      label: 'Profile',
                      inactiveIconData: CupertinoIcons.profile_circled,
                      activeIconData: CupertinoIcons.profile_circled),
                ],
              )),
        ),
      ),
      extendBody: true,
    );
  }
}

class TabIcon extends StatelessWidget {
  final Widget activeIcon;
  final Widget inactiveIcon;
  final String label;
  final bool isActive;
  final void Function() onTap;
  const TabIcon(
      {Key? key,
      required this.activeIcon,
      required this.inactiveIcon,
      required this.label,
      required this.isActive,
      required this.onTap})
      : super(key: key);

  Duration get kAnimationDuration => const Duration(milliseconds: 400);
  double get kLabelSpacerHeight => 3.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      pressedOpacity: 0.9,
      onPressed: onTap,
      child: AnimatedOpacity(
        duration: kAnimationDuration,
        opacity: isActive ? 1 : 0.6,
        child: AnimatedSwitcher(
            duration: kAnimationDuration,
            child: isActive
                ? Column(
                    children: [
                      activeIcon,
                      SizedBox(height: kLabelSpacerHeight),
                      MyText(
                        label,
                        size: FONTSIZE.one,
                      )
                    ],
                  )
                : Column(
                    children: [
                      inactiveIcon,
                      SizedBox(height: kLabelSpacerHeight),
                      MyText(label, size: FONTSIZE.one)
                    ],
                  )),
      ),
    );
  }
}
