import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/components/text.dart';

extension StringExtension on String {
  String get capitalize => this[0].toUpperCase() + substring(1);
}

// https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension DateTimeFormatting on DateTime {
  String get timeString => DateFormat.jm().format(this);
  String get timeString24 => DateFormat('HH:mm').format(this);

  /// Date only - July 10, 1996
  String get dateString => DateFormat.yMMMMd().format(this);

  String get compactDateString => DateFormat('MMM d, yyyy').format(this);
  String get minimalDateStringYear => DateFormat('MMM d, yy').format(this);
  String get minimalDateString => DateFormat('MMM d').format(this);
  String get dateAndTime => '$minimalDateString, $timeString';

  String get daysAgo => isToday
      ? 'Today'
      : isYesterday
          ? 'Yesterday'
          : '${DateTime.now().difference(this).inDays} days ago';

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }
}

extension DoubleExtension on double {
  // https://python.developreference.com/article/10024227/How+to+remove+trailing+zeros+using+Dart
  // The "EDIT" version
  String stringMyDouble() {
    final int i = truncate();
    if (this == i) {
      return i.toString();
    }
    // Returns to max of two decimal places
    return ((this * 100).truncate() / 100).toString();
  }

  double roundMyDouble(
    int decimalPlaces,
  ) {
    final int i = truncate();
    if (this == i) {
      return i.toDouble();
    }
    // Returns to max of [decimalPlaces] decimal places
    return (this * pow(10, decimalPlaces)).round() / pow(10, decimalPlaces);
  }
}

extension DurationExtension on Duration {
  Widget display(
      {Axis direction = Axis.horizontal,
      bool bold = false,
      Color? color,
      FONTSIZE fontSize = FONTSIZE.three}) {
    final int minutes = inMinutes;
    final int seconds = inSeconds.remainder(60);
    final FontWeight weight = bold ? FontWeight.bold : FontWeight.normal;

    final List<Widget> children = [
      if (minutes != 0)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              minutes.toString(),
              weight: weight,
              lineHeight: 1.2,
              color: color,
              size: fontSize,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: MyText(
                'min',
                weight: weight,
                size: fontSize,
                color: color,
              ),
            ),
          ],
        ),
      if (seconds != 0)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              seconds.toString(),
              weight: weight,
              lineHeight: 1.3,
              color: color,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: MyText('secs', weight: weight, size: FONTSIZE.two),
            )
          ],
        ),
    ];
    if (direction == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
  }

  String get displayString {
    if (inSeconds == 0) {
      return '---';
    }
    final int minutes = inMinutes;
    final int seconds = inSeconds.remainder(60);
    final String minuteString = minutes != 0 ? '$minutes min' : "";
    final String secondsString = seconds != 0 ? '$seconds sec' : "";

    final minuteSpace = minutes != 0 && seconds != 0 ? ' ' : '';

    return '$minuteString$minuteSpace$secondsString';
  }

  Duration clamp(Duration lower, Duration upper) {
    if (this < lower) {
      return lower;
    } else if (this > upper) {
      return upper;
    } else {
      return this;
    }
  }

  String compactDisplay() {
    final String _hours =
        inHours != 0 ? '${inHours.toString().padLeft(2, '0')}:' : '';
    final String _minutes =
        '${inMinutes.remainder(60).toString().padLeft(2, '0')}:';
    final String _seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$_hours$_minutes$_seconds';
  }
}

extension IntExtension on int {
  String get secondsToTimeDisplay => Duration(seconds: this).compactDisplay();
}

extension ListExtension on List {
  /// If not in list, add it, else remove it.
  /// Assumes Equatable functionality if item is non scalar.
  /// Returns a new list.
  List<T> toggleItem<T>(T item) {
    return (this as List<T>).contains(item)
        ? (this as List<T>).where((e) => e != item).toList()
        : <T>[...this as List<T>, item];
  }
}

extension PageControllerExtension on PageController {
  void toPage(int page) => animateToPage(page,
      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
}
