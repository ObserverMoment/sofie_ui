import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';

class CupertinoSwitchRow extends StatelessWidget {
  final bool value;
  final String title;
  final void Function(bool v) updateValue;
  const CupertinoSwitchRow(
      {Key? key,
      required this.title,
      required this.updateValue,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title),
          MyCupertinoSwitch(
            value: value,
            onChanged: updateValue,
          )
        ],
      ),
    );
  }
}

/// Default color.
class MyCupertinoSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  const MyCupertinoSwitch(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: Styles.primaryAccent,
    );
  }
}
