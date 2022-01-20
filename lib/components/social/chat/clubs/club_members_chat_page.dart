import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/social/chat/message_list_view.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart' as avatar;

class ClubMembersChatPage extends StatefulWidget {
  final String clubId;
  const ClubMembersChatPage({Key? key, required this.clubId}) : super(key: key);

  @override
  _ClubMembersChatPageState createState() => _ClubMembersChatPageState();
}

class _ClubMembersChatPageState extends State<ClubMembersChatPage> {
  late StreamChatClient _streamChatClient;
  late Channel _channel;
  late bool _channelReady = false;
  ClubChatSummary? _clubChatSummary;

  @override
  void initState() {
    super.initState();
    _streamChatClient = StreamChatCore.of(context).client;

    _initGetStreamChat();
  }

  Future<void> _initGetStreamChat() async {
    try {
      /// Get club and club member data.
      final result = await context.graphQLStore.networkOnlyOperation<
              ClubChatSummary$Query, ClubChatSummaryArguments>(
          operation: ClubChatSummaryQuery(
              variables: ClubChatSummaryArguments(clubId: widget.clubId)));

      checkOperationResult(context, result, onFail: () {
        throw Exception('Could not retrieve Club data for this chat.');
      }, onSuccess: () {
        _clubChatSummary = result.data!.clubChatSummary;
      });

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

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kStandardAnimationDuration,
      child: _channelReady && _clubChatSummary != null
          ? ClubMembersChatChannelPage(
              channel: _channel,
              clubChatSummary: _clubChatSummary!,
            )
          : const MyPageScaffold(
              navigationBar: MyNavBar(
                middle: NavBarTitle('Loading Chat...'),
              ),
              child: LoadingCircle()),
    );
  }
}

class ClubMembersChatChannelPage extends StatefulWidget {
  final Channel channel;
  final ClubChatSummary clubChatSummary;

  const ClubMembersChatChannelPage(
      {Key? key, required this.channel, required this.clubChatSummary})
      : super(key: key);

  @override
  State<ClubMembersChatChannelPage> createState() =>
      _ClubMembersChatChannelPageState();
}

class _ClubMembersChatChannelPageState
    extends State<ClubMembersChatChannelPage> {
  final _messageListController = MessageListController();

  @override
  Widget build(BuildContext context) {
    final displayName = widget.clubChatSummary.name;
    final avatarUri = widget.clubChatSummary.coverImageUri;

    return StreamChannel(
        channel: widget.channel,
        child: CupertinoPageScaffold(
            navigationBar: MyNavBar(
              middle: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  // onPressed: () => openBottomSheetMenu(
                  //     context: context,
                  //     child: BottomSheetMenu(
                  //         header: BottomSheetMenuHeader(
                  //           name: displayName,
                  //           subtitle: 'Chat',
                  //           imageUri: avatarUri,
                  //         ),
                  //         items: [
                  //           BottomSheetMenuItem(
                  //               text: 'Block',
                  //               icon: CupertinoIcons.nosign,
                  //               onPressed: () => printLog('block')),
                  //           BottomSheetMenuItem(
                  //               text: 'Report',
                  //               icon: CupertinoIcons.exclamationmark_circle,
                  //               onPressed: () => printLog('report')),
                  //         ])),
                  child: MyHeaderText(displayName)),
              trailing: CupertinoButton(
                onPressed: avatarUri != null
                    ? () => openFullScreenImageViewer(context, avatarUri)
                    : null,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: avatar.UserAvatar(
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
                    messageListBuilder: (context, messages) {
                      /// Mark channel messages as read.
                      widget.channel.markRead();

                      /// Build the list.
                      return LazyLoadScrollView(
                        onStartOfPage: () async {
                          await _messageListController.paginateData!();
                        },
                        child: MessagesList(
                          messages: messages,
                        ),
                      );
                    }))));
  }
}
