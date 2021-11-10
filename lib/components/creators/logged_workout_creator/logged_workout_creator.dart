import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/logged_workout_creator_with_sections.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/required_user_inputs.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class LoggedWorkoutCreatorPage extends StatefulWidget {
  final Workout workout;
  final ScheduledWorkout? scheduledWorkout;
  const LoggedWorkoutCreatorPage(
      {Key? key, required this.workout, this.scheduledWorkout})
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
    final result = await bloc.createAndSave(context);

    setState(() {
      _savingToDB = false;
    });

    if (result.hasErrors) {
      context
          .showErrorAlert('Sorry, there was a problem logging this workout!');
    } else {
      await context.showSuccessAlert(
        title: 'Workout Logged!',
        message: 'You can go to Progress -> Logs to view it.',
      );
      context.pop(result: true); // Close the logged workout creator.
    }
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
          scheduledWorkout: widget.scheduledWorkout),
      builder: (context, child) {
        final requireUserInputs =
            context.select<LoggedWorkoutCreatorBloc, bool>(
                (b) => b.loggedWorkout.loggedWorkoutSections.isEmpty);

        return MyPageScaffold(
            navigationBar: MyNavBar(
              customLeading: NavBarCancelButton(_handleCancel),
              middle: NavBarTitle(widget.workout.name),
              trailing: !requireUserInputs
                  ? _savingToDB
                      ? const NavBarTrailingRow(
                          children: [
                            NavBarLoadingDots(),
                          ],
                        )
                      : NavBarSaveButton(
                          () => _saveLogToDB(
                              context.read<LoggedWorkoutCreatorBloc>()),
                          text: 'Log It',
                        )
                  : null,
            ),
            child: AnimatedSwitcher(
              duration: kStandardAnimationDuration,
              child: requireUserInputs
                  ? const RequiredUserInputs()
                  : const LoggedWorkoutCreatorWithSections(),
            ));
      },
    );
  }
}
