import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class RepScoreInput extends StatefulWidget {
  final int? repScore;
  final void Function(int repScore) updateRepScore;
  const RepScoreInput(
      {Key? key, required this.repScore, required this.updateRepScore})
      : super(key: key);

  @override
  State<RepScoreInput> createState() => _RepScoreInputState();
}

class _RepScoreInputState extends State<RepScoreInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.repScore?.toString() ?? '');

    _controller.addListener(() {
      if (_controller.text != '') {
        widget.updateRepScore(int.parse(_controller.text));
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MyText('TOTAL REPS'),
            const SizedBox(width: 4),
            SuperText(
              child: AnimatedSwitcher(
                  duration: kStandardAnimationDuration,
                  child: _controller.text == ''
                      ? const Icon(
                          CupertinoIcons.exclamationmark_circle_fill,
                          color: Styles.errorRed,
                          size: 16,
                        )
                      : const Icon(
                          CupertinoIcons.checkmark_alt_circle_fill,
                          color: Styles.primaryAccent,
                          size: 16,
                        )),
            )
          ],
        ),
        const SizedBox(height: 8),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 100,
            child: MyNumberInput(
              _controller,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              backgroundColor: context.theme.background,
              textSize: 24,
            )),
      ],
    );
  }
}

class TimeTakenInput extends StatefulWidget {
  final Duration? duration;
  final void Function(Duration duration) updateDuration;

  const TimeTakenInput({
    Key? key,
    required this.duration,
    required this.updateDuration,
  }) : super(key: key);

  @override
  State<TimeTakenInput> createState() => _TimeTakenInputState();
}

class _TimeTakenInputState extends State<TimeTakenInput> {
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late TextEditingController _secondsController;

  final _inputPadding =
      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8);
  final _unitPadding = const EdgeInsets.only(left: 4.0, right: 8);
  final _inputWidth = 64.0;
  final _inputTextSize = 24.0;

  @override
  void initState() {
    super.initState();
    final hours = widget.duration?.inHours ?? 0;
    final minutes =
        widget.duration != null ? widget.duration!.inMinutes % 60 : 0;
    final seconds =
        widget.duration != null ? widget.duration!.inSeconds % 60 : 0;

    _hoursController = TextEditingController(text: hours.toString());
    _minutesController = TextEditingController(text: minutes.toString());
    _secondsController = TextEditingController(text: seconds.toString());

    _hoursController.addListener(_updateDuration);
    _minutesController.addListener(_updateDuration);
    _secondsController.addListener(_updateDuration);
  }

  Duration get _activeDuration => Duration(
      hours: int.tryParse(_hoursController.text) ?? 0,
      minutes: int.tryParse(_minutesController.text) ?? 0,
      seconds: int.tryParse(_secondsController.text) ?? 0);

  void _updateDuration() {
    widget.updateDuration(_activeDuration);
  }

  Widget _buildInput(TextEditingController controller) => MyNumberInput(
        controller,
        padding: _inputPadding,
        backgroundColor: context.theme.background,
        textSize: _inputTextSize,
      );

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const MyText('TIME TAKEN'),
              const SizedBox(width: 4),
              SuperText(
                child: AnimatedSwitcher(
                    duration: kStandardAnimationDuration,
                    child: _activeDuration.inSeconds == 0
                        ? const Icon(
                            CupertinoIcons.exclamationmark_circle_fill,
                            color: Styles.errorRed,
                            size: 16,
                          )
                        : const Icon(
                            CupertinoIcons.checkmark_alt_circle_fill,
                            color: Styles.primaryAccent,
                            size: 16,
                          )),
              )
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(width: _inputWidth, child: _buildInput(_hoursController)),
            Padding(
              padding: _unitPadding,
              child: const MyText('hr'),
            ),
            SizedBox(
                width: _inputWidth, child: _buildInput(_minutesController)),
            Padding(
              padding: _unitPadding,
              child: const MyText('min'),
            ),
            SizedBox(
                width: _inputWidth, child: _buildInput(_secondsController)),
            Padding(
              padding: _unitPadding,
              child: const MyText('sec'),
            ),
          ],
        ),
      ],
    );
  }
}
