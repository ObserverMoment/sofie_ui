import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_created_workout_plans.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_enroled_workout_plans.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_saved_workout_plans.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_workout_plans_text_search.dart';
import 'package:sofie_ui/router.gr.dart';

class YourPlansPage extends StatefulWidget {
  const YourPlansPage({Key? key}) : super(key: key);

  @override
  _YourPlansPageState createState() => _YourPlansPageState();
}

class _YourPlansPageState extends State<YourPlansPage> {
  /// 0 = CreatedPlans, 1 = Participating in plans, 2 = saved to collections
  int _activeTabIndex = 0;

  void _updatePageIndex(int index) {
    setState(() => _activeTabIndex = index);
  }

  void _openWorkoutPlanEnrolmentDetails(String id) {
    context.navigateTo(WorkoutPlanEnrolmentDetailsRoute(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          middle: const NavBarTitle('Your Plans'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () =>
                    context.push(child: const YourPlansTextSearch()),
                child: const Icon(CupertinoIcons.search),
              ),
              const SizedBox(width: 8),
              CreateIconButton(
                  onPressed: () =>
                      context.navigateTo(WorkoutPlanCreatorRoute())),
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
                      1: MyText('Joined'),
                      2: MyText('Saved'),
                    }),
              ),
            ),
            Expanded(
                child: IndexedStack(
              index: _activeTabIndex,
              children: [
                const YourCreatedWorkoutPlans(),
                YourEnrolledWorkoutPlans(
                  selectEnrolment: (id) => _openWorkoutPlanEnrolmentDetails(id),
                ),
                const YourSavedPlans()
              ],
            ))
          ],
        ));
  }
}
