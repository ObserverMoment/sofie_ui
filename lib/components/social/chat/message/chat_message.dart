import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/social/chat/message/chat_attachment.dart';
import 'package:sofie_ui/components/social/chat/message/chat_message_shared_content.dart';
import 'package:sofie_ui/components/social/chat/message/chat_message_text.dart';
import 'package:sofie_ui/components/social/chat/message/chat_quoted_message.dart';
import 'package:sofie_ui/components/social/chat/message/stream_message_types.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Message;

class ChatMessage extends StatelessWidget {
  final Alignment alignment;
  final EdgeInsets margin;
  final Message message;
  final Color color;
  final Color messageColor;
  final bool hasTail;

  const ChatMessage({
    Key? key,
    required this.alignment,
    required this.margin,
    required this.message,
    required this.color,
    required this.messageColor,
    this.hasTail = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.isDeleted) {
      return Align(
        alignment: alignment,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: MyText(
            'Message deleted...',
            subtext: true,
            size: FONTSIZE.two,
          ),
        ),
      );
    }

    final sharedContentType = message.extraData[kSharedContentTypeField];

    final messageType = sharedContentType != null
        ? streamLabelToChatMessageType[sharedContentType]
        : null;

    return Column(
      children: [
        if (message.quotedMessage != null)
          ChatQuotedMessage(
            quotedMessage: message.quotedMessage!,
            alignment: alignment,
            mainAxisSize: MainAxisSize.min,
            forInputDisplay: false,
          ),
        if (message.attachments.isNotEmpty)
          ...message.attachments
              .map((a) => ChatAttachment(
                    attachment: a,
                    isInQuotedMessage: false,
                    alignment: alignment,
                  ))
              .toList(),
        if (messageType != null)
          ChatMessageSharedContent(
            alignment: alignment,
            name: message.extraData[kSharedContentNameField] != null
                ? message.extraData[kSharedContentNameField].toString()
                : '...',
            objectId: message.extraData[kSharedContentIdField] != null
                ? message.extraData[kSharedContentIdField].toString()
                : '...',
            type: messageType,
            margin: margin,
            hasTail: hasTail,
          ),
        if (Utils.textNotNull(message.text))
          ChatMessageText(
              alignment: alignment,
              margin: margin,
              color: color,
              message: message,
              messageColor: messageColor,
              hasTail: hasTail,
              isQuotedMessage: false)
      ],
    );
  }
}
