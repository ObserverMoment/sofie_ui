import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class DiscoverCreators extends StatelessWidget {
  const DiscoverCreators({Key? key}) : super(key: key);

  double get _tileHeight => 178;
  double get _avatarSize => 120;

  @override
  Widget build(BuildContext context) {
    final query = UserProfilesQuery(variables: UserProfilesArguments());

    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.biggest.width;
      final tileWidth = screenWidth / 2.3;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 8, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MyHeaderText(
                  'People',
                  size: FONTSIZE.five,
                ),
                IconButton(
                    iconData: CupertinoIcons.compass,
                    onPressed: () =>
                        context.navigateTo(const DiscoverPeopleRoute()))
              ],
            ),
          ),
          QueryObserver<UserProfiles$Query, json.JsonSerializable>(
              key: Key('DiscoverCreators- ${query.operationName}'),
              query: query,
              loadingIndicator: Container(
                height: _tileHeight * 2,
                padding: const EdgeInsets.only(top: 2.0, left: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ShimmerFriendsList(
                      avatarSize: _avatarSize,
                    ),
                    ShimmerFriendsList(
                      avatarSize: _avatarSize,
                    ),
                  ],
                ),
              ),
              builder: (data) {
                return SizedBox(
                  height: _tileHeight * 2,
                  child: GridView.count(
                    childAspectRatio: _tileHeight / tileWidth,
                    padding: EdgeInsets.zero,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 2,
                    children: [...data.userProfiles, ...data.userProfiles]
                        .map((p) => SizedBox(
                              width: tileWidth,
                              height: _tileHeight,
                              child: GestureDetector(
                                onTap: () => context.navigateTo(
                                    UserPublicProfileDetailsRoute(
                                        userId: p.id)),
                                child: _CreatorCard(
                                  profileSummary: p,
                                  avatarSize: _avatarSize,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 3),
        UserAvatar(avatarUri: profileSummary.avatarUri, size: avatarSize),
        const SizedBox(height: 3),
        MyText(
          profileSummary.displayName,
          size: FONTSIZE.two,
          weight: FontWeight.bold,
        ),
        if (profileSummary.skills.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 3.0, left: 8, right: 8),
            child: CommaSeparatedList(
              profileSummary.skills,
              fontSize: FONTSIZE.one,
              alignment: WrapAlignment.center,
              runSpacing: 2,
            ),
          )
      ],
    );
  }
}
