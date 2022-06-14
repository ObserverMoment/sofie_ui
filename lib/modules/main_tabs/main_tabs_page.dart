import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/workout_type_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';

/// Scaffold for the main top level tabs view.
class MainTabsPage extends StatelessWidget {
  const MainTabsPage({Key? key}) : super(key: key);

  void _openWorkoutTypeSelector(BuildContext context) {
    openBottomSheetMenu(
        context: context,
        child: BottomSheetMenu(
            header: const BottomSheetMenuHeader(name: 'Select Type'),
            items: [
              BottomSheetMenuItem(
                  text: 'Cardio', icon: WorkoutType.cardio, onPressed: () {}),
              BottomSheetMenuItem(
                  text: 'Resistance',
                  icon: WorkoutType.resistance,
                  onPressed: () =>
                      context.navigateTo(ResistanceWorkoutCreatorRoute())),
              BottomSheetMenuItem(
                  text: 'Intervals',
                  icon: WorkoutType.intervals,
                  onPressed: () => {}),
              BottomSheetMenuItem(
                  text: 'Mobility',
                  icon: WorkoutType.stability,
                  onPressed: () => {}),
              BottomSheetMenuItem(
                  text: 'AMRAP',
                  icon: WorkoutType.stopwatch,
                  onPressed: () => {}),
              BottomSheetMenuItem(
                  text: 'For Time',
                  icon: WorkoutType.stopwatch,
                  onPressed: () => {}),
            ]));
  }

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
          HomeRoute(),
          CirclesRoute(),
          StudioStack(),
          ProgressRoute(),
        ],
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Styles.primaryAccent,
          foregroundColor: Styles.white,
          child: const Icon(CupertinoIcons.quote_bubble),
          onPressed: () => Utils.openUserFeedbackPage(context),
        ),
        bottomNavigationBuilder: (context, tabsRouter) => ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.cardBackground.withOpacity(0.6),
                    ),
                    height: EnvironmentConfig.bottomNavBarHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTabItem(
                            tabsRouter: tabsRouter,
                            activeIndex: tabsRouter.activeIndex,
                            tabIndex: 0,
                            label: 'Home',
                            inactiveIconData: CupertinoIcons.home,
                            activeIconData: CupertinoIcons.home),
                        _buildTabItem(
                            tabsRouter: tabsRouter,
                            activeIndex: tabsRouter.activeIndex,
                            tabIndex: 1,
                            label: 'Circles',
                            inactiveIconData: CupertinoIcons.circle,
                            activeIconData: CupertinoIcons.circle_fill),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          pressedOpacity: 0.9,
                          onPressed: () {
                            openBottomSheetMenu(
                                context: context,
                                child: BottomSheetMenu(
                                    header: const BottomSheetMenuHeader(
                                        name: 'What do you want to do?'),
                                    items: [
                                      BottomSheetMenuItem(
                                          icon: CupertinoIcons
                                              .text_badge_checkmark,
                                          text: 'Log a Workout',
                                          onPressed: () {}),
                                      BottomSheetMenuItem(
                                          icon: MyCustomIcons.dumbbell,
                                          text: 'Create a new Workout',
                                          onPressed: () =>
                                              _openWorkoutTypeSelector(
                                                  context)),
                                      BottomSheetMenuItem(
                                          icon: MyCustomIcons.plansIcon,
                                          text: 'Create a new Plan',
                                          onPressed: () {}),
                                      BottomSheetMenuItem(
                                          icon: CupertinoIcons.circle,
                                          text: 'Create a new Circle',
                                          onPressed: () {}),
                                    ]));
                          },
                          child: Icon(
                            CupertinoIcons.plus_circled,
                            size: 38,
                            color: context.theme.primary.withOpacity(0.85),
                          ),
                        ),
                        _buildTabItem(
                            tabsRouter: tabsRouter,
                            activeIndex: tabsRouter.activeIndex,
                            tabIndex: 2,
                            label: 'Studio',
                            inactiveIconData:
                                CupertinoIcons.square_stack_3d_down_right,
                            activeIconData:
                                CupertinoIcons.square_stack_3d_down_right_fill),
                        _buildTabItem(
                            tabsRouter: tabsRouter,
                            activeIndex: tabsRouter.activeIndex,
                            tabIndex: 3,
                            label: 'Progress',
                            inactiveIconData: Icons.stacked_line_chart_outlined,
                            activeIconData: Icons.stacked_line_chart_rounded),
                        // const _FeedbackIcon()
                      ],
                    )),
              ),
            ),
        extendBody: true);
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
