import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_rotation.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:table_calendar/table_calendar.dart';

/// Determines which picker is open.
/// https://www.idownloadblog.com/2021/06/09/apple-ios-15-wheel-time-picker/
enum DateTimePickerMode { date, time }

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

class DateTimePickerDisplay extends StatelessWidget {
  final String title;
  final DateTime? dateTime;
  final bool showDate;
  final bool showTime;
  final void Function(DateTime dateTime) saveDateTime;
  final Color? contentBoxColor;
  const DateTimePickerDisplay(
      {Key? key,
      required this.dateTime,
      this.showDate = true,
      this.showTime = true,
      this.title = 'When',
      required this.saveDateTime,
      this.contentBoxColor})
      : assert(showDate || showTime),
        super(key: key);

  void _openDateTimePicker(BuildContext context, DateTimePickerMode mode) {
    context.showBottomSheet(
        child: DateTimePicker(
      title: title,
      dateTime: dateTime,
      showDate: showDate,
      showTime: showTime,
      mode: mode,
      saveDateTime: saveDateTime,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DateTimePickerDisplayRow(
      title: title,
      dateTime: dateTime,
      showDate: showDate,
      showTime: showTime,
      onTapDate: () => _openDateTimePicker(context, DateTimePickerMode.date),
      onTapTime: () => _openDateTimePicker(context, DateTimePickerMode.time),
      contentBoxColor: contentBoxColor,
    );
  }
}

class DateTimePickerDisplayRow extends StatelessWidget {
  final String title;
  final DateTime? dateTime;
  final bool showDate;
  final bool showTime;
  final VoidCallback onTapDate;
  final VoidCallback onTapTime;
  final Color? contentBoxColor;

  /// When being used in picker (rather than in display) - highlight the active picker type display.
  final int? activePickerIndex;
  const DateTimePickerDisplayRow(
      {Key? key,
      required this.dateTime,
      this.showDate = true,
      this.showTime = true,
      this.title = 'When',
      required this.onTapDate,
      required this.onTapTime,
      this.contentBoxColor,
      this.activePickerIndex})
      : assert(showDate || showTime),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Styles.primaryAccent;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(title),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDate)
              GestureDetector(
                onTap: onTapDate,
                child: ContentBox(
                    backgroundColor: contentBoxColor,
                    child: MyText(
                      dateTime == null
                          ? 'Select date...'
                          : dateTime!.compactDateString,
                      color: activePickerIndex == 0 ? highlightColor : null,
                      weight: activePickerIndex == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
              ),
            if (showDate && showTime) const SizedBox(width: 6),
            if (showTime)
              GestureDetector(
                onTap: onTapTime,
                child: ContentBox(
                    backgroundColor: contentBoxColor,
                    child: MyText(
                      dateTime == null
                          ? 'Select time...'
                          : dateTime!.timeString24,
                      color: activePickerIndex == 1 ? highlightColor : null,
                      weight: activePickerIndex == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
              ),
          ],
        ),
      ],
    );
  }
}

class DateTimePicker extends StatefulWidget {
  final String title;
  final DateTime? dateTime;
  final bool showDate;
  final bool showTime;
  final DateTimePickerMode mode;
  final void Function(DateTime dateTime) saveDateTime;
  const DateTimePicker(
      {Key? key,
      this.showDate = true,
      this.showTime = true,
      this.mode = DateTimePickerMode.date,
      required this.title,
      this.dateTime,
      required this.saveDateTime})
      : assert(showDate || showTime),
        super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late int _activePickerIndex;
  late DateTime _activeDateTime;

  @override
  void initState() {
    super.initState();
    _activePickerIndex = widget.mode == DateTimePickerMode.date ? 0 : 1;
    _activeDateTime = widget.dateTime ?? DateTime.now();
  }

  void _updateDate(DateTime newDate) {
    final updatedDateTime = DateTime(newDate.year, newDate.month, newDate.day,
        _activeDateTime.hour, _activeDateTime.minute);
    setState(() => _activeDateTime = updatedDateTime);
  }

  void _updateTime(DateTime newTime) {
    final updatedDateTime = DateTime(
        _activeDateTime.year,
        _activeDateTime.month,
        _activeDateTime.day,
        newTime.hour,
        newTime.minute);
    setState(() => _activeDateTime = updatedDateTime);
  }

  void _saveAndClose() {
    widget.saveDateTime(_activeDateTime);
    context.pop();
  }

