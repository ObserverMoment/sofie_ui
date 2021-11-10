import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/collection_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

/// Returns a collection.
/// Also allows inline creation of a new collection (name input only) which gets immediately returned.
class CollectionSelector extends StatelessWidget {
  final void Function(Collection collection) selectCollection;
  final String title;
  const CollectionSelector(
      {Key? key,
      required this.selectCollection,
      this.title = 'Your Collections'})
      : super(key: key);

  void _handleSelectCollection(BuildContext context, Collection collection) {
    selectCollection(collection);
    context.pop();
  }

  void _openCreateCollection(BuildContext context) {
    context.pushRoute(CollectionCreatorRoute(
      onComplete: (collection) {
        selectCollection(collection);
        context.pop();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          customLeading: NavBarCancelButton(context.pop),
          middle: NavBarTitle(title),
        ),
        child: QueryObserver<UserCollections$Query, json.JsonSerializable>(
            key: Key(
                'CollectionSelector - ${UserCollectionsQuery().operationName}'),
            query: UserCollectionsQuery(),
            fetchPolicy: QueryFetchPolicy.storeFirst,
            loadingIndicator:
                const ShimmerCardList(itemCount: 20, cardHeight: 100),
            builder: (data) {
              final collections = data.userCollections
                  .sortedBy<DateTime>((c) => c.createdAt)
                  .reversed
                  .toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: CreateTextIconButton(
                        text: 'Create new collection',
                        onPressed: () => _openCreateCollection(context)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: collections.length,
                          itemBuilder: (c, i) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _handleSelectCollection(
                                    context, collections[i]),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CollectionCard(
                                      collection: collections[i]),
                                ),
                              )),
                    ),
                  ),
                ],
              );
            }));
  }
}
