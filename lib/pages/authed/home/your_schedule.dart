import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/calendar.dart';
import 'package:sofie_ui/components/cards/scheduled_workout_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/toast_request.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class YourSchedulePage extends StatefulWidget {
  final DateTime? openAtDate;
  const YourSchedulePage({Key? key, this.openAtDate}) : super(key: key);
  @override
  _YourSchedulePageState createState() => _YourSchedulePageState();
}

class _YourSchedulePageState extends State<YourSchedulePage> {
  final ScrollController _scrollController = ScrollController();
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.openAtDate ?? DateTime.now();
    _focusedDay = _selectedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay,
      List<ScheduledWorkout> allScheduled) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
      });
    }
  }

  Widget? _buildSingleMarker(
      BuildContext context, DateTime dateTime, Object scheduled) {
    final color = (scheduled as ScheduledWorkout).loggedWorkoutId != null
        ? Styles.primaryAccent // Done
        : scheduled.scheduledAt.isBefore(DateTime.now())
            ? Styles.errorRed // Missed
            : Styles.primaryAccent; // Upcoming
    return Container(
        height: 8,
        width: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }

  void _findWorkoutToSchedule() => openBottomSheetMenu(
      context: context,
      child: BottomSheetMenu(
          header: const BottomSheetMenuHeader(
            name: 'Schedule a Workout From',
          ),
          items: [
            BottomSheetMenuItem(
                text: 'Your Workouts',
                onPressed: () => context.navigateTo(YourWorkoutsRoute(
                    selectWorkout: (w) => _openScheduleWorkout(w),
                    showCreateButton: true,
                    pageTitle: 'Select Workout'))),
            BottomSheetMenuItem(
                text: 'Public Workouts',
                onPressed: () => context.navigateTo(PublicWorkoutFinderRoute(
                    selectWorkout: (w) => _openScheduleWorkout(w)))),
          ]));

  Future<void> _openScheduleWorkout(WorkoutSummary workout) async {
    final result = await context.pushRoute(ScheduledWorkoutCreatorRoute(
        workout: workout,
        // Open at the selected day and at the current time by combining _selectedDay and DateTime.now().
        scheduleOn: DateTime(_selectedDay.year, _selectedDay.month,
            _selectedDay.day, DateTime.now().hour)));
    if (result is ToastRequest) {
      context.showToast(message: result.message, toastType: result.type);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserScheduledWorkouts$Query, json.JsonSerializable>(
      key: Key(
          'YourSchedulePage - ${UserScheduledWorkoutsQuery().operationName}'),
      query: UserScheduledWorkoutsQuery(),
      builder: (data) {
        final allScheduled =
            data.userScheduledWorkouts.sortedBy<DateTime>((s) => s.scheduledAt);

        final selectedDayScheduled = allScheduled
            .where((s) => isSameDay(s.scheduledAt, _selectedDay))
            .toList();

        return MyPageScaffold(
            navigationBar: MyNavBar(
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MyText(
                      DateFormat.yMMM().format(_focusedDay),
                      weight: FontWeight.bold,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => setState(() {
                      _calendarFormat = _calendarFormat == CalendarFormat.week
                          ? CalendarFormat.month
                          : CalendarFormat.week;
                    }),
                    child: _calendarFormat == CalendarFormat.week
                        ? const Icon(CupertinoIcons.square_grid_4x3_fill)
                        : const Icon(CupertinoIcons.rectangle_split_3x1),
                  ),
                ],
              ),
            ),
            child: FABPage(
              columnButtons: [
                FloatingButton(
                    icon: CupertinoIcons.add, onTap: _findWorkoutToSchedule),
                FloatingButton(
                    icon: CupertinoIcons.search,
                    onTap: () => context.push(
                            child: YourScheduleTextSearch(
                          allScheduledWorkouts: allScheduled,
                        ))),
              ],
              child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Material(
                          color: context.theme.background,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TableCalendar(
                                headerVisible: false,
                                firstDay: DateTime.utc(2021),
                                lastDay: DateTime(DateTime.now().year + 10),
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  _onDaySelected(
                                      selectedDay, focusedDay, allScheduled);
                                },
                                onPageChanged: (focusedDay) {
                                  setState(() {
                                    _focusedDay = focusedDay;
                                  });
                                },
                                calendarFormat: _calendarFormat,
                                onFormatChanged: (format) {
                                  setState(() {
                                    _calendarFormat = format;
                                  });
                                },
                                eventLoader: (day) {
                                  return allScheduled
                                      .where(
                                          (s) => isSameDay(s.scheduledAt, day))
                                      .toList();
                                },
                                calendarBuilders:
                                    CalendarBuilders<List<ScheduledWorkout>>(
                                        singleMarkerBuilder:
                                            _buildSingleMarker),
                                daysOfWeekStyle:
                                    CalendarUI.daysOfWeekStyle(context),
                                calendarStyle:
                                    CalendarUI.calendarStyle(context)),
                          ),
                        ),
                      )
                    ];
                  },
                  body: selectedDayScheduled.isEmpty
                      ? const Center(child: MyText('Nothing planned'))
                      : ListView(
                          children: selectedDayScheduled
                              .map((s) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    child: ScheduledWorkoutCard(
                                        scheduledWorkout: s),
                                  ))
                              .toList(),
                        )),
            ));
      },
    );
  }
}

class YourScheduleTextSearch extends StatefulWidget {
  final List<ScheduledWorkout> allScheduledWorkouts;

  const YourScheduleTextSearch({Key? key, required this.allScheduledWorkouts})
      : super(key: key);

  @override
  _YourScheduleTextSearchState createState() => _YourScheduleTextSearchState();
}

class _YourScheduleTextSearchState extends State<YourScheduleTextSearch> {
  String _searchString = '';

  bool _filter(ScheduledWorkout scheduledWorkout) {
    return scheduledWorkout.workout != null &&
        [
          scheduledWorkout.workout!.name,
          ...scheduledWorkout.workout!.tags,
        ]
            .where((t) => Utils.textNotNull(t))
            .map((t) => t.toLowerCase())
            .any((t) => t.contains(_searchString));
  }

  List<ScheduledWorkout> _filterBySearchString() {
    return Utils.textNotNull(_searchString)
        ? widget.allScheduledWorkouts.where((m) => _filter(m)).toList()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    final filteredScheduledWorkouts = _filterBySearchString();
    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: MyCupertinoSearchTextField(
            placeholder: 'Search your schedule',
            autofocus: true,
            onChanged: (value) =>
                setState(() => _searchString = value.toLowerCase()),
          ),
        ),
        trailing: NavBarTextButton(context.pop, 'Close'),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: _searchString.length > 2
            ? filteredScheduledWorkouts.isEmpty
                ? const Center(
                    child: MyText(
                    'No results',
                    subtext: true,
                  ))
                : ListView(
                    shrinkWrap: true,
                    children: filteredScheduledWorkouts
                        .sortedBy<num>((scheduledWorkout) =>
                            scheduledWorkout.scheduledAt.millisecondsSinceEpoch)
                        .reversed
                        .map((scheduledWorkout) => SizeFadeIn(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, right: 4, bottom: 8.0),
                                child: ScheduledWorkoutCard(
                                    scheduledWorkout: scheduledWorkout),
                              ),
                            ))
                        .toList(),
                  )
            : const Center(
                child: MyText(
                'Enter at least 3 characters',
                subtext: true,
              )),
      ),
    );
  }
}
