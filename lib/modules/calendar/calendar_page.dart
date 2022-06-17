import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/modules/calendar/calendar_bloc.dart';
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
  final _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', ' Sat'];
  final CalendarController _controller = CalendarController();

  bool _showMonthYearPicker = false;

  @override
  void initState() {
    super.initState();
    _controller.view = CalendarView.month;
  }

  void _updateViewType(CalendarView view) => _controller.view = view;

  void _toggleMonthYearPicker() {
    /// TODO: If the date has changed then update the calendat controller.
    setState(() {
      _showMonthYearPicker = !_showMonthYearPicker;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ChangeNotifierProvider(
        create: (_) => CalendarBloc(),
        child: CupertinoPageScaffold(
          backgroundColor: context.theme.barBackground,
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        iconData: CupertinoIcons.chevron_back,
                        onPressed: () {}),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: TertiaryButton(
                          text: 'June 2229',
                          suffixIconData: CupertinoIcons.chevron_down,
                          onPressed: _toggleMonthYearPicker),
                    )
                  ],
                ),
                GrowInOut(
                    show: _showMonthYearPicker,
                    child: Container(
                      color: context.theme.cardBackground,
                      height: 240,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoDatePicker(
                            initialDateTime: DateTime.now(),
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (d) => print(d)),
                      ),
                    )),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 7,
                    children: _days
                        .map((d) => Center(
                              child: MyText(
                                d,
                                subtext: true,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SfCalendar(
                        controller: _controller,
                        headerHeight: 0,
                        initialSelectedDate: DateTime.now(),
                        view: _controller.view ?? CalendarView.month,
                        backgroundColor: context.theme.barBackground,
                        viewHeaderHeight: 0,
                        initialDisplayDate:
                            DateTime(now.year, now.month, 1, 0, 0, 0),
                        monthViewSettings: const MonthViewSettings(
                            showAgenda: true,
                            agendaItemHeight: 80,
                            numberOfWeeksInView: 5),
                        selectionDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: context.theme.primary, width: 2),
                        ),
                        todayHighlightColor: context.theme.primary,
                        headerStyle: CalendarHeaderStyle(
                          textStyle: context
                              .theme.cupertinoThemeData.textTheme.textStyle
                              .copyWith(fontSize: 16),
                        ),
                        monthCellBuilder: (context, details) => DayCell(
                              details: details,
                            )),
                  ),
                ),
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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isToday
              ? context.theme.cardBackground
              : context.theme.barBackground),
      padding: const EdgeInsets.all(2),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: isToday
                            ? context.theme.primary
                            : material.Colors.transparent,
                        borderRadius: BorderRadius.circular(50)),
                    height: 4,
                  ),
                ),
              ],
            ),
          ),
          MyText(
            details.date.day.toString(),
            weight: FontWeight.bold,
            subtext: !isToday,
          ),
        ],
      ),
    );
  }
}

// extension CalendarViewExtension on CalendarView {
//   String get display {
//     switch (this) {
//       case this.:
//         break;
//       default:
//         throw Exception(
//             'CalendarViewExtension.display: No branch specified for $this');
//     }
//   }
// }

// class CalendarPage extends StatefulWidget {
//   final DateTime? openAtDate;
//   final String? previousPageTitle;
//   const CalendarPage({Key? key, this.openAtDate, this.previousPageTitle})
//       : super(key: key);
//   @override
//   State<CalendarPage> createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   final ScrollController _scrollController = ScrollController();
//   late DateTime _selectedDay;
//   late DateTime _focusedDay;
//   CalendarFormat _calendarFormat = CalendarFormat.month;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = widget.openAtDate ?? DateTime.now();
//     _focusedDay = _selectedDay;
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay,
//       List<ScheduledWorkout> allScheduled) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _focusedDay = focusedDay;
//         _selectedDay = selectedDay;
//       });
//     }
//   }

//   Widget? _buildSingleMarker(
//       BuildContext context, DateTime dateTime, Object scheduled) {
//     final color = (scheduled as ScheduledWorkout).loggedWorkoutId != null
//         ? Styles.primaryAccent // Done
//         : scheduled.scheduledAt.isBefore(DateTime.now())
//             ? Styles.errorRed // Missed
//             : Styles.primaryAccent; // Upcoming
//     return Container(
//         height: 8,
//         width: 8,
//         decoration: BoxDecoration(color: color, shape: BoxShape.circle));
//   }

