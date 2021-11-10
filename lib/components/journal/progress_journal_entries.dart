import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/cards/progress_journal_entry_card.dart';
import 'package:sofie_ui/components/creators/progress_journal_creator/progress_journal_entry_creator.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';

class ProgressJournalEntries extends StatelessWidget {
  final ProgressJournal parentJournal;
  final List<ProgressJournalEntry> entries;
  const ProgressJournalEntries(
      {Key? key, required this.entries, required this.parentJournal})
      : super(key: key);

  Future<void> _deleteJournalEntry(BuildContext context, String id) async {
    final variables = DeleteProgressJournalEntryByIdArguments(id: id);

    final result = await context.graphQLStore.delete(
        mutation: DeleteProgressJournalEntryByIdMutation(variables: variables),
        objectId: id,
        typename: kProgressJournalEntryTypename,
        broadcastQueryIds: [
          GQLVarParamKeys.progressJournalByIdQuery(parentJournal.id),
          GQLOpNames.userProgressJournalsQuery,
        ],
        removeAllRefsToId: true);

    if (result.hasErrors || result.data?.deleteProgressJournalEntryById != id) {
      context.showToast(
          message: 'Sorry, there was a problem deleting this entry.',
          toastType: ToastType.destructive);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries =
        entries.sortedBy<DateTime>((e) => e.createdAt).reversed.toList();

    return StackAndFloatingButton(
      onPressed: () => context.push(
          child: ProgressJournalEntryCreator(
        parentJournal: parentJournal,
      )),
      pageHasBottomNavBar: false,
      buttonText: 'Add Entry',
      child: entries.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: MyText(
                'No entries yet',
                textAlign: TextAlign.center,
                subtext: true,
              ),
            )
          : ListAvoidFAB(
              itemCount: entries.length,
              itemBuilder: (c, i) => GestureDetector(
                  onTap: () => context.push(
                          child: ProgressJournalEntryCreator(
                        parentJournal: parentJournal,
                        progressJournalEntry: sortedEntries[i],
                      )),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: AnimatedSlidable(
                          key: Key(
                              'progress-journal-entry-${sortedEntries[i].id}'),
                          index: i,
                          itemType: 'Journal Entry',
                          itemName: sortedEntries[i].createdAt.dateString,
                          removeItem: (index) =>
                              _deleteJournalEntry(context, sortedEntries[i].id),
                          secondaryActions: const [],
                          child: ProgressJournalEntryCard(
                            parentJournal: parentJournal,
                            progressJournalEntry: sortedEntries[i],
                          )))),
            ),
    );
  }
}
