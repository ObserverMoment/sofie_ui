import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout_plan_enrolment/workout_plan_enrolment_progress_summary.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';

class YourWorkoutPlanEnrolments extends StatelessWidget {
  final void Function(String enrolmentId) selectEnrolment;
  const YourWorkoutPlanEnrolments({Key? key, required this.selectEnrolment})
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
          selectEnrolment: selectEnrolment,
        );
      },
    );
  }
}

class _FilterableEnroledPlans extends StatefulWidget {
  final void Function(String enrolmentId) selectEnrolment;
  final List<WorkoutPlanEnrolmentSummary> enrolments;
  const _FilterableEnroledPlans(
      {Key? key, required this.selectEnrolment, required this.enrolments})
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

    return Column(
      children: [
        if (allTags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 8, bottom: 8),
            child: SizedBox(
                height: 32,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allTags.length,
                    itemBuilder: (c, i) => Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: SelectableTag(
                            fontSize: FONTSIZE.two,
                            text: allTags[i],
                            isSelected: allTags[i] == _workoutTagFilter,
                            onPressed: () => setState(() => _workoutTagFilter =
                                allTags[i] == _workoutTagFilter
                                    ? null
                                    : allTags[i]),
                          ),
                        ))),
          ),
        filteredEnrolments.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const MyText(
                        'No plans joined yet...',
                        subtext: true,
                      ),
                      const SizedBox(height: 24),
                      SecondaryButton(
                        onPressed: () =>
                            context.navigateTo(PublicWorkoutPlanFinderRoute()),
                        prefixIconData: CupertinoIcons.compass,
                        text: 'Find Plans',
                      )
                    ],
                  ),
                ))
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredEnrolments.length,
                    itemBuilder: (c, i) {
                      return GestureDetector(
                        onTap: () =>
                            widget.selectEnrolment(filteredEnrolments[i].id),
                        child: Card(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 9),
                                child: WorkoutPlanEnrolmentProgressSummary(
                                  completed: filteredEnrolments[i]
                                      .completedPlanDayWorkoutIds
                                      .length,
                                  startedOn: filteredEnrolments[i].startDate,
                                  total: filteredEnrolments[i]
                                      .workoutPlan
                                      .workoutsCount,
                                ),
                              ),
                              WorkoutPlanCard(
                                filteredEnrolments[i].workoutPlan,
                                elevation: 0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
      ],
    );
  }
}
