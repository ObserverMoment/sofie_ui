import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/details_page/info_section.dart';
import 'package:sofie_ui/services/utils.dart';

class ResistanceSessionDetails extends StatelessWidget {
  final ResistanceSession resistanceSession;
  const ResistanceSessionDetails({Key? key, required this.resistanceSession})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (Utils.textNotNull(resistanceSession.note))
          InfoSection(
            content: ReadMoreTextBlock(
                text: resistanceSession.note!, title: resistanceSession.name),
            header: 'Description',
            icon: CupertinoIcons.doc_text,
          ),
      ],
    );
  }
}
