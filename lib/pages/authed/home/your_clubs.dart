import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/club_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class YourClubsPage extends StatelessWidget {
  const YourClubsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserClubsQuery();

    return QueryObserver<UserClubs$Query, json.JsonSerializable>(
        key: Key('YourClubsPage- ${query.operationName}'),
        query: query,
        loadingIndicator: const ShimmerListPage(),
        builder: (data) {
          final clubs = data.userClubs;

          return MyPageScaffold(
              navigationBar: MyNavBar(
                middle: const NavBarTitle('Clubs'),
                trailing: CreateIconButton(
                  onPressed: () => context.navigateTo(ClubCreatorRoute()),
                ),
              ),
              child: data.userClubs.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: clubs.length,
                      itemBuilder: (c, i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: GestureDetector(
                          onTap: () => context
                              .navigateTo(ClubDetailsRoute(id: clubs[i].id)),
                          child: ClubCard(
                            club: clubs[i],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: SecondaryButton(
                                prefixIconData: CupertinoIcons.add,
                                text: 'New Club',
                                onPressed: () =>
                                    context.navigateTo(ClubCreatorRoute())),
                          ),
                        ),
                      ],
                    ));
        });
  }
}
