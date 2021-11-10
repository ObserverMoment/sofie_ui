import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/personal_best_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
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
        loadingIndicator: const ShimmerListPage(),
        builder: (data) {
          final benchmarks = data.userBenchmarks
              .sortedBy<DateTime>((b) => b.lastEntryAt)
              .reversed
              .toList();

          return MyPageScaffold(
            navigationBar: MyNavBar(
              middle: const NavBarTitle('Personal Bests'),
              trailing: CreateIconButton(
                onPressed: () => context.navigateTo(PersonalBestCreatorRoute()),
              ),
            ),
            child: _FilterablePBsList(
                allBenchmarks: benchmarks,
                selectBenchmark: (id) =>
                    context.navigateTo(PersonalBestDetailsRoute(id: id))),
          );
        });
  }
}

/// Note: UserBenchmark (API) == Personal Best (UI)
class _FilterablePBsList extends StatefulWidget {
  final void Function(String benchmarkId) selectBenchmark;
  final List<UserBenchmark> allBenchmarks;
  const _FilterablePBsList(
      {Key? key, required this.selectBenchmark, required this.allBenchmarks})
      : super(key: key);

  @override
  __FilterablePBsListState createState() => __FilterablePBsListState();
}

class __FilterablePBsListState extends State<_FilterablePBsList> {
  UserBenchmarkTag? _userBenchmarkTagFilter;

  @override
  Widget build(BuildContext context) {
    final allTags = widget.allBenchmarks
        .fold<List<UserBenchmarkTag>>(
            [], (acum, next) => [...acum, ...next.userBenchmarkTags])
        .toSet()
        .toList();

    final filteredBenchmarks = _userBenchmarkTagFilter == null
        ? widget.allBenchmarks
        : widget.allBenchmarks.where(
            (w) => w.userBenchmarkTags.contains(_userBenchmarkTagFilter));

    final sortedBenchmarks = filteredBenchmarks
        .sortedBy<DateTime>((w) => w.createdAt)
        .reversed
        .toList();

    return Column(
      children: [
        if (allTags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
            child: SizedBox(
                height: 34,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allTags.length,
                    itemBuilder: (c, i) => Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: SelectableTag(
                            text: allTags[i].name,
                            isSelected: allTags[i] == _userBenchmarkTagFilter,
                            onPressed: () => setState(() =>
                                _userBenchmarkTagFilter =
                                    allTags[i] == _userBenchmarkTagFilter
                                        ? null
                                        : allTags[i]),
                          ),
                        ))),
          ),
        sortedBenchmarks.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: MyText(
                            'Track all of your perfomance achievements here! Max lifts, sprints, AMRAPS...set up your own definition and then easily add top scores along with videos of your performances as you get better.',
                            textAlign: TextAlign.center,
                            maxLines: 6,
                            lineHeight: 1.4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SecondaryButton(
                      prefixIconData: CupertinoIcons.plus,
                      onPressed: () =>
                          context.navigateTo(PersonalBestCreatorRoute()),
                      text: 'Create a Personal Best Tracker',
                    ),
                  ],
                ))
            : Expanded(
                child: _UserBenchmarksList(
                  benchmarks: sortedBenchmarks,
                  selectBenchmark: widget.selectBenchmark,
                ),
              ),
      ],
    );
  }
}

class _UserBenchmarksList extends StatelessWidget {
  final List<UserBenchmark> benchmarks;
  final void Function(String workoutId) selectBenchmark;
  const _UserBenchmarksList(
      {required this.benchmarks, required this.selectBenchmark});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: benchmarks.length,
        itemBuilder: (c, i) => GestureDetector(
              key: Key(benchmarks[i].id),
              onTap: () => selectBenchmark(benchmarks[i].id),
              child: SizeFadeIn(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: PersonalBestCard(userBenchmark: benchmarks[i]),
                ),
              ),
            ));
  }
}
