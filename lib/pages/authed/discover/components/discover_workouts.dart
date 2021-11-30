import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class DiscoverWorkouts extends StatelessWidget {
  const DiscoverWorkouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyHeaderText('Spotlight: Workouts'),
              IconButton(
                  iconData: CupertinoIcons.compass,
                  onPressed: () =>
                      context.showAlertDialog(title: 'Coming Soon!'))
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: MyText('Coming soon...'),
        ),
      ],
    );
  }
}
