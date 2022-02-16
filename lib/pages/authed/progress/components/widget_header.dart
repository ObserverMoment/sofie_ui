import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Widget title + icon.
/// Plus optional top right icon buttons.
class WidgetHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final List<WidgetHeaderAction> actions;
  const WidgetHeader(
      {Key? key, this.icon, required this.title, this.actions = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: CircularBox(
                    padding: const EdgeInsets.all(7),
                    color: context.theme.background,
                    child: Icon(
                      icon,
                      size: 18,
                    )),
              ),
            MyText(
              title,
              weight: FontWeight.bold,
              size: FONTSIZE.two,
              subtext: true,
            )
          ],
        ),
        if (actions.isNotEmpty)
          Row(
              children: actions
                  .map((a) => IconButton(
                        iconData: a.icon,
                        size: 24,
                        onPressed: a.onPressed,
                      ))
                  .toList()),
      ],
    );
  }
}

class WidgetHeaderAction {
  final IconData icon;
  final VoidCallback onPressed;
  WidgetHeaderAction({required this.icon, required this.onPressed});
}
