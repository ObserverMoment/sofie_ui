import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout_plan_enrolment/workout_plan_enrolment_progress_summary.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class YourEnrolledWorkoutPlans extends StatelessWidget {
  final void Function(String enrolmentId) selectEnrolment;
  const YourEnrolledWorkoutPlans({Key? key, required this.selectEnrolment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<EnrolledWorkoutPlans$Query, json.JsonSerializable>(
      key: Key(
          'YourEnrolledWorkoutPlans - ${EnrolledWorkoutPlansQuery().operationName}'),
      query: EnrolledWorkoutPlansQuery(),
      loadingIndicator: const ShimmerCardList(itemCount: 20, cardHeight: 260),
      builder: (data) {
        final workoutPlans = data.enrolledWorkoutPlans.toList();

        return _FilterableEnroledPlans(
          workoutPlans: workoutPlans,
          selectEnrolment: selectEnrolment,
        );
      },
    );
  }
}

class _FilterableEnroledPlans extends StatefulWidget {
  final void Function(String enrolmentId) selectEnrolment;
  final List<WorkoutPlan> workoutPlans;
  const _FilterableEnroledPlans(
      {Key? key, required this.selectEnrolment, required this.workoutPlans})
      : super(key: key);

  @override
  __FilterableEnroledPlansState createState() =>
      __FilterableEnroledPlansState();
}

class __FilterableEnroledPlansState extends State<_FilterableEnroledPlans> {
  WorkoutTag? _workoutTagFilter;

  /// Search the plan enrolments and return the ID of the enrolment that matches the user Id.
  WorkoutPlanEnrolment getUserEnrolmentFromPlan(WorkoutPlan workoutPlan) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    /// No fallback - if the enrolment is not found then an error should be thrown indicating a bug. User should not be here if they are not enrolled in these workout plans.
    return workoutPlan.workoutPlanEnrolments
        .firstWhere((e) => e.user.id == authedUserId);
  }

  @override
  Widget build(BuildContext context) {
    final allTags = widget.workoutPlans
        .fold<List<WorkoutTag>>(
            [], (acum, next) => [...acum, ...next.workoutTags])
        .toSet()
        .toList();

    final filteredWorkoutPlans = _workoutTagFilter == null
        ? widget.workoutPlans
        : widget.workoutPlans
            .where((wp) => wp.workoutTags.contains(_workoutTagFilter))
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
                            text: allTags[i].tag,
                            isSelected: allTags[i] == _workoutTagFilter,
                            onPressed: () => setState(() => _workoutTagFilter =
                                allTags[i] == _workoutTagFilter
                                    ? null
                                    : allTags[i]),
                          ),
                        ))),
          ),
        filteredWorkoutPlans.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: MyText(
                    'No plans joined yet',
                    subtext: true,
                  ),
                ))
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredWorkoutPlans.length,
                    itemBuilder: (c, i) {
                      final enrolment =
                          getUserEnrolmentFromPlan(filteredWorkoutPlans[i]);

                      return GestureDetector(
                        onTap: () => widget.selectEnrolment(enrolment.id),
                        child: Card(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 9),
                                child: WorkoutPlanEnrolmentProgressSummary(
                                    enrolment: enrolment,
                                    workoutPlan: filteredWorkoutPlans[i]),
                              ),
                              WorkoutPlanCard(
                                filteredWorkoutPlans[i],
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
