import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/home/your_workouts/your_created_workouts.dart';
import 'package:sofie_ui/pages/authed/home/your_workouts/your_saved_workouts.dart';
import 'package:sofie_ui/pages/authed/home/your_workouts/your_workouts_text_search.dart';
import 'package:sofie_ui/router.gr.dart';

class YourWorkoutsPage extends StatefulWidget {
  const YourWorkoutsPage({Key? key}) : super(key: key);

  @override
  _YourWorkoutsPageState createState() => _YourWorkoutsPageState();
}

class _YourWorkoutsPageState extends State<YourWorkoutsPage> {
  /// 0 = Created Workouts, 1 = Saved Workouts - via collections
  int _activeTabIndex = 0;

  void _updatePageIndex(int index) {
    setState(() => _activeTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          middle: const NavBarTitle('Your Workouts'),
          trailing: NavBarTrailingRow(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () =>
                    context.push(child: const YourWorkoutsTextSearch()),
                child: const Icon(CupertinoIcons.search),
              ),
              const SizedBox(width: 8),
              CreateIconButton(
                onPressed: () => context.navigateTo(WorkoutCreatorRoute()),
              ),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: SizedBox(
                width: double.infinity,
                child: SlidingSelect<int>(
                    value: _activeTabIndex,
                    updateValue: _updatePageIndex,
                    children: const {
                      0: MyText('Created'),
                      1: MyText('Saved'),
                    }),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _activeTabIndex,
                children: const [YourCreatedWorkouts(), YourSavedWorkouts()],
              ),
            )
          ],
        ));
  }
}
