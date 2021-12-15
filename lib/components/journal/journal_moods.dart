import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/cards/journal_mood_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:json_annotation/json_annotation.dart' as json;

class JournalMoods extends StatelessWidget {
  const JournalMoods({Key? key}) : super(key: key);

  Future<void> _deleteJournalMood(BuildContext context, String id) async {
    final variables = DeleteJournalMoodByIdArguments(id: id);

    final result = await context.graphQLStore.delete(
        mutation: DeleteJournalMoodByIdMutation(variables: variables),
        objectId: id,
        typename: kJournalMoodTypename,
        broadcastQueryIds: [
          GQLOpNames.journalNotes,
        ],
        removeAllRefsToId: true);

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem deleting this entry.',
            toastType: ToastType.destructive));
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<JournalMoods$Query, json.JsonSerializable>(
        key: Key('JournalMoods - ${JournalMoodsQuery().operationName}'),
        query: JournalMoodsQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final sortedMoods = data.journalMoods
              .sortedBy<DateTime>((e) => e.createdAt)
              .reversed
              .toList();

          return sortedMoods.isEmpty
              ? YourContentEmptyPlaceholder(
                  message: 'No moods logged',
                  explainer:
                      'Keep track of your energy levels and your mental and emotional state, so that you know when to push and when to rest.',
                  actions: [
                      EmptyPlaceholderAction(
                          action: () => print('create mood'),
                          buttonIcon: CupertinoIcons.add,
                          buttonText: 'Add Mood'),
                    ])
              : FABPage(
                  child: ListView.builder(
                      itemCount: sortedMoods.length,
                      itemBuilder: (c, i) => GestureDetector(
                          onTap: () => print('edit mood'),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: AnimatedSlidable(
                                  key: Key('journal-mood-${sortedMoods[i].id}'),
                                  index: i,
                                  itemType: 'Journal Mood',
                                  itemName: sortedMoods[i].createdAt.dateString,
                                  removeItem: (index) => _deleteJournalMood(
                                      context, sortedMoods[i].id),
                                  secondaryActions: const [],
                                  child: JournalMoodCard(
                                    journalMood: sortedMoods[i],
                                  ))))));
        });
  }
}
