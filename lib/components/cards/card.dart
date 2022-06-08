import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';

class Card extends StatelessWidget {
  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final BorderRadiusGeometry? borderRadius;
  final DecorationImage? backgroundImage;

  final int? elevation;

  const Card(
      {Key? key,
      this.height,
      required this.child,
      this.backgroundColor,
      this.padding = kStandardCardPadding,
      this.borderRadius,
      this.elevation = 2,
      this.backgroundImage,
      this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      height: height,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
          color: backgroundColor ?? context.theme.cardBackground,
          boxShadow: kElevation[elevation],
          borderRadius: borderRadius ?? kStandardCardBorderRadius,
          image: backgroundImage),
      child: child,
    );
  }
}
