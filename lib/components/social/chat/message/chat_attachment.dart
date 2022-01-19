import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/custom_page_transitions.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/video/video_players.dart';
import 'package:sofie_ui/components/social/chat/media_viewers/chat_image_viewer.dart';
import 'package:sofie_ui/components/social/chat/message/stream_message_types.dart';
import 'package:sofie_ui/components/social/chat/utils.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

class ChatAttachment extends StatelessWidget {
  final Attachment attachment;
  final Alignment alignment;
  final bool isInQuotedMessage;
  const ChatAttachment(
      {Key? key,
      required this.attachment,
      required this.isInQuotedMessage,
      required this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (streamLabelToChatAttachmentType[attachment.type]) {
      case ChatAttachmentType.image:
        return ChatAttachmentImage(
          attachment: attachment,
          isInQuotedMessage: isInQuotedMessage,
          alignment: alignment,
        );
      case ChatAttachmentType.video:
        return ChatAttachmentVideo(
          attachment: attachment,
          isInQuotedMessage: isInQuotedMessage,
          alignment: alignment,
        );
      default:
        throw Exception(
            'ChatAttachment: No builder provided for ${attachment.type}');
    }
  }
}

/// Ontap will open the image in a full screen viewer.
class ChatAttachmentImage extends StatelessWidget {
  final Attachment attachment;
  final Alignment alignment;
  final bool isInQuotedMessage;

  const ChatAttachmentImage({
    Key? key,
    required this.attachment,
    required this.isInQuotedMessage,
    required this.alignment,
  }) : super(key: key);

  BorderRadius get _borderRadius => BorderRadius.circular(20);

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: MyText(
          'Image not found',
          subtext: true,
        ),
      );
    } else {
      return CachedNetworkImage(
        fit: BoxFit.fitWidth,
        imageUrl: imageUrl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final thumbOrMainUrl = getAttachmentThumbUrl(attachment);

    return isInQuotedMessage
        ? SizedBox(
            height: 50,
            child: ClipRRect(
              borderRadius: _borderRadius,
              child: _buildImage(thumbOrMainUrl),
            ),
          )
        : Align(
            alignment: alignment,
            child: OpenContainer(
                closedColor: context.theme.modalBackground,
                openColor: context.theme.background,
                closedShape:
                    RoundedRectangleBorder(borderRadius: _borderRadius),
                closedBuilder: (context, action) => FractionallySizedBox(
                      widthFactor: kChatMessageWidthFactor,
                      child: ClipRRect(
                        borderRadius: _borderRadius,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: _buildImage(thumbOrMainUrl),
                        ),
                      ),
                    ),

                /// Pass the full size image - to the viewer.
                /// If it is not there then pass the thumb.
                openBuilder: (context, action) {
                  final urlToPass = getAttachmentMainImageUrl(attachment);

                  return urlToPass != null
                      ? ChatImageViewer(
                          imageUrl: urlToPass,
                        )
                      : const MyPageScaffold(
                          navigationBar: MyNavBar(
                            middle: NavBarTitle('Something went wrong..'),
                          ),
                          child: Center(
                            child:
                                MyText('Sorry, we could not load this image.'),
                          ));
                }),
          );
  }
}

/// Ontap will open the image in a full screen viewer.
class ChatAttachmentVideo extends StatelessWidget {
  final Attachment attachment;
  final Alignment alignment;
  final bool isInQuotedMessage;

  const ChatAttachmentVideo({
    Key? key,
    required this.attachment,
    required this.isInQuotedMessage,
    required this.alignment,
  }) : super(key: key);

  /// Video url comes from a stream [Attachment.assetUrl]
  Future<void> _openFullScreenChatVideo(
      BuildContext context, String videoUrl) async {
    final controller = VideoPlayerController.network(videoUrl);
    await controller.initialize();

    final isPortrait = controller.value.aspectRatio < 1;

    if (isPortrait) {
      await Navigator.of(context).push(PortraitVideoEmergingPageRoute(
          page: PortraitFullScreenVideoPlayer(
        controller: controller,
      )));
    } else {
      await Navigator.of(context).push(LandscapeVideoRotatingPageRoute(
          page: LandscapeFullScreenVideoPlayer(
        controller: controller,
      )));
    }

    /// Dispose of the controller once user is finished.
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Utils.textNotNull(attachment.assetUrl)) {
      return Align(
        alignment: alignment,
        child: const ContentBox(
          borderRadius: 35,
          child: MyText(
            'Video not found',
            subtext: true,
          ),
        ),
      );
    }

    return isInQuotedMessage
        ? const SizedBox(
            height: 50,
            child: Icon(CupertinoIcons.tv),
          )
        : Align(
            alignment: alignment,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: GestureDetector(
                  onTap: () =>
                      _openFullScreenChatVideo(context, attachment.assetUrl!),
                  child: ContentBox(
                    backgroundColor: context.theme.modalBackground,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          CupertinoIcons.tv,
                          size: 40,
                        ),
                        SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.chevron_right,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                )),
          );
  }
}
