import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout/vertical_workouts_list.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class YourCreatedWorkouts extends StatelessWidget {
  final void Function(WorkoutSummary workout)? selectWorkout;
  const YourCreatedWorkouts({Key? key, this.selectWorkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserWorkouts$Query, json.JsonSerializable>(
        key: Key('YourCreatedWorkouts - ${UserWorkoutsQuery().operationName}'),
        query: UserWorkoutsQuery(),
        loadingIndicator: const ShimmerCardList(itemCount: 20),
        builder: (data) {
          final workouts = data.userWorkouts
              .sortedBy<DateTime>((w) => w.createdAt)
              .reversed
              .toList();
          return FilterableCreatedWorkouts(
            allWorkouts: workouts,
            selectWorkout: selectWorkout,
          );
        });
  }
}

class FilterableCreatedWorkouts extends StatefulWidget {
  final void Function(WorkoutSummary workout)? selectWorkout;
  final List<WorkoutSummary> allWorkouts;
  const FilterableCreatedWorkouts(
      {Key? key, this.selectWorkout, required this.allWorkouts})
      : super(key: key);

  @override
  _FilterableCreatedWorkoutsState createState() =>
      _FilterableCreatedWorkoutsState();
}

class _FilterableCreatedWorkoutsState extends State<FilterableCreatedWorkouts> {
  String? _workoutTagFilter;

  @override
  Widget build(BuildContext context) {
    final allTags = widget.allWorkouts
        .fold<List<String>>([], (acum, next) => [...acum, ...next.tags])
        .toSet()
        .toList();

    final filteredWorkouts = _workoutTagFilter == null
        ? widget.allWorkouts
        : widget.allWorkouts.where((w) => w.tags.contains(_workoutTagFilter));

    final sortedWorkouts = filteredWorkouts
        .sortedBy<DateTime>((w) => w.createdAt)
        .reversed
        .toList();

    return ListView(
      shrinkWrap: true,
      children: [
        if (allTags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: allTags
                  .map((t) => SelectableTag(
                        fontSize: FONTSIZE.two,
                        text: t,
                        isSelected: t == _workoutTagFilter,
                        onPressed: () => setState(() => _workoutTagFilter =
                            t == _workoutTagFilter ? null : t),
                      ))
                  .toList(),
            ),
          ),
        VerticalWorkoutsList(
          workouts: sortedWorkouts,
          selectWorkout: widget.selectWorkout,
          scrollable: false,
          avoidBottomNavBar: true,
          heroTagKey: 'FilterableCreatedWorkouts',
        ),
      ],
    );
  }
}
