import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/social/chat/message/attachment_caption_input_page.dart';
import 'package:sofie_ui/components/social/chat/message/chat_quoted_message.dart';
import 'package:sofie_ui/components/social/chat/message/stream_message_types.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/page_transitions.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:dio/src/cancel_token.dart';

class ChatMessageInput extends StatefulWidget {
  final Message? quotedMessage;
  final VoidCallback clearQuotedMessage;
  final VoidCallback onNewMessageSent;
  final FocusNode focusNode;
  const ChatMessageInput({
    Key? key,
    this.quotedMessage,
    required this.clearQuotedMessage,
    required this.onNewMessageSent,
    required this.focusNode,
  }) : super(key: key);

  @override
  ChatMessageInputState createState() => ChatMessageInputState();
}

class ChatMessageInputState extends State<ChatMessageInput> {
  late StreamChannelState _streamChannel;
  final _textController = TextEditingController();
  final _picker = ImagePicker();

  /// Must be between 0.0 and 1.0.
  double _mediaUploadProgress = 0.0;
  bool _uploadingMedia = false;
  final CancelToken _mediaUploadCancelToken = CancelToken();

  @override
  void initState() {
    super.initState();

    _streamChannel = StreamChannel.of(context);

    _textController.addListener(() {
      setState(() {});
    });
  }

  void _setUploading(bool uploading) =>
      setState(() => _uploadingMedia = uploading);

  void _updateProgress(int count, int total) => setState(() {
        _mediaUploadProgress = (count / total).clamp(0.0, 1.0);
      });

  /// Pick content to share.
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await (_picker.pickImage(source: source));
    if (pickedFile == null) {
      return;
    }
    final file = File(pickedFile.path);

    if (mounted) {
      Navigator.of(context).push(BottomSheetAnimateInPageRoute(
          page: AttachmentCaptionInputPage(
        attachmentType: ChatAttachmentType.image,
        captionController: _textController,
        file: file,
        sendMessage: () async {
          _setUploading(true);

          final bytes = await file.readAsBytes();

          final sendImageResponse = await _streamChannel.channel.sendImage(
              AttachmentFile(
                bytes: bytes,
                path: pickedFile.path,
                size: bytes.length,
              ),
              onSendProgress: _updateProgress,
              cancelToken: _mediaUploadCancelToken);

          _setUploading(false);

          final attachment = Attachment(
            type: chatAttachmentTypeToStreamLabel[ChatAttachmentType.image],
            uploadState: const UploadState.success(),
            assetUrl: sendImageResponse.file,
          );

          await _sendMessage(Message(attachments: [attachment]));
        },
      )));
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await (_picker.pickVideo(source: ImageSource.gallery));
    if (pickedFile == null) {
      return;
    }
    final file = File(pickedFile.path);

    if (mounted) {
      Navigator.of(context).push(BottomSheetAnimateInPageRoute(
          page: AttachmentCaptionInputPage(
        attachmentType: ChatAttachmentType.video,
        captionController: _textController,
        file: file,
        sendMessage: () async {
          _setUploading(true);

          final bytes = await file.readAsBytes();

          final sendFileResponse = await _streamChannel.channel.sendFile(
              AttachmentFile(
                bytes: bytes,
                path: pickedFile.path,
                size: bytes.length,
              ),
              onSendProgress: _updateProgress,
              cancelToken: _mediaUploadCancelToken);

          _setUploading(false);

          final attachment = Attachment(
            type: chatAttachmentTypeToStreamLabel[ChatAttachmentType.video],
            uploadState: const UploadState.success(),
            assetUrl: sendFileResponse.file,
          );

          await _sendMessage(Message(attachments: [attachment]));
        },
      )));
    }
  }

  /// When sharing internal content to the chat we fill these fields in [Message.extraData] so that we can easily link to it from the messages list.
  Map<String, String?> _formatMessageExtraData(
      ChatMessageType type, String id, String name) {
    return {
      'shared-content-type': chatMessageTypeToStreamLabel[type],
      'shared-content-id': id,
      'shared-content-name': name
    };
  }

  Future<void> _pickWorkout() async {
    // context.navigateTo(WorkoutsRoute(
    //     pageTitle: 'Select Workout',
    //     showCreateButton: false,
    //     selectWorkout: (workout) async {
    //       await _sendMessage(Message(
    //           extraData: _formatMessageExtraData(
    //               ChatMessageType.workout, workout.id, workout.name)));
    //     }));
  }

