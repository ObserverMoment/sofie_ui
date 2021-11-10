import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class LoggedWorkoutSectionCard extends StatelessWidget {
  final LoggedWorkoutSection loggedWorkoutSection;
  const LoggedWorkoutSectionCard({Key? key, required this.loggedWorkoutSection})
      : super(key: key);

  EdgeInsets get kLinePadding => const EdgeInsets.symmetric(vertical: 8.0);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LoggedWorkoutSectionSummaryTag(
              loggedWorkoutSection,
              fontSize: FONTSIZE.three,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => printLog('open moves and details page'),
              child: const Icon(CupertinoIcons.list_number),
            )
          ],
        ),
        if (Utils.textNotNull(loggedWorkoutSection.name))
          Padding(
            padding: kLinePadding,
            child: MyHeaderText(
              loggedWorkoutSection.name!,
              size: FONTSIZE.four,
            ),
          ),
        Padding(
          padding: kLinePadding,
          child: const MyText('Moves'),
        ),
        Padding(
          padding: kLinePadding,
          child: const MyText('Move Types'),
        ),
        Padding(
          padding: kLinePadding,
          child: const MyText('Body Areas'),
        ),
      ],
    ));
  }
}
