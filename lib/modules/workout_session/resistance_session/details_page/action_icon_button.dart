import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class ActionIconButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;
  const ActionIconButton(
      {Key? key,
      required this.icon,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: ContentBox(
        child: Row(
          children: [
            icon,
            const SizedBox(width: 4),
            MyText(
              label.toUpperCase(),
              size: FONTSIZE.one,
            ),
          ],
        ),
      ),
    );
  }
}
