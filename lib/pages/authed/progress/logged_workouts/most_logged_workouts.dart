import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts/widget_header.dart';
import 'package:sofie_ui/router.gr.dart';

class MostLoggedWorkoutsWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const MostLoggedWorkoutsWidget({Key? key, required this.loggedWorkouts})
      : super(key: key);

  int get _workoutsPerCard => 4;
  double get _cardHeight => 50.0;
  double get _cardMargin => 4.0;
  double get _cardHeightWithMargin => _cardHeight + (_cardMargin * 2);
  int _nextIndex(int i) => (i * _workoutsPerCard) + _workoutsPerCard;
  int? _clampedIndex(int i, int max) =>
      _nextIndex(i) > max ? null : _nextIndex(i);

  @override
  Widget build(BuildContext context) {
    final logsByWorkoutId = loggedWorkouts
        .where((lw) => lw.workoutId != null)
        .fold<Map<String, List<LoggedWorkout>>>({}, (acum, next) {
      if (acum[next.workoutId] == null) {
        acum[next.workoutId!] = [];
      }

      acum[next.workoutId]!.add(next);

      return acum;
    });

    final entries = logsByWorkoutId.entries
        .map((e) => _LoggedWorkoutByWorkoutId(
            loggedWorkouts: e.value, workoutId: e.key))
        .sortedBy<num>((d) => d.loggedWorkouts.length)
        .reversed
        .toList();

    final onlyOneCard = entries.length <= _workoutsPerCard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LogAnalysisWidgetHeader(
          heading: 'Most Logged Workouts',
        ),
        Container(
          padding: EdgeInsets.only(
              left: onlyOneCard ? 10.0 : 0, right: onlyOneCard ? 10 : 0),
          height: entries.length < _workoutsPerCard
              ? _cardHeightWithMargin * entries.length
              : _cardHeightWithMargin * _workoutsPerCard,
          child: PageView.builder(
            itemCount: (entries.length / _workoutsPerCard).ceil(),
            controller:
                PageController(viewportFraction: onlyOneCard ? 1 : 0.95),
            itemBuilder: (c, i) => ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: entries
                  .slice(i * _workoutsPerCard, _clampedIndex(i, entries.length))
                  .map((e) => Padding(
                        padding: EdgeInsets.all(_cardMargin),
                        child: GestureDetector(
                          onTap: () => context
                              .navigateTo(WorkoutDetailsRoute(id: e.workoutId)),
                          child: Card(
                              margin: EdgeInsets.zero,
                              height: _cardHeight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(e.loggedWorkouts[0].name),
                                          const SizedBox(height: 4),
                                          MyText(
                                            e.loggedWorkouts[0]
                                                .loggedWorkoutSections
                                                .map((lws) => lws
                                                    .workoutSectionType.name
                                                    .toUpperCase())
                                                .toSet()
                                                .join(', '),
                                            size: FONTSIZE.one,
                                            color: Styles.primaryAccent,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  MyText(
                                      '${e.loggedWorkouts.length} ${e.loggedWorkouts.length == 1 ? "time" : "times"}'),
                                ],
                              )),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoggedWorkoutByWorkoutId {
  final List<LoggedWorkout> loggedWorkouts;
  final String workoutId;
  _LoggedWorkoutByWorkoutId(
      {required this.loggedWorkouts, required this.workoutId});
}
