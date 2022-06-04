import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/animated/dragged_item.dart';
import 'package:sofie_ui/components/animated/my_reorderable_list.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/creator/blocs/resistance_session_bloc.dart';
import 'package:sofie_ui/modules/workout_session/creator/resistance/display/resistance_set_display.dart';

class ResistanceExerciseDisplay extends StatelessWidget {
  final ResistanceExercise resistanceExercise;
  const ResistanceExerciseDisplay({Key? key, required this.resistanceExercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedSets = resistanceExercise.childrenOrder
        .map((id) =>
            resistanceExercise.resistanceSets.firstWhere((s) => s.id == id))
        .toList();

    return Card(
        padding: const EdgeInsets.only(bottom: 8, top: 2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TertiaryButton(
                    prefixIconData: CupertinoIcons.add,
                    text: 'Add Set',
                    onPressed: () {}),
                IconButton(iconData: CupertinoIcons.ellipsis, onPressed: () {}),
              ],
            ),
            MyReorderableList<ResistanceSet>(
              itemBuilder: (context, index, item) => ResistanceSetDisplay(
                key: ValueKey('$index - ${item.id}'),
                resistanceSet: item,
                setPosition: index,
              ),
              items: sortedSets,
              reorderItems: (reorderedItems) {
                context.read<ResistanceSessionBloc>().updateResistanceExercise(
                    resistanceExercise.id, {
                  'childrenOrder': reorderedItems.map((i) => i.id).toList()
                });
              },
            ),
            // material.ReorderableListView.builder(
            //     proxyDecorator: (child, index, animation) =>
            //         DraggedItem(child: child),
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: sortedSets.length,
            //     itemBuilder: (context, index) => ResistanceSetDisplay(
            //           key: ValueKey('$index - ${sortedSets[index].id}'),
            //           resistanceSet: sortedSets[index],
            //           setPosition: index,
            //         ),
            //     onReorder: (from, to) {
            //       // https://api.flutter.dev/flutter/material/ReorderableListView-class.html
            //       // // Necessary because of how flutters reorderable list calculates drop position...I think.
            //       final moveTo = from < to ? to - 1 : to;

            //       final newChildrenOrder =
            //           List.from(resistanceExercise.childrenOrder);
            //       final inTransit = newChildrenOrder.removeAt(from);
            //       newChildrenOrder.insert(moveTo, inTransit);
            //       context
            //           .read<ResistanceSessionBloc>()
            //           .updateResistanceExercise(resistanceExercise.id,
            //               {'childrenOrder': newChildrenOrder});
            //     })
          ],
        ));
  }
}
