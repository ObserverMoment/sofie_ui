import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/timeline_and_feed.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/stream.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      child: SafeArea(
        child: FABPage(
            rowButtonsAlignment: MainAxisAlignment.end,
            rowButtons: [
              const ChatsIconButton(),
              const SizedBox(width: 16),
              FloatingButton(
                  contentColor: Styles.white,
                  onTap: () => context.navigateTo(const YourPostsRoute()),
                  icon: CupertinoIcons.tray_arrow_up),
              const SizedBox(width: 16),
              FloatingButton(
                  gradient: Styles.primaryAccentGradient,
                  contentColor: Styles.white,
                  onTap: () => context.navigateTo(const PostCreatorRoute()),
                  icon: CupertinoIcons.pencil),
            ],
            child: const TimelineAndFeed()),
      ),
    );
  }
}
