import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/pages/authed/home/components/category_link_tile.dart';
import 'package:sofie_ui/pages/authed/progress/components/streak_and_stats_summary.dart';
import 'package:sofie_ui/router.gr.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      child: ListView(
        children: [
          const StreakAndStatsSummary(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2),
            child: GridView.count(
              crossAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                CategoryLinkTile(
                  label: 'Personal Best Lifts & Times',
                  assetImagePath: 'personal_bests.svg',
                  onTap: () => context.navigateTo(const PersonalBestsRoute()),
                ),
                CategoryLinkTile(
                  label: 'Journal and Goals',
                  assetImagePath: 'journal.svg',
                  onTap: () => context.navigateTo(const JournalRoute()),
                ),
                CategoryLinkTile(
                  label: 'Body Tracking',
                  assetImagePath: 'body_transform.svg',
                  onTap: () => context.navigateTo(const BodyTrackingRoute()),
                ),
                CategoryLinkTile(
                  label: 'Workout Logs & History',
                  assetImagePath: 'logs.svg',
                  onTap: () => context.navigateTo(const LoggedWorkoutsRoute()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
