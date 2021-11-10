import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/workout_plan/vertical_workout_plans_list.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/text_search_filters.dart';

class PrivatePlansTextSearch extends StatefulWidget {
  final List<WorkoutPlan> userWorkoutPlans;
  final void Function(WorkoutPlan workoutPlan)? selectWorkoutPlan;

  const PrivatePlansTextSearch(
      {Key? key, required this.userWorkoutPlans, this.selectWorkoutPlan})
      : super(key: key);

  @override
  _PrivatePlansTextSearchState createState() => _PrivatePlansTextSearchState();
}

class _PrivatePlansTextSearchState extends State<PrivatePlansTextSearch> {
  String _searchString = '';

  List<WorkoutPlan> _filteredUserWorkoutPlans = [];

  void _handleSearchStringUpdate(String text) {
    setState(() => _searchString = text.toLowerCase());
    if (_searchString.length > 2) {
      setState(() {
        _filteredUserWorkoutPlans =
            TextSearchFilters.workoutPlansBySearchString(
                widget.userWorkoutPlans, _searchString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          withoutLeading: true,
          middle: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: MyCupertinoSearchTextField(
              autofocus: true,
              placeholder: 'Search your plans',
              onChanged: _handleSearchStringUpdate,
            ),
          ),
          trailing: NavBarTextButton(context.pop, 'Close'),
        ),
        child: _searchString.length > 2
            ? _filteredUserWorkoutPlans.isEmpty
                ? const Center(
                    child: MyText(
                    'No results.',
                    subtext: true,
                  ))
                : VerticalWorkoutPlansList(
                    selectWorkoutPlan: widget.selectWorkoutPlan,
                    workoutPlans: _filteredUserWorkoutPlans)
            : const Center(
                child: MyText(
                'Enter at least 3 characters.',
                subtext: true,
              )));
  }
}
