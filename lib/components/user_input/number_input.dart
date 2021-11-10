import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

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
