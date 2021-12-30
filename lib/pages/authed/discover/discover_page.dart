import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
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
      child: SafeArea(
        child: Column(
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
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  _verticalPadding(child: const DiscoverCreators()),
                  _verticalPadding(child: const DiscoverClubs()),
                ],
              ),
            )
          ],
        ),
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
        border: Border.all(color: context.theme.primary, width: 2),
        borderRadius: BorderRadius.circular(60),
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
