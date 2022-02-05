import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/workout_card_minimal.dart';
import 'package:sofie_ui/components/cards/workout_plan_day_card.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/pre_logging_modifications.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/model/toast_request.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:supercharged/supercharged.dart';

class WorkoutPlanEnrolmentProgress extends StatelessWidget {
  final WorkoutPlanEnrolmentWithPlan enrolmentWithPlan;
  const WorkoutPlanEnrolmentProgress(
      {Key? key, required this.enrolmentWithPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Zero index - week '1' is at daysByWeek[0].
    final daysByWeek = enrolmentWithPlan.workoutPlan.workoutPlanDays
        .groupBy<int, WorkoutPlanDay>((day) => (day.dayNumber / 7).floor());

    final completedWorkouts =
        enrolmentWithPlan.workoutPlanEnrolment.completedWorkoutPlanDayWorkouts;

    return ListView(
      shrinkWrap: true,
      children: daysByWeek.keys
          .map((i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: WorkoutPlanEnrolmentWorkoutsWeek(
                    workoutPlanDaysInWeek: daysByWeek[i] ?? [],
                    weekNumber: i,
                    enrolmentWithPlan: enrolmentWithPlan,
                    completedWorkouts: completedWorkouts),
              ))
          .toList(),
    );
  }
}

class WorkoutPlanEnrolmentWorkoutsWeek extends StatelessWidget {
  final WorkoutPlanEnrolmentWithPlan enrolmentWithPlan;
  final int weekNumber;
  final List<WorkoutPlanDay> workoutPlanDaysInWeek;
  final List<CompletedWorkoutPlanDayWorkout> completedWorkouts;
  const WorkoutPlanEnrolmentWorkoutsWeek(
      {Key? key,
      required this.weekNumber,
      required this.workoutPlanDaysInWeek,
      required this.enrolmentWithPlan,
      required this.completedWorkouts})
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
                    enrolmentWithPlan: enrolmentWithPlan,
                    completedWorkouts: completedWorkouts)
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
  final WorkoutPlanEnrolmentWithPlan enrolmentWithPlan;
  final List<CompletedWorkoutPlanDayWorkout> completedWorkouts;
  const _WorkoutPlanEnrolmentDayCard(
      {Key? key,
      required this.workoutPlanDay,
      required this.displayDayNumber,
      required this.enrolmentWithPlan,
      required this.completedWorkouts})
      : super(key: key);

  Future<void> _openScheduleWorkout(
      BuildContext context, WorkoutPlanDayWorkout workoutPlanDayWorkout) async {
    final result = await context.pushRoute(ScheduledWorkoutCreatorRoute(
      workout: workoutPlanDayWorkout.workout.summary,
      workoutPlanEnrolmentId: enrolmentWithPlan.workoutPlanEnrolment.id,
    ));
    if (result is ToastRequest) {
      context.showToast(message: result.message, toastType: result.type);
    }
  }

  Future<void> _handleLogWorkoutProgramWorkout(
      BuildContext context, WorkoutPlanDayWorkout planDayWorkout) async {
    await context.push(
        child: PreLoggingModificationsAndUserInputs(
            workoutId: planDayWorkout.workout.id,
            workoutPlanDayWorkoutId: planDayWorkout.id,
            workoutPlanEnrolmentId: enrolmentWithPlan.workoutPlanEnrolment.id));
  }

  void _confirmDeleteCompletedWorkout(BuildContext context,
      CompletedWorkoutPlanDayWorkout completedPlanDayWorkout) {
    context.showConfirmDialog(
        title: 'Reset This Workout',
        message:
            'Do this if you want to do the workout again. The original workout log will not be deleted but will no longer count towards progress in this plan.',
        onConfirm: () => _deleteCompletedWorkoutPlanDayWorkout(
            context, completedPlanDayWorkout));
  }

