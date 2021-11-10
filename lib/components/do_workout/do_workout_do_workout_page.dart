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

class DoWorkoutDoWorkoutPage extends StatelessWidget {
  const DoWorkoutDoWorkoutPage({
    Key? key,
  }) : super(key: key);

  void _navigateToSection(
      BuildContext context, int sectionIndex, int numWorkoutSections) {
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
  }

  Future<void> _generateLog(BuildContext context) async {
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

  void _handleExitRequest(BuildContext context) {
    context.showConfirmDialog(
        title: 'Exit Workout',
        message: 'Nothing will be saved. OK?',
        verb: 'Exit',
        onConfirm: context.popRoute);
  }

  @override
  Widget build(BuildContext context) {
    final numWorkoutSections = context.select<DoWorkoutBloc, int>(
        (b) => b.activeWorkout.workoutSections.length);

    return DoWorkoutOverview(
        handleExitRequest: () => _handleExitRequest(context),
        navigateToSectionPage: (sectionIndex) =>
            _navigateToSection(context, sectionIndex, numWorkoutSections),
        generateLog: () => _generateLog(context));
  }
}
