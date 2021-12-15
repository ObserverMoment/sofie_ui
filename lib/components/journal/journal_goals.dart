import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/cards/journal_goal_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/extensions/type_extensions.dart';

class JournalGoals extends StatelessWidget {
  const JournalGoals({Key? key}) : super(key: key);

  Future<void> _deleteJournalGoal(BuildContext context, String id) async {
    final variables = DeleteJournalGoalByIdArguments(id: id);

    final result = await context.graphQLStore.delete(
        mutation: DeleteJournalGoalByIdMutation(variables: variables),
        objectId: id,
        typename: kJournalGoalTypename,
        broadcastQueryIds: [
          JournalGoalsQuery().operationName,
        ],
        removeAllRefsToId: true);

    if (result.hasErrors || result.data?.deleteJournalGoalById != id) {
      context.showToast(
          message: 'Sorry, there was a problem deleting this goal.',
          toastType: ToastType.destructive);
    }
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<JournalGoals$Query, json.JsonSerializable>(
        key: Key('JournalGoals - ${JournalGoalsQuery().operationName}'),
        query: JournalGoalsQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final sortedGoals = data.journalGoals
              .sortedBy<DateTime>((e) => e.createdAt)
              .reversed
              .toList();

          return sortedGoals.isEmpty
              ? YourContentEmptyPlaceholder(
                  message: 'No goals yet',
                  explainer:
                      'Set yourself realistic goals to track your progress and keep yourself motivated.',
                  actions: [
                      EmptyPlaceholderAction(
                          action: () => print('create goal'),
                          buttonIcon: CupertinoIcons.add,
                          buttonText: 'Add Goal'),
                    ])
              : FABPage(
                  child: ListView.builder(
                      itemCount: sortedGoals.length,
                      itemBuilder: (c, i) => GestureDetector(
                          onTap: () => print('edit goal'),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: AnimatedSlidable(
                                  key: Key('journal-goal-${sortedGoals[i].id}'),
                                  index: i,
                                  itemType: 'Journal Goal',
                                  itemName: sortedGoals[i].createdAt.dateString,
                                  removeItem: (index) => _deleteJournalGoal(
                                      context, sortedGoals[i].id),
                                  secondaryActions: const [],
                                  child: JournalGoalCard(
                                    journalGoal: sortedGoals[i],
                                  ))))));
        });
  }
}
