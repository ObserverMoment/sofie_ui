import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/logged_workout_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class LoggedWorkoutsPage extends StatelessWidget {
  const LoggedWorkoutsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query =
        UserLoggedWorkoutsQuery(variables: UserLoggedWorkoutsArguments());
    return QueryObserver<UserLoggedWorkouts$Query, json.JsonSerializable>(
        key: Key('LoggedWorkoutsPage - ${query.operationName}'),
        query: query,
        loadingIndicator: const ShimmerListPage(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final logs = data.userLoggedWorkouts
              .sortedBy<DateTime>((l) => l.completedOn)
              .reversed
              .toList();

          return MyPageScaffold(
            navigationBar: const MyNavBar(
              middle: NavBarTitle('Workout Logs'),
            ),
            child: FilterableLoggedWorkoutsList(logs: logs),
          );
        });
  }
}

class FilterableLoggedWorkoutsList extends StatefulWidget {
  final List<LoggedWorkout> logs;
  const FilterableLoggedWorkoutsList({Key? key, required this.logs})
      : super(key: key);

  @override
  _FilterableLoggedWorkoutsListState createState() =>
      _FilterableLoggedWorkoutsListState();
}

class _FilterableLoggedWorkoutsListState
    extends State<FilterableLoggedWorkoutsList> {
  DateTime? _filterFrom;
  DateTime? _filterTo;

  void _openLoggedWorkoutDetails(BuildContext context, String id) {
    context.navigateTo(LoggedWorkoutDetailsRoute(id: id));
  }

  void _clearDateRange() => setState(() {
        _filterFrom = null;
        _filterTo = null;
      });

  List<Widget> _floatingButtons(int numLogs) => [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              DateRangePickerDisplay(
                textColor: Styles.white,
                from: _filterFrom,
                to: _filterTo,
                updateRange: (from, to) => setState(() {
                  _filterFrom = from;
                  _filterTo = to;
                }),
              ),
              if (_filterFrom != null || _filterTo != null)
                FadeIn(
                    child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _clearDateRange,
                  child: const Icon(
                    CupertinoIcons.clear_thick,
                    color: Styles.errorRed,
                    size: 20,
                  ),
                ))
            ],
          ),
        ),
        CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () => context.push(
                rootNavigator: true,
                child: YourLoggedWorkoutsTextSearch(
                    allLoggedWorkouts: widget.logs,
                    selectLoggedWorkout: (l) =>
                        _openLoggedWorkoutDetails(context, l.id))),
            child: const Icon(CupertinoIcons.search,
                color: Styles.white, size: 20))
      ];

  @override
  Widget build(BuildContext context) {
    /// One day added / subtracted so as to get the range inclusively.
    final logsAfterFrom = _filterFrom == null
        ? widget.logs
        : widget.logs
            .where((l) => l.completedOn
                .isAfter(_filterFrom!.subtract(const Duration(days: 1))))
            .toList();

    final filteredLogs = _filterTo == null
        ? logsAfterFrom
        : logsAfterFrom
            .where((l) =>
                l.completedOn.isBefore(_filterTo!.add(const Duration(days: 1))))
            .toList();

    final buttons = _floatingButtons(filteredLogs.length);

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        if (filteredLogs.isEmpty)
          const Center(child: MyText('No logs to display...'))
        else
          Column(
            children: [
              if (_filterFrom != null || _filterTo != null)
                FadeIn(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyText(
                          'Showing ${filteredLogs.length} logs',
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                  child: ListAvoidFAB(
                itemBuilder: (c, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: GestureDetector(
                      onTap: () => _openLoggedWorkoutDetails(
                          context, filteredLogs[i].id),
                      child: LoggedWorkoutCard(
                        loggedWorkout: filteredLogs[i],
                      )),
                ),
                itemCount: filteredLogs.length,
              )),
            ],
          ),
        Positioned(
            bottom: EnvironmentConfig.bottomNavBarHeight + 6,
            child: FloatingActionButtonContainer(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c, i) => buttons[i],
                    separatorBuilder: (c, i) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: ButtonSeparator(
                            color: Styles.white,
                          ),
                        ),
                    itemCount: buttons.length),
              ),
            ))
      ],
    );
  }
}

class YourLoggedWorkoutsTextSearch extends StatefulWidget {
  final List<LoggedWorkout> allLoggedWorkouts;
  final void Function(LoggedWorkout loggedWorkout) selectLoggedWorkout;

  const YourLoggedWorkoutsTextSearch(
      {Key? key,
      required this.allLoggedWorkouts,
      required this.selectLoggedWorkout})
      : super(key: key);

  @override
  _YourLoggedWorkoutsTextSearchState createState() =>
      _YourLoggedWorkoutsTextSearchState();
}

class _YourLoggedWorkoutsTextSearchState
    extends State<YourLoggedWorkoutsTextSearch> {
  String _searchString = '';

  bool _filter(LoggedWorkout log) {
    return log.name.toLowerCase().contains(_searchString);
  }

  List<LoggedWorkout> _filterBySearchString() {
    return _searchString.length < 3
        ? <LoggedWorkout>[]
        : widget.allLoggedWorkouts.where((m) => _filter(m)).toList();
  }

  void _handleSelectLoggedWorkout(LoggedWorkout loggedWorkout) {
    widget.selectLoggedWorkout(loggedWorkout);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _filterBySearchString();
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: MyCupertinoSearchTextField(
            placeholder: 'Search your logs',
            autofocus: true,
            onChanged: (value) =>
                setState(() => _searchString = value.toLowerCase()),
          ),
        ),
        trailing: NavBarTextButton(context.pop, 'Close'),
      ),
      child: AnimatedSwitcher(
        duration: kStandardAnimationDuration,
        child: _searchString.length < 3
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    MyText('Type at least 3 characters', subtext: true),
                  ],
                ),
              )
            : filteredLogs.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        MyText(
                          'No logs found...',
                          subtext: true,
                        ),
                      ],
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: filteredLogs
                        .sortedBy<DateTime>((log) => log.completedOn)
                        .reversed
                        .map((log) => GestureDetector(
                            onTap: () => _handleSelectLoggedWorkout(log),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: LoggedWorkoutCard(loggedWorkout: log),
                            )))
                        .toList(),
                  ),
      ),
    );
  }
}
