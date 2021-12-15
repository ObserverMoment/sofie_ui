import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_text_field.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/debounce.dart';
import 'package:sofie_ui/services/utils.dart';

//// Update Jan 2021 ////
/// TikTok style text editing flow.
/// Clicking opens up auto focused full screen for entering text
class EditableDisplayNameRow extends StatelessWidget {
  final String title;
  final Widget? icon;
  final String text;
  final Function(String) onSave;

  /// E.g. is the display name or club name available.
  final Future<bool> Function(String) apiValidation;
  final String apiMessage;

  /// E.g. is the users input valid length or format.
  final bool Function(String) inputValidation;
  final String? validationMessage;
  final int maxInputLines;
  final int? maxChars;
  final bool isRequired;
  final String placeholder;

  const EditableDisplayNameRow(
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
      this.icon,
      required this.apiValidation,
      required this.apiMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasText = Utils.textNotNull(text);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.push(
          child: FullScreenDisplayNameEditing(
        title: title,
        inputValidation: inputValidation,
        validationMessage: validationMessage,
        initialValue: text,
        onSave: onSave,
        maxChars: maxChars,
        maxInputLines: maxInputLines,
        apiMessage: apiMessage,
        apiValidation: apiValidation,
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

/// Use for any user inputted name that has some api validation required.
class FullScreenDisplayNameEditing extends StatefulWidget {
  final String title;
  final String? initialValue;
  final Function(String) onSave;
  final Future<bool> Function(String) apiValidation;
  final String apiMessage;
  final bool Function(String) inputValidation;
  final String? validationMessage;
  final int? maxChars;
  final int? maxInputLines;

  const FullScreenDisplayNameEditing(
      {Key? key,
      required this.title,
      this.initialValue,
      required this.onSave,
      required this.inputValidation,
      this.validationMessage,
      this.maxChars,
      this.maxInputLines,
      required this.apiValidation,
      required this.apiMessage})
      : super(key: key);

  @override
  _FullScreenDisplayNameEditingState createState() =>
      _FullScreenDisplayNameEditingState();
}

class _FullScreenDisplayNameEditingState
    extends State<FullScreenDisplayNameEditing> {
  late TextEditingController _controller;
  bool _formIsDirty = false;
  bool _apiCheckIsvalid = false;
  bool _inputIsValid = false;

  final _debouncer = Debouncer();

  Future<void> _runValidation({bool debounce = true}) async {
    setState(() {
      _formIsDirty = widget.initialValue != _controller.text;
      _inputIsValid = widget.inputValidation(_controller.text);
    });
    if (_inputIsValid) {
      if (debounce) {
        _debouncer
            .run(() => widget.apiValidation(_controller.text).then((valid) {
                  setState(() => _apiCheckIsvalid = valid);
                }));
      } else {
        widget.apiValidation(_controller.text).then((valid) {
          setState(() => _apiCheckIsvalid = valid);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_runValidation);
    _runValidation(debounce: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.onSave(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          customLeading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: const MyText('Cancel')),
            ],
          ),
          middle: NavBarTitle(widget.title),
          trailing: _formIsDirty && _inputIsValid && _apiCheckIsvalid
              ? FadeIn(
                  child: NavBarSaveButton(
                  _handleSave,
                ))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                    placeholder: widget.title,
                    autofocus: true,
                    maxLines: widget.maxInputLines,
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
                          padding: const EdgeInsets.only(left: 3, top: 5.0),
                          child: MyText(
                            '(${widget.validationMessage})',
                            size: FONTSIZE.two,
                          ),
                        )
                    ],
                  ),
                ),
                if (_inputIsValid && !_apiCheckIsvalid)
                  FadeInUp(
                      child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child:
                        MyText(widget.apiMessage, color: Styles.primaryAccent),
                  ))
              ],
            ),
          ),
        ));
  }
}
