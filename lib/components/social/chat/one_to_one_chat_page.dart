import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/stream.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;

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
  late chat.StreamChatClient _streamChatClient;
  late chat.Channel _channel;
  String? _displayName; // Of the other person to show at the top center.
  String? _avatarUri; // Of the other person to show at the top right.
  late bool _channelReady = false;

  @override
  void initState() {
    super.initState();
    _authedUser = GetIt.I<AuthBloc>().authedUser!;
    _streamChatClient = context.streamChatClient;

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

      /// Call API and get UserAvatarData[]
      final result = await context.graphQLStore
          .networkOnlyOperation<UserAvatarById$Query, UserAvatarByIdArguments>(
              operation: UserAvatarByIdQuery(
                  variables: UserAvatarByIdArguments(id: widget.otherUserId)));

      _displayName = result.data?.userAvatarById.displayName;
      _avatarUri = result.data?.userAvatarById.avatarUri;

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
      child: _channelReady
          ? chat.StreamChannel(
              channel: _channel,
              child: CupertinoPageScaffold(
                navigationBar: MyNavBar(
                  middle: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => openBottomSheetMenu(
                          context: context,
                          child: BottomSheetMenu(
                              header: BottomSheetMenuHeader(
                                name: _displayName ?? 'Unnamed',
                                subtitle: 'Chat',
                                imageUri: _avatarUri,
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
                      child: MyHeaderText(_displayName ?? 'Unnamed')),
                  trailing: CupertinoButton(
                    onPressed: _avatarUri != null
                        ? () => openFullScreenImageViewer(context, _avatarUri!)
                        : null,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: UserAvatar(
                      size: 36,
                      avatarUri: _avatarUri,
                    ),
                  ),
                ),
                child: chat.StreamChat(
                  client: _streamChatClient,
                  streamChatThemeData: generateStreamTheme(context),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: chat.MessageListView(
                          onMessageTap: (message) =>
                              printLog(message.toString()),
                          messageBuilder: (context, message, messages,
                              defaultMessageWidget) {
                            return defaultMessageWidget.copyWith(
                              onLinkTap: (link) => printLog(link),
                              onMessageActions: (context, message) =>
                                  printLog(message.toString()),
                              onAttachmentTap: (message, attachment) =>
                                  printLog('View, share, save options'),
                              showUserAvatar: chat.DisplayWidget.gone,
                              usernameBuilder: (context, message) => Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: MyText(
                                  _displayName ?? 'Unnamed',
                                  color: Styles.primaryAccent,
                                  size: FONTSIZE.two,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const chat.MessageInput(
                          showCommandsButton: false, disableAttachments: true),
                    ],
                  ),
                ),
              ),
            )
          : const MyPageScaffold(
              navigationBar: MyNavBar(
                middle: NavBarTitle('Loading Chat...'),
              ),
              child: LoadingCircle()),
    );
  }
}
