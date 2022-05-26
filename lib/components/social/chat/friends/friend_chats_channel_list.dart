import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart'
    as avatar;
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FriendChatsChannelList extends StatefulWidget {
  const FriendChatsChannelList({Key? key}) : super(key: key);

  @override
  _FriendChatsChannelListState createState() => _FriendChatsChannelListState();
}

class _FriendChatsChannelListState extends State<FriendChatsChannelList> {
  final _channelListController = ChannelListController();

  @override
  Widget build(BuildContext context) {
    final user = StreamChatCore.of(context).currentUser;
    return ChannelsBloc(
        child: ChannelListCore(
            channelListController: _channelListController,
            filter: Filter.and([
              Filter.equal('type', kMessagingChannelName),
              Filter.in_('members', [user!.id]),
            ]),
            sort: const [SortOption('last_message_at')],
            emptyBuilder: (BuildContext context) {
              return const Center(
                child: Text('No one to one chats yet...'),
              );
            },
            loadingBuilder: (_) => const ShimmerChatChannelPreviewList(),
            errorBuilder: (BuildContext context, dynamic error) {
              return const Center(
                child: Text('Oh no, something went wrong.'),
              );
            },
            listBuilder: (
              BuildContext context,
              List<Channel> channels,
            ) =>
                LazyLoadScrollView(
                  onEndOfPage: () async {
                    _channelListController.paginateData?.call();
                  },
                  child: CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(onRefresh: () async {
                        _channelListController.loadData?.call();
                      }),
                      FriendsChannelsPage(
                        channels: channels,
                      ),
                    ],
                  ),
                )));
  }
}

class FriendsChannelsPage extends StatelessWidget {
  final List<Channel> channels;
  const FriendsChannelsPage({Key? key, required this.channels})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (c, i) => FriendChannelPreviewTile(
                channel: channels[i],
                authedUserId: authedUserId,
              ),
          childCount: channels.length),
    );
  }
}

class FriendChannelPreviewTile extends StatelessWidget {
  final String authedUserId;
  final Channel channel;
  const FriendChannelPreviewTile(
      {Key? key, required this.channel, required this.authedUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastMessage = channel.state!.lastMessage;
    final otherMember = channel.state!.members
        .where((m) => m.userId != authedUserId)
        .toList()[0];

    return StreamBuilder<int>(
        stream: channel.state!.unreadCountStream,
        builder: (context, snapshot) {
          final unreadCount = snapshot.data;

          return GestureDetector(
            onTap: () => context.navigateTo(
                OneToOneChatRoute(otherUserId: otherMember.userId!)),
            child: Container(
              height: 74,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 6),
                    child: avatar.UserAvatar(
                      avatarUri: otherMember.user!.image,
                      size: 40,
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
                                MyText(otherMember.user!.name),
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
                                  child: unreadCount != null && unreadCount > 0
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
