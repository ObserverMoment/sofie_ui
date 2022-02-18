import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/blocs/workout_structure_modifications_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/pre_log_scores_and_modifications/required_user_input.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/pre_log_scores_and_modifications/section_modifications.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/logged_workout/congratulations_logged_workout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/data_model_converters/workout_to_logged_workout.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

/// Before being routed to the [LoggedWorkoutCreator] the user can make adjustments to any part of the workout and also remove entire sections if they did not do them.
/// On complete this widget passed the modified [Workout] on to the [LoggedWorkoutCreator].
class PreLoggingModificationsAndUserInputs extends StatelessWidget {
  final String workoutId;

  // When present these should be connected to the log
  /// [scheduledWorkout] so that we can add the log to the scheduled workout to mark it as done.
  /// [workoutPlanDayWorkoutId] and [workoutPlanEnrolmentId] so that we can create a [CompletedWorkoutPlanDayWorkout] to mark it as done in the plan.
  final ScheduledWorkout? scheduledWorkout;
  final String? workoutPlanDayWorkoutId;
  final String? workoutPlanEnrolmentId;
  const PreLoggingModificationsAndUserInputs(
      {Key? key,
      required this.workoutId,
      this.scheduledWorkout,
      this.workoutPlanDayWorkoutId,
      this.workoutPlanEnrolmentId})
      : super(key: key);

  Future<void> _createAndSaveLog(
      {required BuildContext context,
      required Workout workout,
      required List<WorkoutSectionInput> sectionInputs}) async {
    context.read<WorkoutStructureModificationsBloc>().setSavingLogToDB(true);

    final loggedWorkout = loggedWorkoutFromWorkout(
        workout: workout,
        completedOn: scheduledWorkout?.scheduledAt,
        note: scheduledWorkout?.note,
        gymProfile: scheduledWorkout?.gymProfile);

    final includedSectionIds =
        context.read<WorkoutStructureModificationsBloc>().includedSectionIds;

    /// Remove the sections that are not included.
    workout.workoutSections = workout.workoutSections
        .where((ws) => includedSectionIds.contains(ws.id))
        .toList();

    loggedWorkout.loggedWorkoutSections =
        LoggedWorkoutCreatorBloc.generateLoggedWorkoutSections(
            workout: workout, sectionInputs: sectionInputs);

    final result = await LoggedWorkoutCreatorBloc.createLoggedWorkoutAndSave(
        context: context,
        loggedWorkout: loggedWorkout.copyAndSortAllChildren,
        scheduledWorkout: scheduledWorkout);

    context.read<WorkoutStructureModificationsBloc>().setSavingLogToDB(false);

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: 'Sorry, something went wrong',
            toastType: ToastType.destructive),
        onSuccess: () {
          context.push(
              fullscreenDialog: true,
              child: CongratulationsLoggedWorkout(
                  onExit: () => context.router.popAndPush(
                      LoggedWorkoutDetailsRoute(
                          id: result.data!.createLoggedWorkout.id)),
                  loggedWorkout: result.data!.createLoggedWorkout));
        });
  }

  @override
  Widget build(BuildContext context) {
    final query =
        WorkoutByIdQuery(variables: WorkoutByIdArguments(id: workoutId));
    return QueryObserver<WorkoutById$Query, WorkoutByIdArguments>(
        key: Key(
            'PreLoggingModificationsAndUserInputs - ${query.operationName}-$workoutId'),
        query: query,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        parameterizeQuery: true,
        builder: (data) => ChangeNotifierProvider(
              create: (context) => WorkoutStructureModificationsBloc(
                context,
                data.workoutById,
              ),
              builder: (context, child) {
                final originalWorkout = data.workoutById;

                final includedSectionIds = context.select<
                    WorkoutStructureModificationsBloc,
                    List<String>>((b) => b.includedSectionIds);

                final sectionInputs = context.select<
                    WorkoutStructureModificationsBloc,
                    List<WorkoutSectionInput>>((b) => b.sectionInputs);

                final _savingLogToDB =
                    context.select<WorkoutStructureModificationsBloc, bool>(
                        (b) => b.savingLogToDB);

                final validInputs = includedSectionIds.isNotEmpty &&
                    includedSectionIds.every((id) {
                      final input = sectionInputs
                          .firstWhereOrNull(
                              (input) => input.workoutSection.id == id)
                          ?.input;
                      return input != null && input != 0;
                    });

                return MyPageScaffold(
                    navigationBar: MyNavBar(
                      customLeading: NavBarCancelButton(context.pop),
                      middle: const NavBarTitle('Scores and Modifications'),
                      trailing: validInputs
                          ? FadeInUp(
                              child: NavBarTertiarySaveButton(
                                () {
                                  final bloc = context.read<
                                      WorkoutStructureModificationsBloc>();
                                  _createAndSaveLog(
                                      context: context,
                                      sectionInputs: bloc.sectionInputs,
                                      workout: bloc.workout);
                                },
                                text: 'Done',
                                loading: _savingLogToDB,
                              ),
                            )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 4, right: 8, bottom: 16),
                          child: MyText(
                            originalWorkout.name,
                            size: FONTSIZE.four,
                            weight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (c, i) => Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: _WorkoutSectionCard(
                                        workoutSection:
                                            originalWorkout.workoutSections[i],
                                        includedSectionIds: includedSectionIds,
                                        toggleIncludeSectionId: (id) => context
                                            .read<
                                                WorkoutStructureModificationsBloc>()
                                            .toggleIncludeSectionId(id),
                                      ),
                                    ),
                                itemCount:
                                    originalWorkout.workoutSections.length)),
                      ],
                    ));
              },
            ));
  }
}

