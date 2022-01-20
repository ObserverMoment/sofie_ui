import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/social/chat/message/stream_message_types.dart';

IconData getChatMessageIconData(ChatMessageType type) {
  switch (type) {
    case ChatMessageType.workout:
      return MyCustomIcons.dumbbell;
    case ChatMessageType.workoutPlan:
      return CupertinoIcons.calendar_today;
    case ChatMessageType.club:
      return MyCustomIcons.clubsIcon;
    case ChatMessageType.loggedWorkout:
      return MyCustomIcons.plansIcon;
    default:
      throw Exception('getChatMessageIconData: No builder provided for $type');
  }
}

String getSharedContentTypeHeaderDisplay(ChatMessageType type) {
  switch (type) {
    case ChatMessageType.workout:
      return 'Workout';
    case ChatMessageType.workoutPlan:
      return 'Plan';
    case ChatMessageType.club:
      return 'Club';
    case ChatMessageType.loggedWorkout:
      return 'Log';
    default:
      throw Exception(
          'getSharedContentTypeHeaderDisplay: No builder provided for $type');
  }
}
