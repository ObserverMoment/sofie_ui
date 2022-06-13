import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout/fab_page/fab_page.dart';
import 'package:sofie_ui/constants.dart';

class FloatingIconButton extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final double iconSize;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool loading;

  const FloatingIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.iconSize = 24,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(16),
    this.loading = false,
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
          child: AnimatedSwitcher(
            duration: kStandardAnimationDuration,
            child: loading
                ? const LoadingIndicator(size: 8)
                : Icon(
                    icon,
                    size: iconSize,
                  ),
          ),
        ));
  }
}
