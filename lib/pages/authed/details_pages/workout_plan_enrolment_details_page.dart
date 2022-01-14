import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/review_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/navigation.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_goals.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_meta.dart';
import 'package:sofie_ui/components/workout_plan/workout_plan_participants.dart';
import 'package:sofie_ui/components/workout_plan_enrolment/workout_plan_enrolment_progress_summary.dart';
import 'package:sofie_ui/components/workout_plan_enrolment/workout_plan_enrolment_workouts_progress.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class WorkoutPlanEnrolmentDetailsPage extends StatefulWidget {
  final String id;
  const WorkoutPlanEnrolmentDetailsPage(
      {Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  _WorkoutPlanEnrolmentDetailsPageState createState() =>
      _WorkoutPlanEnrolmentDetailsPageState();
}

class _WorkoutPlanEnrolmentDetailsPageState
    extends State<WorkoutPlanEnrolmentDetailsPage> {
  /// 0 = Schedule List. 1 = Goals HeatMap / Calendar. 2 = Participants. 3 = reviews.
  int _activeTabIndex = 0;

  void _handleTabChange(int index) {
    setState(() => _activeTabIndex = index);
  }

  void _confirmSchedulePlan() {
    context.showConfirmDialog(
        title: 'Schedule Plan',
        verb: 'Schedule Plan',
        message:
            'All workouts will be added to your calendar, starting from your chosen date and time. Any previous schedule will be cleared.',
        onConfirm: () => _selectScheduleStartDate());
  }

  void _selectScheduleStartDate() {
    context.showBottomSheet(
        child: DateTimePicker(
      saveDateTime: _createScheduleForPlanEnrolment,
      title: 'Start Date and Time',
    ));
  }

  Future<void> _createScheduleForPlanEnrolment(DateTime startDate) async {
    final variables = CreateScheduleForPlanEnrolmentArguments(
        data: CreateScheduleForPlanEnrolmentInput(
            startDate: startDate, workoutPlanEnrolmentId: widget.id));

    final result = await context.graphQLStore.mutate(
        mutation: CreateScheduleForPlanEnrolmentMutation(variables: variables),
        refetchQueryIds: [
          GQLOpNames.userScheduledWorkouts,
          GQLOpNames.workoutPlanEnrolments
        ],
        broadcastQueryIds: [
          GQLVarParamKeys.workoutPlanEnrolmentById(widget.id),
        ]);

    checkOperationResult(
      context,
      result,
      onFail: () => context.showToast(
          message: 'Sorry, there was a problem',
          toastType: ToastType.destructive),
      onSuccess: () => context.showToast(
        message:
            'Plan scheduled! 1st workout on ${startDate.compactDateString}',
      ),
    );
  }

  void _confirmClearSchedule() {
    context.showConfirmDialog(
        title: 'Clear Plan Schedule',
        message:
            'All workouts from this plan will be removed from your calendar.',
        onConfirm: _clearScheduleForPlanEnrolment);
  }

  Future<void> _clearScheduleForPlanEnrolment() async {
    final variables =
        ClearScheduleForPlanEnrolmentArguments(enrolmentId: widget.id);

    final result = await context.graphQLStore.mutate(
        mutation: ClearScheduleForPlanEnrolmentMutation(variables: variables),
        refetchQueryIds: [
          GQLOpNames.userScheduledWorkouts,
          GQLOpNames.workoutPlanEnrolments
        ],
        broadcastQueryIds: [
          GQLVarParamKeys.workoutPlanEnrolmentById(widget.id),
        ]);

    checkOperationResult(
      context,
      result,
      onFail: () => context.showToast(
          message: 'Sorry, there was a problem',
          toastType: ToastType.destructive),
      onSuccess: () => context.showToast(
        message: 'Plan schedule removed from your calendar.',
      ),
    );
  }

  /// Deletes all [CompletedWorkoutplanDayWorkouts] from the enrolment - for full reset.
  void _confirmClearAllProgress() {
    context.showConfirmDialog(
        title: 'Clear All Progress',
        message:
            'All progress will be reset. Logged workouts will not be deleted, but they will no longer count towards progress in this plan.',
        onConfirm: _clearWorkoutPlanEnrolmentProgres);
  }

  Future<void> _clearWorkoutPlanEnrolmentProgres() async {
    final variables =
        ClearWorkoutPlanEnrolmentProgressArguments(enrolmentId: widget.id);

    final result = await context.graphQLStore.mutate(
        mutation:
            ClearWorkoutPlanEnrolmentProgressMutation(variables: variables),
        refetchQueryIds: [
          GQLOpNames.workoutPlanEnrolments
        ],
        broadcastQueryIds: [
          GQLVarParamKeys.workoutPlanEnrolmentById(widget.id),
        ]);

    checkOperationResult(
      context,
      result,
      onFail: () => context.showToast(
          message: 'Sorry, there was a problem',
          toastType: ToastType.destructive),
      onSuccess: () => context.showToast(
        message: 'Plan progress has been reset.',
      ),
    );
  }

  Future<void> _shareWorkoutPlan(WorkoutPlan workoutPlan) async {
    await SharingAndLinking.shareLink(
        'workout-plan/${workoutPlan.id}', 'Check out this workout plan!');
  }

  void _confirmLeavePlan(WorkoutPlan workoutPlan) {
    context.showConfirmDialog(
        title: 'Leave Plan?',
        message:
            'Progress within the plan will not be saved. Your logged workouts will not be affected. OK?',
        verb: 'Leave',
        onConfirm: () => _deleteWorkoutPlanEnrolmentById(workoutPlan));
  }

  /// I.e unenrol the user from the plan.
  Future<void> _deleteWorkoutPlanEnrolmentById(WorkoutPlan workoutPlan) async {
    final variables = DeleteWorkoutPlanEnrolmentByIdArguments(id: widget.id);

    final result = await context.graphQLStore.delete<
            DeleteWorkoutPlanEnrolmentById$Mutation,
            DeleteWorkoutPlanEnrolmentByIdArguments>(
        mutation: DeleteWorkoutPlanEnrolmentByIdMutation(variables: variables),
        objectId: widget.id,
        typename: kWorkoutPlanEnrolmentWithPlanTypename,
        processResult: (data) {
          /// Remove the [WorkoutPlanEnrolmentSummary].
          final summaryKey =
              '$kWorkoutPlanEnrolmentSummaryTypename:${widget.id}';
          context.graphQLStore.deleteNormalizedObject(summaryKey);
          context.graphQLStore.removeAllQueryRefsToId(summaryKey);

          /// Remove the enrolment from the [WorkoutPlan] in store then re-write.
          final String? authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
          final planKey = '$kWorkoutPlanTypename:${workoutPlan.id}';
          final plan = WorkoutPlan.fromJson(
              context.graphQLStore.readDenomalized(planKey));
          plan.workoutPlanEnrolments
              .removeWhere((e) => e.user.id == authedUserId);

          context.graphQLStore.writeDataToStore(data: plan.toJson());
        },
        broadcastQueryIds: [
          GQLOpNames.workoutPlanEnrolments,
          GQLVarParamKeys.workoutPlanById(workoutPlan.id)
        ],
        clearQueryDataAtKeys: [
          GQLVarParamKeys.workoutPlanEnrolmentById(widget.id),
        ]);

    if (result.hasErrors) {
      context.showErrorAlert(
          'Something went wrong, there was an issue leaving the plan.');
    } else {
      context.pop(); // This screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = WorkoutPlanEnrolmentByIdQuery(
        variables: WorkoutPlanEnrolmentByIdArguments(id: widget.id));

    return QueryObserver<WorkoutPlanEnrolmentById$Query,
            WorkoutPlanEnrolmentByIdArguments>(
        key: Key(
            'WorkoutPlanEnrolmentDetailsPage - ${query.operationName}-${widget.id}'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final enrolmentWithPlan = data.workoutPlanEnrolmentById;
          final enrolment = enrolmentWithPlan.workoutPlanEnrolment;
          final workoutPlan = enrolmentWithPlan.workoutPlan;

          final String? authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
          final WorkoutPlanReview? authedUserReview = enrolmentWithPlan
              .workoutPlan.workoutPlanReviews
              .firstWhereOrNull((r) => r.user.id == authedUserId);

          return MyPageScaffold(
              navigationBar: MyNavBar(
                middle: NavBarTitle(workoutPlan.name),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.ellipsis),
                  onPressed: () => openBottomSheetMenu(
                      context: context,
                      child: BottomSheetMenu(
                          header: BottomSheetMenuHeader(
                            name: workoutPlan.name,
                            subtitle: 'Plan progress',
                            imageUri: workoutPlan.coverImageUri,
                          ),
                          items: [
                            BottomSheetMenuItem(
                                text: enrolment.startDate == null
                                    ? 'Schedule All Workouts'
                                    : 'Re-schedule All Workouts',
                                icon: CupertinoIcons.calendar_badge_plus,
                                onPressed: _confirmSchedulePlan),
                            if (enrolment.startDate != null)
                              BottomSheetMenuItem(
                                  text: 'Clear Plan Schedule',
                                  icon: CupertinoIcons.calendar_badge_minus,
                                  onPressed: _confirmClearSchedule),
                            if (enrolment
                                .completedWorkoutPlanDayWorkouts.isNotEmpty)
                              BottomSheetMenuItem(
                                  text: 'Reset progress',
                                  icon: CupertinoIcons.refresh_bold,
                                  onPressed: _confirmClearAllProgress),
                            BottomSheetMenuItem(
                                text: 'Share plan',
                                icon: CupertinoIcons.paperplane,
                                onPressed: () =>
                                    _shareWorkoutPlan(workoutPlan)),
                            BottomSheetMenuItem(
                                text: 'Leave plan',
                                isDestructive: true,
                                icon: CupertinoIcons.square_arrow_right,
                                onPressed: () =>
                                    _confirmLeavePlan(workoutPlan)),
                          ])),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    child: WorkoutPlanEnrolmentProgressSummary(
                        completed:
                            enrolment.completedWorkoutPlanDayWorkouts.length,
                        startedOn: enrolment.startDate,
                        total: workoutPlan.workoutsInPlan.length),
                  ),
                  MyTabBarNav(
                      titles: const [
                        'Progress',
                        'Info',
                        'Goals',
                        'Reviews',
                        'People',
                      ],
                      handleTabChange: _handleTabChange,
                      activeTabIndex: _activeTabIndex),
                  Expanded(
                    child: IndexedStack(index: _activeTabIndex, children: [
                      WorkoutPlanEnrolmentProgress(
                        enrolmentWithPlan: enrolmentWithPlan,
                      ),
                      WorkoutPlanMeta(
                          workoutPlan: workoutPlan,
                          allEquipment: workoutPlan.allEquipment,
                          showSaveIcon: false,
                          collections: const [],
                          hasEnrolled: true),
                      WorkoutPlanGoals(
                        workoutPlan: workoutPlan,
                      ),
                      _YourReviewDisplay(
                        enrolmentWithPlan: enrolmentWithPlan,
                        authedUserReview: authedUserReview,
                      ),
                      WorkoutPlanParticipants(
                        workoutPlan: workoutPlan,
                      )
                    ]),
                  ),
                ],
              ));
        });
  }
}

