import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/services/utils.dart';

class ResistanceSessionCard extends StatelessWidget {
  final ResistanceSession resistanceSession;
  const ResistanceSessionCard({Key? key, required this.resistanceSession})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              resistanceSession.name,
              size: FONTSIZE.four,
              maxLines: 2,
            ),
            UserAvatar(
              avatarUri: resistanceSession.user.avatarUri,
              size: 40,
            )
          ],
        ),
        if (Utils.textNotNull(resistanceSession.note))
          MyText(
            resistanceSession.note!,
            subtext: true,
          ),
      ],
    ));
  }
}
