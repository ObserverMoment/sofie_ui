import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';

class FABPage extends StatelessWidget {
  final Widget child;
  final List<Widget> columnButtons;
  final List<Widget> rowButtons;
  final Alignment stackAlignment;
  final MainAxisAlignment rowButtonsAlignment;

  /// Sometimes needed to avoid bottom nav bar.
  final double bottomPadding;
  const FABPage({
    Key? key,
    required this.child,
    this.stackAlignment = Alignment.topCenter,
    this.columnButtons = const [],
    this.rowButtons = const [],
    this.rowButtonsAlignment = MainAxisAlignment.center,
    this.bottomPadding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.expand,
      alignment: stackAlignment,
      clipBehavior: Clip.none,
      children: [
        child,
        if (columnButtons.isNotEmpty)
          Positioned(
            bottom: bottomPadding + 16 + (rowButtons.isEmpty ? 0 : 56),
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: columnButtons
                  .map((b) => Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: b,
                      ))
                  .toList(),
            ),
          ),
        if (rowButtons.isNotEmpty)
          Positioned(
            bottom: 16,
            right: rowButtonsAlignment == MainAxisAlignment.end ? 0 : null,
            left: rowButtonsAlignment == MainAxisAlignment.start ? 0 : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: screenWidth,
              child: Row(
                mainAxisAlignment: rowButtonsAlignment,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: rowButtons,
              ),
            ),
          ),
      ],
    );
  }
}

class FloatingButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final void Function() onTap;
  final double iconSize;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color? contentColor;
  final Color? color;
  final Gradient? gradient;

  const FloatingButton({
    Key? key,
    this.text,
    this.icon,
    required this.onTap,
    this.iconSize = 26,
    this.margin = EdgeInsets.zero,
    this.color,
    this.gradient,
    this.contentColor,
    this.padding = const EdgeInsets.all(11),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        onTap();
      },
      child: FABPageButtonContainer(
        color: color,
        gradient: gradient,
        padding: padding,
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (text != null)
              MyText(
                text!,
                size: FONTSIZE.four,
                color: contentColor,
              ),
            if (icon != null && text != null) const SizedBox(width: 6),
            if (icon != null) Icon(icon, size: iconSize, color: contentColor),
          ],
        ),
      ),
    );
  }
}

class FABPageCircularButtonContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  /// [gradient] will override [color].
  final Gradient? gradient;
  final Color? color;

  const FABPageCircularButtonContainer(
      {Key? key,
      required this.child,
      this.padding = const EdgeInsets.all(12),
      this.gradient,
      this.color,
      this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: kElevation[6],
        color: gradient != null ? null : color ?? context.theme.cardBackground,
        gradient: gradient,
      ),
      child: child,
    );
  }
}

class FABPageButtonContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  /// [gradient] will override [color].
  final Gradient? gradient;
  final Color? color;

  const FABPageButtonContainer(
      {Key? key,
      required this.child,
      this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      this.gradient,
      this.color,
      this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          boxShadow: kElevation[6],
          color:
              gradient != null ? null : color ?? context.theme.cardBackground,
          gradient: gradient,
          border: Border.all(color: context.theme.primary.withOpacity(0.06)),
          borderRadius: BorderRadius.circular(60)),
      child: child,
    );
  }
}
