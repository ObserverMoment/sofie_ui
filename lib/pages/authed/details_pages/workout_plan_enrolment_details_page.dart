import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
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
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

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

  Future<void> _updateStartDate(WorkoutPlanEnrolment enrolment) async {
    context.showBottomSheet(
        expand: false,
        child: DateTimePicker(
          title: 'Change Start Date',
          dateTime: enrolment.startDate,
          showDate: true,
          showTime: false,
          saveDateTime: (newDate) async {
            final variables = UpdateWorkoutPlanEnrolmentArguments(
                data: UpdateWorkoutPlanEnrolmentInput(id: ''));

            final result = await context.graphQLStore.mutate<
                    UpdateWorkoutPlanEnrolment$Mutation,
                    UpdateWorkoutPlanEnrolmentArguments>(
                mutation:
                    UpdateWorkoutPlanEnrolmentMutation(variables: variables),
                broadcastQueryIds: [
                  GQLVarParamKeys.workoutPlanByEnrolmentId(enrolment.id),
                  EnrolledWorkoutPlansQuery().operationName,
                ],
                customVariablesMap: {
                  'data': {
                    'id': enrolment.id,
                    'startDate': newDate.millisecondsSinceEpoch
                  }
                });

            if (result.hasErrors) {
              context.showErrorAlert(
                  'Something went wrong, the update did not work.');
            }
          },
        ));
  }

  void _confirmResetPlan() {
    context.showConfirmDialog(
        title: 'Reset Plan Progress?',
        verb: 'Reset Progress',
        message: 'All completed workout progress will be cleared. OK?',
        onConfirm: _resetCompletedWorkoutPlanDayWorkoutIds);
  }

  Future<void> _resetCompletedWorkoutPlanDayWorkoutIds() async {
    final variables = UpdateWorkoutPlanEnrolmentArguments(
        data: UpdateWorkoutPlanEnrolmentInput(id: ''));

    final result = await context.graphQLStore.mutate<
            UpdateWorkoutPlanEnrolment$Mutation,
            UpdateWorkoutPlanEnrolmentArguments>(
        mutation: UpdateWorkoutPlanEnrolmentMutation(variables: variables),
        broadcastQueryIds: [
          GQLVarParamKeys.workoutPlanByEnrolmentId(widget.id),
          EnrolledWorkoutPlansQuery().operationName,
        ],
        customVariablesMap: {
          'data': {'id': widget.id, 'completedPlanDayWorkoutIds': []}
        });

    if (result.hasErrors) {
      context.showErrorAlert('Something went wrong, the update did not work.');
    } else {
      context.showToast(message: 'Plan progress reset');
    }
  }

  Future<void> _shareWorkoutPlan(WorkoutPlan workoutPlan) async {
    await SharingAndLinking.shareLink(
        'workout-plan/${workoutPlan.id}', 'Check out this workout plan!');
  }

  void _confirmLeavePlan() {
    context.showConfirmDialog(
        title: 'Leave Plan?',
        message:
            'Progress within the plan will not be saved. Your logged workouts will not be affected. OK?',
        verb: 'Leave',
        onConfirm: _deleteWorkoutPlanEnrolmentById);
  }

  /// I.e unenrol the user from the plan.
  Future<void> _deleteWorkoutPlanEnrolmentById() async {
    final variables = DeleteWorkoutPlanEnrolmentByIdArguments(id: widget.id);

    final result = await context.graphQLStore.delete<
            DeleteWorkoutPlanEnrolmentById$Mutation,
            DeleteWorkoutPlanEnrolmentByIdArguments>(
        objectId: widget.id,
        typename: kWorkoutPlanEnrolmentTypename,
        mutation: DeleteWorkoutPlanEnrolmentByIdMutation(variables: variables),
        removeRefFromQueries: [EnrolledWorkoutPlansQuery().operationName]);

    if (result.hasErrors) {
      context.showErrorAlert(
          'Something went wrong, there was an issue leaving the plan.');
    } else {
      context.pop(); // This screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = WorkoutPlanByEnrolmentIdQuery(
        variables: WorkoutPlanByEnrolmentIdArguments(id: widget.id));

    return QueryObserver<WorkoutPlanByEnrolmentId$Query,
            WorkoutPlanByEnrolmentIdArguments>(
        key: Key(
            'WorkoutPlanEnrolmentDetailsPage - ${query.operationName}-${widget.id}'),
        query: query,
        parameterizeQuery: true,
        loadingIndicator: const ShimmerDetailsPage(title: 'Getting Ready'),
        builder: (data) {
          final workoutPlan = data.workoutPlanByEnrolmentId;

          final enrolments = workoutPlan.workoutPlanEnrolments;

          /// No else null fallback specified because the user should not be on this page if they are not enrolled in this plan.
          final enrolment = enrolments.firstWhere((e) => e.id == widget.id);

          final String? authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
          final WorkoutPlanReview? authedUserReview = workoutPlan
              .workoutPlanReviews
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
                                text: 'Reset progress',
                                icon: const Icon(CupertinoIcons.refresh_bold),
                                onPressed: _confirmResetPlan),
                            BottomSheetMenuItem(
                                text: 'Change start date',
                                icon: const Icon(CupertinoIcons.calendar_today),
                                onPressed: () => _updateStartDate(enrolment)),
                            BottomSheetMenuItem(
                                text: 'Share plan',
                                icon: const Icon(CupertinoIcons.paperplane),
                                onPressed: () =>
                                    _shareWorkoutPlan(workoutPlan)),
                            BottomSheetMenuItem(
                                text: 'Leave plan',
                                isDestructive: true,
                                icon: const Icon(
                                  CupertinoIcons.square_arrow_right,
                                  color: Styles.errorRed,
                                ),
                                onPressed: _confirmLeavePlan),
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
                        workoutPlan: workoutPlan, enrolment: enrolment),
                  ),
                  MyTabBarNav(
                      titles: const [
                        'Progress',
                        'Info',
                        'Goals',
                        'Reviews',
                        'Social',
                      ],
                      handleTabChange: _handleTabChange,
                      activeTabIndex: _activeTabIndex),
                  Expanded(
                    child: IndexedStack(index: _activeTabIndex, children: [
                      WorkoutPlanEnrolmentWorkoutsProgress(
                        workoutPlan: workoutPlan,
                        enrolment: enrolment,
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
                        workoutPlanEnrolment: enrolment,
                        authedUserReview: authedUserReview,
                        workoutPlan: workoutPlan,
                      ),
                      WorkoutPlanParticipants(
                        userSummaries: enrolments.map((e) => e.user).toList(),
                      )
                    ]),
                  ),
                ],
              ));
        });
  }
}

class _YourReviewDisplay extends StatelessWidget {
  final WorkoutPlanEnrolment workoutPlanEnrolment;
  final WorkoutPlan workoutPlan;
  final WorkoutPlanReview? authedUserReview;
  const _YourReviewDisplay(
      {Key? key,
      required this.workoutPlanEnrolment,
      required this.authedUserReview,
      required this.workoutPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    color: Styles.secondaryAccent,
                    size: 14,
                  ),
                  text: 'Edit Review',
                  onPressed: () =>
                      context.pushRoute(WorkoutPlanReviewCreatorRoute(
                    parentWorkoutPlanEnrolmentId: workoutPlanEnrolment.id,
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
                      color: Styles.secondaryAccent,
                      size: 14,
                    ),
                    text: 'Leave Review',
                    onPressed: () =>
                        context.pushRoute(WorkoutPlanReviewCreatorRoute(
                      parentWorkoutPlanEnrolmentId: workoutPlanEnrolment.id,
                      parentWorkoutPlanId: workoutPlan.id,
                    )),
                  ),
                ],
              ),
            ),
    );
  }
}