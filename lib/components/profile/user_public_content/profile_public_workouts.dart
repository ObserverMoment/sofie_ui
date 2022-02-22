import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/workout_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/tags_collections_filter_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:collection/collection.dart';
import 'package:auto_route/auto_route.dart';

class ProfilePublicWorkoutsPage extends StatelessWidget {
  final String userId;
  final String? userDisplayName;
  const ProfilePublicWorkoutsPage(
      {Key? key, required this.userId, this.userDisplayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserPublicWorkoutsQuery(
        variables: UserPublicWorkoutsArguments(userId: userId));

    return QueryObserver<UserPublicWorkouts$Query, UserPublicWorkoutsArguments>(
        key: Key('ProfilePublicWorkoutsPage - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final workouts = data.userPublicWorkouts;

          return CupertinoPageScaffold(
              child: NestedScrollView(
                  headerSliverBuilder: (c, i) => [
                        MySliverNavbar(
                          title: 'Workouts',
                          trailing: userDisplayName != null
                              ? MyText(userDisplayName!, size: FONTSIZE.two)
                              : null,
                        ),
                      ],
                  body: _FilterablePublicWorkouts(allWorkouts: workouts)));
        });
  }
}

class _FilterablePublicWorkouts extends StatefulWidget {
  final List<WorkoutSummary> allWorkouts;
  const _FilterablePublicWorkouts({Key? key, required this.allWorkouts})
      : super(key: key);

  @override
  __FilterablePublicWorkoutsState createState() =>
      __FilterablePublicWorkoutsState();
}

class __FilterablePublicWorkoutsState extends State<_FilterablePublicWorkouts> {
  String? _workoutTagFilter;

  @override
  Widget build(BuildContext context) {
    final allTags = widget.allWorkouts
        .fold<List<String>>([], (acum, next) => [...acum, ...next.tags])
        .toSet()
        .toList();

    final filteredWorkouts = _workoutTagFilter == null
        ? widget.allWorkouts
        : widget.allWorkouts.where((w) => w.tags.contains(_workoutTagFilter));

    final sortedWorkouts = filteredWorkouts
        .sortedBy<DateTime>((w) => w.createdAt)
        .reversed
        .toList();

    return sortedWorkouts.isEmpty
        ? const YourContentEmptyPlaceholder(message: 'No workouts', actions: [])
        : FABPage(
            rowButtonsAlignment: MainAxisAlignment.end,
            rowButtons: [
              if (allTags.isNotEmpty)
                TagsFilterMenu(
                  allTags:
                      allTags.where((t) => t != kCustomSessionName).toList(),
                  selectedTag: _workoutTagFilter,
                  updateSelectedTag: (t) =>
                      setState(() => _workoutTagFilter = t),
                ),
            ],
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 6, bottom: 60),
                shrinkWrap: true,
                itemCount: sortedWorkouts.length,
                cacheExtent: 3000,
                itemBuilder: (c, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FadeInUp(
                      key: Key(sortedWorkouts[i].id),
                      delay: 5,
                      delayBasis: 20,
                      duration: 100,
                      child: GestureDetector(
                        onTap: () => context.navigateTo(
                            WorkoutDetailsRoute(id: sortedWorkouts[i].id)),
                        child: WorkoutCard(
                          sortedWorkouts[i],
                        ),
                      ),
                    ),
                  );
                }));
  }
}
