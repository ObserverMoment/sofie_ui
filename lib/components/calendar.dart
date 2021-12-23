import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarUI {
  // https://github.com/aleksanderwozniak/table_calendar/issues/498
  static BoxDecoration kDefaultDecoration =
      const BoxDecoration(shape: BoxShape.circle);

  static CalendarStyle calendarStyle(BuildContext context) {
    final primaryTextStyle = GoogleFonts.sourceSansPro(
        textStyle:
            TextStyle(color: context.theme.primary, height: 1, fontSize: 15));
    return CalendarStyle(
        markerDecoration: const BoxDecoration(
            color: Styles.primaryAccent, shape: BoxShape.circle),
        // https://github.com/aleksanderwozniak/table_calendar/issues/498
        defaultDecoration: kDefaultDecoration,
        weekendDecoration: kDefaultDecoration,
        outsideDecoration: kDefaultDecoration,
        disabledDecoration: kDefaultDecoration,
        holidayDecoration: kDefaultDecoration,
        selectedDecoration: BoxDecoration(
          color: context.theme.primary,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
            border: Border.all(color: Styles.primaryAccent),
            shape: BoxShape.circle),
        weekendTextStyle: primaryTextStyle,
        selectedTextStyle: primaryTextStyle.copyWith(
            color: context.theme.cardBackground, fontWeight: FontWeight.bold),
        todayTextStyle: primaryTextStyle,
        defaultTextStyle: primaryTextStyle);
  }

  static DaysOfWeekStyle daysOfWeekStyle(BuildContext context) {
    final primaryTextStyle = GoogleFonts.sourceSansPro(
        textStyle: TextStyle(
            color: context.theme.primary.withOpacity(0.7),
            height: 1,
            fontSize: 15));
    return DaysOfWeekStyle(
      dowTextFormatter: (date, locale) =>
          DateFormat.E(locale).format(date).toUpperCase(),
      weekdayStyle: primaryTextStyle,
      weekendStyle: primaryTextStyle,
    );
  }
}
