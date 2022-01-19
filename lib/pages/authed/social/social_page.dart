import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/timeline_and_feed.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/stream.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({Key? key}) : super(key: key);

  Widget get _buttonSpacer => const SizedBox(width: 10);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        trailing: NavBarTrailingRow(
          children: [
            IconButton(
                iconData: CupertinoIcons.plus_rectangle,
                onPressed: () => context.navigateTo(const PostCreatorRoute())),
            _buttonSpacer,
            const ChatsIconButton(),
            _buttonSpacer,
            IconButton(
                iconData: CupertinoIcons.person_2,
                onPressed: () => print('open followers and following.')),
            _buttonSpacer,
            IconButton(
                iconData: CupertinoIcons.tray_full,
                onPressed: () => context.navigateTo(const YourPostsRoute())),
          ],
        ),
      ),
      child: const TimelineAndFeed(),
      // child: SafeArea(
      //   child: FABPage(rowButtons: [
      //     // const ChatsIconButton(),
      //     // const SizedBox(width: 16),
      //     FloatingButton(
      //       text: 'New Post',
      //       onTap: () => context.navigateTo(const PostCreatorRoute()),
      //       icon: CupertinoIcons.pencil,
      //       iconSize: 18,
      //     ),
      //     const SizedBox(width: 16),
      //     FloatingButton(
      //       text: 'History',
      //       onTap: () => context.navigateTo(const YourPostsRoute()),
      //       icon: CupertinoIcons.tray_arrow_up,
      //       iconSize: 18,
      //     ),
      //   ], child: const TimelineAndFeed()),
      // ),
    );
  }
}
