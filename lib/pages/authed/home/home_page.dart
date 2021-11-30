import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/schedule/coming_up_list.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/home/components/category_link_tile.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/stream.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildNavBarButton(IconData iconData, VoidCallback onPressed) =>
      CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          onPressed: onPressed,
          child: Icon(iconData));

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: FABPage(
          buttons: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: FABPageButtonContainer(
                  padding: EdgeInsets.all(14), child: ChatsIconButton()),
            ),
            FloatingButton(
                onTap: () => context.navigateTo(const TimersRoute()),
                icon: CupertinoIcons.timer),
            FloatingButton(
                onTap: () => context.navigateTo(YourScheduleRoute()),
                icon: CupertinoIcons.calendar),
          ],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ComingUpList(),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 8,
                      bottom: EnvironmentConfig.bottomNavBarHeight + 12),
                  shrinkWrap: true,
                  children: [
                    CategoryLinkTile(
                      label: 'Workouts',
                      assetImagePath: 'workouts.svg',
                      onTap: () =>
                          context.navigateTo(const YourWorkoutsRoute()),
                    ),
                    CategoryLinkTile(
                      label: 'Plans',
                      assetImagePath: 'plans.svg',
                      onTap: () => context.navigateTo(const YourPlansRoute()),
                    ),
                    CategoryLinkTile(
                      label: 'Clubs',
                      assetImagePath: 'clubs.svg',
                      onTap: () => context.navigateTo(const YourClubsRoute()),
                    ),
                    CategoryLinkTile(
                      label: 'Collections',
                      assetImagePath: 'collections.svg',
                      onTap: () =>
                          context.navigateTo(const YourCollectionsRoute()),
                    ),
                    CategoryLinkTile(
                      label: 'Throwdowns',
                      assetImagePath: 'challenges.svg',
                      onTap: () =>
                          context.showAlertDialog(title: 'Coming Soon!'),
                    ),
                    CategoryLinkTile(
                      label: 'Events',
                      assetImagePath: 'events.svg',
                      onTap: () =>
                          context.showAlertDialog(title: 'Coming Soon!'),
                    ),
                    CategoryLinkTile(
                      label: 'Gym Profiles',
                      assetImagePath: 'gym_profiles.svg',
                      onTap: () =>
                          context.navigateTo(const YourGymProfilesRoute()),
                    ),
                    CategoryLinkTile(
                      label: 'Move Library',
                      assetImagePath: 'moves_library.svg',
                      onTap: () =>
                          context.navigateTo(const YourMovesLibraryRoute()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
