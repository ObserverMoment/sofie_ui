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

/// Comes back in from Stream API with enriched data.
class EnrichedActivityExtraData {
  User? creator; // Enriched Stream User
  String? clubId;
  String? title;
  String? caption;
  List<String> tags;
  String? audioUrl;
  String? imageUrl;
  String? videoUrl;
  String? originalPostId; // For re-posts
  EnrichedActivityExtraData(
      {this.creator,
      this.clubId,
      this.title,
      this.caption,
      required this.tags,
      this.audioUrl,
      this.imageUrl,
      this.videoUrl,
      this.originalPostId});

  factory EnrichedActivityExtraData.fromJson(Map<String, Object?> o) =>
      EnrichedActivityExtraData(
          creator: o['creator'] != null
              ? User.fromJson(o['creator']! as Map<String, dynamic>)
              : null,
          clubId: o['clubId'] as String?,
          title: o['title'] as String?,
          caption: o['caption'] as String?,
          tags: (o['tags'] != null && o['tags'] is List)
              ? (o['tags'] as List).map((o) => o.toString()).toList()
              : <String>[],
          audioUrl: o['audioUrl'] as String?,
          imageUrl: o['imageUrl'] as String?,
          videoUrl: o['videoUrl'] as String?,
          originalPostId: o['original_post_id'] as String?);

  Map<String, Object> get toJson => {
        'creator': creator?.toJson(),
        'clubId': clubId,
        'title': title,
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

/// Use this to create a new activity. Uses refs [SU:id] etc.
class ActivityExtraData {
  String? creator; // Ref to creator in format SU:id
  String? clubId;
  String? title;
  String? caption;
  List<String> tags;
  String? audioUrl;
  String? imageUrl;
  String? videoUrl;
  String? originalPostId; // For re-posts
  ActivityExtraData(
      {this.creator,
      this.clubId,
      this.title,
      this.caption,
      required this.tags,
      this.audioUrl,
      this.imageUrl,
      this.videoUrl,
      this.originalPostId});

  factory ActivityExtraData.fromJson(Map<String, Object?> o) =>
      ActivityExtraData(
          creator: o['creator'] as String?,
          clubId: o['clubId'] as String?,
          title: o['title'] as String?,
          caption: o['caption'] as String?,
          tags: (o['tags'] != null && o['tags'] is List)
              ? (o['tags'] as List).map((o) => o.toString()).toList()
              : <String>[],
          audioUrl: o['audioUrl'] as String?,
          imageUrl: o['imageUrl'] as String?,
          videoUrl: o['videoUrl'] as String?,
          originalPostId: o['original_post_id'] as String?);

  Map<String, Object> get toJson => {
        'creator': creator,
        'clubId': clubId,
        'title': title,
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
