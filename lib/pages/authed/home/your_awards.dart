import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class YourAwardsPage extends StatelessWidget {
  const YourAwardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarTitle('Awards'),
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
