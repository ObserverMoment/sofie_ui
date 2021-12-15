import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/personal_best_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
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

          return MyPageScaffold(
              child: NestedScrollView(
                  headerSliverBuilder: (c, i) => [
                        const MySliverNavbar(
                          title: 'Personal Bests',
                        )
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
                          selectBenchmark: (id) => context
                              .navigateTo(PersonalBestDetailsRoute(id: id)))));
        });
  }
}

/// Note: UserBenchmark (API) == Personal Best (UI)
class _FilterablePBsList extends StatelessWidget {
  final void Function(String benchmarkId) selectBenchmark;
  final List<UserBenchmark> allBenchmarks;
  const _FilterablePBsList({
    Key? key,
    required this.selectBenchmark,
    required this.allBenchmarks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedBenchmarks =
        allBenchmarks.sortedBy<DateTime>((w) => w.createdAt).reversed.toList();

    return FABPage(
      rowButtonsAlignment: MainAxisAlignment.end,
      rowButtons: [
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
                onTap: () => selectBenchmark(sortedBenchmarks[i].id),
                child: FadeInUp(
                  key: Key(sortedBenchmarks[i].id),
                  delay: 5,
                  delayBasis: 20,
                  duration: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: PersonalBestCard(userBenchmark: sortedBenchmarks[i]),
                  ),
                ),
              )),
    );
  }
}
