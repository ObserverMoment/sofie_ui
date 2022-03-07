import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/workout/vertical_workouts_list.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/text_search_filters.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class PrivateWorkoutTextSearch extends StatefulWidget {
  final List<WorkoutSummary> userWorkouts;
  final void Function(WorkoutSummary workout)? selectWorkout;

  const PrivateWorkoutTextSearch({
    Key? key,
    required this.userWorkouts,
    this.selectWorkout,
  }) : super(key: key);

  @override
  _PrivateWorkoutTextSearchState createState() =>
      _PrivateWorkoutTextSearchState();
}

class _PrivateWorkoutTextSearchState extends State<PrivateWorkoutTextSearch> {
  String _searchString = '';

  List<WorkoutSummary> _filteredUserWorkouts = [];

  void _handleSearchStringUpdate(String text) {
    setState(() => _searchString = text.toLowerCase());
    if (_searchString.length > 1) {
      setState(() {
        _filteredUserWorkouts = TextSearchFilters.workoutsBySearchString(
            widget.userWorkouts, _searchString);
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
              placeholder: 'Search your workouts',
              onChanged: _handleSearchStringUpdate,
            ),
          ),
          trailing: NavBarTextButton(context.pop, 'Close'),
        ),
        child: _searchString.length > 1
            ? _filteredUserWorkouts.isEmpty
                ? const Center(child: NoResultsToDisplay())
                : VerticalWorkoutsList(
                    selectWorkout: widget.selectWorkout,
                    workouts: _filteredUserWorkouts)
            : const Center(
                child: MyText(
                'Enter at least 2 characters',
                subtext: true,
              )));
  }
}
