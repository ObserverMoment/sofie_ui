import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stream_feed/stream_feed.dart';

/// TODO: Deprecate!
class ActivityWithObjectData {
  final EnrichedActivity activity;
  final TimelinePostObjectData? objectData;
  const ActivityWithObjectData(this.activity, this.objectData);
}

/// TODO: Deprecate!
class FollowWithUserAvatarData {
  final Follow follow;
  final UserAvatarData? userAvatarData;
  const FollowWithUserAvatarData(this.follow, this.userAvatarData);
}

enum FeedPostType {
  announcement,
  article,
  video,
  workout,
  workoutPlan,
  loggedWorkout
}

class ActivityExtraData {
  String? posterId;
  String? posterName;
  String? avatarUri;
  String? objectId;
  String? objectName;
  String? creatorId;
  String? creatorName;
  String? clubId;
  String? clubName;
  String? caption;
  List<String> tags;
  String? audioUrl;
  String? imageUrl;
  String? videoUrl;
  String? originalPostId; // For re-posts
  ActivityExtraData(
      {required this.posterId,
      required this.posterName,
      this.avatarUri, // Can be either a user avatar or a club avatar.
      this.objectId,
      this.objectName,
      this.creatorId,
      this.creatorName,
      this.clubId,
      this.clubName,
      this.caption,
      required this.tags,
      this.audioUrl,
      this.imageUrl,
      this.videoUrl,
      this.originalPostId});

  factory ActivityExtraData.fromJson(Map<String, Object?> o) =>
      ActivityExtraData(
          posterId: o['posterId'] as String?,
          posterName: o['posterName'] as String?,
          avatarUri: o['avatarUri'] as String?,
          objectId: o['objectId'] as String?,
          objectName: o['objectName'] as String?,
          creatorId: o['creatorId'] as String?,
          creatorName: o['creatorName'] as String?,
          clubId: o['clubId'] as String?,
          clubName: o['clubName'] as String?,
          caption: o['caption'] as String?,
          tags: (o['tags'] != null && o['tags'] is List)
              ? (o['tags'] as List).map((o) => o.toString()).toList()
              : <String>[],
          audioUrl: o['audioUrl'] as String?,
          imageUrl: o['imageUrl'] as String?,
          videoUrl: o['videoUrl'] as String?,
          originalPostId: o['original_post_id'] as String?);

  Map<String, Object> get toJson => {
        'posterId': posterId,
        'posterName': posterName,
        'avatarUri': avatarUri,
        'objectId': objectId,
        'objectName': objectName,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'clubId': clubId,
        'clubName': clubName,
        'caption': caption,
        'tags': tags,
        // Should be full urls - either Uploadcare or Stream CDNs.
        'audioUrl': audioUrl,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'original_post_id': originalPostId
      }.entries.fold<Map<String, Object>>({}, (acum, next) {
        if (next.value != null) {
          acum[next.key] = next.value!;
        }
        return acum;
      });
}
