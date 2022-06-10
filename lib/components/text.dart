import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

enum FONTSIZE {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  eleven,
  twelve
}

Map<FONTSIZE, double> _fontSizeMap = {
  FONTSIZE.zero: 8,
  FONTSIZE.one: 10,
  FONTSIZE.two: 13,
  FONTSIZE.three: 15,
  FONTSIZE.four: 17,
  FONTSIZE.five: 21,
  FONTSIZE.six: 24,
  FONTSIZE.seven: 27,
  FONTSIZE.eight: 31,
  FONTSIZE.nine: 37,
  FONTSIZE.ten: 47,
  FONTSIZE.eleven: 57,
  FONTSIZE.twelve: 59,
};

class MyText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final FONTSIZE size;
  final FontWeight weight;
  final TextOverflow overflow;
  final int? maxLines;
  final Color? color;
  final TextDecoration? decoration;
  final double? lineHeight;
  final bool subtext;
  final double? letterSpacing;

  const MyText(this.text,
      {Key? key,
      this.textAlign = TextAlign.start,
      this.size = FONTSIZE.three,
      this.overflow = TextOverflow.ellipsis,
      this.weight = FontWeight.normal,
      this.maxLines = 1,
      this.color,
      this.decoration,
      this.lineHeight = 1.1,
      this.subtext = false,
      this.letterSpacing = 1.1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
            fontWeight: weight,
            decoration: decoration,
            height: lineHeight,
            fontSize: _fontSizeMap[size],
            letterSpacing: letterSpacing,
            color: subtext
                ? context.theme.primary.withOpacity(0.75)
                : color ?? context.theme.primary));
  }
}

class MyRichText extends StatelessWidget {
  final List<TextSpan> children;
  final FONTSIZE size;
  final FontWeight weight;
  final double? lineHeight;
  const MyRichText(
      {Key? key,
      required this.children,
      this.size = FONTSIZE.three,
      this.weight = FontWeight.normal,
      this.lineHeight = 1.3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: children),
        style: GoogleFonts.sourceSansPro(
          textStyle: TextStyle(
              color: context.theme.primary,
              fontWeight: weight,
              fontSize: _fontSizeMap[size],
              height: lineHeight,
              letterSpacing: 1.1),
        ));
  }
}

class MyHeaderText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final FONTSIZE size;
  final FontWeight weight;
  final TextOverflow overflow;
  final int? maxLines;
  final Color? color;
  final TextDecoration? decoration;
  final double? lineHeight;
  final double? letterSpacing;
  final bool subtext;

  const MyHeaderText(this.text,
      {Key? key,
      this.textAlign = TextAlign.start,
      this.size = FONTSIZE.three,
      this.overflow = TextOverflow.ellipsis,
      this.weight = FontWeight.bold,
      this.maxLines = 1,
      this.color,
      this.decoration,
      this.lineHeight = 1.1,
      this.subtext = false,
      this.letterSpacing = 1.2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.archivo(
            textStyle: TextStyle(
                fontWeight: weight,
                decoration: decoration,
                height: lineHeight,
                fontSize: _fontSizeMap[size],
                letterSpacing: letterSpacing,
                color: subtext
                    ? context.theme.primary.withOpacity(0.75)
                    : color ?? context.theme.primary)));
  }
}

class H1 extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color? color;
  final TextOverflow overflow;

  const H1(this.text,
      {Key? key,
      this.textAlign = TextAlign.start,
      this.color,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyHeaderText(text,
        color: color, textAlign: textAlign, size: FONTSIZE.six);
  }
}

class H2 extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color? color;
  final TextOverflow overflow;
  const H2(this.text,
      {Key? key,
      this.textAlign = TextAlign.start,
      this.color,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyHeaderText(text,
        color: color, textAlign: textAlign, size: FONTSIZE.five);
  }
}

class H3 extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color? color;
  final TextOverflow overflow;
  const H3(this.text,
      {Key? key,
      this.textAlign = TextAlign.start,
      this.color,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHeaderText(
      text,
      color: color,
      textAlign: textAlign,
      size: FONTSIZE.four,
    );
  }
}

/// Use top left of a top nav bar in an IOs-ish style.
class NavBarLargeTitle extends StatelessWidget {
  final String title;
  const NavBarLargeTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyHeaderText(
            title,
            size: FONTSIZE.four,
          ),
        ],
      ),
    );
  }
}

/// Small size, bold, uppercase letters
class NavBarTitle extends StatelessWidget {
  final String text;
  const NavBarTitle(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MyHeaderText(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// For when we want the title to be on the left of the nav bar and an action button on the right.
/// E.g. Selecting from a list before popping.
class LeadingNavBarTitle extends StatelessWidget {
  final String text;
  final FONTSIZE fontSize;
  const LeadingNavBarTitle(this.text, {Key? key, this.fontSize = FONTSIZE.four})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          MyHeaderText(
            text.toUpperCase(),
            size: fontSize,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Displays a widget up and to the right of normal text position. i.e super.
class SuperText extends StatelessWidget {
  final Widget child;
  const SuperText({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -8),
      child: child,
    );
  }
}

/// Displays '(required)' in super text pos and style. For inputs.
class RequiredSuperText extends StatelessWidget {
  const RequiredSuperText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SuperText(
      child: Icon(
        CupertinoIcons.exclamationmark_circle_fill,
        size: 14,
        color: Styles.errorRed,
      ),
    );
  }
}

class InfoPageText extends StatelessWidget {
  final String text;
  const InfoPageText(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyText(
      text,
      maxLines: 30,
      lineHeight: 1.5,
    );
  }
}
