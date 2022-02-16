import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/skill_creator/skills_manager.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/discover/components/discover_clubs.dart';
import 'package:sofie_ui/pages/authed/discover/components/discover_creators.dart';
import 'package:sofie_ui/router.gr.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  Widget _verticalPadding({required Widget child}) =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: child);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),
                  child: ContentBox(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: PageLink(
                        linkText: 'Workouts',
                        icon: MyCustomIcons.dumbbell,
                        bold: true,
                        separator: false,
                        onPress: () =>
                            context.navigateTo(PublicWorkoutFinderRoute())),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),
                  child: ContentBox(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: PageLink(
                        linkText: 'Plans',
                        icon: MyCustomIcons.plansIcon,
                        bold: true,
                        separator: false,
                        onPress: () =>
                            context.navigateTo(PublicWorkoutPlanFinderRoute())),
                  ),
                ),
              ),
            ],
          ),
          // GridView.count(
          //   padding: const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),
          //   crossAxisSpacing: 8,
          //   physics: const NeverScrollableScrollPhysics(),
          //   mainAxisSpacing: 8,
          //   shrinkWrap: true,
          //   crossAxisCount: 2,
          //   children: [

          // DiscoverPageButton(
          //     text: 'Workouts',
          //     onPressed: () =>
          //         context.navigateTo(PublicWorkoutFinderRoute())),
          // DiscoverPageButton(
          //     text: 'Plans',
          //     onPressed: () =>
          //         context.navigateTo(PublicWorkoutPlanFinderRoute())),
          // DiscoverPageButton(
          //     text: 'Throwdowns',
          //     onPressed: () =>
          //         context.showAlertDialog(title: 'Coming Soon!')),
          // DiscoverPageButton(
          //     text: 'Coaching',
          //     onPressed: () =>
          //         context.showAlertDialog(title: 'Coming Soon!')),
          // DiscoverPageButton(
          //     text: 'Gear',
          //     onPressed: () =>
          //         context.showAlertDialog(title: 'Coming Soon!')),
          // ],
          // ),
          // const SizedBox(height: 6),
          _verticalPadding(child: const DiscoverCreators()),
          _verticalPadding(child: const DiscoverClubs()),
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
      padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: context.theme.cardBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        onPressed: onPressed,
        child: MyHeaderText(
          text,
          size: FONTSIZE.two,
        ),
      ),
    );
  }
}
