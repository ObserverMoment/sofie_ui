import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/chat/message/chat_message.dart';
import 'package:sofie_ui/components/social/chat/message/chat_message_input.dart';
import 'package:sofie_ui/components/social/chat/swipe_to_reply.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/components/social/chat/message_header.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Message, StreamChatCore;

class MessagesList extends StatefulWidget {
  final List<Message>? messages;
  final bool isGroupChat;
  const MessagesList({Key? key, this.messages, required this.isGroupChat})
      : super(key: key);

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  Message? _quotedMessage;
  late FocusNode _inputFocusNode;

  final _scrollController = ScrollController();

  bool _showBackToBottomButton = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!_showBackToBottomButton &&
          _scrollController.positions.isNotEmpty &&
          _scrollController.position.pixels > 1000) {
        setState(() => _showBackToBottomButton = true);
      }
      if (_showBackToBottomButton &&
          _scrollController.positions.isNotEmpty &&
          _scrollController.position.pixels <= 1000) {
        setState(() => _showBackToBottomButton = false);
      }
    });

    _inputFocusNode = FocusNode();
  }

  Future<void> _copyMessageToClipboard(String messageText) async {
    await Clipboard.setData(ClipboardData(text: messageText));
    context.showToast(message: "Copied to clipboard");
  }

  Future<void> _replyToMessage(Message message) async {
    _inputFocusNode.requestFocus();
    setState(() {
      _quotedMessage = message;
    });
  }

  void _onNewMessageSent() {
    setState(() {
      _quotedMessage = null;
    });
    _scrollToEndOfMessages();
  }

  void _scrollToEndOfMessages() => _scrollController.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );

  Future<void> _deleteMessage(Message message) async {
    StreamChatCore.of(context).client.deleteMessage(message.id);
  }

  @override
  Widget build(BuildContext context) {
    final entries = groupBy(widget.messages!,
            (Message message) => message.createdAt.toString().substring(0, 10))
        .entries
        .toList();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Align(
                      alignment: FractionalOffset.topCenter,
                      child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 14.0, 8.0, 2.0),
                                  child: MessageHeader(
                                      rawTimeStamp: entries[index].key), //date
                                ),
                                ...entries[index]
                                    .value //messages
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) {
                                        final message = entry.value;
                                        final isFinalMessage = 0 == entry.key;
                                        final ownMessage =
                                            isOwnMessage(message, context);

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: GestureDetector(
                                            onLongPress: () =>
                                                openBottomSheetMenu(
                                                    context: context,
                                                    child: BottomSheetMenu(
                                                      items: [
                                                        BottomSheetMenuItem(
                                                            onPressed: () =>
                                                                _replyToMessage(
                                                                    message),
                                                            text: 'Reply'),
                                                        if (Utils.textNotNull(
                                                            message.text))
                                                          BottomSheetMenuItem(
                                                              onPressed: () =>
                                                                  _copyMessageToClipboard(
                                                                      message
                                                                          .text!),
                                                              text:
                                                                  'Copy Text'),
                                                        if (ownMessage)
                                                          BottomSheetMenuItem(
                                                              isDestructive:
                                                                  true,
                                                              onPressed: () =>
                                                                  _deleteMessage(
                                                                      message),
                                                              text:
                                                                  'Delete Message'),
                                                      ],
                                                    )),
                                            child: SwipeToReply(
                                              onSwipe: () =>
                                                  _replyToMessage(message),
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4),
                                                  child: (ownMessage)
                                                      ? ChatMessage(
                                                          alignment: Alignment
                                                              .topRight,
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  14.0,
                                                                  8.0,
                                                                  22.0,
                                                                  8.0),
                                                          color: Styles
                                                              .primaryAccent,
                                                          messageColor:
                                                              CupertinoColors
                                                                  .white,
                                                          message: message,
                                                          hasTail:
                                                              isFinalMessage,
                                                          showSenderName: false,
                                                        )
                                                      : ChatMessage(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  22.0,
                                                                  8.0,
                                                                  14.0,
                                                                  8.0),
                                                          color: context.theme
                                                              .cardBackground,
                                                          messageColor: context
                                                              .theme.primary,
                                                          message: message,
                                                          hasTail:
                                                              isFinalMessage,
                                                          showSenderName: widget
                                                              .isGroupChat,
                                                        )),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    .toList()
                                    .reversed,
                              ],
                            );
                          }),
                    )),
              ),
              ChatMessageInput(
                quotedMessage: _quotedMessage,
                clearQuotedMessage: () => setState(() => _quotedMessage = null),
                onNewMessageSent: _onNewMessageSent,
                focusNode: _inputFocusNode,
              )
            ],
          ),
        ),
        if (_showBackToBottomButton)
          Positioned(
              right: 0,
              bottom: 90,
              child: FadeInUp(
                child: ContentBox(
                  padding: const EdgeInsets.all(4),
                  child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.chevron_down_circle,
                        size: 30,
                      ),
                      onPressed: _scrollToEndOfMessages),
                ),
              )),
      ],
    );
  }

  bool isOwnMessage(Message message, BuildContext context) {
    final currentUserId = StreamChatCore.of(context).currentUser!.id;
    return message.user!.id == currentUserId;
  }

  bool isSameDay(Message message) =>
      message.createdAt.day == DateTime.now().day;
}
