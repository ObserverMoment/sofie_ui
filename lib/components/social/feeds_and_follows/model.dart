import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stream_feed/stream_feed.dart';

class FollowWithUserAvatarData {
  final Follow follow;
  final UserAvatarData? userAvatarData;
  const FollowWithUserAvatarData(this.follow, this.userAvatarData);
}

enum FeedPostType { announcement, article, workout, workoutPlan, loggedWorkout }

// /// Return data type.
// /// Comes back in from Stream API with enriched data.
// class EnrichedActivityExtraData {
//   User? creator; // Enriched Stream User
//   StreamFeedClub?
//       club; // Enriched object from 'Club' collection on Stream servers.
//   String? title;
//   String? caption;
//   List<String> tags;
//   String? audioUrl;
//   String? imageUrl;
//   String? videoUrl;
//   String? originalPostId; // For re-posts
//   EnrichedActivityExtraData(
//       {this.creator,
//       this.club,
//       this.title,
//       this.caption,
//       required this.tags,
//       this.audioUrl,
//       this.imageUrl,
//       this.videoUrl,
//       this.originalPostId});

//   factory EnrichedActivityExtraData.fromJson(Map<String, Object?> o) =>
//       EnrichedActivityExtraData(
//           creator: o['creator'] != null
//               ? User.fromJson(o['creator']! as Map<String, dynamic>)
//               : null,
//           club: o['club'] != null
//               ? StreamFeedClub.fromJson(o['club'] as Map<String, Object?>)
//               : null,
//           title: o['title'] as String?,
//           caption: o['caption'] as String?,
//           tags: (o['tags'] != null && o['tags'] is List)
//               ? (o['tags'] as List).map((o) => o.toString()).toList()
//               : <String>[],
//           audioUrl: o['audioUrl'] as String?,
//           imageUrl: o['imageUrl'] as String?,
//           videoUrl: o['videoUrl'] as String?,
//           originalPostId: o['original_post_id'] as String?);

//   Map<String, Object> get toJson => {
//         'creator': creator?.toJson(),
//         'club': club?.toJson,
//         'title': title,
//         'caption': caption,
//         'tags': tags,
//         // Should be full urls - either Uploadcare or Stream CDNs.
//         'audioUrl': audioUrl,
//         'imageUrl': imageUrl,
//         'videoUrl': videoUrl,
//         'original_post_id': originalPostId
//       }.entries.fold<Map<String, Object>>({}, (acum, next) {
//         if (next.value != null) {
//           acum[next.key] = next.value!;
//         }
//         return acum;
//       });
// }

// class StreamFeedClub {
//   final String id;
//   final StreamFeedClubData data;
//   StreamFeedClub({required this.id, required this.data});

//   factory StreamFeedClub.fromJson(Map<String, Object?> o) => StreamFeedClub(
//       data: StreamFeedClubData.fromJson(o['data'] as Map<String, Object?>),
//       id: o['id'] as String);

//   Map<String, Object> get toJson => {
//         'id': id,
//         'data': data.toJson,
//       };
// }

// class StreamFeedClubData {
//   final String? name;
//   final String? coverImageUri;
//   StreamFeedClubData({required this.name, required this.coverImageUri});

//   factory StreamFeedClubData.fromJson(Map<String, Object?> o) =>
//       StreamFeedClubData(
//           coverImageUri: o['image'] as String?, name: o['name'] as String?);

//   Map<String, Object> get toJson => {
//         'name': name,
//         'image': coverImageUri,
//       }.entries.fold<Map<String, Object>>({}, (acum, next) {
//         if (next.value != null) {
//           acum[next.key] = next.value!;
//         }
//         return acum;
//       });
// }

// /// Create new activity data type.
// /// Use this to create a new activity. Uses refs [SU:id] etc.
// /// Refs: https://getstream.io/activity-feeds/docs/flutter-dart/collections_references/
// class ActivityExtraData {
//   /// Ref to creator in format SU:id. Generated via [client.currentUser.ref]
//   String? creator;

//   /// Ref to club generated via [client.collections.entry('club', clubId)];
//   String? club;
//   String? title;
//   String? caption;
//   List<String> tags;
//   String? audioUrl;
//   String? imageUrl;
//   String? videoUrl;
//   String? originalPostId; // For re-posts
//   ActivityExtraData(
//       {this.creator,
//       this.club,
//       this.title,
//       this.caption,
//       required this.tags,
//       this.audioUrl,
//       this.imageUrl,
//       this.videoUrl,
//       this.originalPostId});

//   factory ActivityExtraData.fromJson(Map<String, Object?> o) =>
//       ActivityExtraData(
//           creator: o['creator'] as String?,
//           club: o['club'] as String?,
//           title: o['title'] as String?,
//           caption: o['caption'] as String?,
//           tags: (o['tags'] != null && o['tags'] is List)
//               ? (o['tags'] as List).map((o) => o.toString()).toList()
//               : <String>[],
//           audioUrl: o['audioUrl'] as String?,
//           imageUrl: o['imageUrl'] as String?,
//           videoUrl: o['videoUrl'] as String?,
//           originalPostId: o['original_post_id'] as String?);

//   Map<String, Object> get toJson => {
//         'creator': creator,
//         'club': club,
//         'title': title,
//         'caption': caption,
//         'tags': tags,
//         // Should be full urls - either Uploadcare or Stream CDNs.
//         'audioUrl': audioUrl,
//         'imageUrl': imageUrl,
//         'videoUrl': videoUrl,
//         'original_post_id': originalPostId
//       }.entries.fold<Map<String, Object>>({}, (acum, next) {
//         if (next.value != null) {
//           acum[next.key] = next.value!;
//         }
//         return acum;
//       });
// }
