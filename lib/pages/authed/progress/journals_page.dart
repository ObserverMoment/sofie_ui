import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/progress_journal_card.dart';
import 'package:sofie_ui/components/info_pages/journals_info.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class JournalsPage extends StatelessWidget {
  const JournalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserProgressJournals$Query, json.JsonSerializable>(
        key: Key('JournalsPage - ${UserProgressJournalsQuery().operationName}'),
        query: UserProgressJournalsQuery(),
        loadingIndicator: const ShimmerListPage(),
        builder: (data) {
          final journals = data.userProgressJournals
              .sortedBy<DateTime>((j) => j.createdAt)
              .reversed
              .toList();

          return MyPageScaffold(
            key: const Key('JournalsPage - CupertinoPageScaffold'),
            navigationBar: MyNavBar(
              key: const Key('JournalsPage - MyNavBar'),
              middle: const NavBarTitle('Journals'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const InfoPopupButton(infoWidget: JournalsInfo()),
                  const SizedBox(width: 8),
                  CreateIconButton(
                    onPressed: () =>
                        context.navigateTo(ProgressJournalCreatorRoute()),
                  ),
                ],
              ),
            ),
            child: journals.isEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: SecondaryButton(
                              prefixIconData: CupertinoIcons.add,
                              text: 'New Journal',
                              onPressed: () => context
                                  .navigateTo(ProgressJournalCreatorRoute())),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: journals.length,
                    itemBuilder: (context, index) {
                      final ProgressJournal journal = journals[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            behavior: HitTestBehavior
                                .opaque, // As there is empty space in the [ProgressJournalCard] which otherwise would not react to taps.
                            onTap: () => context.navigateTo(
                                ProgressJournalDetailsRoute(id: journal.id)),
                            child:
                                ProgressJournalCard(progressJournal: journal)),
                      );
                    }),
          );
        });
  }
}
