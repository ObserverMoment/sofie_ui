import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/chat/chat_bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sofie_ui/components/social/chat/chat_image_viewer.dart';
import 'package:sofie_ui/components/social/chat/utils.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Message;
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

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

  String get quotedMessageText => message.quotedMessage?.text ?? '';

  Widget _buildQuotedMessage(
      BuildContext context, ChatMessageAttachmentType? type) {
    final quotedMessage = message.quotedMessage!;
    switch (type) {
      case null:
        // No attachment is a standard text message.
        return MessageText(
          alignment: alignment,
          margin: margin,
          color: color,
          message: message,
          messageColor: messageColor,
          isQuotedMessage: false,
          hasTail: hasTail,
        );
      case ChatMessageAttachmentType.audio:
        return MyText('Audio - TODO');
      case ChatMessageAttachmentType.image:
        return FractionallySizedBox(
          alignment: alignment,
          widthFactor: 0.75,
          child: MessageImage(
            color: color,
            message: message.quotedMessage!,
            messageColor: messageColor,
            isQuotedMessage: true,
          ),
        );
      case ChatMessageAttachmentType.video:
        return MyText('Video - TODO');
      case ChatMessageAttachmentType.workout:
        return MyText('Workout - TODO');
      case ChatMessageAttachmentType.workoutPlan:
        return MyText('Plan - TODO');
      case ChatMessageAttachmentType.club:
        return MyText('Club - TODO');
      case ChatMessageAttachmentType.loggedWorkout:
        return MyText('Log - TODO');
      default:
        throw Exception(
            'MessageWidget._buildQuotedMessage: No builder provided for $type');
    }
  }

  Widget _buildMainMessage(ChatMessageAttachmentType? type) {
    switch (type) {
      case null:
        // No attachment is a standard text message.
        return MessageText(
          alignment: alignment,
          margin: margin,
          color: color,
          message: message,
          messageColor: messageColor,
          isQuotedMessage: false,
          hasTail: hasTail,
        );
      case ChatMessageAttachmentType.audio:
        return MyText('Audio - TODO');
      case ChatMessageAttachmentType.image:
        return FractionallySizedBox(
          alignment: alignment,
          widthFactor: 0.75,
          child: MessageImage(
            color: color,
            message: message,
            messageColor: messageColor,
            isQuotedMessage: false,
          ),
        );
      case ChatMessageAttachmentType.video:
        return MyText('Video - TODO');
      case ChatMessageAttachmentType.workout:
        return MyText('Workout - TODO');
      case ChatMessageAttachmentType.workoutPlan:
        return MyText('Plan - TODO');
      case ChatMessageAttachmentType.club:
        return MyText('Club - TODO');
      case ChatMessageAttachmentType.loggedWorkout:
        return MyText('Log - TODO');
      default:
        throw Exception(
            'MessageWidget._buildMainMessage: No builder provided for $type');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.isDeleted) {
      return Align(
        alignment: alignment,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: MyText(
            'This message was deleted',
            subtext: true,
            size: FONTSIZE.two,
          ),
        ),
      );
    }

    /// Get the attachment type - if any.
    final type = message.attachments.isNotEmpty
        ? message.attachments.first.type!.toChatMessageAttachmentType()
        : null;

    print(type);

    return Align(
      alignment: alignment,
      child: Column(
        children: [
          if (message.quotedMessage != null) _buildQuotedMessage(context, type),
          _buildMainMessage(type)
        ],
      ),
    );

    // return message.isDeleted
    //     ? Align(
    //         alignment: alignment,
    //         child: const Padding(
    //           padding: EdgeInsets.all(8.0),
    //           child: MyText(
    //             'This message was deleted',
    //             subtext: true,
    //             size: FONTSIZE.two,
    //           ),
    //         ),
    //       )
    //     : Column(
    //         children: [
    //           if (quotedMessage != null)
    //             quotedMessageIsImage
    //                 ? Align(
    //                     alignment: alignment,
    //                     child: FractionallySizedBox(
    //                       alignment: alignment,
    //                       widthFactor: 0.75,
    //                       child: MessageImage(
    //                         color: color,
    //                         message: quotedMessage,
    //                         messageColor: messageColor,
    //                         isQuotedMessage: true,
    //                       ),
    //                     ),
    //                   )
    //                 : MessageText(
    //                     alignment: alignment,
    //                     margin: margin,
    //                     color: context.theme.cardBackground,
    //                     message: message.quotedMessage!,
    //                     messageColor: context.theme.primary,
    //                     isQuotedMessage: true,
    //                     hasTail: false,
    //                   ),
    //           if (isImage)
    //             Align(
    //               alignment: alignment,
    //               child: FractionallySizedBox(
    //                 alignment: alignment,
    //                 widthFactor: 0.75,
    //                 child: MessageImage(
    //                   color: color,
    //                   message: message,
    //                   messageColor: messageColor,
    //                   isQuotedMessage: false,
    //                 ),
    //               ),
    //             )
    //           else
    //             MessageText(
    //               alignment: alignment,
    //               margin: margin,
    //               color: color,
    //               message: message,
    //               messageColor: messageColor,
    //               isQuotedMessage: false,
    //               hasTail: hasTail,
    //             )
    //         ],
    //       );
  }
}

