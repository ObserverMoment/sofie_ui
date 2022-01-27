import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_text_field.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

//// Update Jan 2021 ////
/// TikTok style text editing flow.
/// Clicking opens up auto focused full screen for entering text
/// [EditableTextFieldRow variant] used for single line displays
/// [EditableTextFieldArea variant] used for displaying blocks of text
class EditableTextFieldRow extends StatelessWidget {
  final String title;
  final Widget? icon;
  final String text;
  final Function(String) onSave;
  final bool Function(String) inputValidation;
  final String? validationMessage;
  final int maxInputLines;
  final int? maxChars;
  final bool isRequired;
  final String placeholder;

  const EditableTextFieldRow(
      {Key? key,
      required this.title,
      this.text = '',
      this.placeholder = 'Add',
      required this.onSave,
      required this.inputValidation,
      this.validationMessage,
      this.maxChars,
      this.maxInputLines = 1,
      this.isRequired = false,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasText = Utils.textNotNull(text);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.push(
          child: FullScreenTextEditing(
        title: title,
        inputValidation: inputValidation,
        validationMessage: validationMessage,
        initialValue: text,
        onSave: onSave,
        maxChars: maxChars,
        maxInputLines: maxInputLines,
      )),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Row(
              children: [
                MyText(
                  title,
                ),
                if (isRequired == true) const RequiredSuperText(),
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: icon!,
                  )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: MyText(
                hasText ? text : placeholder,
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditableTextAreaRow extends StatelessWidget {
  final String title;
  final String text;
  final String placeholder;
  final int? maxDisplayLines;
  final Function(String) onSave;
  final bool Function(String) inputValidation;
  final String? validationMessage;
  final int? maxInputLines;
  final int? maxChars;
  final bool isRequired;

  const EditableTextAreaRow(
      {Key? key,
      required this.title,
      this.text = '',
      this.placeholder = 'Add',
      required this.onSave,
      required this.inputValidation,
      this.validationMessage,
      this.maxChars,
      this.maxInputLines,
      this.maxDisplayLines = 4,
      this.isRequired = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasText = Utils.textNotNull(text);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.push(
          child: FullScreenTextEditing(
        title: title,
        inputValidation: inputValidation,
        validationMessage: validationMessage,
        initialValue: text,
        onSave: onSave,
        maxChars: maxChars,
        maxInputLines: maxInputLines,
      )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Row(
              children: [
                MyText(
                  title,
                ),
                if (isRequired == true) const RequiredSuperText()
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: MyText(
                hasText ? text : placeholder,
                maxLines: maxDisplayLines,
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenTextEditing extends StatefulWidget {
  final String title;
  final String? initialValue;
  final Function(String) onSave;
  final bool Function(String) inputValidation;
  final String? validationMessage;
  final int? maxChars;
  final int? maxInputLines;

  const FullScreenTextEditing(
      {Key? key,
      required this.title,
      this.initialValue,
      required this.onSave,
      required this.inputValidation,
      this.validationMessage,
      this.maxChars,
      this.maxInputLines})
      : super(key: key);

  @override
  _FullScreenTextEditingState createState() => _FullScreenTextEditingState();
}

class _FullScreenTextEditingState extends State<FullScreenTextEditing> {
  late TextEditingController _controller;
  bool _formIsDirty = false;
  bool _inputIsValid() => widget.inputValidation(_controller.text);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      setState(() => _formIsDirty = widget.initialValue != _controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.onSave(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: context.theme.cardBackground,
        navigationBar: MyNavBar(
          customLeading: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: NavBarCancelButton(context.pop, text: 'Cancel'),
          ),
          middle: NavBarTitle(widget.title),
          trailing: _formIsDirty && _inputIsValid()
              ? FadeIn(
                  child: TertiaryButton(
                  backgroundColor: Styles.primaryAccent,
                  textColor: Styles.white,
                  onPressed: _handleSave,
                  text: 'Save',
                ))
              : null,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                  placeholder: widget.title,
                  autofocus: true,
                  maxLines: widget.maxInputLines,
                  backgroundColor: material.Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  disableSuffix: true,
                  controller: _controller),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    if (widget.maxChars != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 2, top: 6.0),
                        child: MyText(
                          '${_controller.text.length}/${widget.maxChars}',
                          size: FONTSIZE.two,
                          color: _controller.text.length > widget.maxChars!
                              ? Styles.errorRed
                              : CupertinoTheme.of(context).primaryColor,
                        ),
                      ),
                    if (widget.validationMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5.0),
                        child: MyText(
                          '(${widget.validationMessage})',
                          size: FONTSIZE.two,
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
