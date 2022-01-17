import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/stream.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;

class ClubMembersChatPage extends StatefulWidget {
  final String clubId;
  const ClubMembersChatPage({Key? key, required this.clubId}) : super(key: key);

  @override
  _ClubMembersChatPageState createState() => _ClubMembersChatPageState();
}

class _ClubMembersChatPageState extends State<ClubMembersChatPage> {
  late chat.StreamChatClient _streamChatClient;
  late chat.Channel _channel;
  late bool _channelReady = false;
  late ClubChatSummary _clubChatSummary;

  chat.Message? _quotedMessage;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _streamChatClient = context.streamChatClient;

    _initGetStreamChat();
    _focusNode = FocusNode();
  }

  Future<void> _initGetStreamChat() async {
    try {
      /// Get club and club member data.
      final result = await context.graphQLStore.networkOnlyOperation<
              ClubChatSummary$Query, ClubChatSummaryArguments>(
          operation: ClubChatSummaryQuery(
              variables: ClubChatSummaryArguments(clubId: widget.clubId)));

      if (result.hasErrors || result.data == null) {
        throw Exception('Could not retrieve Club data for this chat.');
      } else {
        _clubChatSummary = result.data!.clubChatSummary;
      }

      /// Create / watch a channel consisting of the authed user and the 'other user.
      /// This type of channel is always just these two users. More users cannot be added.
      _channel =
          _streamChatClient.channel(kClubMembersChannelName, id: widget.clubId);

      await _channel.watch();

      setState(() => _channelReady = true);
    } catch (e) {
      printLog(e.toString());
      context.showToast(message: 'There was a problem setting up chat!');
    }
  }

  String _getUserNameFromStreamId(String? id) {
    if (id == null) {
      return 'Unknown';
    }
    if (_clubChatSummary.owner.id == id) {
      return '${_clubChatSummary.owner.displayName} (Owner)';
    }
    final admin = _clubChatSummary.admins.firstWhereOrNull((a) => a.id == id);
    if (admin != null) {
      return '${admin.displayName} (Admin)';
    }
    final member = _clubChatSummary.members.firstWhereOrNull((m) => m.id == id);
    if (member != null) {
      return member.displayName;
    }
    return 'Non-member';
  }

  void _reply(chat.Message message) {
    setState(() => _quotedMessage = message);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  Radius get _radiusTight => const Radius.circular(8);
  Radius get _radiusLoose => const Radius.circular(24);

  BorderRadiusGeometry get _myChatBubbleRadius => BorderRadius.only(
        topLeft: _radiusTight,
        topRight: _radiusLoose,
        bottomLeft: _radiusTight,
      );
  BorderRadiusGeometry get _otherChatBubbleRadius => BorderRadius.only(
        topLeft: _radiusLoose,
        topRight: _radiusTight,
        bottomRight: _radiusTight,
      );

  @override
  void dispose() {
    _focusNode!.dispose();
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
                  backgroundColor: context.theme.cardBackground,
                  middle: Column(
                    children: [
                      const NavBarTitle('Club Chat'),
                      MyText(
                        '${_clubChatSummary.totalMembers} members',
                        size: FONTSIZE.two,
                        subtext: true,
                        lineHeight: 1.4,
                      )
                    ],
                  ),
                  trailing: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Utils.textNotNull(_clubChatSummary.coverImageUri)
                            ? UserAvatar(
                                size: 40,
                                avatarUri: _clubChatSummary.coverImageUri,
                              )
                            : Container(
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.asset(
                                  'assets/placeholder_images/workout.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                child: chat.StreamChat(
                  client: _streamChatClient,
                  streamChatThemeData: generateStreamTheme(context),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: chat.MessageListView(
                          onMessageSwiped: _reply,
                          messageBuilder: (context, message, messages,
                              defaultMessageWidget) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FractionallySizedBox(
                                widthFactor: 0.78,
                                alignment: message.isMyMessage
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () =>
                                      showPopoverMenu(context: context, items: [
                                    PopoverMenuItem(
                                      onTap: () {},
                                      text: 'Hi there',
                                    )
                                  ]),
                                  child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: context.theme.cardBackground,
                                        borderRadius: message.isMyMessage
                                            ? _myChatBubbleRadius
                                            : _otherChatBubbleRadius,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (message.message.quotedMessage !=
                                              null)
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: context
                                                      .theme.modalBackground,
                                                  borderRadius: message
                                                          .isMyMessage
                                                      ? _myChatBubbleRadius
                                                      : _otherChatBubbleRadius,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    MyText(
                                                      _getUserNameFromStreamId(
                                                          message
                                                              .message
                                                              .quotedMessage!
                                                              .user
                                                              ?.id),
                                                      weight: FontWeight.bold,
                                                      size: FONTSIZE.two,
                                                      subtext: true,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    MyText(
                                                      message
                                                              .message
                                                              .quotedMessage!
                                                              .text ??
                                                          '...',
                                                      subtext: true,
                                                      maxLines: 999,
                                                      lineHeight: 1.4,
                                                    ),
                                                  ],
                                                )),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  _getUserNameFromStreamId(
                                                      message.message.user?.id),
                                                  weight: FontWeight.bold,
                                                  size: FONTSIZE.two,
                                                  subtext: true,
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: MyText(
                                                        message.message.text ??
                                                            '...',
                                                        maxLines: 999,
                                                        lineHeight: 1.4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            );

                            return defaultMessageWidget.copyWith(
                              showReplyMessage: false,
                              // onReplyTap: _reply,

                              // onMessageActions: (_, __) => openBottomSheetMenu(
                              //   context: context,
                              //   child: BottomSheetMenu(
                              //     items: [
                              //       BottomSheetMenuItem(
                              //         onPressed: () {},
                              //         text: 'Reply',
                              //       ),
                              //       BottomSheetMenuItem(
                              //         onPressed: () {},
                              //         isDestructive: true,
                              //         text: 'Delete',
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 12),
                              onLinkTap: (link) => printLog(link),
                              // onMessageActions: (context, message) =>
                              //     print('onMessageActions - '),
                              showUserAvatar: chat.DisplayWidget.gone,
                              usernameBuilder: (context, message) => Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: MyText(
                                  _getUserNameFromStreamId(message.user?.id),
                                  color: Styles.primaryAccent,
                                  size: FONTSIZE.two,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      chat.MessageInput(
                        showCommandsButton: false,
                        disableAttachments: true,
                        focusNode: _focusNode,
                        quotedMessage: _quotedMessage,
                        onQuotedMessageCleared: () {
                          setState(() => _quotedMessage = null);
                          _focusNode!.unfocus();
                        },
                        userMentionsTileBuilder: (context, user) => Card(
                          elevation: 1,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          child: Row(
                            children: [
                              MyText(
                                '@${_getUserNameFromStreamId(user.id)}',
                                weight: FontWeight.bold,
                              ),
                              if (user.online)
                                const Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Dot(
                                    color: CupertinoColors.activeGreen,
                                    diameter: 10,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const MyPageScaffold(
              navigationBar: MyNavBar(
                middle: NavBarTitle('Loading Chat...'),
              ),
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: 12,
                ),
              )),
    );
  }
}
