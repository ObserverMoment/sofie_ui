import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

/// Need to separate these two widgets because of this. https://github.com/dart-lang/sdk/issues/32042.
/// Originally this was a generic but was causing errors when trying to run [saveValue].
/// [T] should be either [int] or [double]
/// [class NumberInputModal<T> extends StatefulWidget]
/// If you just want to input ints within a relatively small range then consider [NumberPickerModal]
class NumberInputModalInt extends StatefulWidget {
  final String title;
  final int? value;
  final void Function(int value) saveValue;
  const NumberInputModalInt(
      {Key? key,
      required this.value,
      required this.saveValue,
      this.title = 'Enter...'})
      : super(key: key);
  @override
  _NumberInputModalIntState createState() => _NumberInputModalIntState();
}

class _NumberInputModalIntState extends State<NumberInputModalInt> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.value == null ? ' - ' : widget.value.toString());
    // Auto select the previous input.
    _controller.selection = TextSelection(
        baseOffset: 0, extentOffset: _controller.value.text.length);
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _saveValue() {
    if (Utils.textNotNull(_controller.text) &&
        _controller.text != ' - ' &&
        _controller.text != widget.value.toString()) {
      widget.saveValue(int.parse(_controller.text));
    }
    context.pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalPageScaffold(
      cancel: context.pop,
      save: _saveValue,
      validToSave:
          Utils.textNotNull(_controller.text) && _controller.text != ' - ',
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            child: MyNumberInput(
              _controller,
              autoFocus: true,
            ),
          ),
        ],
      ),
    );
  }
}

class NumberInputModalDouble extends StatefulWidget {
  final String title;
  final double? value;
  final void Function(double value) saveValue;
  final bool allowNegative;
  final String? unitDisplay;
  const NumberInputModalDouble(
      {Key? key,
      required this.value,
      required this.saveValue,
      this.title = 'Enter...',
      this.allowNegative = false,
      this.unitDisplay})
      : super(key: key);
  @override
  _NumberInputModalDoubleState createState() => _NumberInputModalDoubleState();
}

class _NumberInputModalDoubleState extends State<NumberInputModalDouble> {
  late TextEditingController _controller;
  late bool _negative;

  @override
  void initState() {
    super.initState();
    _negative = widget.value != null && widget.value! < 0;

    _controller = TextEditingController(
        text: widget.value == null ? ' - ' : widget.value!.abs().toString());
    // Auto select the previous input.
    _controller.selection = TextSelection(
        baseOffset: 0, extentOffset: _controller.value.text.length);
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _saveValue() {
    if (Utils.textNotNull(_controller.text) && _controller.text != ' - ') {
      widget.saveValue(_negative
          ? -double.parse(_controller.text)
          : double.parse(_controller.text));
    }
    context.pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalPageScaffold(
      cancel: context.pop,
      save: _saveValue,
      validToSave:
          Utils.textNotNull(_controller.text) && _controller.text != ' - ',
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            child: Row(
              children: [
                if (widget.allowNegative)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          duration: kStandardAnimationDuration,
                          opacity: _negative ? 0.3 : 1.0,
                          child: CupertinoButton(
                              pressedOpacity: 0.9,
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  setState(() => _negative = false),
                              child: const Icon(CupertinoIcons.add)),
                        ),
                        AnimatedOpacity(
                          duration: kStandardAnimationDuration,
                          opacity: _negative ? 1.0 : 0.3,
                          child: CupertinoButton(
                              pressedOpacity: 0.9,
                              padding: EdgeInsets.zero,
                              onPressed: () => setState(() => _negative = true),
                              child: const Icon(CupertinoIcons.minus)),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: MyNumberInput(
                    _controller,
                    allowDouble: true,
                    autoFocus: true,
                  ),
                ),
              ],
            ),
          ),
          if (widget.unitDisplay != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(widget.unitDisplay!),
            ),
        ],
      ),
    );
  }
}