//   void _findWorkoutToSchedule() => openBottomSheetMenu(
//       context: context,
//       child: BottomSheetMenu(
//           header: const BottomSheetMenuHeader(
//             name: 'Schedule a Workout From',
//           ),
//           items: [
//             // BottomSheetMenuItem(
//             //     text: 'Your Workouts',
//             //     onPressed: () => context.navigateTo(WorkoutsRoute())),
//             // BottomSheetMenuItem(
//             //     text: 'Public Workouts',
//             //     onPressed: () => context.navigateTo(PublicWorkoutFinderRoute(
//             //         selectWorkout: (w) => _openScheduleWorkout(w)))),
//           ]));

//   Future<void> _openScheduleWorkout(WorkoutSummary workout) async {
//     // final result = await context.pushRoute(ScheduledWorkoutCreatorRoute(
//     //     workout: workout,
//     //     // Open at the selected day and at the current time by combining _selectedDay and DateTime.now().
//     //     scheduleOn: DateTime(_selectedDay.year, _selectedDay.month,
//     //         _selectedDay.day, DateTime.now().hour)));
//     // if (result is ToastRequest) {
//     //   context.showToast(message: result.message, toastType: result.type);
//     // }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return QueryObserver<UserScheduledWorkouts$Query, json.JsonSerializable>(
//       key: Key('CalendarPage - ${UserScheduledWorkoutsQuery().operationName}'),
//       query: UserScheduledWorkoutsQuery(),
//       builder: (data) {
//         final allScheduled =
//             data.userScheduledWorkouts.sortedBy<DateTime>((s) => s.scheduledAt);

//         final selectedDayScheduled = allScheduled
//             .where((s) => isSameDay(s.scheduledAt, _selectedDay))
//             .toList();

