import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/video/file_video_player.dart';
import 'package:sofie_ui/components/social/chat/message/stream_message_types.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class AttachmentCaptionInputPage extends StatelessWidget {
  final File file;
  final ChatAttachmentType attachmentType;
  final TextEditingController captionController;
  final VoidCallback sendMessage;
  const AttachmentCaptionInputPage(
      {Key? key,
      required this.attachmentType,
      required this.captionController,
      required this.sendMessage,
      required this.file})
      : super(key: key);

  void _sendMessageAndPop(BuildContext context) {
    context.pop();
    sendMessage();
  }

  Widget _buildMediaPreview() {
    switch (attachmentType) {
      case ChatAttachmentType.audio:
        return const MyText('Audio preview');
      case ChatAttachmentType.image:
        return PhotoView(imageProvider: FileImage(file));
      case ChatAttachmentType.video:
        return FileVideoPlayer(
          file: file,
        );
      default:
        throw Exception(
            'AttachmentCaptionInputPage._buildMediaPreview: No builder provided for $attachmentType');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
          child: Stack(
        children: [
          _buildMediaPreview(),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularBox(
                padding: const EdgeInsets.all(2.0),
                color: Styles.black.withOpacity(0.5),
                child: IconButton(
                  iconData: CupertinoIcons.clear,
                  onPressed: context.pop,
                  iconColor: Styles.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ContentBox(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              borderRadius: 0,
              child: Row(
                children: [
                  Expanded(
                      child: CupertinoTextField(
                    controller: captionController,
                    maxLines: 10,
                    minLines: 1,
                    onSubmitted: (input) => sendMessage(),
                    placeholder: 'Add a caption...',
                    decoration: BoxDecoration(
                      color: context.theme.background,
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    suffixMode: OverlayVisibilityMode.editing,
                  )),
                  const SizedBox(width: 8),
                  CupertinoButton(
                      onPressed: () => _sendMessageAndPop(context),
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.paperplane_fill,
                        color: Styles.primaryAccent,
                      )),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
