import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

enum TrimMode {
  length,
  line,
}

class ReadMoreTextBlock extends StatelessWidget {
  const ReadMoreTextBlock({
    Key? key,
    required this.text,
    required this.title,
    this.trimLength = 240,
    this.trimLines = 3,
    this.trimMode = TrimMode.line,
    this.locale,
    this.semanticsLabel,
    this.delimiterStyle,
    this.fontSize = 17,
    this.textAlign = TextAlign.start,
    this.textColor,
  }) : super(key: key);

  final double fontSize;

  final TextAlign textAlign;

  final Color? textColor;

  /// Used on TrimMode.length
  final int trimLength;

  /// Used on TrimMode.lines
  final int trimLines;

  /// Determines the type of trim. TrimMode.length takes into account
  /// the number of letters, while TrimMode.lines takes into account
  /// the number of lines
  final TrimMode trimMode;

  final String text;
  final String title;
  final Locale? locale;
  final String? semanticsLabel;
  final TextStyle? delimiterStyle;

  final String _klineSeparator = '\u2028';
  final String delimiter = '\u2026';

  void _onTapLink(BuildContext context) {
    context.push(child: TextViewer(text, title));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? effectiveTextStyle = context
        .theme.cupertinoThemeData.textTheme.textStyle
        .copyWith(fontSize: fontSize, color: textColor);

    final textDirection = Directionality.of(context);
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final selectedLocale = locale ?? Localizations.maybeLocaleOf(context);

    final defaultDelimiterStyle = delimiterStyle ?? effectiveTextStyle;

    TextSpan link = const TextSpan(
        text: 'MORE', style: TextStyle(color: Styles.primaryAccent));

    TextSpan textDelimiter = TextSpan(
      text: delimiter,
      style: defaultDelimiterStyle,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // Create a TextSpan with text
        final styledText = TextSpan(
          style: effectiveTextStyle,
          text: text,
        );

        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: trimLines,
          ellipsis: delimiter,
          locale: selectedLocale,
        );
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        // Layout and measure delimiter
        textPainter.text = textDelimiter;
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final delimiterSize = textPainter.size;

        // Layout and measure text
        textPainter.text = styledText;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        // Get the endIndex of text
        bool linkLongerThanline = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final readMoreSize = linkSize.width + delimiterSize.width;
          final pos = textPainter.getPositionForOffset(Offset(
            textDirection == TextDirection.rtl
                ? readMoreSize
                : textSize.width - readMoreSize,
            textSize.height,
          ));
          endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
        } else {
          final pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
          linkLongerThanline = true;
        }

        TextSpan textSpan;
        switch (trimMode) {
          case TrimMode.length:
            if (trimLength < text.length) {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: text.substring(0, trimLength),
                children: <TextSpan>[textDelimiter, link],
              );
            } else {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: text,
              );
            }
            break;
          case TrimMode.line:
            if (textPainter.didExceedMaxLines) {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: text.substring(0, endIndex) +
                    (linkLongerThanline ? _klineSeparator : ''),
                children: <TextSpan>[textDelimiter, link],
              );
            } else {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: text,
              );
            }
            break;
          default:
            throw Exception('TrimMode type: $trimMode is not supported');
        }

        return RichText(
            textDirection: textDirection,
            softWrap: true,
            //softWrap,
            overflow: TextOverflow.fade,
            //overflow,
            textScaleFactor: textScaleFactor,
            text: textSpan,
            textAlign: textAlign);
      },
    );
    if (semanticsLabel != null) {
      result = Semantics(
        textDirection: textDirection,
        label: semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }
    return GestureDetector(onTap: () => _onTapLink(context), child: result);
  }
}

class TextViewer extends StatelessWidget {
  final String text;
  final String title;
  const TextViewer(this.text, this.title, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarLargeTitle(title),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: MyText(
            text,
            maxLines: 999,
            lineHeight: 1.4,
            size: FONTSIZE.four,
          ),
        ),
      ),
    );
  }
}