//         return MyPageScaffold(
//           navigationBar: MyNavBar(
//             previousPageTitle: widget.previousPageTitle,
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: MyText(
//                     DateFormat.yMMM().format(_focusedDay),
//                     weight: FontWeight.bold,
//                   ),
//                 ),
//                 CupertinoButton(
//                   padding: EdgeInsets.zero,
//                   onPressed: () => setState(() {
//                     _calendarFormat = _calendarFormat == CalendarFormat.week
//                         ? CalendarFormat.month
//                         : CalendarFormat.week;
//                   }),
//                   child: _calendarFormat == CalendarFormat.week
//                       ? const Icon(CupertinoIcons.square_grid_4x3_fill)
//                       : const Icon(CupertinoIcons.rectangle_split_3x1),
//                 ),
//               ],
//             ),
//           ),
//           child: FABPage(
//               columnButtons: [
//                 FloatingIconButton(
//                     icon: CupertinoIcons.add, onTap: _findWorkoutToSchedule),
//                 // FloatingTextButton(
//                 //     icon: CupertinoIcons.search,
//                 //     onTap: () => context.push(
//                 //             child: YourScheduleTextSearch(
//                 //           allScheduledWorkouts: allScheduled,
//                 //         ))),
//               ],
//               child: NestedScrollView(
//                 controller: _scrollController,
//                 headerSliverBuilder: (context, innerBoxIsScrolled) {
//                   return [
//                     SliverToBoxAdapter(
//                       child: Material(
//                         color: context.theme.background,
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: TableCalendar(
//                               headerVisible: false,
//                               firstDay: DateTime.utc(2021),
//                               lastDay: DateTime(DateTime.now().year + 10),
//                               focusedDay: _focusedDay,
//                               selectedDayPredicate: (day) {
//                                 return isSameDay(_selectedDay, day);
//                               },
//                               onDaySelected: (selectedDay, focusedDay) {
//                                 _onDaySelected(
//                                     selectedDay, focusedDay, allScheduled);
//                               },
//                               onPageChanged: (focusedDay) {
//                                 setState(() {
//                                   _focusedDay = focusedDay;
//                                 });
//                               },
//                               calendarFormat: _calendarFormat,
//                               onFormatChanged: (format) {
//                                 setState(() {
//                                   _calendarFormat = format;
//                                 });
//                               },
//                               eventLoader: (day) {
//                                 return allScheduled
//                                     .where((s) => isSameDay(s.scheduledAt, day))
//                                     .toList();
//                               },
//                               calendarBuilders:
//                                   CalendarBuilders<List<ScheduledWorkout>>(
//                                       singleMarkerBuilder: _buildSingleMarker),
//                               daysOfWeekStyle:
//                                   CalendarUI.daysOfWeekStyle(context),
//                               calendarStyle: CalendarUI.calendarStyle(context)),
//                         ),
//                       ),
//                     )
//                   ];
//                 },
//                 body: MyText('TODO'),
//                 // body: selectedDayScheduled.isEmpty
//                 //     ? const Center(child: MyText('Nothing planned'))
//                 //     : ListView(
//                 //         children: selectedDayScheduled
//                 //             .map((s) => Padding(
//                 //                   padding: const EdgeInsets.symmetric(
//                 //                       horizontal: 6, vertical: 4),
//                 //                   child: ScheduledWorkoutCard(
//                 //                       scheduledWorkout: s),
//                 //                 ))
//                 //             .toList(),
//               )),
//         );
//       },
//     );
//   }
// }

// // class YourScheduleTextSearch extends StatefulWidget {
// //   final List<ScheduledWorkout> allScheduledWorkouts;

// //   const YourScheduleTextSearch({Key? key, required this.allScheduledWorkouts})
// //       : super(key: key);

// //   @override
// //   _YourScheduleTextSearchState createState() => _YourScheduleTextSearchState();
// // }

// // class _YourScheduleTextSearchState extends State<YourScheduleTextSearch> {
// //   String _searchString = '';

// //   bool _filter(ScheduledWorkout scheduledWorkout) {
// //     return scheduledWorkout.workout != null &&
// //         [
// //           scheduledWorkout.workout!.name,
// //           ...scheduledWorkout.workout!.tags,
// //         ]
// //             .where((t) => Utils.textNotNull(t))
// //             .map((t) => t.toLowerCase())
// //             .any((t) => t.contains(_searchString));
// //   }

// //   List<ScheduledWorkout> _filterBySearchString() {
// //     return Utils.textNotNull(_searchString)
// //         ? widget.allScheduledWorkouts.where((m) => _filter(m)).toList()
// //         : [];
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final filteredScheduledWorkouts = _filterBySearchString();
// //     return CupertinoPageScaffold(
// //       navigationBar: MyNavBar(
// //         automaticallyImplyLeading: false,
// //         middle: Padding(
// //           padding: const EdgeInsets.only(right: 10.0),
// //           child: MyCupertinoSearchTextField(
// //             placeholder: 'Search your schedule',
// //             autofocus: true,
// //             onChanged: (value) =>
// //                 setState(() => _searchString = value.toLowerCase()),
// //           ),
// //         ),
// //         trailing: NavBarTextButton(context.pop, 'Close'),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.only(top: 12.0),
// //         child: _searchString.length > 2
// //             ? filteredScheduledWorkouts.isEmpty
// //                 ? const Center(
// //                     child: MyText(
// //                     'No results',
// //                     subtext: true,
// //                   ))
// //                 : ListView(
// //                     shrinkWrap: true,
// //                     children: filteredScheduledWorkouts
// //                         .sortedBy<num>((scheduledWorkout) =>
// //                             scheduledWorkout.scheduledAt.millisecondsSinceEpoch)
// //                         .reversed
// //                         .map((scheduledWorkout) => SizeFadeIn(
// //                               child: Padding(
// //                                 padding: const EdgeInsets.only(
// //                                     left: 4, right: 4, bottom: 8.0),
// //                                 child: ScheduledWorkoutCard(
// //                                     scheduledWorkout: scheduledWorkout),
// //                               ),
// //                             ))
// //                         .toList(),
// //                   )
// //             : const Center(
// //                 child: MyText(
// //                 'Enter at least 3 characters',
// //                 subtext: true,
// //               )),
// //       ),
// //     );
// //   }
// // }
