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
import 'package:sofie_ui/extensions/context_extensions.dart';

class DiscoverCreators extends StatelessWidget {
  const DiscoverCreators({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query =
        UserPublicProfilesQuery(variables: UserPublicProfilesArguments());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyHeaderText('Creators'),
              IconButton(
                  iconData: CupertinoIcons.compass,
                  onPressed: () =>
                      context.navigateTo(const DiscoverPeopleRoute()))
            ],
          ),
        ),
        QueryObserver<UserPublicProfiles$Query, json.JsonSerializable>(
            key: Key('DiscoverCreators- ${query.operationName}'),
            query: query,
            loadingIndicator: Container(
              height: 190,
              padding: const EdgeInsets.only(top: 2.0, left: 12),
              child: const ShimmerFriendsList(
                avatarSize: 140,
              ),
            ),
            builder: (data) {
              final profiles = data.userPublicProfiles;
              return Container(
                height: 200,
                padding: const EdgeInsets.only(top: 2.0, left: 12),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: profiles.length,
                    itemBuilder: (c, i) => Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: GestureDetector(
                            onTap: () => context.navigateTo(
                                UserPublicProfileDetailsRoute(
                                    userId: profiles[i].id)),
                            child: _CreatorAvatar(
                              profileSummary: profiles[i],
                            ),
                          ),
                        )),
              );
            })
      ],
    );
  }
}

class _CreatorAvatar extends StatelessWidget {
  final UserPublicProfileSummary profileSummary;
  const _CreatorAvatar({Key? key, required this.profileSummary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 146,
      child: Column(children: [
        UserAvatar(
          elevation: 0,
          avatarUri: profileSummary.avatarUri,
          size: 140,
        ),
        const SizedBox(height: 8),
        ContentBox(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            backgroundColor: context.theme.cardBackground.withOpacity(0.5),
            child: MyText(
              profileSummary.displayName,
              maxLines: 2,
              textAlign: TextAlign.center,
            )),
      ]),
    );
  }
}
