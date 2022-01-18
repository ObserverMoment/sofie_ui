import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/social/chat/utils.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:cached_network_image/src/cached_image_widget.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Attachment, AttachmentFile, Message, StreamChannel;

class MessageInput extends StatefulWidget {
  final Message? quotedMessage;
  final VoidCallback clearQuotedMessage;
  final VoidCallback onNewImageSent;
  final FocusNode focusNode;
  const MessageInput({
    Key? key,
    this.quotedMessage,
    required this.clearQuotedMessage,
    required this.onNewImageSent,
    required this.focusNode,
  }) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _textController = TextEditingController();
  final _picker = ImagePicker();
  bool _sendingMessage = false;

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      setState(() {});
    });
  }

  /// Pick content to share.
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await (_picker.pickImage(source: source));
    if (pickedFile == null) {
      return;
    }
    final bytes = await File(pickedFile.path).readAsBytes();
    final attachment = Attachment(
      type: ChatMessageAttachmentType.image.string,
      file: AttachmentFile(
        bytes: bytes,
        path: pickedFile.path,
        size: bytes.length,
      ),
    );

    await _sendMessage(ChatMessageType type, input: _textController.text, attachment: attachment);
  }

  Future<void> _pickVideo() async {
    final pickedFile = await (_picker.pickVideo(source: ImageSource.gallery));
    if (pickedFile == null) {
      return;
    }
    final bytes = await File(pickedFile.path).readAsBytes();
    final attachment = Attachment(
      type: ChatMessageAttachmentType.video.string,
      file: AttachmentFile(
        bytes: bytes,
        path: pickedFile.path,
        size: bytes.length,
      ),
    );

    await _sendMessage(input: _textController.text, attachment: attachment);
  }

  Future<void> _pickWorkout() async {
    context.navigateTo(YourWorkoutsRoute(
        pageTitle: 'Select Workout',
        showCreateButton: false,
        selectWorkout: (workout) async {
;

          await _sendMessage(
              input: _textController.text);
        }));
  }

  Future<void> _pickWorkoutPlan() async {
    context.navigateTo(YourPlansRoute(
        pageTitle: 'Select Plan',
        showCreateButton: false,
        selectPlan: (plan) async {
          final attachment = Attachment(
              type: ChatMessageAttachmentType.workoutPlan.string,
              title: plan.id,
              text: plan.name);

          await _sendMessage(
              input: _textController.text, attachment: attachment);
        }));
  }

  Future<void> _pickClub() async {
    /// TODO:
    print('not implemented');
  }

  Future<void> _pickLoggedWorkout() async {
    /// TODO:
    print('not implemented');
  }

  Future<void> _sendMessage(
      {required String input, Attachment? attachment}) async {
    final streamChannel = StreamChannel.of(context);

    setState(() {
      _sendingMessage = true;
    });

    await streamChannel.channel.sendMessage(Message(
        text: input.trim(),
        type: /// TODO: regular, audio, video, workout, - create new enum.
        quotedMessageId:
            widget.quotedMessage != null ? widget.quotedMessage!.id : null,
        attachments: attachment != null ? [attachment] : []));

    setState(() {
      _sendingMessage = false;
    });

    widget.onNewImageSent();
  }

  double get _containerHeight => 50.0;

  @override
  Widget build(BuildContext context) {
    final isImage = widget.quotedMessage != null
        ? isImageMessage(widget.quotedMessage!)
        : false;

    final imageUrl = isImage
        ? getAttachmentThumbUrl(widget.quotedMessage!.attachments.first)
        : null;

    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
        child: Column(
          children: [
            GrowInOut(
              show: widget.quotedMessage != null,
              child: Container(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyText(
                            widget.quotedMessage?.user?.name ?? '',
                            weight: FontWeight.bold,
                          ),
                          MyText(isImage
                              ? 'On ${widget.quotedMessage!.createdAt.dateAndTime}'
                              : widget.quotedMessage?.text ?? ''),
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: widget.clearQuotedMessage,
                      child: const Icon(
                        CupertinoIcons.clear_circled,
                        color: Styles.primaryAccent,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                    width: 40,
                    height: 40,
                    child: AnimatedSwitcher(
                      duration: kStandardAnimationDuration,
                      child: _sendingMessage
                          ? const CupertinoActivityIndicator()
                          : GestureDetector(
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
                                            icon:
                                                CupertinoIcons.calendar_today),
                                        BottomSheetMenuItem(
                                            onPressed: _pickClub,
                                            text: 'Club',
                                            icon: MyCustomIcons.clubsIcon),
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
                                            onPressed: () =>
                                                _pickImage(ImageSource.camera),
                                            text: 'Photo from Camera',
                                            icon: CupertinoIcons.camera),
                                        BottomSheetMenuItem(
                                            onPressed: _pickVideo,
                                            text: 'Video from Gallery',
                                            icon: CupertinoIcons.video_camera),
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
                    )),
                Expanded(
                  child: CupertinoTextField(
                    focusNode: widget.focusNode,
                    controller: _textController,
                    maxLines: 10,
                    minLines: 1,
                    onSubmitted: (input) async {
                      await _sendMessage(input: input);
                    },
                    placeholder: '',
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    suffixMode: OverlayVisibilityMode.editing,
                    suffix: GestureDetector(
                      onTap: () async {
                        if (_textController.value.text.isNotEmpty) {
                          await _sendMessage(input: _textController.value.text);
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
