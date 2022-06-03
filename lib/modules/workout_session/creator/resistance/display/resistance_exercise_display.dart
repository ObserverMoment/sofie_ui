import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/creator/resistance/display/resistance_set_display.dart';

class ResistanceExerciseDisplay extends StatelessWidget {
  final ResistanceExercise resistanceExercise;
  const ResistanceExerciseDisplay({Key? key, required this.resistanceExercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(resistanceExercise.childrenOrder);
    final sortedSets = resistanceExercise.childrenOrder
        .map((id) =>
            resistanceExercise.resistanceSets.firstWhere((s) => s.id == id))
        .toList();

    print(sortedSets.length);

    return Card(
        child: Column(
      children: [
        MyText('Actions'),
        ImplicitlyAnimatedList<ResistanceSet>(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            items: sortedSets,
            itemBuilder: (context, animation, resistanceSet, index) =>
                SizeFadeTransition(
                  animation: animation,
                  sizeFraction: 0.7,
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ResistanceSetDisplay(
                      resistanceSet: resistanceSet,
                      setPosition: index,
                    ),
                  ),
                ),
            areItemsTheSame: (a, b) => a.id == b.id)
      ],
    ));
  }
}
