import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/announcement_update_card.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';

/// Use this widget to display news and updates from the app admins to users on their home / feed page.
/// Users can mark read so that they no longer display on their feed page.
/// Displays as  horizontal swipeable list.
class AnnouncementsUpdates extends StatelessWidget {
  const AnnouncementsUpdates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = AnnouncementUpdatesQuery();

    return QueryObserver<AnnouncementUpdates$Query, json.JsonSerializable>(
        key: Key('AnnouncementsUpdates- ${query.operationName}'),
        query: query,
        loadingIndicator: Container(),
        builder: (data) {
          return GrowInOut(
              show: data.announcementUpdates.isNotEmpty,
              child: Container(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                height: 200,
                child: AnnouncementUpdatesList(
                  announcements: data.announcementUpdates
                      .sortedBy<DateTime>((a) => a.createdAt),
                ),
              ));
        });
  }
}

class AnnouncementUpdatesList extends StatelessWidget {
  final List<AnnouncementUpdate> announcements;
  const AnnouncementUpdatesList({Key? key, required this.announcements})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onlyOne = announcements.length == 1;

    return Padding(
      padding:
          EdgeInsets.only(left: onlyOne ? 10.0 : 0, right: onlyOne ? 10 : 0),
      child: PageView(
        controller: PageController(viewportFraction: onlyOne ? 1 : 0.95),
        children: announcements
            .map((a) => Padding(
                  padding: EdgeInsets.only(
                      left: onlyOne ? 0 : 5, right: onlyOne ? 0 : 5.0),
                  child: AnnouncementUpdateCard(announcement: a),
                ))
            .toList(),
      ),
    );
  }
}
