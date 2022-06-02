import 'package:flutter/src/widgets/framework.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ResistanceExerciseCard extends StatelessWidget {
  final ResistanceExercise resistanceExercise;
  const ResistanceExerciseCard({Key? key, required this.resistanceExercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(child: MyText(resistanceExercise.id));
  }
}
