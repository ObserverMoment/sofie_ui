import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/cards/user_profile_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class DiscoverPeoplePage extends StatelessWidget {
  const DiscoverPeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query =
        UserPublicProfilesQuery(variables: UserPublicProfilesArguments());
    return QueryObserver<UserPublicProfiles$Query, json.JsonSerializable>(
        key: Key('DiscoverPeoplePage- ${query.operationName}'),
        query: query,
        loadingIndicator: const ShimmerListPage(),
        builder: (data) {
          final profiles = data.userPublicProfiles;

          return MyPageScaffold(
              child: NestedScrollView(
                  headerSliverBuilder: (c, i) => [
                        const CupertinoSliverNavigationBar(
                            leading: NavBarBackButton(),
                            largeTitle: Text('Discover People'),
                            border: null)
                      ],
                  body: ListView.separated(
                    padding: const EdgeInsets.only(top: 8),
                    shrinkWrap: true,
                    itemCount: profiles.length,
                    separatorBuilder: (c, i) => const HorizontalLine(),
                    itemBuilder: (c, i) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.navigateTo(
                          UserPublicProfileDetailsRoute(
                              userId: profiles[i].id)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UserProfileCard(
                            profileSummary: profiles[i], avatarSize: 130),
                      ),
                    ),
                  )));
        });
  }
}
