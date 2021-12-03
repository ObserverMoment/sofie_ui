import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/workout_plan/selectable_workout_plan_card.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/components/user_input/filters/tags_collections_filter_menu.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';

class YourSavedPlans extends StatelessWidget {
  final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;
  final bool showDiscoverButton;
  const YourSavedPlans(
      {Key? key, this.selectWorkoutPlan, required this.showDiscoverButton})
      : super(key: key);

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
            showDiscoverButton: showDiscoverButton,
          );
        });
  }
}

class FilterableSavedWorkoutPlans extends StatefulWidget {
  final void Function(WorkoutPlanSummary workoutPlan)? selectWorkoutPlan;
  final List<Collection> allCollections;
  final bool showDiscoverButton;
  const FilterableSavedWorkoutPlans(
      {Key? key,
      required this.selectWorkoutPlan,
      required this.allCollections,
      required this.showDiscoverButton})
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
    final filteredPlans = _selectedCollection != null
        ? _selectedCollection!.workoutPlans
        : widget.allCollections.fold<List<WorkoutPlanSummary>>(
            [], (acum, next) => [...acum, ...next.workoutPlans]);

    final sortedPlans =
        filteredPlans.sortedBy<DateTime>((w) => w.createdAt).reversed.toList();

    final collectionsWithPlans =
        widget.allCollections.where((c) => c.workoutPlans.isNotEmpty).toList();

    return sortedPlans.isEmpty
        ? YourContentEmptyPlaceholder(message: 'No saved plans', actions: [
            EmptyPlaceholderAction(
                action: () => context.navigateTo(WorkoutPlanCreatorRoute()),
                buttonIcon: CupertinoIcons.add,
                buttonText: 'Create Plan'),
            EmptyPlaceholderAction(
                action: () =>
                    context.navigateTo(PublicWorkoutPlanFinderRoute()),
                buttonIcon: CupertinoIcons.compass,
                buttonText: 'Find Plan'),
          ])
        : FABPage(
            rowButtonsAlignment: MainAxisAlignment.end,
            rowButtons: [
              // Collections only for saved.
              if (collectionsWithPlans.isNotEmpty)
                TagsCollectionsFilterMenu(
                  filterMenuType: FilterMenuType.collection,
                  allCollections: collectionsWithPlans,
                  allTags: const [],
                  selectedCollection: _selectedCollection,
                  selectedTag: null,
                  updateSelectedCollection: (c) =>
                      setState(() => _selectedCollection = c),
                  updateSelectedTag: (_) {},
                ),
              if (widget.showDiscoverButton)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: FloatingButton(
                      onTap: () =>
                          context.navigateTo(PublicWorkoutPlanFinderRoute()),
                      icon: CupertinoIcons.compass),
                ),
              const SizedBox(width: 10),
              FloatingButton(
                  gradient: Styles.primaryAccentGradient,
                  contentColor: Styles.white,
                  icon: CupertinoIcons.add,
                  onTap: () => context.navigateTo(WorkoutPlanCreatorRoute())),
            ],
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 6, bottom: 60),
                shrinkWrap: true,
                itemCount: sortedPlans.length,
                itemBuilder: (c, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FadeInUp(
                      key: Key(sortedPlans[i].id),
                      delay: 5,
                      delayBasis: 20,
                      duration: 100,
                      child: SelectableWorkoutPlanCard(
                        index: i,
                        selectWorkoutPlan: widget.selectWorkoutPlan,
                        workoutPlan: sortedPlans[i],
                      ),
                    ),
                  );
                }),
          );
  }
}
