import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/cards/user_goal_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class UserGoalsPage extends StatelessWidget {
  const UserGoalsPage({Key? key}) : super(key: key);

  Future<void> _deleteUserGoal(BuildContext context, String id) async {
    final variables = DeleteUserGoalArguments(id: id);

    final result = await GraphQLStore.store.delete(
        mutation: DeleteUserGoalMutation(variables: variables),
        objectId: id,
        typename: kUserGoalTypename,
        broadcastQueryIds: [
          GQLOpNames.userGoals,
        ],
        removeAllRefsToId: true);

    checkOperationResult(result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem deleting this goal.',
            toastType: ToastType.destructive));
  }

  /// Sort by deadline, then updated at, then completed at.
  /// List goes:
  /// With Deadline.
  /// Without Deadline
  /// Completed.
  List<UserGoal> _sortedGoals(List<UserGoal> goals) {
    final incompleteWithDeadline = goals
        .where((g) => g.completedDate == null && g.deadline != null)
        .sortedBy<DateTime>((g) => g.deadline!)
        .toList();

    final incompleteWithoutDeadline = goals
        .where((g) => g.completedDate == null && g.deadline == null)
        .sortedBy<DateTime>((g) => g.updatedAt)
        .toList();

    final complete = goals
        .where((g) => g.completedDate != null)
        .sortedBy<DateTime>((g) => g.completedDate!)
        .toList();

    return [
      ...incompleteWithDeadline,
      ...incompleteWithoutDeadline,
      ...complete
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (c, i) =>
                [const MySliverNavbar(title: 'Goal Tracking')],
            body: QueryObserver<UserGoals$Query, json.JsonSerializable>(
                key: Key('UserGoals - ${UserGoalsQuery().operationName}'),
                query: UserGoalsQuery(),
                fetchPolicy: QueryFetchPolicy.storeFirst,
                builder: (data) {
                  final sortedGoals = _sortedGoals(data.userGoals);

                  return sortedGoals.isEmpty
                      ? YourContentEmptyPlaceholder(
                          message: 'No goals yet',
                          explainer:
                              'Set yourself realistic goals to track your progress and keep yourself motivated.',
                          actions: [
                              EmptyPlaceholderAction(
                                  action: () => context
                                      .navigateTo(UserGoalCreatorRoute()),
                                  buttonIcon: CupertinoIcons.add,
                                  buttonText: 'Add Goal'),
                            ])
                      : FABPage(
                          rowButtons: [
                            FloatingButton(
                              iconSize: 20,
                              text: 'Add Goal',
                              onTap: () =>
                                  context.navigateTo(UserGoalCreatorRoute()),
                              icon: CupertinoIcons.add,
                              width: 200,
                            ),
                          ],
                          child: ImplicitlyAnimatedList<UserGoal>(
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
                                            UserGoalCreatorRoute(
                                                journalGoal: goal)),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: MySlidable(
                                                key: Key(
                                                    'journal-goal-${goal.id}'),
                                                index: index,
                                                itemType: 'Journal Goal',
                                                itemName: goal.name,
                                                removeItem: (index) =>
                                                    _deleteUserGoal(
                                                        context, goal.id),
                                                secondaryActions: const [],
                                                child: UserGoalCard(
                                                  journalGoal: goal,
                                                )))),
                                  )),
                        );
                })));
  }
}
