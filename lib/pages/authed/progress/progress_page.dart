import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/pages/authed/progress/components/sub_section_link_tile.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/all_time_stats_summary.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/logged_moods.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/logged_sessions.dart';
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
                          ProgressWidgetContainer(
                            child: LoggedSessionsWidget(
                              loggedWorkouts: loggedWorkouts,
                            ),
                          ),
                        ],
                      );
                    });
              }),
          const ProgressWidgetContainer(child: LoggedMoodsWidget()),
          Padding(
            padding: const EdgeInsets.all(24.0),
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
      padding: const EdgeInsets.all(4.0),
      child: Card(
          padding:
              const EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 8),
          borderRadius: BorderRadius.circular(20),
          child: child),
    );
  }
}
