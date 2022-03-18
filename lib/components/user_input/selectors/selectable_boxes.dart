import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class SelectableBox extends StatelessWidget {
  final bool isSelected;
  final void Function() onPressed;
  final String text;
  final Color selectedColor;
  final FONTSIZE fontSize;
  final EdgeInsets padding;
  final double height;
  const SelectableBox(
      {Key? key,
      required this.isSelected,
      required this.onPressed,
      required this.text,
      this.height = 60,
      this.fontSize = FONTSIZE.four,
      this.selectedColor = Styles.primaryAccent,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: AnimatedOpacity(
          duration: kStandardAnimationDuration,
          opacity: isSelected ? 1.0 : 0.6,
          child: Container(
            height: height,
            decoration: BoxDecoration(
                color: context.theme.cardBackground,
                borderRadius: BorderRadius.circular(8)),
            padding: padding,
            child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  MyText(
                    text,
                    size: fontSize,
                    lineHeight: 1,
                    weight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  if (isSelected)
                    const Positioned(
                      top: -10,
                      right: -13,
                      child: FadeIn(
                          child: Icon(
                        CupertinoIcons.checkmark_alt,
                        color: Styles.primaryAccent,
                        size: 21,
                      )),
                    )
                ]),
          )),
    );
  }
}

/// For use in a vertical list when you want the container to take up the full width of the screen.
class SelectableBoxExpanded extends StatelessWidget {
  final bool isSelected;
  final void Function() onPressed;
  final String text;
  final Color selectedColor;
  final FONTSIZE fontSize;
  final double height;

  const SelectableBoxExpanded({
    Key? key,
    required this.isSelected,
    required this.onPressed,
    required this.text,
    this.height = 60,
    this.fontSize = FONTSIZE.four,
    this.selectedColor = Styles.primaryAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: AnimatedOpacity(
          duration: kStandardAnimationDuration,
          opacity: isSelected ? 1.0 : 0.6,
          child: Container(
            height: height,
            decoration: BoxDecoration(
                color: context.theme.cardBackground,
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Center(
                    child: MyText(
                      text,
                      size: fontSize,
                      lineHeight: 1,
                      weight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isSelected)
                    const Positioned(
                      top: -8,
                      right: -8,
                      child: FadeIn(
                          child: Icon(
                        CupertinoIcons.checkmark_alt,
                        color: Styles.primaryAccent,
                        size: 24,
                      )),
                    )
                ]),
          )),
    );
  }
}

class SelectableBoxTextOnly extends StatelessWidget {
  final bool isSelected;
  final void Function() onPressed;
  final String text;
  final Color selectedColor;
  final FONTSIZE fontSize;
  final EdgeInsets padding;
  const SelectableBoxTextOnly(
      {Key? key,
      required this.isSelected,
      required this.onPressed,
      required this.text,
      this.fontSize = FONTSIZE.four,
      this.selectedColor = Styles.primaryAccent,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Padding(
        padding: padding,
        child: AnimatedOpacity(
            duration: kStandardAnimationDuration,
            opacity: isSelected ? 1.0 : 0.6,
            child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  MyText(
                    text,
                    size: fontSize,
                    lineHeight: 1,
                    weight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  if (isSelected)
                    const Positioned(
                      top: -12,
                      right: -12,
                      child: FadeIn(
                          child: Icon(
                        CupertinoIcons.checkmark_alt,
                        color: Styles.primaryAccent,
                        size: 18,
                      )),
                    )
                ])),
      ),
    );
  }
}
