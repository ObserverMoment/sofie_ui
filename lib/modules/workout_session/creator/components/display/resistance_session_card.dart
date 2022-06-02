import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ResistanceSessionCard extends StatelessWidget {
  final ResistanceSession resistanceSession;
  const ResistanceSessionCard({Key? key, required this.resistanceSession})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        MyText('Resistance'),
        MyText(resistanceSession.note ?? 'no note')
      ],
    ));
  }
}
