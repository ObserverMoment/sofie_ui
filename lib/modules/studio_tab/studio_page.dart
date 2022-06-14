import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/modules/main_tabs/main_nav_bar_builder.dart';
import 'package:sofie_ui/modules/main_tabs/profile_settings_drawer.dart';
import 'package:sofie_ui/modules/studio_tab/components/category_link_tile.dart';
import 'package:sofie_ui/modules/studio_tab/components/workout_type_links.dart';
import 'package:sofie_ui/router.gr.dart';

class StudioPage extends StatefulWidget {
  const StudioPage({Key? key}) : super(key: key);

  @override
  State<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  final GlobalKey<material.ScaffoldState> _key = GlobalKey();

  double get tileHeight => 90.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth = screenWidth / 2;

    return material.Scaffold(
      key: _key,
      appBar: buildMainNavBar(_key),
      endDrawer: const ProfileSettingsDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: WorkoutTypeLinks(),
          ),
          GridView.count(
            padding: const EdgeInsets.all(8),
            crossAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: tileWidth / tileHeight,
            children: [
              CategoryLinkTile(
                label: 'Training Plans',
                assetImagePath: 'journal.svg',
                tileHeight: tileHeight,
                onTap: () => context.navigateTo(TrainingPlansRoute(
                    showCreateButton: true, showDiscoverButton: true)),
              ),
              CategoryLinkTile(
                label: 'Events and Comps',
                assetImagePath: 'events.svg',
                tileHeight: tileHeight,
                onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
              ),
              CategoryLinkTile(
                label: 'Exercise Library',
                assetImagePath: 'library.svg',
                tileHeight: tileHeight,
                onTap: () => context.navigateTo(
                    ExerciseLibraryRoute(previousPageTitle: 'Studio')),
              ),
              CategoryLinkTile(
                  label: 'Gym Profiles',
                  assetImagePath: 'gym_profiles.svg',
                  tileHeight: tileHeight,
                  onTap: () => context.navigateTo(
                      GymProfilesRoute(previousPageTitle: 'Studio'))),
            ],
          ),
        ],
      ),
    );
  }
}
