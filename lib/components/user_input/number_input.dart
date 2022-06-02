import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class MyStatefulNumberInput extends StatefulWidget {
  final num? initialValue;
  final bool allowDouble;
  final double textSize;
  final bool autoFocus;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final Function(num updated) update;
  const MyStatefulNumberInput({
    Key? key,
    this.allowDouble = false,
    this.textSize = 20,
    this.autoFocus = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    required this.update,
    this.initialValue,
  }) : super(key: key);

  @override
  State<MyStatefulNumberInput> createState() => _MyStatefulNumberInputState();
}

class _MyStatefulNumberInputState extends State<MyStatefulNumberInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!.toString();
    }
    _controller.addListener(() {
      setState(() {
        widget.allowDouble
            ? widget.update(double.parse(_controller.text))
            : widget.update(int.parse(_controller.text));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: _controller,
      onTap: () {
        _controller.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller.value.text.length);
      },
      keyboardAppearance: context.theme.cupertinoThemeData.brightness,
      autofocus: widget.autoFocus,
      keyboardType:
          TextInputType.numberWithOptions(decimal: widget.allowDouble),
      // https://stackoverflow.com/questions/54454983/allow-only-two-decimal-number-in-flutter-input
      inputFormatters: [
        if (widget.allowDouble)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: BoxDecoration(
          color: widget.backgroundColor ?? context.theme.cardBackground,
          borderRadius: BorderRadius.circular(8)),
      padding: widget.padding,
      style: TextStyle(fontSize: widget.textSize, height: 1),
      textAlign: TextAlign.center,
    );
  }
}

class MyNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final bool allowDouble;
  final double textSize;
  final bool autoFocus;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  const MyNumberInput(
    this.controller, {
    Key? key,
    this.allowDouble = false,
    this.textSize = 50,
    this.autoFocus = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      onTap: () {
        controller.selection = TextSelection(
            baseOffset: 0, extentOffset: controller.value.text.length);
      },
      keyboardAppearance: context.theme.cupertinoThemeData.brightness,
      autofocus: autoFocus,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDouble),
      // https://stackoverflow.com/questions/54454983/allow-only-two-decimal-number-in-flutter-input
      inputFormatters: [
        if (allowDouble)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: BoxDecoration(
          color: backgroundColor ?? context.theme.cardBackground,
          borderRadius: BorderRadius.circular(8)),
      padding: padding,
      style: TextStyle(fontSize: textSize, height: 1),
      textAlign: TextAlign.center,
    );
  }
}
