import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/social/chat/message/chat_bubble.dart';
import 'package:sofie_ui/components/social/chat/message/stream_message_types.dart';
import 'package:sofie_ui/components/social/chat/message/utils.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class ChatMessageSharedContent extends StatelessWidget {
  final Alignment alignment;
  final String objectId;
  final String name;
  final ChatMessageType type;
  final EdgeInsets margin;
  final bool hasTail;
  const ChatMessageSharedContent(
      {Key? key,
      required this.alignment,
      required this.name,
      required this.objectId,
      required this.type,
      required this.margin,
      required this.hasTail})
      : super(key: key);

  void _navigateToSharedContent(BuildContext context) {
    switch (type) {
      case ChatMessageType.workout:
        context.navigateTo(WorkoutDetailsRoute(id: objectId));
        break;
      case ChatMessageType.workoutPlan:
        context.navigateTo(WorkoutPlanDetailsRoute(id: objectId));
        break;
      case ChatMessageType.loggedWorkout:
        context.navigateTo(LoggedWorkoutDetailsRoute(id: objectId));
        break;
      default:
        throw Exception(
            'ChatMessageSharedContent._navigateToSharedContent: No method provided for $type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.primary;
    final contentColor = context.theme.background;
    return Align(
        alignment: alignment,
        child: FractionallySizedBox(
          widthFactor: kChatMessageWidthFactor,
          child: GestureDetector(
            onTap: () => _navigateToSharedContent(context),
            behavior: HitTestBehavior.opaque,
            child: CustomPaint(
              painter: ChatBubble(
                  color: backgroundColor,
                  alignment: alignment,
                  hasTail: hasTail),
              child: Padding(
                padding: margin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              getChatMessageIconData(type),
                              size: 13,
                              color: contentColor,
                            ),
                            const SizedBox(width: 4),
                            MyHeaderText(
                              getSharedContentTypeHeaderDisplay(type),
                              size: FONTSIZE.one,
                              color: contentColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        MyHeaderText(
                          name,
                          color: contentColor,
                          maxLines: 2,
                          size: FONTSIZE.two,
                        )
                      ],
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      color: contentColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