  Future<void> _pickWorkoutPlan() async {
    context.navigateTo(PlansRoute(
        pageTitle: 'Select Plan',
        showCreateButton: false,
        selectPlan: (plan) async {
          await _sendMessage(Message(
              extraData: _formatMessageExtraData(
                  ChatMessageType.workoutPlan, plan.id, plan.name)));
        }));
  }

  Future<void> _pickLoggedWorkout() async {
    context.navigateTo(LoggedWorkoutsHistoryRoute(
        pageTitle: 'Select Log',
        selectLoggedWorkout: (log) async {
          await _sendMessage(Message(
              extraData: _formatMessageExtraData(
                  ChatMessageType.loggedWorkout, log.id, log.name)));
        }));
  }

  void _sendRegularMessage() {
    if (Utils.textNotNull(_textController.text)) {
      _sendMessage(Message(text: _textController.text));
    }
  }

  Future<void> _sendMessage(Message message) async {
    final msg = message.copyWith(
        text: _textController.text.trim(),
        quotedMessageId:
            widget.quotedMessage != null ? widget.quotedMessage!.id : null);

    await _streamChannel.channel.sendMessage(msg);

    widget.onNewMessageSent();

    setState(() {
      _mediaUploadProgress = 0.0;
      _textController.text = '';
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicatorWidth = MediaQuery.of(context).size.width * 0.4;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
        child: Column(
          children: [
            if (_uploadingMedia)
              FadeIn(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ContentBox(
                  borderRadius: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const MyText(
                        'UPLOADING',
                        size: FONTSIZE.one,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      LinearProgressIndicator(
                          progress: _mediaUploadProgress,
                          width: indicatorWidth),
                      const SizedBox(
                        width: 24,
                      ),
                      TextButton(
                          padding: EdgeInsets.zero,
                          text: 'Cancel',
                          destructive: true,
                          onPressed: () => _mediaUploadCancelToken.cancel())
                    ],
                  ),
                ),
              )),
            if (widget.quotedMessage != null)
              GrowIn(
                  child: ChatQuotedMessage(
                quotedMessage: widget.quotedMessage!,
                alignment: Alignment.centerLeft,
                mainAxisSize: MainAxisSize.max,
                clearQuotedMessage: widget.clearQuotedMessage,
                forInputDisplay: true,
              )),
            Row(
              children: [
                GestureDetector(
                  onTap: () => openBottomSheetMenu(
                      context: context,
                      child: BottomSheetMenu(
                          header: const BottomSheetMenuHeader(
                            name: 'Share Something...',
                          ),
                          items: [
                            BottomSheetMenuItem(
                                onPressed: _pickWorkout,
                                text: 'Workout',
                                icon: MyCustomIcons.dumbbell),
                            BottomSheetMenuItem(
                                onPressed: _pickWorkoutPlan,
                                text: 'Plan',
                                icon: CupertinoIcons.calendar_today),
                            BottomSheetMenuItem(
                                onPressed: _pickLoggedWorkout,
                                text: 'Log',
                                icon: MyCustomIcons.plansIcon),
                            BottomSheetMenuItem(
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                text: 'Photo from Gallery',
                                icon: CupertinoIcons.photo),
                            BottomSheetMenuItem(
                                onPressed: () => _pickImage(ImageSource.camera),
                                text: 'Photo from Camera',
                                icon: CupertinoIcons.camera),
                            BottomSheetMenuItem(
                                onPressed: _pickVideo,
                                text: 'Video from Gallery',
                                icon: CupertinoIcons.tv),
                          ])),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 4.0, right: 12, bottom: 4, top: 4),
                    child: Icon(
                      CupertinoIcons.add,
                      color: Styles.primaryAccent,
                      size: 28,
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoTextField(
                    focusNode: widget.focusNode,
                    controller: _textController,
                    maxLines: 10,
                    minLines: 1,
                    onSubmitted: (_) => _sendRegularMessage(),
                    placeholder: '',
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    suffixMode: OverlayVisibilityMode.editing,
                    suffix: GestureDetector(
                      onTap: () async {
                        if (_textController.value.text.isNotEmpty) {
                          _sendRegularMessage();
                          _textController.clear();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          CupertinoIcons.arrow_up_circle_fill,
                          color: context.theme.primary,
                          size: 30,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.cardBackground,
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
