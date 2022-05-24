import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/creators/user_day_logs/user_day_log_mood_creator_page.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/profile/edit_profile_page.dart';
import 'package:sofie_ui/pages/authed/progress/active_widgets_selector.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/eat_well_logs_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/logged_meditations_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/logged_moods_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/logged_sessions_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/sleep_well_logs_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page_components/sub_section_link_tile.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page_components/widget_header.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widget_containers/eat_well_logs_container.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widget_containers/logged_meditations_container.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widget_containers/logged_moods_container.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widget_containers/logged_sessions_container.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widget_containers/sleep_well_logs_container.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widgets/all_time_stats_summary.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widgets/eat_well_logs.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widgets/logged_meditations.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widgets/logged_moods.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widgets/logged_sessions.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widgets/sleep_well_logs.dart';
import 'package:sofie_ui/pages/authed/progress/progress_widgets/streak_summary.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

const kWidgetIdToIconMap = {
  '001': CupertinoIcons.chart_bar,
  '002': CupertinoIcons.flame,
  '003': MyCustomIcons.dumbbell,
  '004': CupertinoIcons.smiley,
  '005': MyCustomIcons.mindfulnessIcon,
  '006': material.Icons.restaurant,
  '007': CupertinoIcons.bed_double,
};

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  double get _widgetHeight => 220.0;
  Widget get _widgetLoadingShimmer => const Center(
          child: CupertinoActivityIndicator(
        radius: 16,
      ));
  Widget get _fullScreenLoadingShimmer => const ShimmerCardList(
        cardHeight: 300,
        itemCount: 6,
      );

  /// 'Move up' means reducing the index of the widget ID by 1.
  /// i.e Move physically up the screen.
  Future<void> _moveWidgetUp(
      {required BuildContext context,
      required List<String> activeProgressWidgets,
      required String widgetId}) async {
    final currentPosition = activeProgressWidgets.indexOf(widgetId);
    if (currentPosition > 0) {
      activeProgressWidgets.removeAt(currentPosition);
      activeProgressWidgets.insert(currentPosition - 1, widgetId);

      final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

      await EditProfilePage.updateUserFields(context, authedUserId,
          {'activeProgressWidgets': activeProgressWidgets});
    }
  }

  /// 'Move down' means increasing the index of the widget ID by 1.
  /// i.e Move physically down the screen.
  Future<void> _moveWidgetDown(
      {required BuildContext context,
      required List<String> activeProgressWidgets,
      required String widgetId}) async {
    final currentPosition = activeProgressWidgets.indexOf(widgetId);
    if (currentPosition < CoreDataRepo.progressWidgets.length - 1) {
      activeProgressWidgets.removeAt(currentPosition);
      activeProgressWidgets.insert(currentPosition + 1, widgetId);

      final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

      await EditProfilePage.updateUserFields(context, authedUserId,
          {'activeProgressWidgets': activeProgressWidgets});
    }
  }

  Widget _buildWidget(
      {required BuildContext context,
      required UserProfile userProfile,
      required String widgetId,
      required int index}) {
    final activeProgressWidgets = userProfile.activeProgressWidgets ?? [];

    /// When index less than [totalActiveWidgets - 1], show [_moveWidgetDown] option in bottom sheet menu.
    final totalActiveWidgets = activeProgressWidgets.length;
    final showMoveWidgetUp = index > 0;
    final showMoveWidgetDown = index < totalActiveWidgets - 1;

    final moveWidgetUp = showMoveWidgetUp
        ? () => _moveWidgetUp(
            context: context,
            activeProgressWidgets: activeProgressWidgets,
            widgetId: widgetId)
        : null;

    final moveWidgetDown = showMoveWidgetDown
        ? () => _moveWidgetDown(
            context: context,
            activeProgressWidgets: activeProgressWidgets,
            widgetId: widgetId)
        : null;

    Future<void> deactivateWidget() async {
      if (activeProgressWidgets.contains(widgetId)) {
        final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

        activeProgressWidgets.remove(widgetId);

        await EditProfilePage.updateUserFields(context, authedUserId,
            {'activeProgressWidgets': activeProgressWidgets});
      }
    }

    switch (widgetId) {
      case '001':
        return LoggedSessionsContainer(
          loadingShimmer: _widgetLoadingShimmer,
          builder: (logs) => ProgressWidgetContainer(
            index: index,
            headerIcon: kWidgetIdToIconMap['001']!,
            title: 'Summary',
            widgetHeight: _widgetHeight,
            widget: AllTimeStatsSummaryWidget(
              loggedWorkouts: logs,
            ),
            moveWidgetUp: moveWidgetUp,
            moveWidgetDown: moveWidgetDown,
            deactivateWidget: deactivateWidget,
          ),
        );
      case '002':
        return LoggedSessionsContainer(
          loadingShimmer: _widgetLoadingShimmer,
          builder: (logs) => ProgressWidgetContainer(
            index: index,
            headerIcon: kWidgetIdToIconMap['002']!,
            title: 'Streaks',
            widgetHeight: _widgetHeight,
            widget: StreaksSummaryWidget(
              loggedWorkouts: logs,
              userProfile: userProfile,
            ),
            moveWidgetUp: moveWidgetUp,
            moveWidgetDown: moveWidgetDown,
            deactivateWidget: deactivateWidget,
          ),
        );
      case '003':
        return ProgressWidgetContainerWithFullScreen(
          index: index,
          fullScreen: LoggedSessionsContainer(
            loadingShimmer: _fullScreenLoadingShimmer,
            builder: (logs) => LoggedSessionsFullScreen(
              widgetId: widgetId,
              loggedWorkouts: logs,
            ),
          ),
          headerIcon: kWidgetIdToIconMap['003']!,
          title: 'Sessions Logged',
          widget: LoggedSessionsContainer(
            loadingShimmer: _widgetLoadingShimmer,
            builder: (logs) => LoggedSessionsWidget(
              loggedWorkouts: logs,
            ),
          ),
          widgetHeight: _widgetHeight,
          moveWidgetUp: moveWidgetUp,
          moveWidgetDown: moveWidgetDown,
          deactivateWidget: deactivateWidget,
        );
      case '004':
        return ProgressWidgetContainerWithFullScreen(
          index: index,
          fullScreen: LoggedMoodsContainer(
            loadingShimmer: _fullScreenLoadingShimmer,
            builder: (userDayLogMoods) => LoggedMoodsFullScreen(
              widgetId: widgetId,
              loggedMoods: userDayLogMoods,
            ),
          ),
          headerIcon: kWidgetIdToIconMap['004']!,
          title: 'Moods',
          widgetHeight: _widgetHeight,
          widget: LoggedMoodsContainer(
            loadingShimmer: _widgetLoadingShimmer,
            builder: (userDayLogMoods) => LoggedMoodsWidget(
              loggedMoods: userDayLogMoods,
            ),
          ),
          moveWidgetUp: moveWidgetUp,
          moveWidgetDown: moveWidgetDown,
          deactivateWidget: deactivateWidget,
          actions: [
            WidgetHeaderAction(
                icon: CupertinoIcons.plus,
                onPressed: () => context.push(
                    fullscreenDialog: true,
                    child: const UserDayLogMoodCreatorPage())),
          ],
        );
      case '005':
        return ProgressWidgetContainerWithFullScreen(
          index: index,
          fullScreen: LoggedMeditationsContainer(
            loadingShimmer: _fullScreenLoadingShimmer,
            builder: (userMeditationLogs) => LoggedMeditationsFullScreen(
              widgetId: widgetId,
              userMeditationLogs: userMeditationLogs,
            ),
          ),
          headerIcon: kWidgetIdToIconMap['005']!,
          title: 'Mindfulness',
          widgetHeight: _widgetHeight,
          widget: LoggedMeditationsContainer(
            loadingShimmer: _widgetLoadingShimmer,
            builder: (userMeditationLogs) => LoggedMeditationsWidget(
              userMeditationLogs: userMeditationLogs,
            ),
          ),
          moveWidgetUp: moveWidgetUp,
          moveWidgetDown: moveWidgetDown,
          deactivateWidget: deactivateWidget,
        );
      case '006':
        return ProgressWidgetContainerWithFullScreen(
          index: index,
          fullScreen: EatWellLogsContainer(
            loadingShimmer: _fullScreenLoadingShimmer,
            builder: (userEatWellLogs) => EatWellLogsFullScreen(
              widgetId: widgetId,
              userEatWellLogs: userEatWellLogs,
            ),
          ),
          headerIcon: kWidgetIdToIconMap['006']!,
          title: 'Food Health',
          widgetHeight: _widgetHeight,
          widget: EatWellLogsContainer(
            loadingShimmer: _widgetLoadingShimmer,
            builder: (userEatWellLogs) => EatWellLogWidget(
              userEatWellLogs: userEatWellLogs,
            ),
          ),
          moveWidgetUp: moveWidgetUp,
          moveWidgetDown: moveWidgetDown,
          deactivateWidget: deactivateWidget,
        );
      case '007':
        return ProgressWidgetContainerWithFullScreen(
          index: index,
          fullScreen: SleepWellLogsContainer(
            loadingShimmer: _fullScreenLoadingShimmer,
            builder: (userSleepWellLogs) => SleepWellLogsFullScreen(
              widgetId: widgetId,
              userSleepWellLogs: userSleepWellLogs,
            ),
          ),
          headerIcon: kWidgetIdToIconMap['007']!,
          title: 'Sleep Health',
          widgetHeight: _widgetHeight,
          widget: SleepWellLogsContainer(
            loadingShimmer: _widgetLoadingShimmer,
            builder: (userSleepWellLogs) => SleepWellLogWidget(
              userSleepWellLogs: userSleepWellLogs,
            ),
          ),
          moveWidgetUp: moveWidgetUp,
          moveWidgetDown: moveWidgetDown,
          deactivateWidget: deactivateWidget,
        );

      default:
        throw Exception(
            'ProgressPage._buildWidget: No builder provided for $widgetId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    /// Required for user settings such as target session per week number.
    final userProfileQuery =
        UserProfileQuery(variables: UserProfileArguments(userId: authedUserId));

    return QueryObserver<UserProfile$Query, UserProfileArguments>(
        key: Key('ProgressPage - ${userProfileQuery.operationName}'),
        query: userProfileQuery,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        parameterizeQuery: true,
        builder: (userData) {
          if (userData.userProfile == null) {
            return const ObjectNotFoundIndicator();
          }

          final userProfile = userData.userProfile!;
          final activeWidgets = userProfile.activeProgressWidgets ?? [];
          final showAddWidgetButton =
              activeWidgets.length < CoreDataRepo.progressWidgets.length;

          return MyPageScaffold(
              child: SafeArea(
                  child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                child: GridView.count(
                  crossAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  childAspectRatio: 0.75,
                  children: [
                    SubSectionLinkTile(
                      label: 'Personal Scorebook',
                      assetImagePath: 'logs.svg',
                      onTap: () =>
                          context.navigateTo(const PersonalScoresRoute()),
                    ),
                    SubSectionLinkTile(
                      label: 'Goal Tracking',
                      assetImagePath: 'goal_target.svg',
                      onTap: () => context.navigateTo(const UserGoalsRoute()),
                    ),
                    SubSectionLinkTile(
                      label: 'Body Tracking',
                      assetImagePath: 'filter_body_icon.svg',
                      onTap: () =>
                          context.navigateTo(const BodyTrackingRoute()),
                    ),
                    SubSectionLinkTile(
                      label: 'Logs & Analysis',
                      assetImagePath: 'logs_analysis.svg',
                      onTap: () =>
                          context.navigateTo(LoggedWorkoutsAnalysisRoute()),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    key: const Key('progress-widgets-list'),
                    cacheExtent: 3000,
                    itemExtent: _widgetHeight,
                    itemCount: showAddWidgetButton
                        ? activeWidgets.length + 1
                        : activeWidgets.length,
                    itemBuilder: (c, i) {
                      if (showAddWidgetButton && i == activeWidgets.length) {
                        return FadeInUp(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 48.0),
                              child: SecondaryButton(
                                  prefixIconData: CupertinoIcons.plus,
                                  text: 'Add Widget',
                                  onPressed: () => context.push(
                                      fullscreenDialog: true,
                                      child: const ActiveWidgetsSelector())),
                            ),
                          ),
                        );
                      } else {
                        return SizeFadeIn(
                          key: Key(activeWidgets[i]),
                          child: _buildWidget(
                              context: context,
                              userProfile: userProfile,
                              widgetId: activeWidgets[i],
                              index: i),
                        );
                      }
                    }),
              ),
            ],
          )));
        });
  }
}

