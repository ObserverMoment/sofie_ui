import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/circles/components/circle_summary_card.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

class YourCircles extends StatefulWidget {
  const YourCircles({Key? key}) : super(key: key);

  @override
  State<YourCircles> createState() => _YourCirclesState();
}

class _YourCirclesState extends State<YourCircles> {
  late String _authedUserId;

  @override
  void initState() {
    _authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final query = UserClubsQuery();

    return QueryObserver<UserClubs$Query, json.JsonSerializable>(
        key: Key('CirclesPage- ${query.operationName}'),
        query: query,
        builder: (data) {
          final sortedClubs = data.userClubs
              .sortedBy<DateTime>((c) => c.createdAt)
              .reversed
              .toList();

          final clubsWhereOwner =
              sortedClubs.where((c) => c.owner.id == _authedUserId);
          final clubsWhereAdmin = sortedClubs
              .where((c) => c.admins.any((a) => a.id == _authedUserId));
          final clubsWhereMember = sortedClubs.where((c) => [
                ...clubsWhereOwner,
                ...clubsWhereAdmin
              ].none((club) => c.id == club.id));

          return sortedClubs.isEmpty
              ? const ContentEmptyPlaceholder(
                  message: 'No Circles to display',
                  explainer:
                      'Circles are the heart of our community experience! Use them to organise events and groups, share fitness stuff, build teams, sell services and merch, entertain fans, reward dedicated team members, create competitions and so much more!',
                  actions: [])
              : GridView.count(
                  padding: const EdgeInsets.all(12),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  crossAxisCount: 2,
                  children: [
                      ...clubsWhereOwner
                          .map((c) => CircleSummaryCard(
                                club: c,
                                isOwner: true,
                              ))
                          .toList(),
                      ...clubsWhereAdmin
                          .map((c) => CircleSummaryCard(
                                club: c,
                                isAdmin: true,
                              ))
                          .toList(),
                      ...clubsWhereMember
                          .map((c) => CircleSummaryCard(
                                club: c,
                              ))
                          .toList(),
                    ]);
        });
  }
}
