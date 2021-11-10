import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/components/user_input/pickers/save_and_close_picker.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class DurationPickerDisplay extends StatelessWidget {
  final String modalTitle;
  final Duration? duration;
  final void Function(Duration duration) updateDuration;
  const DurationPickerDisplay(
      {Key? key,
      required this.updateDuration,
      this.duration,
      this.modalTitle = 'Enter Duration'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => context.showActionSheetPopup(
          child: DurationPicker(
        duration: duration,
        updateDuration: updateDuration,
        title: modalTitle,
      )),
      padding: const EdgeInsets.all(8),
      child: CompactTimerIcon(
        duration: duration,
      ),
    );
  }
}

class DurationPickerRowDisplay extends StatelessWidget {
  final Duration? duration;
  final void Function(Duration duration) updateDuration;
  const DurationPickerRowDisplay(
      {Key? key, required this.duration, required this.updateDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasDuration = duration != null;
    return UserInputContainer(
      child: Column(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.showActionSheetPopup(
                child: DurationPicker(
              duration: duration,
              mode: CupertinoTimerPickerMode.hm,
              minuteInterval: 5,
              updateDuration: updateDuration,
              title: 'Workout Duration',
            )),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Row(
                    children: const [
                      MyText(
                        'Duration',
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
                        CupertinoIcons.clock,
                        size: 18,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: MyText(
                      hasDuration ? duration!.displayString : 'Add',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: const [
              MyText(
                'How long this workout should take in total.',
                size: FONTSIZE.two,
                maxLines: 3,
                subtext: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WorkoutSetDurationPicker extends StatefulWidget {
  final Duration? duration;
  final void Function(Duration duration, bool copyToAll) updateDuration;
  final String? title;
  final String switchTitle;
  final CupertinoTimerPickerMode mode;
  final int minuteInterval;
  final int secondInterval;
  final bool allowCopyToAll;
  const WorkoutSetDurationPicker(
      {Key? key,
      required this.duration,
      required this.updateDuration,
      this.title,
      this.minuteInterval = 1,
      this.secondInterval = 5,
      this.mode = CupertinoTimerPickerMode.ms,
      this.switchTitle = 'Copy to all sets',
      this.allowCopyToAll = true})
      : super(key: key);

  @override
  _WorkoutSetDurationPickerState createState() =>
      _WorkoutSetDurationPickerState();
}

class _WorkoutSetDurationPickerState extends State<WorkoutSetDurationPicker> {
  late Duration? _activeDuration;

  /// Allows the user to bulk update the duration on all / a group of sets.
  bool _copyToAll = false;

  @override
  void initState() {
    super.initState();
    _activeDuration = widget.duration;
  }

  void _saveAndClose() {
    if (_activeDuration != null) {
      widget.updateDuration(_activeDuration!, _copyToAll);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: H2(widget.title!),
            ),
          if (widget.allowCopyToAll)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSwitchRow(
                  title: widget.switchTitle,
                  updateValue: (v) => setState(() => _copyToAll = v),
                  value: _copyToAll),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CupertinoTimerPicker(
                initialTimerDuration: _activeDuration ?? Duration.zero,
                mode: widget.mode,
                minuteInterval: widget.minuteInterval,
                secondInterval: widget.secondInterval,
                onTimerDurationChanged: (duration) =>
                    setState(() => _activeDuration = duration)),
          ),
          SaveAndClosePicker(saveAndClose: _saveAndClose)
        ],
      ),
    );
  }
}

class DurationPicker extends StatefulWidget {
  final Duration? duration;
  final void Function(Duration duration) updateDuration;
  final String? title;
  final CupertinoTimerPickerMode mode;
  final int minuteInterval;
  final int secondInterval;
  const DurationPicker(
      {Key? key,
      required this.duration,
      required this.updateDuration,
      this.title,
      this.minuteInterval = 1,
      this.secondInterval = 1,
      this.mode = CupertinoTimerPickerMode.hms})
      : super(key: key);

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late Duration? _activeDuration;

  @override
  void initState() {
    super.initState();
    _activeDuration = widget.duration;
  }

  void _saveAndClose() {
    if (_activeDuration != null) {
      widget.updateDuration(_activeDuration!);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: H2(widget.title!.toUpperCase()),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CupertinoTimerPicker(
                initialTimerDuration: _activeDuration ?? Duration.zero,
                mode: widget.mode,
                minuteInterval: widget.minuteInterval,
                secondInterval: widget.secondInterval,
                onTimerDurationChanged: (duration) =>
                    setState(() => _activeDuration = duration)),
          ),
          SaveAndClosePicker(saveAndClose: _saveAndClose)
        ],
      ),
    );
  }
}
