import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';

class FeedUtils {
  /// Calls our API to get the necessary data for the User (who created the post) and for the referenced object (all posts reference an object in the DB - e.g a Workout).
  /// Based on [userId] via [activity.actor], and [objectId] | [objectType] via [activity.object]
  /// [ActivityWithObjectData] is what is needed to display a single post in the UI.
  static Future<List<ActivityWithObjectData>> getPostsUserAndObjectData(
      BuildContext context, List<EnrichedActivity> activities) async {
    final List<TimelinePostDataRequestInput> postDataRequests =
        activities.map((a) {
      if (a.object == null) {
        throw Exception('Error: Activity.object should never be null.');
      }
      if (a.actor == null) {
        throw Exception('Error: Activity.actor should never be null.');
      }
      final idAndType = a.object!.split(':');

      return TimelinePostDataRequestInput(
          activityId: a.id!,
          posterId: a.actor!.id!,
          objectId: idAndType[1],
          objectType: idAndType[0].toTimelinePostType());
    }).toList();

    /// Call API and get TimelinePostData[]
    final result = await context.graphQLStore.networkOnlyOperation<
            TimelinePostsData$Query, TimelinePostsDataArguments>(
        operation: TimelinePostsDataQuery(
            variables: TimelinePostsDataArguments(
                postDataRequests: postDataRequests)));

    if (result.hasErrors || result.data == null) {
      throw Exception(
          'getPostUserAndObjectData: Unable to retrieve full timeline posts data.');
    }

    /// [activities] and [requestedPosts] are in the same order - so we can match without going back into the [activities].
    /// Find the correct [TimelinePostData] by matching both the userId and the objectId, then add  to [ActivityWithObjectData] along with the [activity].
    return activities
        .map<ActivityWithObjectData>((activity) => ActivityWithObjectData(
            activity,
            result.data?.timelinePostsData
                .firstWhereOrNull((pd) => pd.activityId == activity.id)))
        .toList();
  }

  /// Call our API and get the data necessary to display a user avatar and name.
  /// The feed / timeline ID in getstream matches a User id in our API.
  /// eg. ["user_feed:{our_user_id}""] or ["user_timeline:{our_user_id}""]
  static Future<List<FollowWithUserAvatarData>> getFollowsWithUserData(
      BuildContext context, List<Follow> follows, List<String> userIds) async {
    /// Call API and get UserAvatarData[]
    final result = await context.graphQLStore
        .networkOnlyOperation<UserAvatars$Query, UserAvatarsArguments>(
            operation: UserAvatarsQuery(
                variables: UserAvatarsArguments(ids: userIds)));

    if (result.hasErrors || result.data == null) {
      throw Exception(
          '_getFollowsWithUserData: Unable to retrieve full user follow data.');
    }

    return follows
        .mapIndexed<FollowWithUserAvatarData>((i, follower) =>
            FollowWithUserAvatarData(
                follower,
                result.data?.userAvatars
                    .firstWhereOrNull((u) => u.id == userIds[i])))
        .toList();
  }

  static void deleteActivityById(
      BuildContext context, FlatFeed feed, String activityId) {
    context.showConfirmDeleteDialog(
        itemType: 'Post',
        message: 'This will remove the post from all timelines. Are you sure?',
        onConfirm: () {
          feed.removeActivityById(activityId).then((value) {
            context.showToast(message: 'Post deleted.');
          }).catchError((e) {
            printLog(e.toString());
            context.showToast(
                message:
                    'Sorry, there was a problem, the post could not be deleted.');
          });
        });
  }

  /// The difference between the structures of EnrichedActivity and Activty is awkward...
  /// Will also change depending if you have stored an object (a user for example) in getStream.
  /// Here we assume that no enriched data exists.
  /// [removeTime]: Set true when you are creating a new activity as it is auto-generated.
  /// [removeId]: Set true when you are creating a new activity as it is auto-generated.
  static Activity activityFromEnrichedActivity(EnrichedActivity e,
          {Map<String, dynamic> data = const {},
          bool removeTime = false,
          bool removeId = false}) =>
      Activity(
        id: removeId ? null : data['id'] as String? ?? e.id,
        // Must be [SU:id]
        actor: data['actor'] as String? ?? "SU:${(e.actor!.data as Map)['id']}",
        // Must be [ObjectType:id]
        object: data['object'] as String?,
        verb: data['verb'] as String? ?? e.verb,
        time: removeTime ? null : data['time'] as DateTime? ?? e.time,
        extraData: data['extraData'] != null
            ? Map.from(data['extraData'] as Map)
            : e.extraData,
      );
}
