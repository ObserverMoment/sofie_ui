import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/modules/studio/components/workout_session_type_tile.dart';
import 'package:sofie_ui/router.gr.dart';

class WorkoutSessionTypeLinks extends StatelessWidget {
  const WorkoutSessionTypeLinks({Key? key}) : super(key: key);

  double get tileHeight => 110.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth = screenWidth / 2;

    return Card(
      backgroundColor: context.theme.cardBackground,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: MyHeaderText('Workouts'),
          ),
          const SizedBox(height: 8),
          GridView.count(
            padding: const EdgeInsets.all(2),
            crossAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: tileWidth / tileHeight,
            children: [
              WorkoutSessionTypeTile(
                  label: 'Resistance',
                  assetImagePath: 'resistance.svg',
                  tileHeight: tileHeight,
                  onTap: () => context.navigateTo(
                      ResistanceSessionsRoute(previousPageTitle: 'Studio'))),
              WorkoutSessionTypeTile(
                label: 'Cardio',
                tileHeight: tileHeight,
                assetImagePath: 'cardio.svg',
                onTap: () {},
              ),
              WorkoutSessionTypeTile(
                  label: 'Intervals',
                  tileHeight: tileHeight,
                  assetImagePath: 'intervals.svg',
                  onTap: () {}),
              WorkoutSessionTypeTile(
                label: 'AMRAP',
                tileHeight: tileHeight,
                assetImagePath: 'stopwatch.svg',
                onTap: () {},
              ),
              WorkoutSessionTypeTile(
                label: 'For Time',
                tileHeight: tileHeight,
                assetImagePath: 'stopwatch.svg',
                onTap: () {},
              ),
              WorkoutSessionTypeTile(
                label: 'Mobility',
                tileHeight: tileHeight,
                assetImagePath: 'stability.svg',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
