import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class JournalGraphs extends StatelessWidget {
  const JournalGraphs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarLargeTitle('History'),
      ),
      child: MyText('Mood and Goals'),
    );
  }
}