class _WorkoutSectionCard extends StatelessWidget {
  final WorkoutSection workoutSection;
  final List<String> includedSectionIds;
  final void Function(String id) toggleIncludeSectionId;
  const _WorkoutSectionCard(
      {Key? key,
      required this.workoutSection,
      required this.includedSectionIds,
      required this.toggleIncludeSectionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final included = includedSectionIds.contains(workoutSection.id);

    final sectionInput =
        context.select<WorkoutStructureModificationsBloc, WorkoutSectionInput>(
            (b) => b.sectionInputs.firstWhere(
                (input) => input.workoutSection.id == workoutSection.id));

    return ContentBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyHeaderText(
                      workoutSection.name ??
                          'Section ${workoutSection.sortPosition + 1}',
                      lineHeight: 1.5,
                    ),
                    MyText(
                      workoutSection.workoutSectionType.name,
                      color: Styles.primaryAccent,
                      lineHeight: 1.5,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedSwitcher(
                            duration: kStandardAnimationDuration,
                            child: included
                                ? const MyText(
                                    'COMPLETED',
                                    size: FONTSIZE.one,
                                  )
                                : const MyText(
                                    'NOT COMPLETED',
                                    size: FONTSIZE.one,
                                    color: Styles.errorRed,
                                  )),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () =>
                              toggleIncludeSectionId(workoutSection.id),
                          child: AnimatedSwitcher(
                              duration: kStandardAnimationDuration,
                              child: included
                                  ? const Icon(
                                      CupertinoIcons.checkmark_alt_circle_fill,
                                      size: 36,
                                      color: Styles.primaryAccent,
                                    )
                                  : const Opacity(
                                      opacity: 0.6,
                                      child: Icon(
                                        CupertinoIcons.clear_circled_solid,
                                        size: 36,
                                      ),
                                    )),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TertiaryButton(
              backgroundColor: context.theme.background,
              suffixIconData: CupertinoIcons.pen,
              iconSize: 14,
              text: 'Make Modifications',
              onPressed: () async {
                final bloc = context.read<WorkoutStructureModificationsBloc>();
                final willRequireInputRefreshAfter = !bloc.typesInputRequired
                    .contains(workoutSection.workoutSectionType.name);

                await Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: bloc,
                    child: PreLoggingSectionModifications(
                      sectionIndex: workoutSection.sortPosition,
                    ),
                  ),
                ));

                /// If the section is a timed section then update the section time taken based on the new changes.
                if (willRequireInputRefreshAfter) {
                  bloc.refreshTimedSectionInput(workoutSection.id);
                }
              },
            ),
          ),
          RequiredUserInput(
            updateSectionInput: context
                .read<WorkoutStructureModificationsBloc>()
                .updateSectionInput,
            workoutSectionWithInput: sectionInput,
          ),
        ],
      ),
    );
  }
}
