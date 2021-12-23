import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/cards/journal_goal_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class JournalGoals extends StatelessWidget {
  const JournalGoals({Key? key}) : super(key: key);

  Future<void> _deleteJournalGoal(BuildContext context, String id) async {
    final variables = DeleteJournalGoalByIdArguments(id: id);

    final result = await context.graphQLStore.delete(
        mutation: DeleteJournalGoalByIdMutation(variables: variables),
        objectId: id,
        typename: kJournalGoalTypename,
        broadcastQueryIds: [
          GQLOpNames.journalGoals,
        ],
        removeAllRefsToId: true);

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem deleting this goal.',
            toastType: ToastType.destructive));
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
                          action: () =>
                              context.navigateTo(JournalGoalCreatorRoute()),
                          buttonIcon: CupertinoIcons.add,
                          buttonText: 'Add Goal'),
                    ])
              : FABPage(
                  rowButtons: [
                    FloatingButton(
                      gradient: Styles.primaryAccentGradient,
                      contentColor: Styles.white,
                      iconSize: 20,
                      text: 'Add Goal',
                      onTap: () =>
                          context.navigateTo(JournalGoalCreatorRoute()),
                      icon: CupertinoIcons.add,
                    ),
                  ],
                  child: ImplicitlyAnimatedList<JournalGoal>(
                      padding: const EdgeInsets.only(
                          left: 4, top: 4, right: 4, bottom: 60),
                      items: sortedGoals,
                      areItemsTheSame: (a, b) => a.id == b.id,
                      itemBuilder: (context, animation, goal, index) =>
                          SizeFadeTransition(
                            animation: animation,
                            sizeFraction: 0.7,
                            curve: Curves.easeInOut,
                            child: GestureDetector(
                                onTap: () => context.navigateTo(
                                    JournalGoalCreatorRoute(journalGoal: goal)),
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: MySlidable(
                                        key: Key('journal-goal-${goal.id}'),
                                        index: index,
                                        itemType: 'Journal Goal',
                                        itemName: goal.name,
                                        removeItem: (index) =>
                                            _deleteJournalGoal(
                                                context, goal.id),
                                        secondaryActions: const [],
                                        child: JournalGoalCard(
                                          journalGoal: goal,
                                        )))),
                          )),
                );
        });
  }
}
