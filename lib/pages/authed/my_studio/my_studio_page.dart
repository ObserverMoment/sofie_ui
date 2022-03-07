import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/category_link_tile.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/recently_viewed_objects.dart';
import 'package:sofie_ui/router.gr.dart';

class MyStudioPage extends StatelessWidget {
  const MyStudioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            GridView.count(
              padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
              crossAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                CategoryLinkTile(
                  label: 'Calendar',
                  assetImagePath: 'calendar.svg',
                  onTap: () => context.navigateTo(YourScheduleRoute()),
                ),
                CategoryLinkTile(
                  label: 'Workouts',
                  assetImagePath: 'workouts.svg',
                  onTap: () => context.navigateTo(YourWorkoutsRoute(
                      showCreateButton: true, showDiscoverButton: true)),
                ),
                CategoryLinkTile(
                  label: 'Plans',
                  assetImagePath: 'journal.svg',
                  onTap: () => context.navigateTo(YourPlansRoute(
                      showCreateButton: true, showDiscoverButton: true)),
                ),
                CategoryLinkTile(
                  label: 'Clubs',
                  assetImagePath: 'clubs.svg',
                  onTap: () => context.navigateTo(const YourClubsRoute()),
                ),
                CategoryLinkTile(
                  label: 'Collections',
                  assetImagePath: 'collections.svg',
                  onTap: () => context.navigateTo(const YourCollectionsRoute()),
                ),
                CategoryLinkTile(
                  label: 'Throwdowns',
                  assetImagePath: 'challenges.svg',
                  onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
                ),
                CategoryLinkTile(
                  label: 'Events',
                  assetImagePath: 'events.svg',
                  onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
                ),
                CategoryLinkTile(
                  label: 'Move Library',
                  assetImagePath: 'library.svg',
                  onTap: () =>
                      context.navigateTo(const YourMovesLibraryRoute()),
                ),
                CategoryLinkTile(
                  label: 'Timers',
                  assetImagePath: 'timer.svg',
                  onTap: () => context.navigateTo(const TimersRoute()),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.theme.cardBackground.withOpacity(0.2)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/category_icons/recents.svg',
                        width: 20, color: context.theme.primary),
                    const SizedBox(width: 8),
                    const MyHeaderText('Recently Viewed'),
                  ],
                ),
              ),
            ),
            const RecentlyViewedObjects(),
          ],
        ),
      ),
    );
  }
}
