import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';

/// Scaffold for the main top level tabs view.
class MainTabsPage extends StatelessWidget {
  const MainTabsPage({Key? key}) : super(key: key);

  Widget _buildTabItem({
    required TabsRouter tabsRouter,
    required int tabIndex,
    required int activeIndex,
    required String label,
    required IconData inactiveIconData,
    required IconData activeIconData,
  }) {
    return _TabIcon(
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
        FeedRoute(),
        DiscoverRoute(),
        MyStudioRoute(),
        ProgressRoute(),
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
                      label: 'Feed',
                      inactiveIconData: CupertinoIcons.news,
                      activeIconData: CupertinoIcons.news_solid),
                  _buildTabItem(
                      tabsRouter: _tabsRouter,
                      activeIndex: _tabsRouter.activeIndex,
                      tabIndex: 1,
                      label: 'Discover',
                      inactiveIconData: CupertinoIcons.compass,
                      activeIconData: CupertinoIcons.compass_fill),
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
                  const _FeedbackIcon()
                ],
              )),
        ),
      ),
      extendBody: true,
    );
  }
}

class _TabIcon extends StatelessWidget {
  final Widget activeIcon;
  final Widget inactiveIcon;
  final String label;
  final bool isActive;
  final void Function() onTap;
  const _TabIcon(
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

class _FeedbackIcon extends StatelessWidget {
  const _FeedbackIcon({
    Key? key,
  }) : super(key: key);

  double get kLabelSpacerHeight => 3.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 11.0),
        pressedOpacity: 0.9,
        onPressed: () => Utils.openUserFeedbackPage(context),
        child: Column(
          children: [
            const Icon(
              CupertinoIcons.quote_bubble,
              size: 23,
              color: Styles.infoBlue,
            ),
            SizedBox(height: kLabelSpacerHeight),
            const MyText(
              'Feedback',
              size: FONTSIZE.one,
              color: Styles.infoBlue,
            )
          ],
        ));
  }
}
