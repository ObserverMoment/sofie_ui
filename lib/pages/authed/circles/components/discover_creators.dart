import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class DiscoverCreators extends StatelessWidget {
  const DiscoverCreators({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = UserProfilesQuery(variables: UserProfilesArguments());

    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.biggest.width;
      final tileWidth = screenWidth / 3.4;
      final tileHeight = tileWidth * 1.38;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MyHeaderText(
                  'People',
                ),
                TertiaryButton(
                    text: 'View All',
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    onPressed: () =>
                        context.navigateTo(const DiscoverPeopleRoute())),
              ],
            ),
          ),
          QueryObserver<UserProfiles$Query, json.JsonSerializable>(
              key: Key('DiscoverCreators- ${query.operationName}'),
              query: query,
              loadingIndicator: ShimmerCirclesGrid(
                itemCount: 8,
                maxDiameter: tileHeight,
                scrollDirection: Axis.horizontal,
              ),
              builder: (data) {
                return Container(
                  padding: const EdgeInsets.only(left: 8),
                  height: tileHeight * 2,
                  child: GridView.count(
                    childAspectRatio: tileHeight / tileWidth,
                    padding: EdgeInsets.zero,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 2,
                    children: data.userProfiles
                        .map((p) => SizedBox(
                              width: tileWidth,
                              height: tileHeight,
                              child: GestureDetector(
                                onTap: () => context.navigateTo(
                                    UserPublicProfileDetailsRoute(
                                        userId: p.id)),
                                child: _CreatorCard(
                                  profileSummary: p,
                                  avatarSize: tileWidth,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                );
              })
        ],
      );
    });
  }
}

class _CreatorCard extends StatelessWidget {
  final UserProfileSummary profileSummary;
  final double avatarSize;
  const _CreatorCard(
      {Key? key, required this.profileSummary, required this.avatarSize})
      : super(key: key);

  double get borderRadius => 12;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatar(
          border: true,
          size: avatarSize,
          avatarUri: profileSummary.avatarUri,
        ),
        const SizedBox(height: 4),
        MyText(
          profileSummary.displayName,
          size: FONTSIZE.one,
          textAlign: TextAlign.center,
        ),
        if (profileSummary.skills.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: MyText(
              profileSummary.skills.join(', '),
              size: FONTSIZE.zero,
              lineHeight: 1.3,
            ),
          ),
      ],
    );
  }
}