/// Ontap will open the image in a full screen viewer.
class MessageImage extends StatelessWidget {
  const MessageImage({
    Key? key,
    required this.color,
    required this.message,
    required this.messageColor,
    required this.isQuotedMessage,
  }) : super(key: key);

  final Color color;
  final Message message;
  final Color messageColor;
  final bool isQuotedMessage;

  BorderRadius get _borderRadius => BorderRadius.circular(20);
  double get _containerHeight => 50.0;

  Widget _buildQuotedMessageImage(BuildContext context) {
    final imageUrl = getAttachmentThumbUrl(message.attachments.first);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: context.theme.modalBackground,
          borderRadius: BorderRadius.circular(8)),
      height: _containerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: 6, color: Styles.primaryAccent),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyText(
                  message.user?.name ?? '',
                  weight: FontWeight.bold,
                ),
                MyText('On ${message.createdAt.dateAndTime}'),
              ],
            ),
          )),
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: _containerHeight - 8,
                width: _containerHeight - 12,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageUrl,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final thumbOrMainUrl = getAttachmentThumbUrl(message.attachments.first);

    if (isQuotedMessage) {
      return _buildQuotedMessageImage(context);
    }

    return OpenContainer(
        closedColor: color,
        openColor: context.theme.background,
        closedShape: RoundedRectangleBorder(borderRadius: _borderRadius),
        closedBuilder: (context, action) => (message.text != null)
            ? Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  children: [
                    if (thumbOrMainUrl != null)
                      ClipRRect(
                        borderRadius: _borderRadius,
                        child: Container(
                          color: color,
                          child: Column(
                            children: [
                              // if (message.attachments.first.file != null)
                              //   Image.memory(
                              //     message.attachments.first.file!.bytes!,
                              //     fit: BoxFit.fitWidth,
                              //   )
                              // else
                              CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                imageUrl: thumbOrMainUrl,
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
              )
            : ClipRRect(
                borderRadius: _borderRadius,
                child: Container(
                    color: color,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: message.attachments.first.thumbUrl!,
                    )),
              ),

        /// Pass the full size image - to the viewer.
        /// If it is not there then pass the thumb.
        openBuilder: (context, action) {
          final urlToPass =
              getAttachmentMainImageUrl(message.attachments.first);

          return urlToPass != null
              ? ChatImageViewer(
                  imageUrl: urlToPass,
                )
              : const MyPageScaffold(
                  navigationBar: MyNavBar(
                    middle: NavBarTitle('Something went wrong..'),
                  ),
                  child: Center(
                    child: MyText('Sorry, we could not load this image.'),
                  ));
        });
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4),
                        child: MyText(
                          isQuotedMessage
                              ? '"${message.text!}"'
                              : message.text!,
                          color: messageColor,
                          maxLines: 999,
                        ),
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
