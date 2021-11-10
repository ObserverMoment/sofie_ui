import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class LoggedWorkoutSectionSummaryCard extends StatelessWidget {
  final LoggedWorkoutSection loggedWorkoutSection;
  final void Function(String note)? addNoteToLoggedSection;
  final bool showSectionName;
  const LoggedWorkoutSectionSummaryCard(
      {Key? key,
      required this.loggedWorkoutSection,
      this.addNoteToLoggedSection,
      this.showSectionName = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showSectionName && Utils.textNotNull(loggedWorkoutSection.name))
          MyText(
            '"${loggedWorkoutSection.name!}"',
            weight: FontWeight.bold,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: LoggedWorkoutSectionSummaryTag(
                loggedWorkoutSection,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
