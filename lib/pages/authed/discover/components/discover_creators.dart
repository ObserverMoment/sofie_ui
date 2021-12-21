import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyHeaderText(
                'Creators',
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
              height: 300,
              padding: const EdgeInsets.only(top: 2.0, left: 12),
              child: const ShimmerFriendsList(
                avatarSize: 120,
              ),
            ),
            builder: (data) {
              return SizedBox(
                height: 290,
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 2,
                  children: data.userProfiles
                      .map((p) => GestureDetector(
                            onTap: () => context.navigateTo(
                                UserPublicProfileDetailsRoute(userId: p.id)),
                            child: _CreatorAvatar(
                              profileSummary: p,
                            ),
                          ))
                      .toList(),
                ),
              );
            })
      ],
    );
  }
}

class _CreatorAvatar extends StatelessWidget {
  final UserProfileSummary profileSummary;
  const _CreatorAvatar({Key? key, required this.profileSummary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      UserAvatar(
        elevation: 1,
        avatarUri: profileSummary.avatarUri,
        size: 120,
      ),
      const SizedBox(height: 4),
      MyText(
        profileSummary.displayName,
        maxLines: 2,
        textAlign: TextAlign.center,
        size: FONTSIZE.two,
      ),
    ]);
  }
}
