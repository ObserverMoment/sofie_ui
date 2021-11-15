import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/gym_profile_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class YourGymProfilesPage extends StatelessWidget {
  const YourGymProfilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: const NavBarTitle('Gym Profiles'),
        trailing: CreateIconButton(
          onPressed: () => context.pushRoute(GymProfileCreatorRoute()),
        ),
      ),
      child: QueryObserver<GymProfiles$Query, json.JsonSerializable>(
          key: Key('YourGymProfilesPage- ${GymProfilesQuery().operationName}'),
          query: GymProfilesQuery(),
          loadingIndicator: const ShimmerCardList(
            itemCount: 10,
          ),
          builder: (data) {
            final gymProfiles = data.gymProfiles.reversed.toList();

            return gymProfiles.isNotEmpty
                ? ListView(
                    shrinkWrap: true,
                    children: gymProfiles
                        .map((g) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: GestureDetector(
                                onTap: () => context.navigateTo(
                                  GymProfileCreatorRoute(
                                    gymProfile: g,
                                  ),
                                ),
                                child: GymProfileCard(gymProfile: g),
                              ),
                            ))
                        .toList(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              child: MyText(
                                'Gym profiles let you save details about the different places that you work out. Name, location, available equipment and more. Use profiles when filtering for workouts and plans to make sure that you have the equipment required to complete them.',
                                textAlign: TextAlign.center,
                                maxLines: 6,
                                lineHeight: 1.4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: SecondaryButton(
                              prefixIconData: CupertinoIcons.add,
                              text: 'Add a Gym Profile',
                              onPressed: () =>
                                  context.navigateTo(ClubCreatorRoute())),
                        ),
                      ],
                    ),
                  );
          }),
    );
  }
}
