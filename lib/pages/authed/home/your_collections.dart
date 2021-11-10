import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/collection_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class YourCollectionsPage extends StatelessWidget {
  const YourCollectionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserCollections$Query, json.JsonSerializable>(
        key: Key(
            'YourCollectionsPage - ${UserCollectionsQuery().operationName}'),
        query: UserCollectionsQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        loadingIndicator: const ShimmerListPage(
          cardHeight: 100,
        ),
        builder: (data) {
          final collections = data.userCollections
              .sortedBy<DateTime>((c) => c.createdAt)
              .reversed
              .toList();

          return MyPageScaffold(
              navigationBar: MyNavBar(
                middle: const NavBarTitle('Your Collections'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CreateIconButton(
                      onPressed: () =>
                          context.navigateTo(CollectionCreatorRoute()),
                    ),
                  ],
                ),
              ),
              child: collections.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: collections.length,
                        itemBuilder: (c, i) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => context.navigateTo(
                              CollectionDetailsRoute(id: collections[i].id)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CollectionCard(
                              collection: collections[i],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: MyText(
                        'No collections yet...',
                        textAlign: TextAlign.center,
                      ),
                    ));
        });
  }
}
