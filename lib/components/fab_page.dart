import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
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
    return Padding(
      padding: EdgeInsets.only(bottom: Platform.isIOS ? 12.0 : 4.0),
      child: Stack(
        fit: StackFit.expand,
        alignment: stackAlignment,
        clipBehavior: Clip.none,
        children: [
          child,
          if (columnButtons.isNotEmpty)
            Positioned(
              bottom: bottomPadding + 16 + (rowButtons.isEmpty ? 0 : 64),
              right: 16,
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
      ),
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

  final bool loading;

  const FloatingButton({
    Key? key,
    this.text,
    this.icon,
    required this.onTap,
    this.iconSize = 24,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(11),
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
          color: context.theme.background.withOpacity(0.9),
          padding: padding,
          margin: margin,
          child: AnimatedSwitcher(
            duration: kStandardAnimationDuration,
            child: loading
                ? const LoadingDots()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null)
                        Icon(
                          icon,
                          size: iconSize,
                        ),
                      if (icon != null && text != null)
                        const SizedBox(width: 6),
                      if (text != null)
                        MyText(
                          text!,
                          size: FONTSIZE.four,
                          weight: FontWeight.bold,
                        ),
                    ],
                  ),
          ),
        ));
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
          boxShadow: kElevation[6],
          color: gradient != null
              ? null
              : color ?? context.theme.background.withOpacity(0.9),
          border: Border.all(color: context.theme.primary, width: 2.5),
          borderRadius: BorderRadius.circular(60)),
      child: child,
    );
  }
}
