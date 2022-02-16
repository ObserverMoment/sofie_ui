import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class DiscoverCreators extends StatelessWidget {
  const DiscoverCreators({Key? key}) : super(key: key);

  double get _tileHeight => 190;

  @override
  Widget build(BuildContext context) {
    final query = UserProfilesQuery(variables: UserProfilesArguments());

    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.biggest.width;
      final tileWidth = screenWidth / 2.22;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0, top: 8, bottom: 10),
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
                itemCount: 4,
                maxDiameter: tileWidth,
              ),
              builder: (data) {
                return Container(
                  padding: const EdgeInsets.only(left: 8),
                  height: _tileHeight * 2,
                  child: GridView.count(
                    childAspectRatio: _tileHeight / tileWidth,
                    padding: EdgeInsets.zero,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 2,
                    children: data.userProfiles
                        .map((p) => SizedBox(
                              width: tileWidth,
                              height: _tileHeight,
                              child: GestureDetector(
                                onTap: () => context.navigateTo(
                                    UserPublicProfileDetailsRoute(
                                        userId: p.id)),
                                child: _CreatorCard(
                                  profileSummary: p,
                                  avatarSize: _tileHeight,
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
    return Stack(
      children: [
        UserAvatar(
          size: avatarSize,
          avatarUri: profileSummary.avatarUri,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContentBox(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  backgroundColor:
                      context.theme.cardBackground.withOpacity(0.95),
                  borderRadius: borderRadius,
                  child: MyText(
                    profileSummary.displayName,
                    maxLines: 2,
                    size: FONTSIZE.two,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (profileSummary.skills.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: ContentBox(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      borderRadius: borderRadius,
                      backgroundColor:
                          context.theme.cardBackground.withOpacity(0.95),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommaSeparatedList(
                              profileSummary.skills,
                              fontSize: FONTSIZE.zero,
                              alignment: WrapAlignment.center,
                              runSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
