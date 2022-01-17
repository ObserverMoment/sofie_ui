import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart' as sofie;
import 'package:sofie_ui/components/social/chat/message_list_view.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A standalone page that can open up a one to one chat conversation.
/// [otherUserSummary] - The UserSummary of the other user. The first user is the authed user.
class OneToOneChatPage extends StatefulWidget {
  final String otherUserId;
  const OneToOneChatPage({
    Key? key,
    required this.otherUserId,
  }) : super(key: key);

  @override
  OneToOneChatPageState createState() => OneToOneChatPageState();
}

class OneToOneChatPageState extends State<OneToOneChatPage> {
  late AuthedUser _authedUser;
  late StreamChatClient _streamChatClient;
  late Channel _channel;
  Member? otherMember;
  late bool _channelReady = false;

  @override
  void initState() {
    super.initState();
    _authedUser = GetIt.I<AuthBloc>().authedUser!;
    _streamChatClient = StreamChatCore.of(context).client;

    _initGetStreamChat();
  }

  Future<void> _initGetStreamChat() async {
    try {
      /// Create / watch a channel consisting of the authed user and the 'other user.
      /// This type of channel is always just these two users. More users cannot be added.
      _channel = _streamChatClient.channel(kMessagingChannelName, extraData: {
        'members': [_authedUser.id, widget.otherUserId],
        'chatType': ChatType.friend.toString(),
      });

      await _channel.watch();

      otherMember = _channel.state!.members
          .where((m) => m.userId == widget.otherUserId)
          .toList()[0];

      setState(() => _channelReady = true);
    } catch (e) {
      printLog(e.toString());
      context.showToast(message: 'There was a problem setting up chat!');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kStandardAnimationDuration,
      child: _channelReady && otherMember != null
          ? ChannelPage(
              channel: _channel,
              otherMember: otherMember!,
            )
          : const MyPageScaffold(
              navigationBar: MyNavBar(
                middle: NavBarTitle('Loading Chat...'),
              ),
              child: LoadingCircle()),
    );
  }
}

class ChannelPage extends StatefulWidget {
  final Channel channel;
  final Member otherMember;

  const ChannelPage(
      {Key? key, required this.channel, required this.otherMember})
      : super(key: key);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  final _messageListController = MessageListController();

  @override
  Widget build(BuildContext context) {
    final displayName = widget.otherMember.user!.name;
    final avatarUri = widget.otherMember.user!.image;
    return StreamChannel(
        channel: widget.channel,
        child: CupertinoPageScaffold(
            navigationBar: MyNavBar(
              middle: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => openBottomSheetMenu(
                      context: context,
                      child: BottomSheetMenu(
                          header: BottomSheetMenuHeader(
                            name: displayName,
                            subtitle: 'Chat',
                            imageUri: avatarUri,
                          ),
                          items: [
                            BottomSheetMenuItem(
                                text: 'Block',
                                icon: CupertinoIcons.nosign,
                                onPressed: () => printLog('block')),
                            BottomSheetMenuItem(
                                text: 'Report',
                                icon: CupertinoIcons.exclamationmark_circle,
                                onPressed: () => printLog('report')),
                          ])),
                  child: MyHeaderText(displayName)),
              trailing: CupertinoButton(
                onPressed: avatarUri != null
                    ? () => openFullScreenImageViewer(context, avatarUri)
                    : null,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: sofie.UserAvatar(
                  size: 36,
                  avatarUri: avatarUri,
                ),
              ),
            ),
            child: StreamChatCore(
                client: widget.channel.client,
                child: MessageListCore(
                  messageListController: _messageListController,
                  loadingBuilder: (context) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  },
                  errorBuilder: (context, err) {
                    return const Center(
                      child: Text('Error'),
                    );
                  },
                  emptyBuilder: (context) {
                    return const Center(
                      child: Text('Nothing here...'),
                    );
                  },
                  messageListBuilder: (context, messages) => LazyLoadScrollView(
                    onStartOfPage: () async {
                      await _messageListController.paginateData!();
                    },
                    child: MessagesList(
                      messages: messages,
                    ),
                  ),
                ))));
    //     child: StreamChat(
    //       client: _streamChatClient,
    //       streamChatThemeData: generateStreamTheme(context),
    //       child: Column(
    //         children: <Widget>[
    //           Expanded(
    //             child: MessageListView(
    //               onMessageTap: (message) =>
    //                   printLog(message.toString()),
    //               messageBuilder: (context, message, messages,
    //                   defaultMessageWidget) {
    //                 return defaultMessageWidget.copyWith(
    //                   onLinkTap: (link) => printLog(link),
    //                   onMessageActions: (context, message) =>
    //                       printLog(message.toString()),
    //                   onAttachmentTap: (message, attachment) =>
    //                       printLog('View, share, save options'),
    //                   showUserAvatar: DisplayWidget.gone,
    //                   usernameBuilder: (context, message) => Padding(
    //                     padding: const EdgeInsets.only(left: 4.0),
    //                     child: MyText(
    //                       displayName,
    //                       color: Styles.primaryAccent,
    //                       size: FONTSIZE.two,
    //                       weight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ),
    //           ),
    //           const MessageInput(
    //               showCommandsButton: false, disableAttachments: true),
    //         ],
    //       ),
    //     ),
    //   ),
    // )
  }
}
