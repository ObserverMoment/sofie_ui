import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout/fab_page/fab_page.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';

class FloatingTextButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final void Function() onTap;
  final double iconSize;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double? width;
  final bool loading;

  const FloatingTextButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onTap,
    this.iconSize = 22,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.loading = false,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Vibrate.feedback(FeedbackType.light);
          onTap();
        },
        child: FABPageButtonContainer(
          padding: padding,
          margin: margin,
          width: width,
          child: AnimatedSwitcher(
            duration: kStandardAnimationDuration,
            child: loading
                ? const LoadingIndicator(size: 8)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null)
                        Icon(
                          icon,
                          size: iconSize,
                        ),
                      if (icon != null) const SizedBox(width: 7),
                      MyText(
                        text.toUpperCase(),
                        size: FONTSIZE.four,
                      ),
                    ],
                  ),
          ),
        ));
  }
}
