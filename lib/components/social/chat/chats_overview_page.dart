import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/chat/clubs/club_chats_channel_list.dart';
import 'package:sofie_ui/components/social/chat/friends/friend_chats_channel_list.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';

/// Opens a chat overview page for the currently logged in User.
class ChatsOverviewPage extends StatefulWidget {
  const ChatsOverviewPage({Key? key}) : super(key: key);

  @override
  _ChatsOverviewPageState createState() => _ChatsOverviewPageState();
}

class _ChatsOverviewPageState extends State<ChatsOverviewPage> {
  /// 0 = Clubs. 1 = Friends.
  int _activeTabIndex = 0;

  void _updateTabIndex(int index) {
    setState(() => _activeTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarLargeTitle('Chats'),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: MySlidingSegmentedControl<int>(
                value: _activeTabIndex,
                updateValue: (v) => _updateTabIndex(v),
                children: const {
                  0: 'Friends',
                  1: 'Clubs',
                },
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _activeTabIndex,
              children: const [
                FriendChatsChannelList(),
                ClubChatsChannelList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