class _YourReviewDisplay extends StatelessWidget {
  final WorkoutPlanEnrolmentWithPlan enrolmentWithPlan;
  final WorkoutPlanReview? authedUserReview;
  const _YourReviewDisplay({
    Key? key,
    required this.enrolmentWithPlan,
    required this.authedUserReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enrolment = enrolmentWithPlan.workoutPlanEnrolment;
    final workoutPlan = enrolmentWithPlan.workoutPlan;

    final otherReviews = authedUserReview == null
        ? workoutPlan.workoutPlanReviews
        : workoutPlan.workoutPlanReviews
            .where((r) => r.id != authedUserReview!.id);

    final sortedReviews = otherReviews.sortedBy<DateTime>((r) => r.createdAt);

    return SingleChildScrollView(
      child: authedUserReview != null
          ? Column(
              children: [
                const SizedBox(height: 10),
                const MyText('Your Review'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: WorkoutPlanReviewCard(
                    review: authedUserReview!,
                  ),
                ),
                const SizedBox(height: 10),
                BorderButton(
                  mini: true,
                  prefix: const Icon(
                    CupertinoIcons.star_fill,
                    color: Styles.primaryAccent,
                    size: 14,
                  ),
                  text: 'Edit Review',
                  onPressed: () =>
                      context.pushRoute(WorkoutPlanReviewCreatorRoute(
                    parentWorkoutPlanEnrolmentId: enrolment.id,
                    parentWorkoutPlanId: workoutPlan.id,
                    workoutPlanReview: authedUserReview,
                  )),
                ),
                const SizedBox(height: 24),
                const HorizontalLine(),
                if (sortedReviews.isNotEmpty)
                  ListView(
                    shrinkWrap: true,
                    children: sortedReviews
                        .map((r) => WorkoutPlanReviewCard(
                              review: r,
                            ))
                        .toList(),
                  ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BorderButton(
                    mini: true,
                    prefix: const Icon(
                      CupertinoIcons.star_fill,
                      color: Styles.primaryAccent,
                      size: 14,
                    ),
                    text: 'Leave Review',
                    onPressed: () =>
                        context.pushRoute(WorkoutPlanReviewCreatorRoute(
                      parentWorkoutPlanEnrolmentId: enrolment.id,
                      parentWorkoutPlanId: workoutPlan.id,
                    )),
                  ),
                ],
              ),
            ),
    );
  }
}
