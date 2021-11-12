import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/components/do_workout/do_workout_overview_page.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
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

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _activeSectionIndex != null) {
      context.read<DoWorkoutBloc>().pauseSection(_activeSectionIndex!);
    } else if (state == AppLifecycleState.resumed &&
        _activeSectionIndex != null) {
      context.read<DoWorkoutBloc>().playSection(_activeSectionIndex!);
    }
  }

  /// Navigating to a section is equivalent to making it "active"
  void _navigateToSection(int sectionIndex, int numWorkoutSections) {
    final _bloc = context.read<DoWorkoutBloc>();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ChangeNotifierProvider<DoWorkoutBloc>.value(
          value: _bloc,
          builder: (context, child) => DoWorkoutSection(
            key: Key(sectionIndex.toString()),
            sectionIndex: sectionIndex,
          ),
        ),
      ),
    );
    _activeSectionIndex = sectionIndex;
  }

  Future<void> _generateLog() async {
    final loggedWorkout = context.read<DoWorkoutBloc>().generateLog();
    final scheduledWorkout = context.read<DoWorkoutBloc>().scheduledWorkout;

    context.showConfirmDialog(
        title: 'Save Log and Exit?',
        message:
            'This will save your workout to a log and then end the workout session.',
        verb: 'Save',
        onConfirm: () async {
          /// Save log to DB.
          final input = LoggedWorkoutCreatorBloc
              .createLoggedWorkoutInputFromLoggedWorkout(
                  loggedWorkout, scheduledWorkout);

          final variables = CreateLoggedWorkoutArguments(data: input);

          final result = await context.graphQLStore.create(
              mutation: CreateLoggedWorkoutMutation(variables: variables),
              addRefToQueries: [GQLNullVarsKeys.userLoggedWorkoutsQuery]);

          await checkOperationResult(context, result);

          /// If the log is being created from a scheduled workout then we need to add the newly completed workout log to the scheduledWorkout.loggedWorkout in the store.
          if (scheduledWorkout != null && result.data != null) {
            LoggedWorkoutCreatorBloc.updateScheduleWithLoggedWorkout(
                context, scheduledWorkout, result.data!.createLoggedWorkout);
          }

          context.router.popAndPush(LoggedWorkoutDetailsRoute(
              id: result.data!.createLoggedWorkout.id));
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
    WidgetsBinding.instance!.removeObserver(this);
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