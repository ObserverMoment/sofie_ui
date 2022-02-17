import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/collections/collection_manager.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/user_input/selectors/collection_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';

/// Didn't use [_FilterableCreatedWorkoutPlans] even tho very similar because we need the cards in this list to have context menu functionality - multiple options when clicked.
/// Note: Also has similar functionality to that found in the [WorkoutPlanDetailsPage] with regards to adding and removing from collections.
class FilterableCollectionWorkoutPlans extends StatefulWidget {
  final Collection collection;
  const FilterableCollectionWorkoutPlans({Key? key, required this.collection})
      : super(key: key);

  @override
  _FilterableCollectionWorkoutPlansState createState() =>
      _FilterableCollectionWorkoutPlansState();
}

class _FilterableCollectionWorkoutPlansState
    extends State<FilterableCollectionWorkoutPlans> {
  String? _workoutTagFilter;

  Future<void> _moveToAnotherCollection(WorkoutPlanSummary workoutPlan) async {
    /// Select collection to move to
    await context.push(
        child: CollectionSelector(selectCollection: (collection) async {
      // Remove from [widget.collection]
      await CollectionManager.removeWorkoutPlanFromCollection(
          context, widget.collection, workoutPlan,
          showToast: false);
      // Add to selected collection.
      await CollectionManager.addWorkoutPlanToCollection(
          context, collection, workoutPlan);
    }));
  }

  Future<void> _copyToAnotherCollection(WorkoutPlanSummary workoutPlan) async {
    /// Select collection to move to
    await context.push(
        child: CollectionSelector(selectCollection: (collection) async {
      await CollectionManager.addWorkoutPlanToCollection(
          context, collection, workoutPlan);
    }));
  }

  void _confirmRemoveFromCollection(WorkoutPlanSummary workoutPlan) {
    CollectionManager.confirmRemoveObjectFromCollection<WorkoutPlanSummary>(
        context, widget.collection, workoutPlan);
  }

  @override
  Widget build(BuildContext context) {
    final allPlans = widget.collection.workoutPlans.where((wp) => !wp.archived);

    final allTags = allPlans
        .fold<List<String>>([], (acum, next) => [...acum, ...next.tags])
        .toSet()
        .toList();

    final filteredPlans = _workoutTagFilter == null
        ? allPlans
        : allPlans.where((wp) => wp.tags.contains(_workoutTagFilter));

    final sortedPlans =
        filteredPlans.sortedBy<DateTime>((w) => w.createdAt).reversed.toList();

    return Column(
      children: [
        if (allTags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 2, bottom: 8),
            child: SizedBox(
                height: 32,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allTags.length,
                    itemBuilder: (c, i) => Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: SelectableTag(
                            text: allTags[i],
                            fontSize: FONTSIZE.two,
                            selectedColor: Styles.primaryAccent,
                            isSelected: allTags[i] == _workoutTagFilter,
                            onPressed: () => setState(() => _workoutTagFilter =
                                allTags[i] == _workoutTagFilter
                                    ? null
                                    : allTags[i]),
                          ),
                        ))),
          ),
        Expanded(
            child: _CollectionWorkoutPlansList(
          workoutPlans: sortedPlans,
          moveToCollection: _moveToAnotherCollection,
          copyToCollection: _copyToAnotherCollection,
          removeFromCollection: _confirmRemoveFromCollection,
        )),
      ],
    );
  }
}

class _CollectionWorkoutPlansList extends StatelessWidget {
  final List<WorkoutPlanSummary> workoutPlans;
  final void Function(WorkoutPlanSummary workoutPlan) moveToCollection;
  final void Function(WorkoutPlanSummary workoutPlan) copyToCollection;
  final void Function(WorkoutPlanSummary workoutPlan) removeFromCollection;
  const _CollectionWorkoutPlansList(
      {required this.workoutPlans,
      required this.moveToCollection,
      required this.copyToCollection,
      required this.removeFromCollection});

  @override
  Widget build(BuildContext context) {
    return workoutPlans.isEmpty
        ? const Center(child: NoResultsToDisplay())
        : ListView.builder(
            cacheExtent: 3000,
            shrinkWrap: true,
            itemCount: workoutPlans.length,
            itemBuilder: (c, i) => GestureDetector(
              onTap: () => openBottomSheetMenu(
                  context: context,
                  child: BottomSheetMenu(
                      header: BottomSheetMenuHeader(
                        imageUri: workoutPlans[i].coverImageUri,
                        name: workoutPlans[i].name,
                        subtitle: 'PLAN',
                      ),
                      items: [
                        BottomSheetMenuItem(
                            text: 'View details',
                            icon: CupertinoIcons.eye,
                            onPressed: () => context.navigateTo(
                                WorkoutPlanDetailsRoute(
                                    id: workoutPlans[i].id))),
                        BottomSheetMenuItem(
                            text: 'Move to other collection',
                            icon: CupertinoIcons.tray_arrow_up,
                            onPressed: () => moveToCollection(workoutPlans[i])),
                        BottomSheetMenuItem(
                            text: 'Copy to other collection',
                            icon: CupertinoIcons.plus_rectangle_on_rectangle,
                            onPressed: () => copyToCollection(workoutPlans[i])),
                        BottomSheetMenuItem(
                            text: 'Remove from collection',
                            icon: CupertinoIcons.delete_simple,
                            isDestructive: true,
                            onPressed: () =>
                                removeFromCollection(workoutPlans[i]))
                      ])),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: WorkoutPlanCard(workoutPlans[i]),
              ),
            ),
          );
  }
}
