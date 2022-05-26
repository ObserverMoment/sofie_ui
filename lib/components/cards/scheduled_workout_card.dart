import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/cards/workout_card_minimal.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/pre_log_scores_and_modifications/pre_logging_modifications.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/toast_request.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/utils.dart';

class ScheduledWorkoutCard extends StatelessWidget {
  final ScheduledWorkout scheduledWorkout;
  const ScheduledWorkoutCard({Key? key, required this.scheduledWorkout})
      : super(key: key);

  Widget? _buildMarker() {
    final hasLog = scheduledWorkout.loggedWorkoutId != null;

    final color = hasLog
        ? Styles.primaryAccent // Done
        : scheduledWorkout.scheduledAt.isBefore(DateTime.now())
            ? Styles.errorRed // Missed
            : Styles.primaryAccent; // Upcoming
    final IconData icon = hasLog
        ? CupertinoIcons.checkmark_alt_circle_fill // Done
        : scheduledWorkout.scheduledAt.isBefore(DateTime.now())
            ? CupertinoIcons.exclamationmark_circle_fill // Missed
            : CupertinoIcons.clock; // Upcoming

    return Icon(
      icon,
      size: 16,
      color: color,
    );
  }

  Future<void> _reschedule(BuildContext context) async {
    final result = await context.pushRoute(ScheduledWorkoutCreatorRoute(
      scheduledWorkout: scheduledWorkout,
    ));
    if (result is ToastRequest) {
      context.showToast(message: result.message, toastType: result.type);
    }
  }

  void _confirmUnschedule(BuildContext context) {
    context.showConfirmDeleteDialog(
        verb: 'Unschedule',
        itemType: 'Workout',
        onConfirm: () => _unschedule(context));
  }

  Future<void> _unschedule(BuildContext context) async {
    final variables =
        DeleteScheduledWorkoutByIdArguments(id: scheduledWorkout.id);

    final result = await GraphQLStore.store.delete(
        mutation: DeleteScheduledWorkoutByIdMutation(variables: variables),
        objectId: scheduledWorkout.id,
        typename: kScheduledWorkoutTypename,
        removeRefFromQueries: [UserScheduledWorkoutsQuery().operationName]);

    if (result.hasErrors) {
      context.showErrorAlert(
          'Sorry there was a problem, the schedule was not updated.');
    } else {
      context.showToast(message: 'Workout unscheduled.');
    }
  }

  Widget _buildCardHeader(
      BuildContext context, String? planName, bool showNote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                MyText(
                  '${scheduledWorkout.scheduledAt.minimalDateString}, ${scheduledWorkout.scheduledAt.timeString}',
                  lineHeight: 1.3,
                  size: FONTSIZE.two,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: _buildMarker(),
                ),
              ],
            ),
            if (scheduledWorkout.gymProfile != null)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: MyText(
                    scheduledWorkout.gymProfile!.name,
                    size: FONTSIZE.two,
                  ),
                ),
              ),
          ],
        ),
        if (showNote && Utils.textNotNull(scheduledWorkout.note))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: ReadMoreTextBlock(
              text: scheduledWorkout.note!,
              title: 'Note',
            ),
          ),
        if (Utils.textNotNull(planName))
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ContentBox(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                backgroundColor: context.theme.background,
                child: MyText('Part of $planName')),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLog = scheduledWorkout.loggedWorkoutId != null;
    final enrolmentId = scheduledWorkout.workoutPlanEnrolmentId;
    final planName = scheduledWorkout.workoutPlanName;

    return Card(
      padding: EdgeInsets.zero,
      child: scheduledWorkout.workout == null
          ? Center(
              child: Column(
                children: const [
                  MyText(
                    'No workout specified!',
                    maxLines: 4,
                  ),
                  MyText(
                    '(The workout may have been deleted)',
                    maxLines: 4,
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () => openBottomSheetMenu(
                  context: context,
                  child: BottomSheetMenu(
                    header: BottomSheetMenuHeader(
                      imageUri: scheduledWorkout.workout!.coverImageUri,
                      name: scheduledWorkout.workout!.name,
                      subtitle: 'WORKOUT',
                    ),
                    items: [
                      if (!hasLog)
                        BottomSheetMenuItem(
                          text: 'Do it',
                          onPressed: () => context.navigateTo(
                              DoWorkoutWrapperRoute(
                                  id: scheduledWorkout.workout!.id,
                                  scheduledWorkout: scheduledWorkout,
                                  workoutPlanDayWorkoutId:
                                      scheduledWorkout.workoutPlanDayWorkoutId,
                                  workoutPlanEnrolmentId:
                                      scheduledWorkout.workoutPlanEnrolmentId)),
                          icon: CupertinoIcons.arrow_right_square,
                        ),
                      if (!hasLog && scheduledWorkout.workout != null)
                        BottomSheetMenuItem(
                          text: 'Log it',
                          onPressed: () => context.push(
                              child: PreLoggingModificationsAndUserInputs(
                                  workoutId: scheduledWorkout.workout!.id,
                                  scheduledWorkout: scheduledWorkout,
                                  workoutPlanDayWorkoutId:
                                      scheduledWorkout.workoutPlanDayWorkoutId,
                                  workoutPlanEnrolmentId:
                                      scheduledWorkout.workoutPlanEnrolmentId)),
                          icon: CupertinoIcons.text_badge_checkmark,
                        ),
                      BottomSheetMenuItem(
                          text: 'View Workout',
                          icon: CupertinoIcons.eye,
                          onPressed: () => context.navigateTo(
                              WorkoutDetailsRoute(
                                  id: scheduledWorkout.workout!.id,
                                  scheduledWorkout: scheduledWorkout,
                                  workoutPlanDayWorkoutId:
                                      scheduledWorkout.workoutPlanDayWorkoutId,
                                  workoutPlanEnrolmentId: scheduledWorkout
                                      .workoutPlanEnrolmentId))),
                      if (enrolmentId != null)
                        BottomSheetMenuItem(
                          text: 'View Plan',
                          onPressed: () => context.navigateTo(
                              WorkoutPlanEnrolmentDetailsRoute(
                                  id: scheduledWorkout
                                      .workoutPlanEnrolmentId!)),
                          icon: CupertinoIcons.list_bullet,
                        ),
                      if (hasLog)
                        BottomSheetMenuItem(
                          text: 'View log',
                          onPressed: () => context.navigateTo(
                              LoggedWorkoutDetailsRoute(
                                  id: scheduledWorkout.loggedWorkoutId!)),
                          icon: CupertinoIcons.doc_chart,
                        ),
                      if (!hasLog)
                        BottomSheetMenuItem(
                          text: 'Edit Schedule',
                          onPressed: () => _reschedule(context),
                          icon: CupertinoIcons.calendar_badge_plus,
                        ),
                      if (!hasLog)
                        BottomSheetMenuItem(
                          text: 'Unschedule',
                          onPressed: () => _confirmUnschedule(context),
                          icon: CupertinoIcons.calendar_badge_minus,
                          isDestructive: true,
                        )
                    ],
                  )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, bottom: 8, left: 12, right: 12),
                    child: _buildCardHeader(context, planName, true),
                  ),
                  const HorizontalLine(
                    verticalPadding: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 8,
                    ),
                    child: MinimalWorkoutCard(
                      scheduledWorkout.workout!,
                      showEquipment: true,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
