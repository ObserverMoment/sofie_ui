import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';

const kDefaultFeedPostVerb = 'post';
const kDefaultClubFeedPostVerb = 'post-club';

const Map<String, FeedPostType> kStreamNameToFeedPostType = {
  'announcement': FeedPostType.announcement,
  'article': FeedPostType.article,
  'workout': FeedPostType.workout,
  'workoutPlan': FeedPostType.workoutPlan,
  'loggedWorkout': FeedPostType.loggedWorkout,
};

const Map<FeedPostType, String> kFeedPostTypeToStreamName = {
  FeedPostType.announcement: 'announcement',
  FeedPostType.article: 'article',
  FeedPostType.workout: 'workout',
  FeedPostType.workoutPlan: 'workoutPlan',
  FeedPostType.loggedWorkout: 'loggedWorkout',
};

const Map<FeedPostType, String> kFeedPostTypeToDisplay = {
  FeedPostType.announcement: 'Announcement',
  FeedPostType.article: 'Article',
  FeedPostType.workout: 'Workout',
  FeedPostType.workoutPlan: 'Plan',
  FeedPostType.loggedWorkout: 'Log',
};

class FeedUtils {
  /// Converts the Stream API's [EnrichedActivity] response objects into our own [StreamEnrichedActivity]. It will also filter out any responses that do not have the required data to display correctly.
  static List<StreamEnrichedActivity> formatStreamAPIResponse(
      List<EnrichedActivity> activities) {
    return activities
        .map((a) => formatStreamEnrichedActivity(a))
        .whereNotNull()
        .toList();
  }

  static bool checkActivityDataIsCorrect(EnrichedActivity a) {
    return !(a.id == null ||
        a.verb == null ||
        a.object == null ||
        a.time == null ||
        a.actor == null ||
        a.extraData == null);
  }

  static StreamEnrichedActivity? formatStreamEnrichedActivity(
      EnrichedActivity a) {
    if (checkActivityDataIsCorrect(a)) {
      final likes = a.reactionCounts?[kLikeReactionName] ?? 0;
      final shares = a.reactionCounts?[kShareReactionName] ?? 0;

      final reactionCounts = StreamActivityReactionCounts()
        ..likes = likes
        ..shares = shares;

      return StreamEnrichedActivity()
        ..id = a.id!
        ..verb = a.verb!
        ..object = a.object!
        ..time = a.time!
        ..reactionCounts = reactionCounts
        ..actor = formatStreamFeedUser(a.actor!)! // Should never be null!
        ..extraData = formatStreamActivityExtraData(a.extraData!);
    } else {
      return null;
    }
  }

  static StreamActivityExtraData formatStreamActivityExtraData(
      Map<String, Object?> extraData) {
    return StreamActivityExtraData()
      ..creator = extraData['creator'] != null
          ? formatStreamFeedUser(
              User.fromJson(extraData['creator'] as Map<String, dynamic>))
          : null
      ..club = extraData['club'] != null
          ? formatStreamFeedClub(CollectionEntry.fromJson(
              extraData['club'] as Map<String, dynamic>))
          : null
      ..title = extraData['title'] as String?
      ..caption = extraData['caption'] as String?
      ..tags = (extraData['tags'] != null && extraData['tags'] is List)
          ? (extraData['tags'] as List).map((o) => o.toString()).toList()
          : <String>[]
      ..articleUrl = extraData['articleUrl'] as String?
      ..audioUrl = extraData['audioUrl'] as String?
      ..imageUrl = extraData['imageUrl'] as String?
      ..videoUrl = extraData['videoUrl'] as String?
      ..originalPostId = extraData['originalPostId'] as String?;
  }

  static StreamFeedUser? formatStreamFeedUser(User user) {
    if (user.id == null || user.data == null) return null;

    final data = StreamFeedUserData()
      ..name = (user.data!['name'] as String?)
      ..image = (user.data!['image'] as String?);

    return StreamFeedUser()
      ..id = user.id!
      ..data = data;
  }

  static StreamFeedClub? formatStreamFeedClub(CollectionEntry entry) {
    /// TODO: The format of the [entry.data] object appears to have a nested data key inside it where the custom fields are being stored...seems a bit redundant so maybe we are creating the data incorrectly?
    if (entry.id == null || entry.data?['data'] == null) return null;

    final clubData = entry.data?['data'] as Map<String, dynamic>;

    final data = StreamFeedClubData()
      ..name = clubData['name'] as String?
      ..image = clubData['image'] as String?;

    return StreamFeedClub()
      ..id = entry.id!
      ..data = data;
  }

  static String getObjectTypeFromRef(String ref) => ref.split(':')[0];

  static String? getObjectIdFromRef(String ref) {
    final parts = ref.split(':');
    if (parts.length > 1) {
      return parts[1];
    } else {
      return null;
    }
  }

  static IconData getFeedSharedContentIcon(FeedPostType type) {
    switch (type) {
      case FeedPostType.workout:
        return MyCustomIcons.dumbbell;
      case FeedPostType.workoutPlan:
        return CupertinoIcons.calendar_today;
      case FeedPostType.loggedWorkout:
        return MyCustomIcons.plansIcon;
      default:
        throw Exception(
            'getFeedSharedContentIcon: No builder provided for $type');
    }
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
}
