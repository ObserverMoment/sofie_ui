import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class YourEventsPage extends StatelessWidget {
  const YourEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarTitle('Events'),
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
