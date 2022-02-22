import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts/filterable_logged_workouts_list.dart';
import 'package:sofie_ui/pages/authed/progress/logged_workouts/log_analysis_averages_widget.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class LoggedWorkoutsPage extends StatelessWidget {
  final void Function(LoggedWorkout loggedWorkout)? selectLoggedWorkout;
  final String pageTitle;
  const LoggedWorkoutsPage(
      {Key? key, this.selectLoggedWorkout, this.pageTitle = 'Logs & Analysis'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserLoggedWorkoutsQuery();
    return QueryObserver<UserLoggedWorkouts$Query, json.JsonSerializable>(
        key: Key('LoggedWorkoutsPage - ${query.operationName}'),
        query: query,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final logs = data.userLoggedWorkouts
              .sortedBy<DateTime>((l) => l.completedOn)
              .reversed
              .toList();

          return MyPageScaffold(
              child: NestedScrollView(
                  headerSliverBuilder: (c, i) => [
                        MySliverNavbar(
                          title: pageTitle,
                          trailing: logs.isEmpty
                              ? null
                              : NavBarTrailingRow(children: [
                                  IconButton(
                                      iconData: CupertinoIcons.list_bullet,
                                      onPressed: () => context.push(
                                              child:
                                                  FilterableLoggedWorkoutsList(
                                            logs: logs,
                                            selectLoggedWorkout:
                                                selectLoggedWorkout,
                                          ))),
                                ]),
                        )
                      ],
                  body: logs.isEmpty
                      ? YourContentEmptyPlaceholder(
                          message: 'No workouts logged yet',
                          explainer:
                              'Once you have done a workout you will be able to view past logs and also analysis of your log hostory here. You will be able to wiew which workouts you did and when, check which goals and body areas they targeted and find old faves to re-do.',
                          actions: [
                              EmptyPlaceholderAction(
                                  action: () => context
                                      .navigateTo(PublicWorkoutFinderRoute()),
                                  buttonIcon: CupertinoIcons.compass,
                                  buttonText: 'Find a Workout'),
                            ])
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: 1,
                          itemBuilder: (c, i) {
                            switch (i) {
                              case 0:
                                return LogAnalysisAveragesWidget(
                                  loggedWorkouts: logs,
                                );
                              default:
                                throw Exception(
                                    'LoggedWorkoutsPage: Widget builder - no widget defined at this index - Index:$i');
                            }
                          })));
        });
  }
}
