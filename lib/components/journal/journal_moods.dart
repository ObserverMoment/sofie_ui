import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/cards/journal_mood_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:auto_route/auto_route.dart';

class JournalMoods extends StatelessWidget {
  const JournalMoods({Key? key}) : super(key: key);

  Future<void> _deleteJournalMood(BuildContext context, String id) async {
    final variables = DeleteJournalMoodByIdArguments(id: id);

    final result = await context.graphQLStore.delete(
        mutation: DeleteJournalMoodByIdMutation(variables: variables),
        objectId: id,
        typename: kJournalMoodTypename,
        broadcastQueryIds: [
          GQLOpNames.journalMoods,
        ],
        removeAllRefsToId: true);

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem.',
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
                          action: () =>
                              context.navigateTo(JournalMoodCreatorRoute()),
                          buttonIcon: CupertinoIcons.add,
                          buttonText: 'Add Mood'),
                    ])
              : FABPage(
                  rowButtons: [
                    FloatingButton(
                      gradient: Styles.primaryAccentGradient,
                      contentColor: Styles.white,
                      iconSize: 20,
                      text: 'Add Mood',
                      onTap: () =>
                          context.navigateTo(JournalMoodCreatorRoute()),
                      icon: CupertinoIcons.add,
                    ),
                  ],
                  child: ImplicitlyAnimatedList<JournalMood>(
                      padding: const EdgeInsets.only(bottom: 60),
                      items: sortedMoods,
                      areItemsTheSame: (a, b) => a.id == b.id,
                      itemBuilder: (context, animation, mood, index) =>
                          SizeFadeTransition(
                            animation: animation,
                            sizeFraction: 0.7,
                            curve: Curves.easeInOut,
                            child: GestureDetector(
                                onTap: () => context.navigateTo(
                                    JournalMoodCreatorRoute(journalMood: mood)),
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: MySlidable(
                                        key: Key('journal-mood-${mood.id}'),
                                        index: index,
                                        itemType: 'Journal Mood',
                                        itemName: mood.createdAt.dateString,
                                        removeItem: (index) =>
                                            _deleteJournalMood(
                                                context, mood.id),
                                        secondaryActions: const [],
                                        child: JournalMoodCard(
                                          journalMood: mood,
                                        )))),
                          )),
                );
        });
  }
}
