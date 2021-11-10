import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class DiscoverChampionsPage extends StatelessWidget {
  const DiscoverChampionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: const MyNavBar(middle: NavBarTitle('Sofie Champions')),
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
