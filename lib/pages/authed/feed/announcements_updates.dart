import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

/// Use this widget to display news and updates from the app admins to users on their home / feed page.
/// Users can mark read so that they no longer display on their feed page.
class AnnouncementsUpdates extends StatelessWidget {
  const AnnouncementsUpdates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      child: MyText('NEW THINGS AND WELCOME MESSAGES'),
    );
  }
}
