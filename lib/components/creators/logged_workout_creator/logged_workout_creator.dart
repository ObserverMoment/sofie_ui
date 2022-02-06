import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/blocs/workout_structure_modifications_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/logged_workout_creator_with_sections.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/logged_workout/congratulations_logged_workout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class LoggedWorkoutCreatorPage extends StatefulWidget {
  final Workout workout;
  final List<WorkoutSectionInput> sectionInputs;

  // When present these should be connected to the log
  /// [scheduledWorkout] so that we can add the log to the scheduled workout to mark it as done.
  /// [workoutPlanDayWorkoutId] and [workoutPlanEnrolmentId] so that we can create a [CompletedWorkoutPlanDayWorkout] to mark it as done in the plan.
  final ScheduledWorkout? scheduledWorkout;
  final String? workoutPlanDayWorkoutId;
  final String? workoutPlanEnrolmentId;
  const LoggedWorkoutCreatorPage(
      {Key? key,
      this.scheduledWorkout,
      required this.workout,
      this.workoutPlanDayWorkoutId,
      this.workoutPlanEnrolmentId,
      required this.sectionInputs})
      : super(key: key);

  @override
  _LoggedWorkoutCreatorPageState createState() =>
      _LoggedWorkoutCreatorPageState();
}

class _LoggedWorkoutCreatorPageState extends State<LoggedWorkoutCreatorPage> {
  bool _savingToDB = false;

  Future<void> _saveLogToDB(LoggedWorkoutCreatorBloc bloc) async {
    setState(() {
      _savingToDB = true;
    });

    /// TODO?
    // final result = await bloc.createAndSave(context);

    setState(() {
      _savingToDB = false;
    });

    /// TODO?
    // checkOperationResult(context, result,
    //     onFail: () => context
    //         .showErrorAlert('Sorry, there was a problem logging this workout!'),
    //     onSuccess: () {
    //       context.push(
    //           fullscreenDialog: true,
    //           child: CongratulationsLoggedWorkout(
    //             loggedWorkout: result.data!.createLoggedWorkout,
    //             onExit: () {
    //               context.pop(
    //                   result: true); // Close the logged workout creator.
    //             },
    //           ));
    //     });
  }

  void _handleCancel() {
    context.showConfirmDialog(
        title: 'Leave without Saving?',
        onConfirm: () => context.pop(result: false));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoggedWorkoutCreatorBloc(
          context: context,
          workout: widget.workout,
          sectionInputs: widget.sectionInputs,
          scheduledWorkout: widget.scheduledWorkout,
          workoutPlanDayWorkoutId: widget.workoutPlanDayWorkoutId,
          workoutPlanEnrolmentId: widget.workoutPlanEnrolmentId),
      builder: (context, child) {
        return MyPageScaffold(
          navigationBar: MyNavBar(
            customLeading: NavBarCancelButton(_handleCancel),
            middle: NavBarTitle(widget.workout.name),
            trailing: _savingToDB
                ? const NavBarTrailingRow(
                    children: [
                      NavBarLoadingIndicator(),
                    ],
                  )
                : NavBarSaveButton(
                    () =>
                        _saveLogToDB(context.read<LoggedWorkoutCreatorBloc>()),
                    text: 'Log It',
                  ),
          ),
          child: const LoggedWorkoutCreatorWithSections(),
        );
      },
    );
  }
}
