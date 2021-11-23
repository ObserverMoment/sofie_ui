import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class PageNotFoundPage extends StatelessWidget {
  const PageNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Page Not Found'),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(height: 32),
                Opacity(
                  opacity: 0.4,
                  child: Icon(
                    CupertinoIcons.question_diamond,
                    size: 150,
                  ),
                ),
                SizedBox(height: 32),
                MyText(
                  "Sorry, we couldn't find anything here...",
                  size: FONTSIZE.four,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
