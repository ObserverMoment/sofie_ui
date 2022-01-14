import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/text.dart';
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

  @override
  void initState() {
    super.initState();
    _streamChatClient = context.streamChatClient;

    _initGetStreamChat();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kStandardAnimationDuration,
      child: _channelReady
          ? chat.StreamChannel(
              channel: _channel,
              child: CupertinoPageScaffold(
                navigationBar: MyNavBar(
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
                          onMessageTap: (message) =>
                              printLog(message.toString()),
                          messageBuilder: (context, message, messages,
                              defaultMessageWidget) {
                            return defaultMessageWidget.copyWith(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 12),
                              onLinkTap: (link) => printLog(link),
                              onMessageActions: (context, message) =>
                                  printLog(message.toString()),
                              onAttachmentTap: (message, attachment) =>
                                  printLog('View, share, save options'),
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
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: 12,
                ),
              )),
    );
  }
}