class ProgressWidgetContainer extends StatelessWidget {
  final String title;
  final IconData headerIcon;
  final Widget widget;
  final double widgetHeight;
  final int index;
  final VoidCallback deactivateWidget;
  final VoidCallback? moveWidgetUp;
  final VoidCallback? moveWidgetDown;
  const ProgressWidgetContainer(
      {Key? key,
      required this.widget,
      required this.widgetHeight,
      required this.title,
      required this.headerIcon,
      required this.index,
      required this.moveWidgetUp,
      required this.moveWidgetDown,
      required this.deactivateWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetHeight,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
      child: Card(
          padding:
              const EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 4),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              WidgetHeader(
                icon: headerIcon,
                title: title,
                actions: [
                  WidgetHeaderAction(
                      icon: CupertinoIcons.settings,
                      onPressed: () => openBottomSheetMenu(
                          context: context,
                          child: BottomSheetMenu(
                              header: BottomSheetMenuHeader(
                                name: title,
                              ),
                              items: [
                                if (moveWidgetUp != null)
                                  BottomSheetMenuItem(
                                      onPressed: moveWidgetUp!,
                                      text: 'Move Up',
                                      icon: CupertinoIcons.up_arrow),
                                if (moveWidgetDown != null)
                                  BottomSheetMenuItem(
                                      onPressed: moveWidgetDown!,
                                      text: 'Move Down',
                                      icon: CupertinoIcons.down_arrow),
                                BottomSheetMenuItem(
                                    onPressed: deactivateWidget,
                                    text: 'Deactivate Widget',
                                    icon: CupertinoIcons.clear_thick),
                              ])))
                ],
              ),
              widget,
            ],
          )),
    );
  }
}

