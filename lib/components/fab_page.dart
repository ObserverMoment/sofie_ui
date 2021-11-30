import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';

enum ButtonAlignment { left, center, right }

class FABPage extends StatelessWidget {
  final Widget child;
  final List<Widget> buttons;
  final ButtonAlignment buttonAlignment;
  FABPage({
    Key? key,
    required this.child,
    this.buttonAlignment = ButtonAlignment.center,
    required this.buttons,
  }) : super(key: key);

  final Map<ButtonAlignment, MainAxisAlignment> _rowMap = {
    ButtonAlignment.left: MainAxisAlignment.start,
    ButtonAlignment.center: MainAxisAlignment.center,
    ButtonAlignment.right: MainAxisAlignment.end,
  };

  final Map<ButtonAlignment, Alignment> _alignMap = {
    ButtonAlignment.left: Alignment.bottomLeft,
    ButtonAlignment.center: Alignment.bottomCenter,
    ButtonAlignment.right: Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: _alignMap[buttonAlignment]!,
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
            bottom: 8,
            child: Row(
              mainAxisAlignment: _rowMap[buttonAlignment]!,
              mainAxisSize: MainAxisSize.min,
              children: buttons,
            ))
      ],
    );
  }
}

class FloatingButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final void Function() onTap;

  const FloatingButton({
    Key? key,
    this.text,
    this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentColor = context.theme.background;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Vibrate.feedback(FeedbackType.light);
          onTap();
        },
        child: FABPageButtonContainer(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (text != null)
                MyText(
                  text!,
                  color: contentColor,
                  size: FONTSIZE.four,
                ),
              if (icon != null && text != null) const SizedBox(width: 10),
              if (icon != null) Icon(icon, size: 26, color: contentColor),
            ],
          ),
        ),
      ),
    );
  }
}

class FABPageButtonContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Color? color;

  const FABPageButtonContainer(
      {Key? key,
      required this.child,
      this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      this.gradient,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: padding,
      decoration: BoxDecoration(
          boxShadow: kElevation[6],
          color: context.theme.primary.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}
