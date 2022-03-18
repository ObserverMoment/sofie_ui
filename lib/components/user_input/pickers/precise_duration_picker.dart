import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';

/// User can input a duration right down to the millisecond.
class PreciseDurationPicker extends StatefulWidget {
  final Duration? value;
  final void Function(Duration duration) updateDuration;
  const PreciseDurationPicker(
      {Key? key, this.value, required this.updateDuration})
      : super(key: key);

  @override
  State<PreciseDurationPicker> createState() => _PreciseDurationPickerState();
}

class _PreciseDurationPickerState extends State<PreciseDurationPicker> {
  final _hoursController = TextEditingController(text: '0');
  final _minutesController = TextEditingController(text: '0');
  final _secondsController = TextEditingController(text: '0');

  @override
  void initState() {
    if (widget.value != null) {
      final hours = widget.value!.inHours;
      _hoursController.text = hours.toString();

      final minutes = widget.value!.inMinutes % 60;

      _minutesController.text = minutes.toString();

      final milliseconds = widget.value!.inMilliseconds % 60000;
      _secondsController.text = (milliseconds / 1000).toString();
    }

    _hoursController.addListener(_handleNewInput);
    _minutesController.addListener(_handleNewInput);
    _secondsController.addListener(_handleNewInput);
    super.initState();
  }

  void _handleNewInput() {
    final hours =
        _hoursController.text == '' ? 0 : int.parse(_hoursController.text);
    final minutes =
        _minutesController.text == '' ? 0 : int.parse(_minutesController.text);
    final seconds = _secondsController.text == ''
        ? 0
        : double.parse(_secondsController.text);
    final milliseconds = (seconds * 1000).round();

    widget.updateDuration(
        Duration(hours: hours, minutes: minutes, milliseconds: milliseconds));
  }

  double get _textSize => 30.0;
  EdgeInsets get _inputPadding =>
      const EdgeInsets.symmetric(horizontal: 12, vertical: 18);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [
                MyNumberInput(
                  _hoursController,
                  allowDouble: false,
                  textSize: _textSize,
                  padding: _inputPadding,
                ),
                const SizedBox(height: 4),
                const MyText(
                  'hour',
                  subtext: true,
                )
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                MyNumberInput(
                  _minutesController,
                  allowDouble: false,
                  textSize: _textSize,
                  padding: _inputPadding,
                ),
                const SizedBox(height: 4),
                const MyText(
                  'min',
                  subtext: true,
                )
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                MyNumberInput(
                  _secondsController,
                  allowDouble: true,
                  textSize: _textSize,
                  padding: _inputPadding,
                ),
                const SizedBox(height: 4),
                const MyText(
                  'sec',
                  subtext: true,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
