import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stream_feed/stream_feed.dart';

class ActivityWithObjectData {
  final EnrichedActivity activity;
  final TimelinePostObjectData? objectData;
  const ActivityWithObjectData(this.activity, this.objectData);
}

class FollowWithUserAvatarData {
  final Follow follow;
  final UserAvatarData? userAvatarData;
  const FollowWithUserAvatarData(this.follow, this.userAvatarData);
}
