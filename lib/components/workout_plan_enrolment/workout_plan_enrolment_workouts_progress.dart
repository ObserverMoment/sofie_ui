import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/workout_card_minimal.dart';
import 'package:sofie_ui/components/cards/workout_plan_day_card.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/model/toast_request.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:supercharged/supercharged.dart';

class WorkoutPlanEnrolmentWorkoutsProgress extends StatelessWidget {
  final WorkoutPlan workoutPlan;
  final WorkoutPlanEnrolment enrolment;
  const WorkoutPlanEnrolmentWorkoutsProgress(
      {Key? key, required this.workoutPlan, required this.enrolment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Zero index - week '1' is at daysByWeek[0].
    final daysByWeek = workoutPlan.workoutPlanDays
        .groupBy<int, WorkoutPlanDay>((day) => (day.dayNumber / 7).floor());

    return ListView(
      shrinkWrap: true,
      children: daysByWeek.keys
          .map((i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: WorkoutPlanEnrolmentWorkoutsWeek(
                    workoutPlanDaysInWeek: daysByWeek[i] ?? [],
                    weekNumber: i,
                    workoutPlanEnrolment: enrolment),
              ))
          .toList(),
    );
  }
}

class WorkoutPlanEnrolmentWorkoutsWeek extends StatelessWidget {
  final WorkoutPlanEnrolment workoutPlanEnrolment;
  final int weekNumber;
  final List<WorkoutPlanDay> workoutPlanDaysInWeek;
  const WorkoutPlanEnrolmentWorkoutsWeek(
      {Key? key,
      required this.weekNumber,
      required this.workoutPlanDaysInWeek,
      required this.workoutPlanEnrolment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Must % 7 so that workouts in weeks higher than week 1 will get assigned to the correct day of that week.
    final byDayNumberInWeek =
        workoutPlanDaysInWeek.fold<Map<int, WorkoutPlanDay>>({}, (acum, next) {
      acum[next.dayNumber % 7] = next;
      return acum;
    });

    final numWorkoutsInWeek = workoutPlanDaysInWeek.fold<int>(
        0, (acum, next) => acum + next.workoutPlanDayWorkouts.length);

    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyHeaderText('Week ${weekNumber + 1}', size: FONTSIZE.two),
              Row(
                children: [
                  MyText('${workoutPlanDaysInWeek.length} days'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Dot(
                        diameter: 3,
                        color: context.theme.primary.withOpacity(0.5)),
                  ),
                  MyText('$numWorkoutsInWeek workouts'),
                ],
              )
            ],
          ),
        ),
        HorizontalLine(
            verticalPadding: 0, color: context.theme.primary.withOpacity(0.1)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (c, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: byDayNumberInWeek[i] != null
                ? _WorkoutPlanEnrolmentDayCard(
                    workoutPlanDay: byDayNumberInWeek[i]!,
                    displayDayNumber: i,
                    workoutPlanEnrolment: workoutPlanEnrolment,
                  )
                : Opacity(
                    opacity: 0.75,
                    child: WorkoutPlanRestDayCard(
                      dayNumber: i,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _WorkoutPlanEnrolmentDayCard extends StatelessWidget {
  /// Zero indexed.
  final int displayDayNumber;
  final WorkoutPlanDay workoutPlanDay;
  final WorkoutPlanEnrolment workoutPlanEnrolment;
  const _WorkoutPlanEnrolmentDayCard(
      {Key? key,
      required this.workoutPlanDay,
      required this.displayDayNumber,
      required this.workoutPlanEnrolment})
      : super(key: key);

  Future<void> _openScheduleWorkout(
      BuildContext context, WorkoutPlanDayWorkout workoutPlanDayWorkout) async {
    final result = await context.pushRoute(ScheduledWorkoutCreatorRoute(
      workout: workoutPlanDayWorkout.workout,
      workoutPlanEnrolmentId: workoutPlanEnrolment.id,
    ));
    if (result is ToastRequest) {
      context.showToast(message: result.message, toastType: result.type);
    }
  }

  Future<void> _handleLogWorkoutProgramWorkout(
      BuildContext context, WorkoutPlanDayWorkout planDayWorkout) async {
    await context
        .pushRoute(LoggedWorkoutCreatorRoute(workout: planDayWorkout.workout));

    /// Note: Currently there is no automated marking of workouts as done.
    /// This is because only the Plan -> Log flow can be implemented in a sensible was at the moment.
    /// The below is disabled pending further research on how to manage these flows.
    /// All Flows
    // Log (Directly from view workout)
    // Do -> Log
    // Schedule -> Log
    // Schedule -> Do -> Log
    // PlanEnrolment -> Log
    // PlanEnrolment -> Do -> Log
    // PlanEnrolment -> Schedule -> Log
    // PlanEnrolment -> Schedule -> Do -> Log

    // if (success != null && success == true) {
    //   if (!workoutPlanEnrolment.completedPlanDayWorkoutIds
    //       .contains(planDayWorkout.id)) {
    //     workoutPlanEnrolment.completedPlanDayWorkoutIds.add(planDayWorkout.id);
    //     _updateCompletedWorkoutIds(
    //         context, workoutPlanEnrolment.completedPlanDayWorkoutIds);
    //   }
    // }
  }

  Future<void> _updateCompletedWorkoutIds(
      BuildContext context, List<String> updatedIds) async {
    final variables = UpdateWorkoutPlanEnrolmentArguments(
        data: UpdateWorkoutPlanEnrolmentInput(id: workoutPlanEnrolment.id));

    final result = await context.graphQLStore.mutate<
            UpdateWorkoutPlanEnrolment$Mutation,
            UpdateWorkoutPlanEnrolmentArguments>(
        mutation: UpdateWorkoutPlanEnrolmentMutation(variables: variables),
        broadcastQueryIds: [
          GQLVarParamKeys.workoutPlanByEnrolmentId(workoutPlanEnrolment.id),
          EnrolledWorkoutPlansQuery().operationName,
        ],
        customVariablesMap: {
          'data': {
            'id': workoutPlanEnrolment.id,
            'completedPlanDayWorkoutIds': updatedIds
          }
        });

    if (result.hasErrors) {
      context.showErrorAlert('Something went wrong, the update did not work.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedWorkoutPlanDayWorkouts = workoutPlanDay.workoutPlanDayWorkouts
        .sortedBy<num>((d) => d.sortPosition)
        .toList();

    final completedIds = workoutPlanEnrolment.completedPlanDayWorkoutIds;

    final dayComplete =
        sortedWorkoutPlanDayWorkouts.every((w) => completedIds.contains(w.id));

    return ContentBox(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyHeaderText(
                    'Day ${displayDayNumber + 1}',
                    size: FONTSIZE.two,
                  ),
                  Row(
                    children: [
                      if (Utils.textNotNull(workoutPlanDay.note))
                        NoteIconViewerButton(workoutPlanDay.note!),
                      if (dayComplete)
                        FadeIn(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 6, right: 4.0),
                          child: Row(
                            children: const [
                              MyText(
                                'Day Complete',
                                size: FONTSIZE.one,
                              ),
                              SizedBox(width: 6),
                              Icon(CupertinoIcons.checkmark_alt_circle,
                                  color: Styles.secondaryAccent)
                            ],
                          ),
                        ))
                    ],
                  )
                ],
              ),
            ),
          ),
          HorizontalLine(
              verticalPadding: 5,
              color: context.theme.primary.withOpacity(0.08)),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sortedWorkoutPlanDayWorkouts.length,
              separatorBuilder: (c, i) => const HorizontalLine(),
              itemBuilder: (c, i) {
                final dayWorkout = sortedWorkoutPlanDayWorkouts[i];
                final workoutCompleted = completedIds.contains(dayWorkout.id);
                return GestureDetector(
                  onTap: () => openBottomSheetMenu(
                      context: context,
                      child: BottomSheetMenu(
                          header: BottomSheetMenuHeader(
                            name: dayWorkout.workout.name,
                            subtitle: 'Day ${displayDayNumber + 1}',
                            imageUri: dayWorkout.workout.coverImageUri,
                          ),
                          items: [
                            if (workoutCompleted)
                              BottomSheetMenuItem(
                                  text: 'Unmark as done',
                                  icon: const Icon(CupertinoIcons.clear_thick),
                                  onPressed: () => _updateCompletedWorkoutIds(
                                      context,
                                      completedIds.toggleItem(dayWorkout.id)))
                            else
                              BottomSheetMenuItem(
                                  text: 'Mark as done',
                                  icon:
                                      const Icon(CupertinoIcons.checkmark_alt),
                                  onPressed: () => _updateCompletedWorkoutIds(
                                      context,
                                      completedIds.toggleItem(dayWorkout.id))),
                            if (!workoutCompleted) ...[
                              BottomSheetMenuItem(
                                text: 'Do it',
                                icon: const Icon(
                                    CupertinoIcons.arrow_right_square),
                                onPressed: () =>
                                    context.navigateTo(DoWorkoutWrapperRoute(
                                  id: dayWorkout.workout.id,
                                )),
                              ),
                              BottomSheetMenuItem(
                                  text: 'Log it',
                                  icon: const Icon(
                                      CupertinoIcons.text_badge_checkmark),
                                  onPressed: () =>
                                      _handleLogWorkoutProgramWorkout(
                                          context, dayWorkout)),
                              BottomSheetMenuItem(
                                  text: 'Schedule it',
                                  icon: const Icon(
                                      CupertinoIcons.calendar_badge_plus),
                                  onPressed: () => _openScheduleWorkout(
                                      context, dayWorkout)),
                            ],
                            BottomSheetMenuItem(
                                text: 'View workout',
                                icon: const Icon(CupertinoIcons.eye),
                                onPressed: () => context.navigateTo(
                                    WorkoutDetailsRoute(
                                        id: dayWorkout.workout.id))),
                          ])),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      MinimalWorkoutCard(
                        dayWorkout.workout,
                      ),
                      if (completedIds.contains(dayWorkout.id))
                        const Positioned(
                            top: 0,
                            right: 4,
                            child: FadeIn(
                              child: Icon(CupertinoIcons.checkmark_alt,
                                  color: Styles.secondaryAccent, size: 20),
                            )),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
