import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stream_feed/stream_feed.dart';

class FollowWithUserAvatarData {
  final Follow follow;
  final UserAvatarData? userAvatarData;
  const FollowWithUserAvatarData(this.follow, this.userAvatarData);
}

enum FeedPostType { announcement, article, workout, workoutPlan, loggedWorkout }

class PostWithLikeReaction {
  final String activityId;
  final String reactionId;
  const PostWithLikeReaction({
    required this.activityId,
    required this.reactionId,
  });
}