  Future<void> _deleteCompletedWorkoutPlanDayWorkout(BuildContext context,
      CompletedWorkoutPlanDayWorkout completedPlanDayWorkout) async {
    final enrolmentId = enrolmentWithPlan.workoutPlanEnrolment.id;

    final variables = DeleteCompletedWorkoutPlanDayWorkoutArguments(
        data: DeleteCompletedWorkoutPlanDayWorkoutInput(
            workoutPlanDayWorkoutId: completedPlanDayWorkout.id,
            workoutPlanEnrolmentId: enrolmentId));

    final result = await context.graphQLStore.mutate(
        mutation:
            DeleteCompletedWorkoutPlanDayWorkoutMutation(variables: variables),
        refetchQueryIds: [
          GQLOpNames.workoutPlanEnrolments
        ],
        broadcastQueryIds: [
          GQLVarParamKeys.workoutPlanEnrolmentById(enrolmentId),
        ]);

    checkOperationResult(
      context,
      result,
      onFail: () => context.showToast(
          message: 'Sorry, there was a problem',
          toastType: ToastType.destructive),
      onSuccess: () => context.showToast(
        message: 'Workout progress has been reset.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedWorkoutPlanDayWorkouts = workoutPlanDay.workoutPlanDayWorkouts
        .sortedBy<num>((d) => d.sortPosition)
        .toList();

    final completedworkoutPlanDayWorkoutIds =
        completedWorkouts.map((w) => w.workoutPlanDayWorkoutId).toList();

    /// All workouts for that day are complete.
    final dayComplete = sortedWorkoutPlanDayWorkouts
        .every((w) => completedworkoutPlanDayWorkoutIds.contains(w.id));

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
                                  color: Styles.primaryAccent)
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
                final completedPlanDayWorkout =
                    completedworkoutPlanDayWorkoutIds.contains(dayWorkout.id)
                        ? completedWorkouts.firstWhere(
                            (w) => w.workoutPlanDayWorkoutId == dayWorkout.id)
                        : null;

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
                            if (completedPlanDayWorkout != null) ...[
                              BottomSheetMenuItem(
                                  text: 'View Log',
                                  icon: CupertinoIcons.doc_chart,
                                  onPressed: () => context.navigateTo(
                                      LoggedWorkoutDetailsRoute(
                                          id: completedPlanDayWorkout
                                              .loggedWorkoutId))),
                              BottomSheetMenuItem(
                                  text: 'Reset Workout',
                                  icon: CupertinoIcons.doc_chart,
                                  onPressed: () =>
                                      _confirmDeleteCompletedWorkout(
                                          context, completedPlanDayWorkout))
                            ] else ...[
                              BottomSheetMenuItem(
                                text: 'Do it',
                                icon: CupertinoIcons.arrow_right_square,
                                onPressed: () => context.navigateTo(
                                    DoWorkoutWrapperRoute(
                                        id: dayWorkout.workout.id,
                                        workoutPlanDayWorkoutId: dayWorkout.id,
                                        workoutPlanEnrolmentId:
                                            enrolmentWithPlan
                                                .workoutPlanEnrolment.id)),
                              ),
                              BottomSheetMenuItem(
                                  text: 'Log it',
                                  icon: CupertinoIcons.text_badge_checkmark,
                                  onPressed: () =>
                                      _handleLogWorkoutProgramWorkout(
                                          context, dayWorkout)),
                              BottomSheetMenuItem(
                                  text: 'Schedule it',
                                  icon: CupertinoIcons.calendar_badge_plus,
                                  onPressed: () => _openScheduleWorkout(
                                      context, dayWorkout)),
                            ],
                            BottomSheetMenuItem(
                                text: 'View workout',
                                icon: CupertinoIcons.eye,
                                onPressed: () => context.navigateTo(
                                    WorkoutDetailsRoute(
                                        id: dayWorkout.workout.id,
                                        workoutPlanDayWorkoutId: dayWorkout.id,
                                        workoutPlanEnrolmentId:
                                            enrolmentWithPlan
                                                .workoutPlanEnrolment.id))),
                          ])),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      MinimalWorkoutCard(
                        dayWorkout.workout.summary,
                      ),
                      if (completedworkoutPlanDayWorkoutIds
                          .contains(dayWorkout.id))
                        const Positioned(
                            top: 0,
                            right: 4,
                            child: FadeIn(
                              child: Icon(CupertinoIcons.checkmark_alt,
                                  color: Styles.primaryAccent, size: 20),
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
