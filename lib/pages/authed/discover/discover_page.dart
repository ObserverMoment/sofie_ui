import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/discover/components/discover_champions.dart';
import 'package:sofie_ui/pages/authed/discover/components/discover_clubs.dart';
import 'package:sofie_ui/pages/authed/discover/components/discover_creators.dart';
import 'package:sofie_ui/pages/authed/discover/components/discover_live.dart';
import 'package:sofie_ui/pages/authed/discover/components/discover_plans.dart';
import 'package:sofie_ui/pages/authed/discover/components/discover_throwdowns.dart';
import 'package:sofie_ui/pages/authed/discover/components/discover_workouts.dart';
import 'package:sofie_ui/router.gr.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  Widget _verticalPadding({required Widget child}) =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: child);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DiscoverPageButton(
                  text: 'Workouts',
                  onPressed: () =>
                      context.navigateTo(PublicWorkoutFinderRoute())),
              DiscoverPageButton(
                  text: 'Plans',
                  onPressed: () =>
                      context.navigateTo(PublicWorkoutPlanFinderRoute())),
              DiscoverPageButton(
                  text: 'Throwdowns',
                  onPressed: () =>
                      context.showAlertDialog(title: 'Coming Soon!')),
            ],
          ),
          _verticalPadding(
            child: const DiscoverCreators(),
          ),
          _verticalPadding(child: const DiscoverClubs()),
          _verticalPadding(child: const DiscoverWorkouts()),
          _verticalPadding(child: const DiscoverWorkoutPlans()),
          _verticalPadding(child: const DiscoverThrowdowns()),
          _verticalPadding(child: const DiscoverLive()),
          _verticalPadding(child: const DiscoverChampions()),
        ],
      ),
    );
  }
}

class DiscoverPageButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const DiscoverPageButton(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.theme.cardBackground,
        borderRadius: BorderRadius.circular(60),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        onPressed: onPressed,
        child: MyHeaderText(
          text,
          size: FONTSIZE.two,
        ),
      ),
    );
  }
}
