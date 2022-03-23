import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Used for standard on screen text inputs where focusing the field brings up a keyboard.
class MyTextFormFieldRow extends StatefulWidget {
  final String placeholder;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final bool obscureText;
  final bool autofocus;
  final String? validationMessage;
  final bool Function()? validator;
  final Color? backgroundColor;
  final TextAlign textAlign;

  /// Pass a controller OR an initial value with and onChange function.
  final TextEditingController? controller;
  final String? initialValue;
  final void Function(String text)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextFormFieldRow(
      {Key? key,
      required this.placeholder,
      required this.keyboardType,
      this.controller,
      this.initialValue,
      this.onChanged,
      this.autofillHints,
      this.autofocus = false,
      this.obscureText = false,
      this.backgroundColor,
      this.inputFormatters,
      this.validationMessage,
      this.validator,
      this.textAlign = TextAlign.left})
      : assert(
            controller != null || (initialValue != null && onChanged != null)),
        super(key: key);

  @override
  _MyTextFormFieldRowState createState() => _MyTextFormFieldRowState();
}

class _MyTextFormFieldRowState extends State<MyTextFormFieldRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 6, right: 8),
              decoration: widget.backgroundColor != null
                  ? BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(16))
                  : null,
              child: CupertinoTextFormFieldRow(
                  controller: _controller,
                  initialValue: widget.initialValue,
                  onChanged: widget.onChanged,
                  textAlign: widget.textAlign,
                  autofocus: widget.autofocus,
                  inputFormatters: widget.inputFormatters,
                  placeholder: widget.placeholder,
                  placeholderStyle: TextStyle(
                      fontSize: 18,
                      color: context.theme.primary.withOpacity(0.6)),
                  keyboardType: widget.keyboardType,
                  style: const TextStyle(fontSize: 18),
                  autofillHints: widget.autofillHints,
                  obscureText: widget.obscureText),
            ),
            if (widget.validator != null && widget.validator!())
              const Positioned(
                  right: 10,
                  child: FadeIn(
                      child: Icon(
                    CupertinoIcons.checkmark_alt,
                    color: Styles.primaryAccent,
                  ))),
          ],
        ),
        if (widget.validationMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 6),
            child: MyText(
              '(${widget.validationMessage!})',
              size: FONTSIZE.two,
            ),
          ),
      ],
    );
  }
}

class MyPasswordFieldRow extends StatefulWidget {
  final Widget? prefix;
  final bool obscureText;
  final bool autofocus;
  final TextEditingController controller;
  final bool Function()? validator;
  final List<String>? autofillHints;
  final Color? backgroundColor;

  const MyPasswordFieldRow(
      {Key? key,
      this.prefix,
      required this.controller,
      this.autofillHints,
      this.autofocus = false,
      this.obscureText = false,
      this.validator,
      this.backgroundColor})
      : super(key: key);

  @override
  _MyPasswordFieldRowState createState() => _MyPasswordFieldRowState();
}

class _MyPasswordFieldRowState extends State<MyPasswordFieldRow> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: MyTextFormFieldRow(
            placeholder: 'Password',
            keyboardType: TextInputType.visiblePassword,
            obscureText: !_showPassword,
            controller: widget.controller,
            validator: widget.validator,
            autofillHints: widget.autofillHints,
            backgroundColor: widget.backgroundColor,
          ),
        ),
        CupertinoButton(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showPassword
                  ? const Icon(CupertinoIcons.eye_slash_fill)
                  : const Icon(CupertinoIcons.eye_fill),
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword))
      ],
    );
  }
}

class MyTextAreaFormFieldRow extends StatelessWidget {
  final Widget? prefix;
  final String placeholder;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final bool obscureText;
  final bool autofocus;
  final TextEditingController controller;
  final bool Function()? validator;
  final Color? backgroundColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool expands;

  const MyTextAreaFormFieldRow(
      {Key? key,
      this.prefix,
      required this.placeholder,
      required this.keyboardType,
      required this.controller,
      this.autofillHints,
      this.autofocus = false,
      this.obscureText = false,
      this.validator,
      this.backgroundColor,
      this.inputFormatters,
      this.maxLines,
      this.expands = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 6, right: 8),
          decoration: backgroundColor != null
              ? BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16))
              : null,
          child: CupertinoTextFormFieldRow(
              keyboardAppearance: context.theme.cupertinoThemeData.brightness,
              controller: controller,
              expands: expands,
              maxLines: maxLines,
              prefix: prefix,
              autofocus: autofocus,
              placeholder: placeholder,
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              style: TextStyle(fontSize: 18, color: context.theme.primary),
              placeholderStyle: TextStyle(
                  fontSize: 18, color: context.theme.primary.withOpacity(0.6)),
              autofillHints: autofillHints,
              obscureText: obscureText),
        ),
        if (validator != null && validator!())
          const Positioned(
              right: 10,
              top: 10,
              child: FadeIn(
                  child: Icon(
                CupertinoIcons.check_mark_circled,
                color: CupertinoColors.systemBlue,
              ))),
      ],
    );
  }
}
