import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/cards/gym_profile_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class YourGymProfilesPage extends StatelessWidget {
  const YourGymProfilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<GymProfiles$Query, json.JsonSerializable>(
        key: Key('YourGymProfilesPage- ${GymProfilesQuery().operationName}'),
        query: GymProfilesQuery(),
        loadingIndicator: const ShimmerCardList(
          itemCount: 10,
        ),
        builder: (data) {
          final gymProfiles = data.gymProfiles.reversed.toList();

          return MyPageScaffold(
              child: NestedScrollView(
                  headerSliverBuilder: (c, i) => [
                        const CupertinoSliverNavigationBar(
                            leading: NavBarBackButton(),
                            largeTitle: Text('Gym Profiles'),
                            border: null)
                      ],
                  body: gymProfiles.isEmpty
                      ? YourContentEmptyPlaceholder(
                          message: 'No gym profiles yet',
                          explainer:
                              'Save details about the different places that you work out. Name, location, available equipment and more. Use profiles when filtering for workouts and plans to make sure that you have the equipment required to complete them.',
                          actions: [
                              EmptyPlaceholderAction(
                                  action: () => context
                                      .navigateTo(GymProfileCreatorRoute()),
                                  buttonIcon: CupertinoIcons.add,
                                  buttonText: 'Create Gym Profile'),
                            ])
                      : FABPage(
                          columnButtons: [
                            FloatingButton(
                                gradient: Styles.primaryAccentGradient,
                                contentColor: Styles.white,
                                icon: CupertinoIcons.add,
                                onTap: () => context
                                    .navigateTo(GymProfileCreatorRoute())),
                          ],
                          child: ListView(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 8),
                            shrinkWrap: true,
                            children: gymProfiles
                                .map((g) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
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
                          ),
                        )));
        });
  }
}
