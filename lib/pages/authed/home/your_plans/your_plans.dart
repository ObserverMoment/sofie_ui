import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_created_workout_plans.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_enroled_workout_plans.dart';
import 'package:sofie_ui/pages/authed/home/your_plans/your_saved_workout_plans.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

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

  void Function(WorkoutPlanSummary)? _selectPlan;

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

    _selectPlan = widget.selectPlan != null ? _handlePlanSelect : null;

    super.initState();
  }

  void _updatePageIndex(int index) {
    setState(() => _activeTabIndex = index);
  }

  /// Pops itself (and any stack items such as the text seach widget)
  /// Then passes the selected plan to the parent.
  void _handlePlanSelect(WorkoutPlanSummary plan) {
    /// If the text search is open then we pop back to the main widget.
    context.router.popUntilRouteWithName(YourPlansRoute.name);
    context.pop();
    widget.selectPlan?.call(plan);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (c, i) =>
                [MySliverNavbar(title: widget.pageTitle)],
            body: Column(
              children: [
                if (_displayTabs.length > 1)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: MySlidingSegmentedControl<int>(
                          value: _activeTabIndex,
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
                        selectPlan: _selectPlan,
                        showDiscoverButton: widget.showDiscoverButton,
                      ),
                    if (widget.showSaved)
                      YourSavedPlans(
                        showDiscoverButton: widget.showDiscoverButton,
                        selectWorkoutPlan: _selectPlan,
                      ),
                    YourCreatedPlans(
                      showDiscoverButton: widget.showDiscoverButton,
                      selectWorkoutPlan: _selectPlan,
                    ),
                  ],
                ))
              ],
            )));
  }
}
