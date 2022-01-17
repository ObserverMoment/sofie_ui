import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/social/chat/chat_bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Message;

class MessageWidget extends StatelessWidget {
  final Alignment alignment;
  final EdgeInsets margin;
  final Message message;
  final Color color;
  final Color messageColor;
  final bool hasTail;

  const MessageWidget({
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
    final isImage = message.attachments.isNotEmpty == true &&
        message.attachments.first.type == 'image';

    if (isImage) {
      return Align(
        alignment: alignment,
        child: FractionallySizedBox(
          alignment: alignment,
          widthFactor: 0.75,
          child: MessageImage(
              color: color, message: message, messageColor: messageColor),
        ),
      );
    } else {
      return MessageText(
        alignment: alignment,
        margin: margin,
        color: color,
        message: message,
        messageColor: messageColor,
        hasTail: hasTail,
      );
    }
  }
}

class MessageImage extends StatelessWidget {
  const MessageImage({
    Key? key,
    required this.color,
    required this.message,
    required this.messageColor,
  }) : super(key: key);

  final Color color;
  final Message message;
  final Color messageColor;

  @override
  Widget build(BuildContext context) {
    if (message.text != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: color,
                child: Column(
                  children: [
                    if (message.attachments.first.file != null)
                      Image.memory(
                        message.attachments.first.file!.bytes!,
                        fit: BoxFit.fitWidth,
                      )
                    else
                      CachedNetworkImage(
                        fit: BoxFit.fitWidth,
                        imageUrl: message.attachments.first.thumbUrl ??
                            message.attachments.first.imageUrl ??
                            message.attachments.first.assetUrl!,
                      ),
                    // if (message.attachments.first.title != null)
                    //   Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: MyText(message.attachments.first.title!,
                    //           maxLines: 99, color: messageColor)),
                    // message.attachments.first.pretext != null
                    //     ? MyText(
                    //         message.attachments.first.pretext!,
                    //         maxLines: 99,
                    //       )
                    //     : Container()
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            color: color,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: message.attachments.first.thumbUrl!,
            )),
      );
    }
  }
}

class MessageText extends StatelessWidget {
  const MessageText({
    Key? key,
    required this.alignment,
    required this.margin,
    required this.color,
    required this.message,
    required this.messageColor,
    required this.hasTail,
  }) : super(key: key);

  final Alignment alignment;
  final Color color;
  final Message message;
  final Color messageColor;
  final EdgeInsets margin;
  final bool hasTail;

  @override
  Widget build(BuildContext context) {
    if (message.text?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Align(
        alignment:
            alignment, //Change this to Alignment.topRight or Alignment.topLeft
        child: CustomPaint(
          painter:
              ChatBubble(color: color, alignment: alignment, hasTail: hasTail),
          child: Container(
            margin: margin,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 4),
                    child: MyText(
                      message.text!,
                      color: messageColor,
                      maxLines: 999,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
