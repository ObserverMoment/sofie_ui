import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/workout_card_minimal.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/components/user_input/selectors/gym_profile_selector.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/model/toast_request.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';

/// [scheduledOn] will be ignored if [scheduledWorkout] is present.
/// Otherwise it will be set as the initial date when the widget is opened.
class ScheduledWorkoutCreatorPage extends StatefulWidget {
  final ScheduledWorkout? scheduledWorkout;
  final WorkoutSummary? workout;
  final DateTime? scheduleOn;
  final String? workoutPlanEnrolmentId;
  const ScheduledWorkoutCreatorPage({
    Key? key,
    this.scheduledWorkout,
    this.workout,
    this.scheduleOn,
    this.workoutPlanEnrolmentId,
  })  : assert(scheduledWorkout != null || workout != null),
        super(key: key);

  @override
  _ScheduledWorkoutCreatorPageState createState() =>
      _ScheduledWorkoutCreatorPageState();
}

class _ScheduledWorkoutCreatorPageState
    extends State<ScheduledWorkoutCreatorPage> {
  late ScheduledWorkout _activeScheduledWorkout;
  late bool _isCreate;
  bool _loading = false;

  ScheduledWorkout _defaultScheduledWorkout() {
    return ScheduledWorkout()
      ..id = 'tempId'
      ..workout = widget.workout
      ..workoutPlanEnrolmentId = widget.workoutPlanEnrolmentId
      ..scheduledAt = widget.scheduleOn ?? DateTime.now();
  }

  @override
  void initState() {
    _isCreate = widget.scheduledWorkout == null;

    _activeScheduledWorkout = widget.scheduledWorkout != null
        ? ScheduledWorkout.fromJson(widget.scheduledWorkout!.toJson())
        : _defaultScheduledWorkout();

    super.initState();
  }

  String _formatDateTime(DateTime dateTime) => dateTime.dateAndTime;

  /// Handles creating a new scheduledWorkout and updating an existing one.
  Future<void> _schedule() async {
    setState(() => _loading = true);
    if (_isCreate) {
      final input = CreateScheduledWorkoutInput.fromJson(
          _activeScheduledWorkout.toJson());

      /// Connect to the users plan enrolment if it exists.
      if (widget.workoutPlanEnrolmentId != null) {
        input.workoutPlanEnrolment = ConnectRelationInput(
            id: _activeScheduledWorkout.workoutPlanEnrolmentId!);
      }

      final createVariables = CreateScheduledWorkoutArguments(data: input);

      final result = await context.graphQLStore.create(
          mutation: CreateScheduledWorkoutMutation(variables: createVariables),
          addRefToQueries: [GQLOpNames.userScheduledWorkouts]);

      if (result.hasErrors || result.data == null) {
        context.showErrorAlert(
            'Sorry there was a problem, the workout was not scheduled.');
      } else {
        final String dateString =
            _formatDateTime(result.data!.createScheduledWorkout.scheduledAt);
        context.pop(
            result: ToastRequest(
                message: 'Workout scheduled for $dateString.',
                type: ToastType.success));
      }
    } else {
      final updateVariables = UpdateScheduledWorkoutArguments(
          data: UpdateScheduledWorkoutInput.fromJson(
              _activeScheduledWorkout.toJson()));

      final result = await context.graphQLStore.mutate(
          mutation: UpdateScheduledWorkoutMutation(variables: updateVariables),
          broadcastQueryIds: [GQLOpNames.userScheduledWorkouts]);

      if (result.hasErrors || result.data == null) {
        context.showErrorAlert(
            'Sorry there was a problem, the schedule was not updated.');
      } else {
        final String dateString =
            _formatDateTime(result.data!.updateScheduledWorkout.scheduledAt);
        context.pop(
            result: ToastRequest(
                message: 'Workout scheduled for $dateString.',
                type: ToastType.success));
      }
    }
    setState(() => _loading = false);
  }

  void _confirmUnschedule() {
    context.showConfirmDialog(
        title: 'Cancel Scheduled Workout',
        verb: 'Unschedule',
        isDestructive: true,
        onConfirm: _unschedule);
  }

  Future<void> _unschedule() async {
    if (widget.scheduledWorkout != null) {
      setState(() => _loading = true);
      final variables =
          DeleteScheduledWorkoutByIdArguments(id: widget.scheduledWorkout!.id);

      final result = await context.graphQLStore.delete(
          mutation: DeleteScheduledWorkoutByIdMutation(variables: variables),
          objectId: widget.scheduledWorkout!.id,
          typename: kScheduledWorkoutTypename,
          removeRefFromQueries: [GQLOpNames.userScheduledWorkouts]);

      if (result.hasErrors) {
        context.showErrorAlert(
            'Sorry there was a problem, the schedule was not updated.');
      } else {
        setState(() => _loading = false);
        context.pop(
            result: ToastRequest(
                message: 'Workout unscheduled.', type: ToastType.destructive));
      }
    }
  }

  void _cancel() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(_cancel),
        middle: const NavBarTitle('Schedule Workout'),
        trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _loading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      NavBarLoadingIndicator(),
                    ],
                  )
                : NavBarSaveButton(_schedule)),
      ),
      child: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: MinimalWorkoutCard(
                  _activeScheduledWorkout.workout!,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                ),
              ),
              UserInputContainer(
                child: DateTimePickerDisplay(
                  dateTime: _activeScheduledWorkout.scheduledAt,
                  saveDateTime: (d) =>
                      setState(() => _activeScheduledWorkout.scheduledAt = d),
                ),
              ),
              UserInputContainer(
                child: GymProfileSelectorDisplay(
                    gymProfile: _activeScheduledWorkout.gymProfile,
                    selectGymProfile: (p) =>
                        setState(() => _activeScheduledWorkout.gymProfile = p),
                    clearGymProfile: () => setState(
                        () => _activeScheduledWorkout.gymProfile = null)),
              ),
              UserInputContainer(
                child: EditableTextAreaRow(
                    title: 'Note',
                    text: _activeScheduledWorkout.note ?? '',
                    onSave: (note) =>
                        setState(() => _activeScheduledWorkout.note = note),
                    inputValidation: (t) => true),
              ),
            ],
          ),
          if (!_isCreate)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: DestructiveButton(
                  text: 'Unschedule',
                  prefixIconData: CupertinoIcons.calendar_badge_minus,
                  onPressed: _confirmUnschedule),
            )
        ],
      ),
    );
  }
}
