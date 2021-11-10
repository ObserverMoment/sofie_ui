import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class YourChallengesPage extends StatelessWidget {
  const YourChallengesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarTitle('Challenges'),
      ),
      child: Center(
        child: MyHeaderText(
          'Coming soon!',
          size: FONTSIZE.six,
        ),
      ),
    );
  }
}
