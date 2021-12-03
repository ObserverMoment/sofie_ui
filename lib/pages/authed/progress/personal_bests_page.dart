import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/personal_best_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/filters/tags_collections_filter_menu.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class PersonalBestsPage extends StatelessWidget {
  const PersonalBestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserBenchmarksQuery();
    return QueryObserver<UserBenchmarks$Query, json.JsonSerializable>(
        key: Key('PersonalBestsPage - ${query.operationName}'),
        query: query,
        builder: (data) {
          final benchmarks = data.userBenchmarks
              .sortedBy<DateTime>((b) => b.lastEntryAt)
              .reversed
              .toList();

          final allTags = benchmarks
              .fold<List<String>>(
                  [],
                  (acum, next) =>
                      [...acum, ...next.userBenchmarkTags.map((t) => t.name)])
              .toSet()
              .toList();

          return MyPageScaffold(
              child: NestedScrollView(
                  headerSliverBuilder: (c, i) => [
                        const CupertinoSliverNavigationBar(
                            leading: NavBarBackButton(),
                            largeTitle: Text('Personal Bests'),
                            border: null)
                      ],
                  body: benchmarks.isEmpty
                      ? YourContentEmptyPlaceholder(
                          message: 'No PBs or records yet',
                          explainer:
                              'Keep track of all your best times, biggest lifts and highest scores here and they will display on your profile page! Define moves, sets or even workouts and then track your progress over time.',
                          actions: [
                              EmptyPlaceholderAction(
                                  action: () => context
                                      .navigateTo(PersonalBestCreatorRoute()),
                                  buttonIcon: CupertinoIcons.add,
                                  buttonText: 'Create PB Tracker'),
                            ])
                      : _FilterablePBsList(
                          allBenchmarks: benchmarks,
                          allTags: allTags,
                          selectBenchmark: (id) => context
                              .navigateTo(PersonalBestDetailsRoute(id: id)))));
        });
  }
}

/// Note: UserBenchmark (API) == Personal Best (UI)
class _FilterablePBsList extends StatefulWidget {
  final void Function(String benchmarkId) selectBenchmark;
  final List<UserBenchmark> allBenchmarks;
  final List<String> allTags;
  const _FilterablePBsList(
      {Key? key,
      required this.selectBenchmark,
      required this.allBenchmarks,
      required this.allTags})
      : super(key: key);

  @override
  __FilterablePBsListState createState() => __FilterablePBsListState();
}

class __FilterablePBsListState extends State<_FilterablePBsList> {
  String? _tagFilter;

  @override
  Widget build(BuildContext context) {
    final filteredBenchmarks = _tagFilter == null
        ? widget.allBenchmarks
        : widget.allBenchmarks.where(
            (w) => w.userBenchmarkTags.map((t) => t.name).contains(_tagFilter));

    final sortedBenchmarks = filteredBenchmarks
        .sortedBy<DateTime>((w) => w.createdAt)
        .reversed
        .toList();

    return FABPage(
      rowButtonsAlignment: MainAxisAlignment.end,
      rowButtons: [
        if (widget.allTags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TagsFilterMenu(
              allTags: widget.allTags,
              selectedTag: _tagFilter,
              updateSelectedTag: (t) => setState(() => _tagFilter = t),
            ),
          ),
        FloatingButton(
            gradient: Styles.primaryAccentGradient,
            contentColor: Styles.white,
            icon: CupertinoIcons.add,
            onTap: () => context.navigateTo(PersonalBestCreatorRoute())),
      ],
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 4, bottom: 60),
          itemCount: sortedBenchmarks.length,
          itemBuilder: (c, i) => GestureDetector(
                key: Key(sortedBenchmarks[i].id),
                onTap: () => widget.selectBenchmark(sortedBenchmarks[i].id),
                child: SizeFadeIn(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: PersonalBestCard(userBenchmark: sortedBenchmarks[i]),
                  ),
                ),
              )),
    );
  }
}
