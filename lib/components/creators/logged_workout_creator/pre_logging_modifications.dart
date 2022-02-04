import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/blocs/workout_structure_modifications_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/required_user_inputs.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/services/utils.dart';

/// Before being routed to the [LoggedWorkoutCreator] the user can make adjustments to any part of the workout and also remove entire sections if they did not do them.
/// On complete this widget passed the modified [Workout] on to the [LoggedWorkoutCreator].
class PreLoggingModifications extends StatefulWidget {
  final String workoutId;

  // When present these should be connected to the log
  /// [scheduledWorkout] so that we can add the log to the scheduled workout to mark it as done.
  /// [workoutPlanDayWorkoutId] and [workoutPlanEnrolmentId] so that we can create a [CompletedWorkoutPlanDayWorkout] to mark it as done in the plan.
  final ScheduledWorkout? scheduledWorkout;
  final String? workoutPlanDayWorkoutId;
  final String? workoutPlanEnrolmentId;
  const PreLoggingModifications(
      {Key? key,
      required this.workoutId,
      this.scheduledWorkout,
      this.workoutPlanDayWorkoutId,
      this.workoutPlanEnrolmentId})
      : super(key: key);

  @override
  _PreLoggingModificationsState createState() =>
      _PreLoggingModificationsState();
}

class _PreLoggingModificationsState extends State<PreLoggingModifications> {
  @override
  Widget build(BuildContext context) {
    final query =
        WorkoutByIdQuery(variables: WorkoutByIdArguments(id: widget.workoutId));
    return QueryObserver<WorkoutById$Query, WorkoutByIdArguments>(
        key: Key(
            'PreLoggingModifications - ${query.operationName}-${widget.workoutId}'),
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

                return MyPageScaffold(
                    navigationBar: MyNavBar(
                      customLeading: NavBarCancelButton(context.pop),
                      middle: const NavBarTitle('Any Modifications?'),
                      trailing: NavBarTertiarySaveButton(
                        () => context.router.popAndPush(
                            LoggedWorkoutCreatorRoute(
                                workout: context
                                    .read<WorkoutStructureModificationsBloc>()
                                    .workout)),
                        text: 'Done',
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyText(
                            originalWorkout.name,
                            size: FONTSIZE.four,
                            weight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (c, i) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _WorkoutSectionCard(
                                        includedWorkoutSectionIds: [],
                                        workoutSection:
                                            originalWorkout.workoutSections[i],
                                      ),
                                    ),
                                separatorBuilder: (c, i) =>
                                    const HorizontalLine(),
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
  final List<String> includedWorkoutSectionIds;
  const _WorkoutSectionCard(
      {Key? key,
      required this.workoutSection,
      required this.includedWorkoutSectionIds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final included = true;

    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WorkoutSectionTypeTag(
                    withBackground: false,
                    workoutSection: workoutSection,
                    fontSize: FONTSIZE.five,
                    showMediaIcons: false,
                  ),
                  MyText(
                    Utils.textNotNull(workoutSection.name)
                        ? workoutSection.name!
                        : 'Section ${workoutSection.sortPosition + 1}',
                    size: FONTSIZE.four,
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
                              ? MyText(
                                  'INCLUDED',
                                  size: FONTSIZE.one,
                                )
                              : MyText(
                                  'EXCLUDED',
                                  size: FONTSIZE.one,
                                )),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => {},
                        child: AnimatedSwitcher(
                            duration: kStandardAnimationDuration,
                            child: included
                                ? Icon(
                                    CupertinoIcons.checkmark_alt_circle_fill,
                                    size: 40,
                                    color: Styles.primaryAccent,
                                  )
                                : Opacity(
                                    opacity: 0.6,
                                    child: Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      size: 40,
                                    ),
                                  )),
                      )
                    ],
                  ),
                  TertiaryButton(
                      text: 'Make Adjustments',
                      onPressed: () => print('open section mods')),
                ],
              ),
            ],
          ),
          MyText('If input is required then ask for it here'),
          RequiredUserInput(
            updateSectionInput: (String workoutSectionId, int input) {},
            workoutSectionWithInput: WorkoutSectionWithInput(
                workoutSection: workoutSection, input: 20),
          ),
        ],
      ),
    );
  }
}
