import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class YourThrowdownsPage extends StatelessWidget {
  const YourThrowdownsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarTitle('Throwdowns'),
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
