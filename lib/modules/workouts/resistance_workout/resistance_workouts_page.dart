import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_tab_bar_view.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/clubs_resistance_workouts.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/your_resistance_workouts.dart';

class ResistanceWorkoutsPage extends StatelessWidget {
  final String? previousPageTitle;
  const ResistanceWorkoutsPage({Key? key, this.previousPageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          previousPageTitle: previousPageTitle,
          middle: const NavBarTitle('Resistance'),
        ),
        child: MyTabBarView(
          leading: ContentBox(
            padding: const EdgeInsets.all(4),
            child: IconButton(
                iconData: CupertinoIcons.slider_horizontal_3, onPressed: () {}),
          ),
          tabs: const ['Your Studio', 'Your Circles'],
          pages: const [YourResistanceWorkouts(), ClubsResistanceWorkouts()],
        ));
  }
}
