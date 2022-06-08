import 'package:flutter/src/widgets/framework.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';

class CardioSessionCard extends StatelessWidget {
  const CardioSessionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(child: MyText('Cardio'));
  }
}
