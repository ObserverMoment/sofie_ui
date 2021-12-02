import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/club_card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:collection/collection.dart';

enum ClubMemberTypeFilter { all, owner, member }

class YourClubsPage extends StatefulWidget {
  const YourClubsPage({Key? key}) : super(key: key);

  @override
  State<YourClubsPage> createState() => _YourClubsPageState();
}

class _YourClubsPageState extends State<YourClubsPage> {
  @override
  Widget build(BuildContext context) {
    final query = UserClubsQuery();

    return QueryObserver<UserClubs$Query, json.JsonSerializable>(
        key: Key('YourClubsPage- ${query.operationName}'),
        query: query,
        builder: (data) {
          return _FilterableClubsList(
            clubs: data.userClubs,
          );
        });
  }
}

class _FilterableClubsList extends StatefulWidget {
  final List<ClubSummary> clubs;
  const _FilterableClubsList({Key? key, required this.clubs}) : super(key: key);

  @override
  __FilterableClubsListState createState() => __FilterableClubsListState();
}

class __FilterableClubsListState extends State<_FilterableClubsList> {
  ClubMemberTypeFilter _memberTypeFilter = ClubMemberTypeFilter.all;
  late String _authedUserId;

  @override
  void initState() {
    _authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filteredClubs = _memberTypeFilter == ClubMemberTypeFilter.all
        ? widget.clubs
        : _memberTypeFilter == ClubMemberTypeFilter.owner
            ? widget.clubs.where((c) => c.owner.id == _authedUserId)
            : widget.clubs.where((c) => c.owner.id != _authedUserId);

    final sortedClubs =
        filteredClubs.sortedBy<DateTime>((c) => c.createdAt).reversed.toList();

    return CupertinoPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  const CupertinoSliverNavigationBar(
                      leading: NavBarBackButton(),
                      largeTitle: Text('Clubs'),
                      border: null)
                ],
            body: sortedClubs.isEmpty
                ? YourContentEmptyPlaceholder(
                    message: 'No clubs to display',
                    explainer:
                        'Clubs are at the heart of the Sofie experience! You can use them to organise events and groups, share workouts and plans, build teams and motivate, sell services and merch, entertain fans, reward high performing and dedicated team members, create competitions and so much more!',
                    actions: [
                        EmptyPlaceholderAction(
                            action: () =>
                                context.navigateTo(ClubCreatorRoute()),
                            buttonIcon: CupertinoIcons.add,
                            buttonText: 'Create Club'),
                        EmptyPlaceholderAction(
                            action: () =>
                                context.navigateTo(const DiscoverClubsRoute()),
                            buttonIcon: CupertinoIcons.compass,
                            buttonText: 'Find Clubs'),
                      ])
                : FABPage(
                    columnButtons: [
                      FloatingButton(
                          gradient: Styles.primaryAccentGradient,
                          contentColor: Styles.white,
                          icon: CupertinoIcons.add,
                          onTap: () => context.navigateTo(ClubCreatorRoute())),
                    ],
                    rowButtonsAlignment: MainAxisAlignment.end,
                    rowButtons: [
                      FABPageButtonContainer(
                        padding: EdgeInsets.zero,
                        child: MySlidingSegmentedControl<ClubMemberTypeFilter>(
                            margin: EdgeInsets.zero,
                            activeColor: Styles.secondaryAccent,
                            childPadding:
                                const EdgeInsets.symmetric(vertical: 7.5),
                            value: _memberTypeFilter,
                            updateValue: (t) =>
                                setState(() => _memberTypeFilter = t),
                            children: const {
                              ClubMemberTypeFilter.all: 'All',
                              ClubMemberTypeFilter.owner: 'Owner',
                              ClubMemberTypeFilter.member: 'Member',
                            }),
                      ),
                    ],
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 4,
                        bottom: 120,
                      ),
                      shrinkWrap: true,
                      itemCount: sortedClubs.length,
                      itemBuilder: (c, i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: GestureDetector(
                          onTap: () => context.navigateTo(
                              ClubDetailsRoute(id: sortedClubs[i].id)),
                          child: ClubCard(
                            club: sortedClubs[i],
                          ),
                        ),
                      ),
                    ),
                  )));
  }
}
