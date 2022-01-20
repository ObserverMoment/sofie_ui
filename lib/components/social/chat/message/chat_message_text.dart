import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/social/chat/message/chat_bubble.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatMessageText extends StatelessWidget {
  const ChatMessageText({
    Key? key,
    required this.alignment,
    required this.margin,
    required this.color,
    required this.message,
    required this.messageColor,
    required this.hasTail,
    required this.isQuotedMessage,
  }) : super(key: key);

  final Alignment alignment;
  final Color color;
  final Message message;
  final Color messageColor;
  final EdgeInsets margin;
  final bool isQuotedMessage;
  final bool hasTail;

  @override
  Widget build(BuildContext context) {
    if (message.text?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Align(
        alignment: alignment,
        child: CustomPaint(
          painter:
              ChatBubble(color: color, alignment: alignment, hasTail: hasTail),
          child: Container(
            margin: margin,
            child: Column(
              children: [
                if (isQuotedMessage)
                  MyText(
                    message.user?.name ?? '',
                    size: FONTSIZE.one,
                    subtext: true,
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.65,
                      ),
                      child: MyText(
                        isQuotedMessage ? '"${message.text!}"' : message.text!,
                        color: messageColor,
                        maxLines: 99,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
