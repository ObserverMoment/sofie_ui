import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/tags_collections_filter_menu.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:collection/collection.dart';
import 'package:auto_route/auto_route.dart';

class ProfilePublicWorkoutPlansPage extends StatelessWidget {
  final String userId;
  final String? userDisplayName;
  const ProfilePublicWorkoutPlansPage(
      {Key? key, required this.userId, this.userDisplayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserPublicWorkoutPlansQuery(
        variables: UserPublicWorkoutPlansArguments(userId: userId));

    return QueryObserver<UserPublicWorkoutPlans$Query,
            UserPublicWorkoutPlansArguments>(
        key: Key('ProfilePublicWorkoutPlansPage - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final workoutPlans = data.userPublicWorkoutPlans;
          return CupertinoPageScaffold(
              child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
              MySliverNavbar(
                title: 'Plans',
                trailing: userDisplayName != null
                    ? MyText(userDisplayName!, size: FONTSIZE.two)
                    : null,
              ),
            ],
            body: _FilterablePublicWorkoutPlans(
              allWorkoutPlans: workoutPlans,
            ),
          ));
        });
  }
}

class _FilterablePublicWorkoutPlans extends StatefulWidget {
  final List<WorkoutPlanSummary> allWorkoutPlans;
  const _FilterablePublicWorkoutPlans({Key? key, required this.allWorkoutPlans})
      : super(key: key);

  @override
  __FilterablePublicWorkoutPlansState createState() =>
      __FilterablePublicWorkoutPlansState();
}

class __FilterablePublicWorkoutPlansState
    extends State<_FilterablePublicWorkoutPlans> {
  String? _workoutTagFilter;

  @override
  Widget build(BuildContext context) {
    final allTags = widget.allWorkoutPlans
        .fold<List<String>>([], (acum, next) => [...acum, ...next.tags])
        .toSet()
        .toList();

    final filteredWorkoutPlans = _workoutTagFilter == null
        ? widget.allWorkoutPlans
        : widget.allWorkoutPlans
            .where((w) => w.tags.contains(_workoutTagFilter));

    final sortedWorkoutPlans = filteredWorkoutPlans
        .sortedBy<DateTime>((w) => w.createdAt)
        .reversed
        .toList();

    return sortedWorkoutPlans.isEmpty
        ? const YourContentEmptyPlaceholder(message: 'No plans', actions: [])
        : FABPage(
            rowButtonsAlignment: MainAxisAlignment.end,
            rowButtons: [
              if (allTags.isNotEmpty)
                TagsFilterMenu(
                  allTags: allTags,
                  selectedTag: _workoutTagFilter,
                  updateSelectedTag: (t) =>
                      setState(() => _workoutTagFilter = t),
                ),
            ],
            child: ListView.builder(
                cacheExtent: 3000,
                padding: const EdgeInsets.only(top: 6, bottom: 60),
                shrinkWrap: true,
                itemCount: sortedWorkoutPlans.length,
                itemBuilder: (c, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FadeInUp(
                      key: Key(sortedWorkoutPlans[i].id),
                      delay: 5,
                      delayBasis: 20,
                      duration: 100,
                      child: GestureDetector(
                        onTap: () => context.navigateTo(WorkoutPlanDetailsRoute(
                            id: sortedWorkoutPlans[i].id)),
                        child: WorkoutPlanCard(
                          sortedWorkoutPlans[i],
                        ),
                      ),
                    ),
                  );
                }));
  }
}
