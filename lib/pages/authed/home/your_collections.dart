import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/collection_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
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
        builder: (data) {
          final collections = data.userCollections
              .sortedBy<DateTime>((c) => c.createdAt)
              .reversed
              .toList();

          return MyPageScaffold(
              child: NestedScrollView(
                  headerSliverBuilder: (c, i) =>
                      [const MySliverNavbar(title: 'Colections')],
                  body: collections.isEmpty
                      ? YourContentEmptyPlaceholder(
                          message: 'No collections yet',
                          explainer:
                              'Collections are a great way to organise your things! Group your workouts, plans and other content however you like and easily save new stuff here whenever you want.',
                          actions: [
                              EmptyPlaceholderAction(
                                  action: () => context
                                      .navigateTo(CollectionCreatorRoute()),
                                  buttonIcon: CupertinoIcons.add,
                                  buttonText: 'Create Collection'),
                            ])
                      : FABPage(
                          columnButtons: [
                            FloatingButton(
                                gradient: Styles.primaryAccentGradient,
                                contentColor: Styles.white,
                                icon: CupertinoIcons.add,
                                onTap: () => context
                                    .navigateTo(CollectionCreatorRoute())),
                          ],
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 4, right: 10),
                            shrinkWrap: true,
                            itemCount: collections.length,
                            itemBuilder: (c, i) => GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => context.navigateTo(
                                  CollectionDetailsRoute(
                                      id: collections[i].id)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: CollectionCard(
                                  collection: collections[i],
                                ),
                              ),
                            ),
                          ),
                        )));
        });
  }
}
