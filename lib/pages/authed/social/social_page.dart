import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feeds_and_follows.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/stream.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: const LeadingNavBarTitle(
          'Social',
        ),
        trailing: NavBarTrailingRow(children: [
          const ChatsIconButton(),
          CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              onPressed: () => context.navigateTo(const PostCreatorRoute()),
              child: const Icon(CupertinoIcons.pencil))
        ]),
      ),
      child: const FeedsAndFollows(),
    );
  }
}
