import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';

class SaveAndClosePicker extends StatelessWidget {
  final void Function() saveAndClose;
  final bool disabled;
  const SaveAndClosePicker(
      {Key? key, required this.saveAndClose, this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
        onPressed: saveAndClose, disabled: disabled, text: 'Save');
  }
}
