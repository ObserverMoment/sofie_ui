import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/logged_workout_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/router.gr.dart';

class FilterableLoggedWorkoutsList extends StatefulWidget {
  final List<LoggedWorkout> logs;
  final void Function(LoggedWorkout loggedWorkout)? selectLoggedWorkout;
  const FilterableLoggedWorkoutsList(
      {Key? key, required this.logs, this.selectLoggedWorkout})
      : super(key: key);

  @override
  _FilterableLoggedWorkoutsListState createState() =>
      _FilterableLoggedWorkoutsListState();
}

class _FilterableLoggedWorkoutsListState
    extends State<FilterableLoggedWorkoutsList> {
  String _searchString = '';
  void Function(LoggedWorkout)? _selectLoggedWorkout;

  /// Pops itself (and any stack items such as the text seach widget)
  /// Then passes the selected loggedWorkout to the parent.
  void _handleLoggedWorkoutSelect(LoggedWorkout loggedWorkout) {
    /// If the text search is open then we pop back to the main widget.
    context.router.popUntilRouteWithName(LoggedWorkoutsRoute.name);
    context.pop();
    widget.selectLoggedWorkout?.call(loggedWorkout);
  }

  DateTime? _filterFrom;
  DateTime? _filterTo;

  @override
  void initState() {
    super.initState();
    _selectLoggedWorkout =
        widget.selectLoggedWorkout != null ? _handleLoggedWorkoutSelect : null;
  }

  bool _textFilter(LoggedWorkout log) {
    return log.name.toLowerCase().contains(_searchString);
  }

  List<LoggedWorkout> _filterBySearchString(List<LoggedWorkout> logs) {
    return logs.where((m) => _textFilter(m)).toList();
  }

  void _clearDateRange() => setState(() {
        _filterFrom = null;
        _filterTo = null;
      });

  void _handleLoggedWorkoutCardTap(LoggedWorkout loggedWorkout) {
    if (_selectLoggedWorkout != null) {
      openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(
              header: BottomSheetMenuHeader(
                name: loggedWorkout.name,
                subtitle: 'LOG',
              ),
              items: [
                BottomSheetMenuItem(
                    text: 'Select',
                    icon: CupertinoIcons.add,
                    onPressed: () => _selectLoggedWorkout!(loggedWorkout)),
                BottomSheetMenuItem(
                    text: 'View',
                    icon: CupertinoIcons.eye,
                    onPressed: () => context.navigateTo(
                        LoggedWorkoutDetailsRoute(id: loggedWorkout.id))),
              ]));
    } else {
      context.navigateTo(LoggedWorkoutDetailsRoute(id: loggedWorkout.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    /// One day added / subtracted so as to get the range inclusively.
    final logsAfterFromDate = _filterFrom == null
        ? widget.logs
        : widget.logs
            .where((l) => l.completedOn
                .isAfter(_filterFrom!.subtract(const Duration(days: 1))))
            .toList();

    final logsBeforeToDate = _filterTo == null
        ? logsAfterFromDate
        : logsAfterFromDate
            .where((l) =>
                l.completedOn.isBefore(_filterTo!.add(const Duration(days: 1))))
            .toList();

    final filteredLogs = _filterBySearchString(logsBeforeToDate);

    return MyPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  const MySliverNavbar(
                    title: 'Workout Logs',
                  )
                ],
            body: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: MyCupertinoSearchTextField(
                      placeholder: 'Search logs',
                      onChanged: (v) => setState(() => _searchString = v),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FABPage(
                        rowButtons: [
                          if (_filterFrom != null || _filterTo != null)
                            FadeInUp(
                                child: FloatingButton(
                              onTap: _clearDateRange,
                              icon: CupertinoIcons.clear_thick,
                            )),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: FABPageButtonContainer(
                              padding: EdgeInsets.zero,
                              child: Row(
                                children: [
                                  DateRangePickerDisplay(
                                    textColor: context.theme.primary,
                                    from: _filterFrom,
                                    to: _filterTo,
                                    updateRange: (from, to) => setState(() {
                                      _filterFrom = from;
                                      _filterTo = to;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        child: ContentBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 8, bottom: 60),
                            itemBuilder: (c, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _handleLoggedWorkoutCardTap(
                                      filteredLogs[i]),
                                  child: LoggedWorkoutCard(
                                    loggedWorkout: filteredLogs[i],
                                  )),
                            ),
                            itemCount: filteredLogs.length,
                          ),
                        )),
                  ),
                ],
              ),
            )));
  }
}
