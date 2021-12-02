import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_created_workout_plans.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_enroled_workout_plans.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_saved_workout_plans.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';

class YourPlansPage extends StatefulWidget {
  final void Function(WorkoutPlanSummary plan)? selectPlan;
  final bool showCreateButton;
  final bool showDiscoverButton;
  final String pageTitle;
  final bool showJoined;
  final bool showSaved;
  const YourPlansPage({
    Key? key,
    this.selectPlan,
    this.showCreateButton = false,
    this.showDiscoverButton = false,
    this.pageTitle = 'Plans',
    this.showJoined = true,
    this.showSaved = true,
  }) : super(key: key);

  @override
  _YourPlansPageState createState() => _YourPlansPageState();
}

class _YourPlansPageState extends State<YourPlansPage> {
  /// 0 = CreatedPlans, 1 = Participating in plans, 2 = saved to collections
  int _activeTabIndex = 0;

  final List<String> _displayTabs = [];
  final Map<int, String> _segmentChildren = {};

  @override
  void initState() {
    if (widget.showJoined) {
      _displayTabs.add('Joined');
    }
    if (widget.showSaved) {
      _displayTabs.add('Saved');
    }
    _displayTabs.add('Created');
    _displayTabs.forEachIndexed((i, t) {
      _segmentChildren[i] = t;
    });

    super.initState();
  }

  void _updatePageIndex(int index) {
    setState(() => _activeTabIndex = index);
  }

  void _openWorkoutPlanEnrolmentDetails(String id) {
    context.navigateTo(WorkoutPlanEnrolmentDetailsRoute(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  CupertinoSliverNavigationBar(
                      leading: const NavBarBackButton(),
                      largeTitle: Text(widget.pageTitle),
                      border: null)
                ],
            body: Column(
              children: [
                if (_displayTabs.length > 1)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: MySlidingSegmentedControl<int>(
                          value: _activeTabIndex,
                          activeColor: Styles.secondaryAccent,
                          updateValue: _updatePageIndex,
                          children: _segmentChildren),
                    ),
                  ),
                Expanded(
                    child: IndexedStack(
                  index: _activeTabIndex,
                  children: [
                    if (widget.showJoined)
                      YourWorkoutPlanEnrolments(
                        selectEnrolment: _openWorkoutPlanEnrolmentDetails,
                        showDiscoverButton: widget.showDiscoverButton,
                      ),
                    if (widget.showSaved)
                      YourSavedPlans(
                        showDiscoverButton: widget.showDiscoverButton,
                      ),
                    YourCreatedPlans(
                      showDiscoverButton: widget.showDiscoverButton,
                    ),
                  ],
                ))
              ],
            )));
  }
}
