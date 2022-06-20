import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/date_and_year_picker.dart';
import 'package:sofie_ui/components/workout_type_icons.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/calendar/calendar_bloc.dart';
import 'package:sofie_ui/modules/scheduled_workout/scheduled_workout_bloc.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/components/resistance_workout_card.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  final DateTime? openAtDate;
  final String? previousPageTitle;
  const CalendarPage({Key? key, this.openAtDate, this.previousPageTitle})
      : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _controller = CalendarController();

  bool _showMonthYearPicker = false;

  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _controller.view = CalendarView.month;
    _selectedDateTime = widget.openAtDate ?? DateTime.now();
    _controller.displayDate = _selectedDateTime;

    _controller.addPropertyChangedListener((p) {
      if (p == 'displayDate' &&
          !_controller.displayDate!.isAtSameMomentAs(_selectedDateTime)) {
        setState(() => _selectedDateTime = _controller.displayDate!);
      }
    });
  }

  void _toggleViewType() => setState(() {
        _controller.view = _controller.view == CalendarView.month
            ? CalendarView.schedule
            : CalendarView.month;
      });

  void _toggleMonthYearPicker() {
    if (_showMonthYearPicker) {
      _controller.displayDate = _selectedDateTime;
    }
    setState(() {
      _showMonthYearPicker = !_showMonthYearPicker;
    });
  }

  //// Builders ////
  Widget _scheduleViewMonthHeaderBuilder(
      BuildContext context, ScheduleViewMonthHeaderDetails details) {
    return ContentBox(
        child: Center(child: MyHeaderText(details.date.monthAndYear)));
  }

  Widget _appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    return Column(
      children: (details.appointments)
          .map((a) => ContentBox(
                  child: Column(
                children: [
                  Row(
                    children: [MyText('Time'), MyText('Location')],
                  ),
                  Row(
                    children: [Icon(WorkoutType.stability), MyText('Name')],
                  ),
                ],
              )))
          .toList(),
    );
  }

  //// Settings ////
  MonthViewSettings _monthViewSettings() => const MonthViewSettings(
        showTrailingAndLeadingDates: false,
        dayFormat: 'EEE',
        appointmentDisplayMode: MonthAppointmentDisplayMode.none,
      );

  ScheduleViewSettings _scheduleViewSettings(TextStyle defaultTextStyle) =>
      ScheduleViewSettings(
          monthHeaderSettings: const MonthHeaderSettings(height: 34),
          appointmentItemHeight: 60,
          weekHeaderSettings:
              WeekHeaderSettings(weekTextStyle: defaultTextStyle),
          dayHeaderSettings: DayHeaderSettings(
              dayTextStyle: defaultTextStyle, dateTextStyle: defaultTextStyle));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle =
        context.theme.cupertinoThemeData.textTheme.textStyle;

    return ChangeNotifierProvider(
        create: (_) => CalendarBloc(),
        child: MyPageScaffold(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        iconData: CupertinoIcons.chevron_back,
                        onPressed: context.pop),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: GestureDetector(
                                onTap: _toggleViewType,
                                child: AnimatedContainer(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          _controller.view == CalendarView.month
                                              ? context.theme.cardBackground
                                              : Styles.primaryAccent),
                                  duration: kStandardAnimationDuration,
                                  child: Icon(
                                    CupertinoIcons.list_bullet,
                                    color:
                                        _controller.view == CalendarView.month
                                            ? context.theme.primary
                                            : context.theme.background,
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 120,
                            child: TertiaryButton(
                                fontSize: FONTSIZE.three,
                                text: _selectedDateTime.monthAndYear,
                                suffixIconData: CupertinoIcons.chevron_down,
                                onPressed: _toggleMonthYearPicker),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                GrowInOut(
                    show: _showMonthYearPicker,
                    child: DateAndYearPicker(
                        dateTime: _selectedDateTime,
                        update: (d) => setState(() => _selectedDateTime = d))),
                Expanded(
                  child: LayoutBuilder(
                      builder: ((context, constraints) => SizedBox(
                            height: constraints.maxHeight,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SfCalendar(
                                  controller: _controller,
                                  dataSource: _ScheduledWorkoutsDataSource([
                                    ScheduledWorkout()
                                      ..id = 'test'
                                      ..createdAt = DateTime.now()
                                      ..scheduledAt = DateTime.now(),
                                    ScheduledWorkout()
                                      ..id = 'test 2'
                                      ..createdAt =
                                          DateTime.now().add(Duration(days: 7))
                                      ..scheduledAt =
                                          DateTime.now().add(Duration(days: 6))
                                  ]),
                                  headerHeight: 0,
                                  initialSelectedDate: DateTime.now(),
                                  viewHeaderHeight: 30,
                                  scheduleViewSettings:
                                      _scheduleViewSettings(defaultTextStyle),
                                  scheduleViewMonthHeaderBuilder:
                                      _scheduleViewMonthHeaderBuilder,
                                  appointmentBuilder: _appointmentBuilder,
                                  monthViewSettings: _monthViewSettings(),
                                  selectionDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: context.theme.primary, width: 2),
                                  ),
                                  todayHighlightColor: context.theme.primary,
                                  viewHeaderStyle: ViewHeaderStyle(
                                      dayTextStyle: defaultTextStyle),
                                  headerStyle: CalendarHeaderStyle(
                                    textStyle:
                                        defaultTextStyle.copyWith(fontSize: 16),
                                  ),
                                  monthCellBuilder: (context, details) =>
                                      DayCell(
                                        details: details,
                                      )),
                            ),
                          ))),
                ),
                ContentBox(child: MyText('Monthly Summary'))
              ],
            ),
          ),
        ));
  }
}

class DayCell extends StatelessWidget {
  final MonthCellDetails details;
  const DayCell({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isToday = details.date.isToday;
    print(details.appointments);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isToday
              ? context.theme.cardBackground
              : context.theme.background),
      padding: const EdgeInsets.all(6),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyText(
            details.date.day.toString(),
            weight: FontWeight.bold,
            subtext: !isToday,
          ),
          if (details.appointments.isNotEmpty)
            Expanded(
              child: Center(
                child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: details.appointments
                        .map(
                          (a) => Icon(WorkoutType.stopwatch,
                              size: 14, color: Styles.primaryAccent),
                        )
                        .toList()),
              ),
            ),
          ContentBox(
              padding: const EdgeInsets.all(2),
              child: MyText('24m',
                  size: FONTSIZE.two, color: Styles.primaryAccent))
        ],
      ),
    );
  }
}

class _ScheduledWorkoutsDataSource extends CalendarDataSource {
  _ScheduledWorkoutsDataSource(List<ScheduledWorkout> scheduledWorkouts) {
    appointments = scheduledWorkouts;
  }
}
