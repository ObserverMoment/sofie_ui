import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';

/// Use this widget to display a sort of welcome to Sofie todo list.
/// The list directs new users to Sofie features. They can dismiss the list items whenever they want and when are all dismissed this just returns an empty container.
class WelcomeTodoItems extends StatelessWidget {
  const WelcomeTodoItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = WelcomeTodoItemsQuery();

    return QueryObserver<WelcomeTodoItems$Query, json.JsonSerializable>(
        key: Key('WelcomeTodoItems- ${query.operationName}'),
        query: query,
        // Should already have queried for this data when booting app.
        fetchPolicy: QueryFetchPolicy.storeFirst,
        loadingIndicator: Container(),
        builder: (data) {
          return data.welcomeTodoItems.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: WelcomeTodoList(
                    welcomeTodoItems: data.welcomeTodoItems
                        .sortedBy<num>((a) => int.parse(a.id)),
                  ),
                )
              : Container();
        });
  }
}

class WelcomeTodoList extends StatelessWidget {
  final List<WelcomeTodoItem> welcomeTodoItems;
  const WelcomeTodoList({Key? key, required this.welcomeTodoItems})
      : super(key: key);

  int get _todosPerCard => 3;
  double get _cardMargin => 4;
  double get _cardHeight => 60.0;
  double get _cardHeightWithMargin => _cardHeight + (_cardMargin * 2);
  int _nextIndex(int i) => (i * _todosPerCard) + _todosPerCard;
  int? _clampedIndex(int i) =>
      _nextIndex(i) > welcomeTodoItems.length ? null : _nextIndex(i);

  @override
  Widget build(BuildContext context) {
    final onlyOneCard = welcomeTodoItems.length <= _todosPerCard;

    return Container(
      padding: EdgeInsets.only(
          left: onlyOneCard ? 10.0 : 0, right: onlyOneCard ? 10 : 0),
      height: onlyOneCard
          ? _cardHeightWithMargin * welcomeTodoItems.length
          : _cardHeightWithMargin * _todosPerCard,
      child: PageView.builder(
          itemCount: (welcomeTodoItems.length / _todosPerCard).ceil(),
          controller: PageController(viewportFraction: onlyOneCard ? 1 : 0.93),
          itemBuilder: (c, i) => ImplicitlyAnimatedList<WelcomeTodoItem>(
              physics: const NeverScrollableScrollPhysics(),
              items:
                  welcomeTodoItems.slice(i * _todosPerCard, _clampedIndex(i)),
              itemBuilder: (context, animation, item, index) =>
                  SizeFadeTransition(
                    animation: animation,
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    child: GestureDetector(
                        onTap: item.routeTo != null
                            ? () => context.navigateNamedTo(item.routeTo!)
                            : item.videoUri != null
                                ? () =>
                                    VideoSetupManager.openFullScreenVideoPlayer(
                                        context: context,
                                        videoUri: item.videoUri!)
                                : null,
                        child: Padding(
                          padding: EdgeInsets.all(_cardMargin),
                          child: WelcomeTodoItemCard(
                              welcomeTodoItem: item, cardHeight: _cardHeight),
                        )),
                  ),
              areItemsTheSame: (a, b) => a.id == b.id)),
    );
  }
}

class WelcomeTodoItemCard extends StatelessWidget {
  final WelcomeTodoItem welcomeTodoItem;
  final double cardHeight;
  const WelcomeTodoItemCard(
      {Key? key, required this.welcomeTodoItem, required this.cardHeight})
      : super(key: key);

  Future<void> _markWelcomeTodoItemAsSeen(BuildContext context) async {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final variables = MarkWelcomeTodoItemAsSeenArguments(
        data: MarkWelcomeTodoItemAsSeenInput(
            welcomeTodoItemId: welcomeTodoItem.id, userId: authedUserId));

    await GraphQLStore.store.delete(
        mutation: MarkWelcomeTodoItemAsSeenMutation(variables: variables),
        objectId: welcomeTodoItem.id,
        typename: kWelcomeTodoItemTypename,
        removeRefFromQueries: [GQLOpNames.welcomeTodoItems]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        height: cardHeight,
        margin: EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.arrow_right_square,
                  color: Styles.primaryAccent,
                ),
                const SizedBox(width: 8),
                MyText(welcomeTodoItem.title),
              ],
            ),
            TertiaryButton(
                text: 'Clear',
                backgroundColor: context.theme.background,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                fontSize: FONTSIZE.one,
                onPressed: () => _markWelcomeTodoItemAsSeen(context))
          ],
        ));
  }
}
