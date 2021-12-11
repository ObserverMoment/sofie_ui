import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/progress_journal_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/info_pages/journals_info.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class JournalsPage extends StatelessWidget {
  const JournalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserProgressJournals$Query, json.JsonSerializable>(
        key: Key('JournalsPage - ${UserProgressJournalsQuery().operationName}'),
        query: UserProgressJournalsQuery(),
        builder: (data) {
          final journals = data.userProgressJournals
              .sortedBy<DateTime>((j) => j.createdAt)
              .reversed
              .toList();

          return MyPageScaffold(
            child: NestedScrollView(
              headerSliverBuilder: (c, i) => [
                const MySliverNavbar(
                  title: 'Journals',
                  trailing: InfoPopupButton(infoWidget: JournalsInfo()),
                )
              ],
              body: journals.isEmpty
                  ? YourContentEmptyPlaceholder(
                      message: 'No journals yet',
                      explainer:
                          'Reflect on your progress, take notes and set goals with Journals. You can create multiple journals if you need to, for different aspects of your journey.',
                      actions: [
                          EmptyPlaceholderAction(
                              action: () => context
                                  .navigateTo(ProgressJournalCreatorRoute()),
                              buttonIcon: CupertinoIcons.add,
                              buttonText: 'Create a Journal'),
                        ])
                  : FABPage(
                      rowButtons: [
                        FloatingButton(
                            onTap: () => context
                                .navigateTo(ProgressJournalCreatorRoute()),
                            gradient: Styles.primaryAccentGradient,
                            contentColor: Styles.white,
                            text: 'New Journal',
                            icon: CupertinoIcons.add,
                            iconSize: 20,
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 16))
                      ],
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: journals.length,
                          padding: const EdgeInsets.only(top: 8, bottom: 60),
                          itemBuilder: (context, index) {
                            final ProgressJournal journal = journals[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: GestureDetector(
                                  behavior: HitTestBehavior
                                      .opaque, // As there is empty space in the [ProgressJournalCard] which otherwise would not react to taps.
                                  onTap: () => context.navigateTo(
                                      ProgressJournalDetailsRoute(
                                          id: journal.id)),
                                  child: ProgressJournalCard(
                                      progressJournal: journal)),
                            );
                          }),
                    ),
            ),
          );
        });
  }
}
