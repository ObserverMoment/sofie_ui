import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/cards/gym_profile_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class ProfileGymProfilesPage extends StatelessWidget {
  const ProfileGymProfilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<GymProfiles$Query, json.JsonSerializable>(
        key:
            Key('ProfileGymProfilesPage - ${GymProfilesQuery().operationName}'),
        query: GymProfilesQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        loadingIndicator: const ShimmerCardList(
          itemCount: 8,
        ),
        builder: (data) {
          final gymProfiles = data.gymProfiles.reversed.toList();
          return StackAndFloatingButton(
            buttonText: 'Add Profile',
            onPressed: () => context.pushRoute(GymProfileCreatorRoute()),
            child: gymProfiles.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListAvoidFAB(
                      itemCount: gymProfiles.length,
                      itemBuilder: (c, i) => GestureDetector(
                        onTap: () => context.pushRoute(
                          GymProfileCreatorRoute(
                            gymProfile: gymProfiles[i],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: GymProfileCard(
                            gymProfile: gymProfiles[i],
                          ),
                        ),
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: MyText(
                      'No gym profiles yet...',
                      textAlign: TextAlign.center,
                    ),
                  ),
          );
        });
  }
}