  String get _buildTitle {
    if (widget.showDate && widget.showTime) {
      return 'Select Date and Time';
    } else if (!widget.showDate) {
      return 'Select Time';
    } else {
      return 'Select Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalPageScaffold(
      title: _buildTitle,
      save: _saveAndClose,
      cancel: context.pop,
      validToSave: true,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            DateTimePickerDisplayRow(
                title: widget.title,
                dateTime: _activeDateTime,
                showDate: widget.showDate,
                showTime: widget.showTime,
                onTapDate: () => setState(() => _activePickerIndex = 0),
                onTapTime: () => setState(() => _activePickerIndex = 1),
                activePickerIndex: _activePickerIndex),
            const SizedBox(height: 10),
            ContentBox(
              child: IndexedStack(
                index: _activePickerIndex,
                children: [
                  GrowInOut(
                      show: _activePickerIndex == 0,
                      child: DatePickerCalendar(
                        dateTime: _activeDateTime,
                        updateDateTime: _updateDate,
                      )),
                  GrowInOut(
                      show: _activePickerIndex == 1,
                      child: TimePicker(
                        dateTime: _activeDateTime,
                        updateDateTime: _updateTime,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Will only update the years, months and days.
/// Will maintain the original hours and minutes.
class DatePickerCalendar extends StatefulWidget {
  final DateTime? dateTime;
  final void Function(DateTime date) updateDateTime;
  const DatePickerCalendar(
      {Key? key, required this.dateTime, required this.updateDateTime})
      : super(key: key);

  @override
  State<DatePickerCalendar> createState() => _DatePickerCalendarState();
}

class _DatePickerCalendarState extends State<DatePickerCalendar> {
  /// use this to move around the calendar.
  late DateTime _focusedDay;

  /// controls highlighting of the selected day.
  DateTime? _selectedDay;

  /// 0 is the calendar grid view.
  /// 1 is the month and year picker in iOS style (scroll wheel)
  int _activeTabIndex = 0;

  final DateTime _earliestDate = DateTime.utc(2000);
  final DateTime _latestDate = DateTime.utc(2099, 12, 31);

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.dateTime ?? DateTime.now();
    _selectedDay = widget.dateTime;
  }

  @override
  void didUpdateWidget(covariant DatePickerCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _focusedDay = widget.dateTime ?? DateTime.now();
    _selectedDay = widget.dateTime;
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    widget.updateDateTime(selected);
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
                onPressed: () => setState(
                    () => _activeTabIndex = _activeTabIndex == 0 ? 1 : 0),
                child: Row(
                  children: [
                    MyText(
                      DateFormat('MMMM yyyy').format(_focusedDay),
                      weight: FontWeight.bold,
                      size: FONTSIZE.four,
                      color: _activeTabIndex == 1 ? Styles.primaryAccent : null,
                    ),
                    const SizedBox(width: 4),
                    MyAnimatedRotation(
                      turns: 0.25,
                      rotate: _activeTabIndex == 1,
                      child: Icon(
                        CupertinoIcons.chevron_right,
                        size: 18,
                        color:
                            _activeTabIndex == 1 ? Styles.primaryAccent : null,
                      ),
                    )
                  ],
                )),
            Row(
              children: [
                CupertinoButton(
                  onPressed: () => setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month - 1);
                  }),
                  child: const Icon(
                    CupertinoIcons.chevron_left,
                  ),
                ),
                CupertinoButton(
                  onPressed: () => setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month + 1);
                  }),
                  child: const Icon(
                    CupertinoIcons.chevron_right,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 350,
          child: IndexedStack(
            index: _activeTabIndex,
            children: [
              Material(
                color: context.theme.cardBackground,
                child: TableCalendar(
                    headerVisible: false,
                    onDaySelected: _onDaySelected,
                    firstDay: _earliestDate,
                    lastDay: _latestDate,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    daysOfWeekStyle: CalendarUI.daysOfWeekStyle(context),
                    calendarStyle: CalendarUI.calendarStyle(context)),
              ),
              SizedBox(
                height: 300,
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  minimumDate: _earliestDate,
                  maximumDate: _latestDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (d) => _onDaySelected(d, d),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

/// Will only update the hours and minutes.
/// Will maintain the original years, months and days.
class TimePicker extends StatefulWidget {
  final DateTime? dateTime;
  final void Function(DateTime date) updateDateTime;
  const TimePicker(
      {Key? key, required this.dateTime, required this.updateDateTime})
      : super(key: key);

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late DateTime _activeDateTime;

  @override
  void initState() {
    super.initState();
    _activeDateTime = widget.dateTime ?? DateTime.now();
  }

  void onDateTimeChangedViaScroll(DateTime selected) {
    widget.updateDateTime(selected);
    setState(() {
      _activeDateTime = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: CupertinoDatePicker(
        initialDateTime: _activeDateTime,
        mode: CupertinoDatePickerMode.time,
        use24hFormat: true,
        onDateTimeChanged: onDateTimeChangedViaScroll,
      ),
    );
  }
}

class DateRangePickerDisplay extends StatelessWidget {
  final DateTime? from;
  final DateTime? to;
  final void Function(DateTime? from, DateTime? to) updateRange;
  final Color textColor;
  const DateRangePickerDisplay({
    Key? key,
    required this.from,
    required this.to,
    required this.updateRange,
    required this.textColor,
  }) : super(key: key);

  Widget _text(String t) => MyText(
        t,
        color: textColor,
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      onPressed: () => context.showBottomSheet(
          child: DateRangePicker(
        from: from,
        saveDateRange: updateRange,
        to: to,
      )),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.calendar,
            color: textColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          if (from == null && to == null)
            _text('All time')
          else if (from == null && to != null)
            _text('Before ${to!.compactDateString}')
          else if (from != null && to == null)
            _text('After ${from!.compactDateString}')
          else
            _text(
                '${from!.minimalDateStringYear} - ${to!.minimalDateStringYear}'),
        ],
      ),
    );
  }
}

class DateRangePicker extends StatefulWidget {
  final DateTime? from;
  final DateTime? to;
  final void Function(DateTime? from, DateTime? to) saveDateRange;
  const DateRangePicker(
      {Key? key,
      required this.from,
      required this.to,
      required this.saveDateRange})
      : super(key: key);

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  /// 0 is [_from]. 1 is [_to]
  int _activePickerIndex = 0;
  late DateTime? _from;
  late DateTime? _to;

  @override
  void initState() {
    super.initState();
    _from = widget.from;
    _to = widget.to;
  }

  void _updateFrom(DateTime? newDate) {
    setState(() => _from = newDate);
  }

  void _updateTo(DateTime? newDate) {
    setState(() => _to = newDate);
  }

  bool _inputsValid() {
    if (_from != null && _to != null) {
      return _from!.isBefore(_to!);
    } else {
      return true;
    }
  }

  void _saveAndClose() {
    widget.saveDateRange(_from, _to);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ModalPageScaffold(
      save: _saveAndClose,
      validToSave: _inputsValid(),
      cancel: context.pop,
      title: 'Select Date Range',
      child: ListView(
        shrinkWrap: true,
        children: [
          ContentBox(
              child: Column(
            children: [
              DateRangePickerRow(
                onTapDate: () => setState(() => _activePickerIndex = 0),
                pickerActive: _activePickerIndex == 0,
                dateTime: _from,
                title: 'Start date',
                selectedDateIsValid: _inputsValid(),
                clearDateTime: () => _updateFrom(null),
              ),
              GrowInOut(
                  show: _activePickerIndex == 0,
                  child: DatePickerCalendar(
                      dateTime: _from, updateDateTime: _updateFrom)),
            ],
          )),
          const SizedBox(height: 12),
          ContentBox(
              child: Column(
            children: [
              DateRangePickerRow(
                onTapDate: () => setState(() => _activePickerIndex = 1),
                pickerActive: _activePickerIndex == 1,
                dateTime: _to,
                title: 'End date',
                selectedDateIsValid: _inputsValid(),
                clearDateTime: () => _updateTo(null),
              ),
              GrowInOut(
                  show: _activePickerIndex == 1,
                  child: DatePickerCalendar(
                      dateTime: _to, updateDateTime: _updateTo)),
            ],
          )),
        ],
      ),
    );
  }
}

class DateRangePickerRow extends StatelessWidget {
  final String title;
  final DateTime? dateTime;
  final VoidCallback clearDateTime;
  final VoidCallback onTapDate;
  final bool pickerActive;
  final Color? contentBoxColor;
  final bool selectedDateIsValid;
  const DateRangePickerRow(
      {Key? key,
      required this.title,
      this.dateTime,
      required this.onTapDate,
      this.contentBoxColor,
      required this.pickerActive,
      required this.selectedDateIsValid,
      required this.clearDateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onTapDate,
                child: ContentBox(
                    backgroundColor: contentBoxColor,
                    child: MyText(
                      dateTime == null
                          ? 'Select date...'
                          : dateTime!.compactDateString,
                      color: !selectedDateIsValid
                          ? Styles.errorRed
                          : pickerActive
                              ? Styles.primaryAccent
                              : null,
                      weight:
                          pickerActive ? FontWeight.bold : FontWeight.normal,
                      decoration: selectedDateIsValid
                          ? null
                          : TextDecoration.lineThrough,
                    )),
              ),
              CupertinoButton(
                  onPressed: clearDateTime,
                  child: const Icon(CupertinoIcons.clear_thick, size: 18))
            ],
          ),
        ],
      ),
    );
  }
}
