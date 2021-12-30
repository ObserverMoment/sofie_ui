import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/workout_plan/selectable_workout_plan_card.dart';
import 'package:sofie_ui/components/workout_plan_enrolment/workout_plan_enrolment_progress_summary.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/components/user_input/filters/tags_collections_filter_menu.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';

class YourWorkoutPlanEnrolments extends StatelessWidget {
  final void Function(WorkoutPlanSummary plan)? selectPlan;
  final bool showDiscoverButton;
  const YourWorkoutPlanEnrolments(
      {Key? key, required this.selectPlan, required this.showDiscoverButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<WorkoutPlanEnrolments$Query, json.JsonSerializable>(
      key: Key(
          'YourWorkoutPlanEnrolments - ${WorkoutPlanEnrolmentsQuery().operationName}'),
      query: WorkoutPlanEnrolmentsQuery(),
      fullScreenError: false,
      loadingIndicator: const ShimmerCardList(itemCount: 20, cardHeight: 260),
      builder: (data) {
        return _FilterableEnroledPlans(
          enrolments: data.workoutPlanEnrolments,
          selectPlan: selectPlan,
          showDiscoverButton: showDiscoverButton,
        );
      },
    );
  }
}

class _FilterableEnroledPlans extends StatefulWidget {
  final void Function(WorkoutPlanSummary plan)? selectPlan;
  final List<WorkoutPlanEnrolmentSummary> enrolments;
  final bool showDiscoverButton;
  const _FilterableEnroledPlans(
      {Key? key,
      required this.selectPlan,
      required this.enrolments,
      required this.showDiscoverButton})
      : super(key: key);

  @override
  __FilterableEnroledPlansState createState() =>
      __FilterableEnroledPlansState();
}

class __FilterableEnroledPlansState extends State<_FilterableEnroledPlans> {
  String? _workoutTagFilter;

  @override
  Widget build(BuildContext context) {
    final allTags = widget.enrolments
        .map((e) => e.workoutPlan)
        .fold<List<String>>([], (acum, next) => [...acum, ...next.tags])
        .toSet()
        .toList();

    final filteredEnrolments = _workoutTagFilter == null
        ? widget.enrolments
        : widget.enrolments
            .where((e) => e.workoutPlan.tags.contains(_workoutTagFilter))
            .toList();

    return filteredEnrolments.isEmpty
        ? YourContentEmptyPlaceholder(message: 'No plans joined', actions: [
            EmptyPlaceholderAction(
                action: () =>
                    context.navigateTo(PublicWorkoutPlanFinderRoute()),
                buttonIcon: CupertinoIcons.compass,
                buttonText: 'Find Plans'),
          ])
        : FABPage(
            rowButtonsAlignment: MainAxisAlignment.end,
            rowButtons: [
              // Tags only for enrolments.
              if (allTags.isNotEmpty)
                TagsCollectionsFilterMenu(
                  filterMenuType: FilterMenuType.tag,
                  allCollections: const [],
                  allTags: allTags,
                  selectedCollection: null,
                  selectedTag: _workoutTagFilter,
                  updateSelectedCollection: (_) {},
                  updateSelectedTag: (t) =>
                      setState(() => _workoutTagFilter = t),
                ),
              if (widget.showDiscoverButton)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: FloatingButton(
                      onTap: () =>
                          context.navigateTo(PublicWorkoutPlanFinderRoute()),
                      icon: CupertinoIcons.compass),
                ),
            ],
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 6, bottom: 60),
                shrinkWrap: true,
                itemCount: filteredEnrolments.length,
                itemBuilder: (c, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FadeInUp(
                      key: Key(filteredEnrolments[i].id),
                      delay: 5,
                      delayBasis: 20,
                      duration: 100,
                      child: Card(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 9),
                              child: WorkoutPlanEnrolmentProgressSummary(
                                completed: filteredEnrolments[i]
                                    .completedWorkoutsCount,
                                startedOn: filteredEnrolments[i].startDate,
                                total: filteredEnrolments[i]
                                    .workoutPlan
                                    .workoutsCount,
                              ),
                            ),
                            widget.selectPlan != null
                                ? SelectableWorkoutPlanCard(
                                    index: i,
                                    workoutPlan:
                                        filteredEnrolments[i].workoutPlan,
                                    selectWorkoutPlan: widget.selectPlan)
                                : GestureDetector(
                                    onTap: () => context.navigateTo(
                                        WorkoutPlanEnrolmentDetailsRoute(
                                            id: filteredEnrolments[i].id)),
                                    child: WorkoutPlanCard(
                                      filteredEnrolments[i].workoutPlan,
                                      elevation: 0,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
