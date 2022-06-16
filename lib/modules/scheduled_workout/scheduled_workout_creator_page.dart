import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/components/workout_type_icons.dart';
import 'package:sofie_ui/modules/gym_profile/gym_profile_selector.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/model/toast_request.dart';
import 'package:sofie_ui/modules/workouts/components/workout_session_minimum_info.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

/// [scheduledOn] will be ignored if [scheduledWorkout] is present.
/// Otherwise it will be set as the initial date when the widget is opened.
class ScheduledWorkoutCreatorPage extends StatefulWidget {
  final ScheduledWorkout? scheduledWorkout;
  final DateTime? scheduleOn;
  final ResistanceWorkout? resistanceWorkout;
  ScheduledWorkoutCreatorPage({
    Key? key,
    this.scheduledWorkout,
    this.scheduleOn,
    this.resistanceWorkout,
  })  : assert([scheduledWorkout, resistanceWorkout]
                .where((e) => e != null)
                .length ==
            1),
        super(key: key);

  @override
  State<ScheduledWorkoutCreatorPage> createState() =>
      _ScheduledWorkoutCreatorPageState();
}

class _ScheduledWorkoutCreatorPageState
    extends State<ScheduledWorkoutCreatorPage> {
  late ScheduledWorkout _scheduledWorkout;

  GymProfile? _gymProfile;

  bool _isRepeating = false;
  ScheduleFrequencyType _scheduleFrequencyType = ScheduleFrequencyType.daily;

  /// Keep at a low max because this operation actually creates this many ScheduledWorkouts.
  /// The only way for the user to reverse this is to manually delete them all.
  /// TODO: Look into a more flexible system.
  /// 1 repeat will result in two scheduledWorkouts being created, the original + 1 repeat.
  int _numRepeats = 1;

  late bool _isCreate;
  bool _loading = false;

  ScheduledWorkout _defaultScheduledWorkout() {
    return ScheduledWorkout()
      ..id = 'tempId'
      ..createdAt = DateTime.now()
      ..resistanceWorkoutInScheduledWorkout = widget.resistanceWorkout != null
          ? ResistanceWorkoutInScheduledWorkout.fromJson(
              widget.resistanceWorkout!.toJson())
          : null
      ..scheduledAt = widget.scheduleOn ?? DateTime.now();
  }

  @override
  void initState() {
    _isCreate = widget.scheduledWorkout == null;

    _scheduledWorkout = widget.scheduledWorkout != null
        ? ScheduledWorkout.fromJson(widget.scheduledWorkout!.toJson())
        : _defaultScheduledWorkout();

    super.initState();
  }

  String _formatDateTime(DateTime dateTime) => dateTime.dateAndTime;

  /// Handles creating a new scheduledWorkout and updating an existing one.
  Future<void> _schedule() async {
    setState(() => _loading = true);
    if (_isCreate) {
      final input =
          CreateScheduledWorkoutInput.fromJson(_scheduledWorkout.toJson());

      final createVariables = CreateScheduledWorkoutsArguments(
          data: _isRepeating
              ? List.generate(_numRepeats, (index) {
                  final inputForRepeat =
                      CreateScheduledWorkoutInput.fromJson(input.toJson());

                  inputForRepeat.scheduledAt = input.scheduledAt.add(Duration(
                      days: _scheduleFrequencyType.daysInFuture(index + 1)));

                  return inputForRepeat;
                })
              : [input]);

      await GraphQLStore.store.networkOnlyOperation(
          operation:
              CreateScheduledWorkoutsMutation(variables: createVariables),
          onFail: (_) => context.showToast(
              message: kDefaultErrorMessage, toastType: ToastType.destructive),
          processResult: (CreateScheduledWorkouts$Mutation data) {
            context.showToast(
                message:
                    '$_numRepeats ${_numRepeats == 1 ? "workout" : "workouts"} scheduled',
                onComplete: context.pop);
          });
    } else {
      final updateVariables = UpdateScheduledWorkoutArguments(
          data:
              UpdateScheduledWorkoutInput.fromJson(_scheduledWorkout.toJson()));

      await GraphQLStore.store.networkOnlyOperation(
          operation: UpdateScheduledWorkoutMutation(variables: updateVariables),
          onFail: (_) => context.showToast(message: kDefaultErrorMessage),
          processResult: (UpdateScheduledWorkout$Mutation data) {
            final String dateString =
                _formatDateTime(data.updateScheduledWorkout.scheduledAt);
            context.pop(
                result: ToastRequest(
                    message: 'Workout scheduled for $dateString.',
                    type: ToastType.success));
          });
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
          DeleteScheduledWorkoutArguments(id: widget.scheduledWorkout!.id);

      await GraphQLStore.store.networkOnlyOperation(
          operation: DeleteScheduledWorkoutMutation(variables: variables),
          onFail: (_) => context.showToast(
              message:
                  'Sorry there was a problem, the schedule was not updated.',
              toastType: ToastType.destructive),
          processResult: (_) => context.pop());
    }
  }

  void _cancel() => context.pop();

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(_cancel),
        middle: const NavBarTitle('Plan Workout'),
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
              if (widget.resistanceWorkout != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WorkoutSessionMinimumInfo(
                    name: widget.resistanceWorkout!.name,
                    iconData: WorkoutType.resistance,
                    type: 'Resistance',
                  ),
                ),
              UserInputContainer(
                child: DateTimePickerDisplay(
                  title: 'Starts',
                  dateTime: _scheduledWorkout.scheduledAt,
                  saveDateTime: (d) =>
                      setState(() => _scheduledWorkout.scheduledAt = d),
                ),
              ),
              UserInputContainer(
                child: Column(
                  children: [
                    CupertinoSwitchRow(
                      title: 'Repeat',
                      value: _isRepeating,
                      updateValue: (v) => setState(() {
                        _isRepeating = v;
                      }),
                    ),
                    GrowInOut(
                        show: _isRepeating,
                        child: Row(
                          children: [
                            PopoverMenu(
                                button: ContentBox(
                                    child:
                                        MyText(_scheduleFrequencyType.display)),
                                items: ScheduleFrequencyType.values
                                    .map((v) => PopoverMenuItem(
                                          onTap: () => setState(
                                              () => _scheduleFrequencyType = v),
                                          text: v.display,
                                        ))
                                    .toList()),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: MyText('for'),
                            ),
                            PopoverMenu(
                                button: ContentBox(
                                    child: MyText(
                                        '$_numRepeats ${_scheduleFrequencyType.unitDispay(_numRepeats)}')),
                                items: List.generate(
                                    8,
                                    (index) => PopoverMenuItem(
                                          onTap: () => setState(
                                              () => _numRepeats = index + 1),
                                          text: '${index + 1}',
                                        ))),
                          ],
                        ))
                  ],
                ),
              ),
              UserInputContainer(
                child: GymProfileSelectorDisplay(
                    title: 'Where',
                    gymProfile: _gymProfile,
                    selectGymProfile: (p) => setState(() => _gymProfile = p),
                    clearGymProfile: () => setState(() => _gymProfile = null)),
              ),
              UserInputContainer(
                child: EditableTextAreaRow(
                    title: 'Note',
                    text: _scheduledWorkout.note ?? '',
                    onSave: (note) =>
                        setState(() => _scheduledWorkout.note = note),
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

enum ScheduleFrequencyType { daily, weekly }

extension ScheduleFrequencyTypeExtension on ScheduleFrequencyType {
  String get display => describeEnum(this).capitalize;

  String unitDispay(int qty) {
    final single = qty == 1;
    switch (this) {
      case ScheduleFrequencyType.daily:
        return single ? 'Day' : 'Days';
      case ScheduleFrequencyType.weekly:
        return single ? 'Week' : 'Weeks';

      default:
        throw Exception(
            'This is not a valid ScheduleFrequencyType enum: $this');
    }
  }

  int daysInFuture(int qty) {
    switch (this) {
      case ScheduleFrequencyType.daily:
        return qty;
      case ScheduleFrequencyType.weekly:
        return qty * 7;
      default:
        throw Exception(
            'This is not a valid ScheduleFrequencyType enum: $this');
    }
  }
}
