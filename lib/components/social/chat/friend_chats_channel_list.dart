import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;
import 'package:sofie_ui/extensions/type_extensions.dart';

class FriendChatsChannelList extends StatefulWidget {
  final chat.StreamChatClient streamChatClient;
  const FriendChatsChannelList({Key? key, required this.streamChatClient})
      : super(key: key);

  @override
  _FriendChatsChannelListState createState() => _FriendChatsChannelListState();
}

class _FriendChatsChannelListState extends State<FriendChatsChannelList> {
  late Stream<List<chat.Channel>> _channelStream;
  late StreamSubscription _channelSubscriber;

  /// Stream Channel plus user data from our API (name and avatar).
  List<ChannelWithUserData> _channelsWithUserData = <ChannelWithUserData>[];
  bool _loadingUserData = true;

  @override
  void initState() {
    super.initState();

    _channelStream = widget.streamChatClient.queryChannels(
        filter: chat.Filter.and([
          chat.Filter.equal('type', kMessagingChannelName),
          chat.Filter.in_(
              'members', [widget.streamChatClient.state.currentUser!.id]),
        ]),
        sort: const [chat.SortOption('last_message_at')]);

    _channelSubscriber = _channelStream.listen(_updateChannelData);
  }

  Future<void> _updateChannelData(List<chat.Channel> channels) async {
    setState(() => _loadingUserData = true);
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    /// For each channel get the userId of the other member of this one on one chat.
    final List<String> otherUserIds = channels
        .map((c) => c.state!.members
            .firstWhereOrNull((m) => m.userId != authedUserId)
            ?.userId)
        .whereType<String>()
        .toList();

    /// Then call our API to get UserAvatarData[]
    final result = await context.graphQLStore
        .networkOnlyOperation<UserAvatars$Query, UserAvatarsArguments>(
            operation: UserAvatarsQuery(
                variables: UserAvatarsArguments(ids: otherUserIds)));

    _channelsWithUserData = channels
        .mapIndexed((i, channel) => ChannelWithUserData(
            channel,
            result.data?.userAvatars
                .firstWhereOrNull((u) => u.id == otherUserIds[i])))
        .toList();

    setState(() => _loadingUserData = false);
  }

  @override
  void dispose() {
    _channelSubscriber.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loadingUserData
        ? const ShimmerChatChannelPreviewList()
        : _channelsWithUserData.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    MyText('No one to one chats yet...'),
                  ],
                ))
            : ListView.builder(
                itemCount: _channelsWithUserData.length,
                itemBuilder: (c, i) => FriendChannelPreviewTile(
                      channelWithUserData: _channelsWithUserData[i],
                    ));
  }
}

/// Helper class for showing data in the preview tile.
class _ChannelInfo {
  final chat.Message? latestMessage;
  final int unreadCount;
  _ChannelInfo(this.latestMessage, this.unreadCount);
}

class FriendChannelPreviewTile extends StatelessWidget {
  final ChannelWithUserData channelWithUserData;
  const FriendChannelPreviewTile({Key? key, required this.channelWithUserData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chat.Channel channel = channelWithUserData.channel;
    final UserAvatarData? userAvatarData = channelWithUserData.userAvatarData;

    return StreamBuilder<_ChannelInfo>(
        initialData: null,
        stream: CombineLatestStream.combine2<chat.Message?, int, _ChannelInfo>(
            channel.state!.lastMessageStream,
            channel.state!.unreadCountStream,
            (a, b) => _ChannelInfo(a, b)),
        builder: (context, snapshot) {
          final lastMessage = snapshot.data?.latestMessage;
          final unreadCount = snapshot.data?.unreadCount ?? 0;

          return GestureDetector(
            onTap: userAvatarData != null
                ? () => context.navigateTo(
                    OneToOneChatRoute(otherUserId: userAvatarData.id))
                : null,
            child: Container(
              height: 74,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 6),
                    child: UserAvatar(
                      size: 50,
                      border: true,
                      borderWidth: 1,
                      avatarUri: userAvatarData?.avatarUri,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      context.theme.primary.withOpacity(0.1)))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                    userAvatarData?.displayName ?? 'Unnamed'),
                                if (lastMessage != null)
                                  MyText(
                                    lastMessage.updatedAt.dateAndTime,
                                    size: FONTSIZE.two,
                                    subtext: true,
                                  )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: MyText(
                                    lastMessage?.text ?? '...',
                                    subtext: true,
                                    size: FONTSIZE.two,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                  child: unreadCount > 0
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Styles.primaryAccent,
                                              borderRadius:
                                                  BorderRadius.circular(60)),
                                          child: Center(
                                            child: MyText(
                                              unreadCount.toString(),
                                              color: Styles.white,
                                              size: FONTSIZE.one,
                                            ),
                                          ))
                                      : null,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ChannelWithUserData {
  final chat.Channel channel;
  final UserAvatarData? userAvatarData;
  const ChannelWithUserData(this.channel, this.userAvatarData);
}
