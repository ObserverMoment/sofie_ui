import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_set_definition.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import "package:collection/collection.dart";
import 'package:sofie_ui/modules/workout_session/resistance_session/display/resistance_set_display.dart';

class ResistanceExerciseDisplay extends StatelessWidget {
  final ResistanceExercise resistanceExercise;
  const ResistanceExerciseDisplay({
    Key? key,
    required this.resistanceExercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedSets =
        resistanceExercise.resistanceSets.sortedBy<num>((e) => e.sortPosition);

    final isSuperSet = sortedSets.length > 1;

    return Card(
        padding: const EdgeInsets.all(4),
        child: Column(children: [
          if (isSuperSet)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: MyText(
                getWorkoutSetDefinitionText(sortedSets.length)!,
                subtext: true,
                size: FONTSIZE.two,
              ),
            ),
          ...sortedSets
              .map(
                (s) => ResistanceSetDisplay(
                  resistanceSet: s,
                ),
              )
              .toList(),
        ]));
  }
}
