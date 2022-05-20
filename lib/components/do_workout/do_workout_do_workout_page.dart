import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/components/do_workout/do_workout_overview_page.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section.dart';
import 'package:sofie_ui/components/logged_workout/congratulations_logged_workout.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

/// This widget is watching app state to check when it is moved into the background by the user.
/// When moved into the background we pause the workout.
/// When moved back into the foreground we resume the workout or prompt the user to resume manually (TBD).
class DoWorkoutDoWorkoutPage extends StatefulWidget {
  const DoWorkoutDoWorkoutPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DoWorkoutDoWorkoutPage> createState() => _DoWorkoutDoWorkoutPageState();
}

class _DoWorkoutDoWorkoutPageState extends State<DoWorkoutDoWorkoutPage>
    with WidgetsBindingObserver {
  int? _activeSectionIndex;

  /// If a section is playing when a user puts the app into the background then we pause the section and set this to true.
  /// When the user re-foregrounds the app, if this is true, we resume (play) the section and set this back to the default of false;
  bool _sectionPausedInBackground = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _activeSectionIndex != null) {
      if (context
          .read<DoWorkoutBloc>()
          .getStopWatchTimerForSection(_activeSectionIndex!)
          .isRunning) {
        context.read<DoWorkoutBloc>().pauseSection(_activeSectionIndex!);
        _sectionPausedInBackground = true;
      }
    } else if (state == AppLifecycleState.resumed &&
        _activeSectionIndex != null &&
        _sectionPausedInBackground) {
      context.read<DoWorkoutBloc>().playSection(_activeSectionIndex!);
      _sectionPausedInBackground = false;
    }
  }

  /// Navigating to a section is equivalent to making it "active"
  void _navigateToSection(int sectionIndex, int numWorkoutSections) async {
    final bloc = context.read<DoWorkoutBloc>();
    _activeSectionIndex = sectionIndex;
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ChangeNotifierProvider<DoWorkoutBloc>.value(
          value: bloc,
          builder: (context, child) => DoWorkoutSection(
            key: Key(sectionIndex.toString()),
            sectionIndex: sectionIndex,
          ),
        ),
      ),
    );

    /// Once user has popped the DoSection page it is no longer active.
    _activeSectionIndex = null;
  }

  Future<void> _generateLog() async {
    final loggedWorkoutInput =
        context.read<DoWorkoutBloc>().generateLogInputData();

    context.showConfirmDialog(
        title: 'Save Log and Exit?',
        message:
            'This will save your workout to a log and then end the workout session.',
        verb: 'Save',
        onConfirm: () async {
          /// Save log to DB.
          final variables =
              CreateLoggedWorkoutArguments(data: loggedWorkoutInput);

          final result = await context.graphQLStore.create(
              mutation: CreateLoggedWorkoutMutation(variables: variables),
              addRefToQueries: [GQLOpNames.userLoggedWorkouts]);

          checkOperationResult(context, result,
              onFail: () => context.showToast(
                  message: 'Sorry, something went wrong',
                  toastType: ToastType.destructive),
              onSuccess: () {
                /// If the log is being created from a scheduled workout then we need to add the newly completed workout log to the scheduledWorkout.loggedWorkout in the store.

                if (loggedWorkoutInput.scheduledWorkout != null) {
                  LoggedWorkoutCreatorBloc.updateScheduleWithLoggedWorkout(
                      context,
                      context.read<DoWorkoutBloc>().scheduledWorkout!,
                      result.data!.createLoggedWorkout);
                }
                if (loggedWorkoutInput.workoutPlanDayWorkout != null &&
                    loggedWorkoutInput.workoutPlanEnrolment != null) {
                  LoggedWorkoutCreatorBloc.refetchWorkoutPlanEnrolmentQueries(
                      context,
                      context.read<DoWorkoutBloc>().workoutPlanEnrolmentId!);
                }

                context.push(
                    fullscreenDialog: true,
                    child: CongratulationsLoggedWorkout(
                        onExit: () => context.router.popAndPush(
                            LoggedWorkoutDetailsRoute(
                                id: result.data!.createLoggedWorkout.id)),
                        loggedWorkout: result.data!.createLoggedWorkout));
              });
        });
  }

  void _handleExitRequest() {
    context.showConfirmDialog(
        title: 'Exit Workout',
        message: 'Nothing will be saved. OK?',
        verb: 'Exit',
        onConfirm: context.popRoute);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numWorkoutSections = context.select<DoWorkoutBloc, int>(
        (b) => b.activeWorkout.workoutSections.length);

    return DoWorkoutOverview(
        handleExitRequest: () => _handleExitRequest(),
        navigateToSectionPage: (sectionIndex) =>
            _navigateToSection(sectionIndex, numWorkoutSections),
        generateLog: () => _generateLog());
  }
}
