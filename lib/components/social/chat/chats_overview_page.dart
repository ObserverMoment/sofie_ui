import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/chat/club_chats_channel_list.dart';
import 'package:sofie_ui/components/social/chat/friend_chats_channel_list.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;

/// Opens a chat overview page for the currently logged in User.
class ChatsOverviewPage extends StatefulWidget {
  const ChatsOverviewPage({Key? key}) : super(key: key);

  @override
  _ChatsOverviewPageState createState() => _ChatsOverviewPageState();
}

class _ChatsOverviewPageState extends State<ChatsOverviewPage> {
  late chat.StreamChatClient _streamChatClient;

  /// 0 = Clubs. 1 = Friends.
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _streamChatClient = context.streamChatClient;
  }

  void _updateTabIndex(int index) {
    setState(() => _activeTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Chats'),
      ),
      child: FABPage(
        rowButtons: [
          MySlidingSegmentedControl<int>(
            value: _activeTabIndex,
            updateValue: (v) => _updateTabIndex(v),
            children: const {
              0: 'Friends',
              1: 'Clubs',
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: _streamChatClient.state.currentUser == null
                  ? const ShimmerChatChannelPreviewList()
                  : IndexedStack(
                      index: _activeTabIndex,
                      children: [
                        FriendChatsChannelList(
                          streamChatClient: _streamChatClient,
                        ),
                        ClubChatsChannelList(
                          streamChatClient: _streamChatClient,
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
