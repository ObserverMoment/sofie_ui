import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/pages/authed/progress/components/sub_section_link_tile.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/all_time_stats_summary.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/logged_sessions.dart';
import 'package:sofie_ui/pages/authed/progress/widgets/streak_summary.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query =
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
          QueryObserver<UserLoggedWorkouts$Query, json.JsonSerializable>(
              key: Key('ProgressPage - ${query.operationName}'),
              query: query,
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
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Flexible(
                    //       child: ProgressWidgetContainer(
                    //         child: AllTimeStatsSummaryWidget(
                    //           loggedWorkouts: loggedWorkouts,
                    //         ),
                    //       ),
                    //     ),
                    //     Flexible(
                    //       child: ProgressWidgetContainer(
                    //         child: StreaksSummaryWidget(
                    //           loggedWorkouts: loggedWorkouts,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    ProgressWidgetContainer(
                      child: LoggedSessionsWidget(
                        loggedWorkouts: loggedWorkouts,
                      ),
                    ),
                  ],
                );
              })
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
