import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Spans the width with title on left + currently selected value on right.
class TappableRow extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final Widget? display;
  final bool showPenIcon;
  final String placeholder;
  const TappableRow(
      {Key? key,
      required this.onTap,
      required this.title,
      this.display,
      this.showPenIcon = false,
      this.placeholder = 'select'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title),
          Row(
            children: [
              display ??
                  MyText(
                    placeholder,
                    color: context.theme.primary.withOpacity(0.5),
                  ),
              if (showPenIcon)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(CupertinoIcons.pencil, size: 18),
                )
            ],
          )
        ],
      ),
    );
  }
}
