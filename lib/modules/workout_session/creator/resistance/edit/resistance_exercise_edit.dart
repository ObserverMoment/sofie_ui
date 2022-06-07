import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/my_reorderable_list.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/creator/blocs/resistance_session_bloc.dart';
import 'package:sofie_ui/modules/workout_session/creator/resistance/edit/resistance_set_edit.dart';

class ResistanceExerciseEdit extends StatelessWidget {
  final String resistanceExerciseId;
  const ResistanceExerciseEdit({Key? key, required this.resistanceExerciseId})
      : super(key: key);

  /// Add a set of 10 reps to all moves in the exercise.
  void _handleAddSet(
      BuildContext context, ResistanceExercise resistanceExercise) {
    // context.read<ResistanceSessionBloc>().updateResistanceSet(
    //     resistanceExercise.id,
    //     resistanceSet.id,
    //     {'Equipment': equipment?.toJson()});
  }

  /// i.e. Create a new ResistanceSet and add it to the ResistanceExercise
  void _handleAddMove(
      BuildContext context, ResistanceExercise resistanceExercise) {
    // context.read<ResistanceSessionBloc>().updateResistanceSet(
    //     resistanceExercise.id,
    //     resistanceSet.id,
    //     {'Equipment': equipment?.toJson()});
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ResistanceSessionBloc>();
    final resistanceExercise = bloc.resistanceSession.resistanceExercises
        .firstWhere((e) => e.id == resistanceExerciseId);
    final sortedSets =
        resistanceExercise.resistanceSets.sortedBy<num>((e) => e.sortPosition);

    return MyPageScaffold(
        navigationBar: MyNavBar(
          withoutLeading: true,
          middle: const LeadingNavBarTitle(
            'Edit',
          ),
          trailing: NavBarSaveButton(
            context.pop,
            text: 'Done',
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (sortedSets.length > 1)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: const [
                    MyHeaderText('SUPERSET'),
                    SizedBox(height: 4),
                    MyText(
                      'Alternate between these moves.',
                      subtext: true,
                    ),
                  ],
                ),
              ),
            const HorizontalLine(),
            MyReorderableList<ResistanceSet>(
              proxyDecoratorBorderRadius: BorderRadius.circular(1.0),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index, item) => Container(
                key: ValueKey('$index - ${item.id}'),
                decoration: BoxDecoration(
                    color: context.theme.barBackground,
                    border: Border(
                        bottom: BorderSide(
                            color: context.theme.primary.withOpacity(0.15)))),
                child: Row(
                  children: [
                    ReorderableDragStartListener(
                        index: index,
                        child: const Icon(
                          material.Icons.drag_indicator,
                          size: 30,
                        )),
                    Expanded(
                      child: ResistanceSetEdit(
                        resistanceSet: item,
                        resistanceExercise: resistanceExercise,
                      ),
                    ),
                  ],
                ),
              ),
              items: sortedSets,
              reorderItems: (_, to, __, movedItem) {
                bloc.reorderResistanceSet(
                    resistanceExerciseId, movedItem.id, to);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TertiaryButton(
                      backgroundColor: Styles.primaryAccent,
                      prefixIconData: CupertinoIcons.add,
                      text: 'Add Set',
                      onPressed: () {}),
                  TertiaryButton(
                      backgroundColor: Styles.primaryAccent,
                      prefixIconData: CupertinoIcons.add,
                      text: 'Add Move',
                      onPressed: () {}),
                ],
              ),
            ),
          ],
        ));
  }
}
