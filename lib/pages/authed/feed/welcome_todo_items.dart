import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
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
        loadingIndicator: Container(),
        builder: (data) {
          return GrowInOut(
              show: data.welcomeTodoItems.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: WelcomeTodoList(
                  welcomeTodoItems: data.welcomeTodoItems
                      .sortedBy<num>((a) => int.parse(a.id)),
                ),
              ));
        });
  }
}

class WelcomeTodoList extends StatelessWidget {
  final List<WelcomeTodoItem> welcomeTodoItems;
  const WelcomeTodoList({Key? key, required this.welcomeTodoItems})
      : super(key: key);

  double get _cardHeight => 70.0;
  int _nextIndex(int i) => (i * 3) + 3;
  int? _clampedIndex(int i) =>
      _nextIndex(i) > welcomeTodoItems.length ? null : _nextIndex(i);

  @override
  Widget build(BuildContext context) {
    final onlyOne = welcomeTodoItems.length == 1;
    final onlyTwo = welcomeTodoItems.length == 2;

    return Container(
      padding:
          EdgeInsets.only(left: onlyOne ? 10.0 : 0, right: onlyOne ? 10 : 0),
      height: onlyTwo
          ? _cardHeight * 2
          : onlyOne
              ? _cardHeight
              : _cardHeight * 3,
      child: PageView.builder(
          itemCount: (welcomeTodoItems.length / 3).ceil(),
          controller: PageController(viewportFraction: onlyOne ? 1 : 0.93),
          itemBuilder: (c, i) => ImplicitlyAnimatedList<WelcomeTodoItem>(
              items: welcomeTodoItems.slice(i * 3, _clampedIndex(i)),
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
                        child: WelcomeTodoItemCard(
                          welcomeTodoItem: item,
                        )),
                  ),
              areItemsTheSame: (a, b) => a.id == b.id)),
    );
  }
}

class WelcomeTodoItemCard extends StatelessWidget {
  final WelcomeTodoItem welcomeTodoItem;
  const WelcomeTodoItemCard({Key? key, required this.welcomeTodoItem})
      : super(key: key);

  Future<void> _markWelcomeTodoItemAsSeen(BuildContext context) async {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final variables = MarkWelcomeTodoItemAsSeenArguments(
        data: MarkWelcomeTodoItemAsSeenInput(
            welcomeTodoItemId: welcomeTodoItem.id, userId: authedUserId));

    await context.graphQLStore.delete(
        mutation: MarkWelcomeTodoItemAsSeenMutation(variables: variables),
        objectId: welcomeTodoItem.id,
        typename: kWelcomeTodoItemTypename,
        removeRefFromQueries: [GQLOpNames.welcomeTodoItems]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