class ProgressWidgetContainerWithFullScreen extends StatelessWidget {
  final String title;
  final IconData headerIcon;

  /// Excluding the full screen action
  final List<WidgetHeaderAction> actions;
  final Widget widget;
  final double widgetHeight;
  final Widget fullScreen;
  final int index;
  final VoidCallback deactivateWidget;
  final VoidCallback? moveWidgetUp;
  final VoidCallback? moveWidgetDown;
  const ProgressWidgetContainerWithFullScreen(
      {Key? key,
      required this.widget,
      required this.title,
      required this.headerIcon,
      this.actions = const <WidgetHeaderAction>[],
      required this.fullScreen,
      required this.widgetHeight,
      required this.index,
      required this.deactivateWidget,
      required this.moveWidgetUp,
      required this.moveWidgetDown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return fullScreen;
      },
      tappable: false,
      openColor: context.theme.background,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      closedElevation: 0,
      closedColor: context.theme.background,
      closedBuilder: (context, openContainer) {
        return Container(
          height: widgetHeight,
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
          child: Card(
              padding:
                  const EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 4),
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  WidgetHeader(
                    icon: headerIcon,
                    title: title,
                    actions: [
                      ...actions,
                      WidgetHeaderAction(
                          icon: CupertinoIcons.rectangle_expand_vertical,
                          onPressed: openContainer),
                      WidgetHeaderAction(
                          icon: CupertinoIcons.settings,
                          onPressed: () => openBottomSheetMenu(
                              context: context,
                              child: BottomSheetMenu(
                                  header: BottomSheetMenuHeader(
                                    name: title,
                                  ),
                                  items: [
                                    if (moveWidgetUp != null)
                                      BottomSheetMenuItem(
                                          onPressed: moveWidgetUp!,
                                          text: 'Move Up',
                                          icon: CupertinoIcons.up_arrow),
                                    if (moveWidgetDown != null)
                                      BottomSheetMenuItem(
                                          onPressed: moveWidgetDown!,
                                          text: 'Move Down',
                                          icon: CupertinoIcons.down_arrow),
                                    BottomSheetMenuItem(
                                        onPressed: deactivateWidget,
                                        text: 'Deactivate Widget',
                                        icon: CupertinoIcons.clear_thick),
                                  ])))
                    ],
                  ),
                  const SizedBox(height: 8),
                  widget,
                ],
              )),
        );
      },
    );
  }
}
