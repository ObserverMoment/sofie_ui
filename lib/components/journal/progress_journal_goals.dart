import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/cards/progress_journal_goal_card.dart';
import 'package:sofie_ui/components/cards/progress_journal_goals_summary_card.dart';
import 'package:sofie_ui/components/creators/progress_journal_creator/progress_journal_goal_creator.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';

class ProgressJournalGoals extends StatelessWidget {
  final String parentJournalId;
  final List<ProgressJournalGoal> goals;
  const ProgressJournalGoals(
      {Key? key, required this.goals, required this.parentJournalId})
      : super(key: key);

  Future<void> _deleteJournalGoal(BuildContext context, String id) async {
    final variables = DeleteProgressJournalGoalByIdArguments(id: id);

    final result = await context.graphQLStore.delete(
        mutation: DeleteProgressJournalGoalByIdMutation(variables: variables),
        objectId: id,
        typename: kProgressJournalGoalTypename,
        broadcastQueryIds: [
          ProgressJournalByIdQuery(
                  variables: ProgressJournalByIdArguments(id: parentJournalId))
              .operationName,
          UserProgressJournalsQuery().operationName,
        ],
        removeAllRefsToId: true);

    if (result.hasErrors || result.data?.deleteProgressJournalGoalById != id) {
      context.showToast(
          message: 'Sorry, there was a problem deleting this goal.',
          toastType: ToastType.destructive);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedGoals =
        goals.sortedBy<DateTime>((e) => e.createdAt).reversed.toList();

    return Column(
      children: [
        ProgressJournalGoalsSummaryCard(
          goals: goals,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StackAndFloatingButton(
            onPressed: () => context.push(
                child: ProgressJournalGoalCreator(
                    parentJournalId: parentJournalId)),
            pageHasBottomNavBar: false,
            buttonText: 'Add Goal',
            child: goals.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: MyText(
                      'No goals yet',
                      textAlign: TextAlign.center,
                      subtext: true,
                    ),
                  )
                : ListAvoidFAB(
                    itemCount: sortedGoals.length,
                    itemBuilder: (c, i) => GestureDetector(
                      onTap: () => context.push(
                          child: ProgressJournalGoalCreator(
                        parentJournalId: parentJournalId,
                        progressJournalGoal: sortedGoals[i],
                      )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: AnimatedSlidable(
                          key:
                              Key('progress-journal-goal-${sortedGoals[i].id}'),
                          index: i,
                          itemType: 'Journal Goal',
                          itemName: sortedGoals[i].name,
                          removeItem: (index) =>
                              _deleteJournalGoal(context, sortedGoals[i].id),
                          secondaryActions: const [],
                          child: ProgressJournalGoalCard(
                              progressJournalGoal: sortedGoals[i]),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
