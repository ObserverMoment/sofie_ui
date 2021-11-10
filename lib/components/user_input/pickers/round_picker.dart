import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/user_input/number_input_modal.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class RoundPicker extends StatelessWidget {
  final int rounds;
  final void Function(int value) saveValue;
  final String modalTitle;
  final EdgeInsetsGeometry? padding;
  const RoundPicker(
      {Key? key,
      required this.rounds,
      required this.saveValue,
      this.modalTitle = 'How many rounds?',
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding ?? const EdgeInsets.all(4),
      onPressed: () => context.showBottomSheet<int>(
          child: NumberInputModalInt(
        value: rounds,
        saveValue: (v) => saveValue(v),
        title: modalTitle,
      )),
      child: NumberRoundsIcon(
        rounds: rounds,
      ),
    );
  }
}
