import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: const LeadingNavBarTitle(
          'My Studio',
        ),
        trailing: NavBarTrailingRow(children: [
          const ChatsIconButton(),
          _buildNavBarButton(CupertinoIcons.timer,
              () => context.navigateTo(const TimersRoute())),
          _buildNavBarButton(
            CupertinoIcons.calendar,
            () => context.navigateTo(YourScheduleRoute()),
          ),
        ]),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 140,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ComingUpList(),
                ),
              ),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                padding: EdgeInsets.only(
                    top: 8, bottom: EnvironmentConfig.bottomNavBarHeight + 12),
                shrinkWrap: true,
                children: [
                  CategoryLinkTile(
                    label: 'Workouts',
                    assetImagePath: 'workouts.svg',
                    onTap: () => context.navigateTo(const YourWorkoutsRoute()),
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
                  CategoryLinkTile(
                    label: 'Awards',
                    assetImagePath: 'events.svg',
                    onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
                  ),
                  CategoryLinkTile(
                    label: 'Throwdowns',
                    assetImagePath: 'challenges.svg',
                    onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
