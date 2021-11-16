import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class BodyTrackingEntryCard extends StatelessWidget {
  final BodyTrackingEntry bodyTrackingEntry;
  const BodyTrackingEntryCard({Key? key, required this.bodyTrackingEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MyText(bodyTrackingEntry.createdAt.toString()),
    );
  }
}
