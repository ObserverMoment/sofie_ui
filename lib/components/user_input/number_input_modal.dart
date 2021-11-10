import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
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
      resizeToAvoidBottomInset: true,
      cancel: context.pop,
      save: _saveValue,
      validToSave:
          Utils.textNotNull(_controller.text) && _controller.text != ' - ',
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
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
  const NumberInputModalDouble(
      {Key? key,
      required this.value,
      required this.saveValue,
      this.title = 'Enter...'})
      : super(key: key);
  @override
  _NumberInputModalDoubleState createState() => _NumberInputModalDoubleState();
}

class _NumberInputModalDoubleState extends State<NumberInputModalDouble> {
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
      widget.saveValue(double.parse(_controller.text));
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
      resizeToAvoidBottomInset: true,
      cancel: context.pop,
      save: _saveValue,
      validToSave:
          Utils.textNotNull(_controller.text) && _controller.text != ' - ',
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
            child: MyNumberInput(
              _controller,
              allowDouble: true,
              autoFocus: true,
            ),
          ),
        ],
      ),
    );
  }
}
