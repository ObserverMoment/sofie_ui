import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/creators/user_day_logs/user_day_log_mood_creator_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/progress/components/sub_section_link_tile.dart';
import 'package:sofie_ui/pages/authed/progress/components/widget_header.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/eat_well_logs_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/logged_meditations_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/logged_moods_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/logged_sessions_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/full_screen_widgets/sleep_well_logs_full_screen.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/all_time_stats_summary.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/eat_well_logs.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/logged_meditations.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/logged_moods.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/logged_sessions.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/sleep_well_logs.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/streak_summary.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  Widget get _loadingWidget => const ShimmerCardList(
        itemCount: 6,
        cardHeight: 170,
      );

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    /// Required for user settings such as target session per week number.
    final userProfileQuery =
        UserProfileQuery(variables: UserProfileArguments(userId: authedUserId));
    final logDataQuery =
        UserLoggedWorkoutsQuery(variables: UserLoggedWorkoutsArguments());

    return MyPageScaffold(
      child: ListView(
        cacheExtent: 2000,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
            child: GridView.count(
              crossAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                SubSectionLinkTile(
                  label: 'Personal Bests',
                  assetImagePath: 'personal_bests.svg',
                  onTap: () => context.navigateTo(const PersonalBestsRoute()),
                ),
                SubSectionLinkTile(
                  label: 'Goal Tracking',
                  assetImagePath: 'journal.svg',
                  onTap: () => context.navigateTo(const UserGoalsRoute()),
                ),
                SubSectionLinkTile(
                  label: 'Body Tracking',
                  assetImagePath: 'body_transform.svg',
                  onTap: () => context.navigateTo(const BodyTrackingRoute()),
                ),
                SubSectionLinkTile(
                  label: 'Workout Logs',
                  assetImagePath: 'logs.svg',
                  onTap: () => context.navigateTo(LoggedWorkoutsRoute()),
                ),
              ],
            ),
          ),
          QueryObserver<UserProfile$Query, json.JsonSerializable>(
              key: Key('ProgressPage - ${userProfileQuery.operationName}'),
              query: userProfileQuery,
              loadingIndicator: _loadingWidget,
              fetchPolicy: QueryFetchPolicy.storeFirst,
              builder: (userData) {
                final userProfile = userData.userProfile;
                final activeWidgets = userProfile.activeProgressWidgets;

                return QueryObserver<UserLoggedWorkouts$Query,
                        json.JsonSerializable>(
                    key: Key('ProgressPage - ${logDataQuery.operationName}'),
                    query: logDataQuery,
                    loadingIndicator: _loadingWidget,
                    fetchPolicy: QueryFetchPolicy.storeFirst,
                    builder: (data) {
                      final loggedWorkouts = data.userLoggedWorkouts;

                      return Column(
                        children: [
                          ProgressWidgetContainer(
                            child: AllTimeStatsSummaryWidget(
                              loggedWorkouts: loggedWorkouts,
                            ),
                          ),
                          ProgressWidgetContainer(
                            child: StreaksSummaryWidget(
                              loggedWorkouts: loggedWorkouts,
                              userProfile: userProfile,
                            ),
                          ),
                          ProgressWidgetContainerWithFullScreen(
                            fullScreen: LoggedSessionsFullScreen(),
                            headerIcon: MyCustomIcons.dumbbell,
                            title: 'Sessions Logged',
                            widget: LoggedSessionsWidget(
                              loggedWorkouts: loggedWorkouts,
                            ),
                            widgetHeight: 320,
                            actions: [
                              WidgetHeaderAction(
                                  icon: CupertinoIcons.settings,
                                  onPressed: () => print('settings')),
                            ],
                          ),
                        ],
                      );
                    });
              }),

          /// TODO: Pull moods logs in here and pass data to both children.
          ProgressWidgetContainerWithFullScreen(
            fullScreen: LoggedMoodsFullScreen(),
            headerIcon: CupertinoIcons.smiley,
            title: 'Moods',
            widget: LoggedMoodsWidget(),
            actions: [
              WidgetHeaderAction(
                  icon: CupertinoIcons.plus,
                  onPressed: () => context.push(
                      fullscreenDialog: true,
                      child: const UserDayLogMoodCreatorPage())),
              WidgetHeaderAction(
                  icon: CupertinoIcons.settings,
                  onPressed: () => print('settings')),
            ],
          ),

          /// TODO: Pull meditation logs in here and pass data to both children.
          ProgressWidgetContainerWithFullScreen(
            fullScreen: LoggedMeditationsFullScreen(),
            headerIcon: MyCustomIcons.mindfulnessIcon,
            title: 'Mindfulness',
            widget: LoggedMeditationsWidget(),
            actions: [
              WidgetHeaderAction(
                  icon: CupertinoIcons.settings,
                  onPressed: () => print('settings')),
            ],
          ),

          /// TODO: Pull food logs in here and pass data to both children.
          ProgressWidgetContainerWithFullScreen(
            fullScreen: EatWellLogsFullScreen(),
            headerIcon: material.Icons.restaurant,
            title: 'Food Health',
            widget: EatWellLogWidget(),
            actions: [
              WidgetHeaderAction(
                  icon: CupertinoIcons.settings,
                  onPressed: () => print('settings')),
            ],
          ),

          /// TODO: Pull sleep logs in here and pass data to both children.
          ProgressWidgetContainerWithFullScreen(
            fullScreen: SleepWellLogsFullScreen(),
            headerIcon: CupertinoIcons.bed_double,
            title: 'Sleep Health',
            widget: SleepWellLogWidget(),
            actions: [
              WidgetHeaderAction(
                  icon: CupertinoIcons.settings,
                  onPressed: () => print('settings')),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 32),
            child: SecondaryButton(
                prefixIconData: CupertinoIcons.plus,
                text: 'Add Widget',
                onPressed: () => print('add widget menu')),
          )
        ],
      ),
    );
  }
}

class ProgressWidgetContainer extends StatelessWidget {
  final Widget child;
  const ProgressWidgetContainer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Card(
          padding:
              const EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 4),
          borderRadius: BorderRadius.circular(20),
          child: child),
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
  const ProgressWidgetContainerWithFullScreen(
      {Key? key,
      required this.widget,
      required this.title,
      required this.headerIcon,
      this.actions = const <WidgetHeaderAction>[],
      required this.fullScreen,
      this.widgetHeight = 260.0})
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
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
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
                          icon: CupertinoIcons.rectangle_expand_vertical,
                          onPressed: openContainer),
                      ...actions
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
