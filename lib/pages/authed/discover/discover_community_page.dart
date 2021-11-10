import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class DiscoverCommunityPage extends StatelessWidget {
  const DiscoverCommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: const MyNavBar(middle: NavBarTitle('Community & Live')),
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: ContentBox(
                  child: MyText('Coming soon'),
                ),
              ),
            )
          ],
        ));
  }
}
