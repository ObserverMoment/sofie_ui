import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/club_card.dart';
import 'package:sofie_ui/components/cards/workout_card.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/services/utils.dart';

/// List of mixed type objects that the user has interacted with recently.
/// [Workouts], [Plans], [Clubs], [Throwdowns] etc.
class RecentlyViewedObjects extends StatelessWidget {
  const RecentlyViewedObjects({Key? key}) : super(key: key);

  Widget _buildRecentObjectCard(UserRecentlyViewedObject object) {
    if (object.club != null) {
      return ClubCard(club: object.club!);
    } else if (object.workout != null) {
      return WorkoutCard(object.workout!);
    } else if (object.workoutPlan != null) {
      return WorkoutPlanCard(object.workoutPlan!);
    } else {
      printLog(
          'RecentlyViewedObjects._buildRecentObjectCard: No valid sub field was found for $object');
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = UserRecentlyViewedObjectsQuery();

    return QueryObserver<UserRecentlyViewedObjects$Query,
            json.JsonSerializable>(
        key: Key('RecentlyViewedObjects - ${query.operationName}'),
        query: query,
        fetchPolicy: QueryFetchPolicy.networkOnly,
        builder: (data) {
          final recents = data.userRecentlyViewedObjects;
          return recents.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: const [
                      Opacity(
                          opacity: 0.4,
                          child: Icon(CupertinoIcons.list_bullet, size: 40)),
                      SizedBox(height: 12),
                      MyText(
                        'Nothing here yet...',
                        subtext: true,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recents.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 10),
                  itemBuilder: (c, i) => _buildRecentObjectCard(recents[i]));
        });
  }
}
