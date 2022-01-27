import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/social/chat/message/chat_attachment.dart';
import 'package:sofie_ui/components/social/chat/message/stream_message_types.dart';
import 'package:sofie_ui/components/social/chat/message/utils.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class ChatQuotedMessage extends StatelessWidget {
  final Message quotedMessage;
  final Alignment alignment;
  final MainAxisSize mainAxisSize;

  /// Only pass this when user is replying to this message. i.e. above the [ChatMessageInput].
  final VoidCallback? clearQuotedMessage;
  final double containerHeight;

  /// If the user is replying to this message then it should display full width above the message input. Otherwise 0.75 of the screen.
  final bool forInputDisplay;
  const ChatQuotedMessage(
      {Key? key,
      required this.quotedMessage,
      required this.alignment,
      this.clearQuotedMessage,
      required this.mainAxisSize,
      this.containerHeight = 50.0,
      required this.forInputDisplay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quotedMessage.isDeleted) {
      return Align(
        alignment: alignment,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: MyText(
            'Quoted message deleted...',
            subtext: true,
            size: FONTSIZE.two,
          ),
        ),
      );
    }

    final sharedContentType = quotedMessage.extraData[kSharedContentTypeField];

    final messageType = sharedContentType != null
        ? streamLabelToChatMessageType[sharedContentType]
        : null;

    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: forInputDisplay ? 1 : kChatMessageWidthFactor,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: context.theme.cardBackground,
              borderRadius: BorderRadius.circular(8)),
          height: containerHeight,
          child: Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(width: 5, color: Styles.primaryAccent),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyText(
                              quotedMessage.user?.name ?? '',
                              weight: FontWeight.bold,
                              subtext: true,
                            ),
                            if (messageType != null)
                              Row(
                                children: [
                                  Icon(
                                    getChatMessageIconData(messageType),
                                    size: 13,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  MyText(
                                    quotedMessage
                                            .extraData[kSharedContentNameField]
                                            ?.toString() ??
                                        '...',
                                    subtext: true,
                                  ),
                                ],
                              ),
                            if (Utils.textNotNull(quotedMessage.text))
                              MyText(
                                quotedMessage.text!,
                                subtext: true,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (quotedMessage.attachments.isNotEmpty ||
                  clearQuotedMessage != null)
                Row(
                  children: [
                    if (quotedMessage.attachments.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                              height: containerHeight - 8,
                              width: containerHeight - 12,
                              child: ChatAttachment(
                                  attachment: quotedMessage.attachments.first,
                                  isInQuotedMessage: true,
                                  alignment: alignment)),
                        ),
                      ),
                    if (clearQuotedMessage != null)
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: clearQuotedMessage,
                        child: const Icon(
                          CupertinoIcons.clear_circled,
                          color: Styles.primaryAccent,
                        ),
                      )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
