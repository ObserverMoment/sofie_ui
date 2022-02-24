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

extension DateTimeExtension on DateTime {
  String get timeString => DateFormat.jm().format(this);
  String get timeString24 => DateFormat('HH:mm').format(this);

  /// Date only - July 10, 1996
  String get dateString => DateFormat.yMMMMd().format(this);

  String get compactDateString => DateFormat('MMM d, yyyy').format(this);
  String get minimalDateStringYear => DateFormat('MMM d, yy').format(this);
  String get minimalDateString => DateFormat('MMM d').format(this);
  String get dateAndTime => '$minimalDateString, $timeString';

  String get monthAbbrev => DateFormat('MMM').format(this);

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 0) {
      return '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else {
      return '${diff.inMinutes}m';
    }
  }

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

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// https://github.com/KadaDev/week_of_year/blob/master/lib/date_week_extensions.dart
  /// The ISO 8601 week of year [1..53].
  /// Algorithm from https://en.wikipedia.org/wiki/ISO_week_date#Algorithms
  int get weekNumberInYear {
    // Add 3 to always compare with January 4th, which is always in week 1
    // Add 7 to index weeks starting with 1 instead of 0
    final woy = ((dayNumberInYear - weekday + 10) ~/ 7);

    // If the week number equals zero, it means that the given date belongs to the preceding (week-based) year.
    if (woy == 0) {
      // The 28th of December is always in the last week of the year
      return DateTime(year - 1, 12, 28).weekNumberInYear;
    }

    // If the week number equals 53, one must check that the date is not actually in week 1 of the following year
    if (woy == 53 &&
        DateTime(year, 1, 1).weekday != DateTime.thursday &&
        DateTime(year, 12, 31).weekday != DateTime.thursday) {
      return 1;
    }

    return woy;
  }

  /// https://github.com/KadaDev/week_of_year/blob/master/lib/date_week_extensions.dart
  /// The ordinal date, the number of days since December 31st the previous year.
  /// January 1st has the ordinal date 1
  /// December 31st has the ordinal date 365, or 366 in leap years
  int get dayNumberInYear {
    const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return offsets[month - 1] + day + (isLeapYear && month > 2 ? 1 : 0);
  }

  /// True if this date is on a leap year.
  bool get isLeapYear {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  /// https://stackoverflow.com/questions/49393231/how-to-get-day-of-year-week-of-year-from-a-datetime-dart-object
  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  /// Returns the number of weeks in the year.
  int get numWeeksInYear {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Adding and subtracting. Pass negative
  DateTime daysBefore(int days) => DateTime(year, month, day - days);
  DateTime daysAfter(int days) => DateTime(year, month, day + days);

  /// Checking date falling within a range.
  bool isBeforeOrSame(DateTime to) => isAtSameMomentAs(to) || isBefore(to);
  bool isAfterOrSame(DateTime from) => isAtSameMomentAs(from) || isAfter(from);
  bool isBetweenDates(DateTime? from, DateTime? to) =>
      (from == null || isAfterOrSame(from)) &&
      (to == null || isBeforeOrSame(to));
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

  String get compactDisplay {
    final String _hours =
        inHours != 0 ? '${inHours.toString().padLeft(2, '0')}:' : '';
    final String _minutes =
        '${inMinutes.remainder(60).toString().padLeft(2, '0')}:';
    final String _seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$_hours$_minutes$_seconds';
  }
}

extension IntExtension on int {
  String get secondsToTimeDisplay => Duration(seconds: this).compactDisplay;

  /// TODO: Requires internationalisation.
  String get displayLong => NumberFormat(
        "#,###,##0",
      ).format(this);
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

  List<T> toggleItems<T>(List<T> items) {
    List<T> result = [...this];
    for (final i in items) {
      if (result.contains(i)) {
        result.removeWhere((o) => o == i);
      } else {
        result.add(i);
      }
    }
    return result;
  }
}

extension PageControllerExtension on PageController {
  void toPage(int page) => animateToPage(page,
      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
}
