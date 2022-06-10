import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_tab_bar_view.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/components/resistance_session_card.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class ResistanceSessionsPage extends StatelessWidget {
  final String? previousPageTitle;
  const ResistanceSessionsPage({Key? key, this.previousPageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          previousPageTitle: previousPageTitle,
          middle: const NavBarTitle('Resistance'),
        ),
        child: MyTabBarView(
          leading: ContentBox(
            padding: const EdgeInsets.all(4),
            child: IconButton(
                iconData: CupertinoIcons.slider_horizontal_3, onPressed: () {}),
          ),
          tabs: const ['Your Studio', 'Your Circles'],
          pages: const [YourResistanceSessions(), YourResistanceSessions()],
        ));
  }
}

class YourResistanceSessions extends StatelessWidget {
  const YourResistanceSessions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserResistanceSessions$Query, json.JsonSerializable>(
        key: Key(
            'ResistanceSessionsPage - ${UserResistanceSessionsQuery().operationName}'),
        query: UserResistanceSessionsQuery(),
        builder: (created) => QueryObserver<UserSavedResistanceSessions$Query,
                json.JsonSerializable>(
            key: Key(
                'ResistanceSessionsPage - ${UserSavedResistanceSessionsQuery().operationName}'),
            query: UserSavedResistanceSessionsQuery(),
            builder: (saved) {
              final sortedByUpdatedAt = [
                ...created.userResistanceSessions,
                ...saved.userSavedResistanceSessions
              ].sortedBy<DateTime>((s) => s.updatedAt);

              return sortedByUpdatedAt.isEmpty
                  ? ContentEmptyPlaceholder(
                      message: 'No resistance sessions to display',
                      explainer:
                          'Get creative by creating your own session, or get involved in some Circles to discover the best workouts out there!',
                      actions: [
                          EmptyPlaceholderAction(
                              action: () => context
                                  .navigateTo(ResistanceSessionCreatorRoute()),
                              buttonIcon: CupertinoIcons.add,
                              buttonText: 'Create Session'),
                        ])
                  : ListView(
                      shrinkWrap: true,
                      children: sortedByUpdatedAt
                          .map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child:
                                    ResistanceSessionCard(resistanceSession: s),
                              ))
                          .toList(),
                    );
            }));
  }
}
