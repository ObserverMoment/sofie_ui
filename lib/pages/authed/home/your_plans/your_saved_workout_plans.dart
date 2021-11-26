import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout_plan/vertical_workout_plans_list.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class YourSavedPlans extends StatelessWidget {
  final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;
  const YourSavedPlans({Key? key, this.selectWorkoutPlan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserCollections$Query, json.JsonSerializable>(
        key: Key('YourSavedPlans - ${UserCollectionsQuery().operationName}'),
        query: UserCollectionsQuery(),
        fullScreenError: false,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        loadingIndicator: const ShimmerCardList(itemCount: 20),
        builder: (data) {
          final collections = data.userCollections;

          return FilterableSavedWorkoutPlans(
            selectWorkoutPlan: selectWorkoutPlan,
            allCollections: collections,
          );
        });
  }
}

class FilterableSavedWorkoutPlans extends StatefulWidget {
  final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;
  final List<Collection> allCollections;
  const FilterableSavedWorkoutPlans(
      {Key? key, required this.selectWorkoutPlan, required this.allCollections})
      : super(key: key);

  @override
  _FilterableSavedWorkoutPlansState createState() =>
      _FilterableSavedWorkoutPlansState();
}

class _FilterableSavedWorkoutPlansState
    extends State<FilterableSavedWorkoutPlans> {
  Collection? _selectedCollection;

  @override
  Widget build(BuildContext context) {
    final selectedCollections = _selectedCollection == null
        ? widget.allCollections
        : [
            widget.allCollections
                .firstWhere((c) => c.id == _selectedCollection!.id)
          ];

    final workoutPlans = selectedCollections
        .fold<List<WorkoutPlanSummary>>(
            [], (acum, next) => [...acum, ...next.workoutPlans])
        .sortedBy<DateTime>((w) => w.createdAt)
        .reversed
        .toList();

    final collectionsWithPlans =
        widget.allCollections.where((c) => c.workoutPlans.isNotEmpty).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 8, bottom: 8),
          child: SizedBox(
              height: 32,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: collectionsWithPlans.length,
                  itemBuilder: (c, i) => Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: SelectableTag(
                          fontSize: FONTSIZE.two,
                          text: collectionsWithPlans[i].name,
                          isSelected:
                              collectionsWithPlans[i] == _selectedCollection,
                          onPressed: () => setState(() => _selectedCollection =
                              collectionsWithPlans[i] == _selectedCollection
                                  ? null
                                  : collectionsWithPlans[i]),
                        ),
                      ))),
        ),
        Expanded(
          child: VerticalWorkoutPlansList(
            workoutPlans: workoutPlans,
            selectWorkoutPlan: widget.selectWorkoutPlan,
            avoidBottomNavBar: true,
            heroTagKey: 'FilterableSavedWorkoutPlans',
          ),
        ),
      ],
    );
  }
}
