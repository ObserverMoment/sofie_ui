import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/animated/my_reorderable_list.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/components/user_input/selectors/move_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/edit/resistance_set_edit.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/resistance_session_bloc.dart';

class ResistanceExerciseEdit extends StatelessWidget {
  final String resistanceExerciseId;
  const ResistanceExerciseEdit({Key? key, required this.resistanceExerciseId})
      : super(key: key);

  /// i.e. Create a new ResistanceSet and add it to the ResistanceExercise
  void _handleAddMove(BuildContext context) {
    context.push(
        fullscreenDialog: true,
        child: MoveSelector(
            selectMove: (m) {
              context.read<ResistanceSessionBloc>().createResistanceSet(
                  resistanceExerciseId, Move.fromJson(m.toJson()));
              context.pop();
            },
            onCancel: context.pop));
  }

  void _handleAddSet(
    BuildContext context,
    ResistanceSet resistanceSet,
  ) {
    final updatedReps = [...resistanceSet.reps, resistanceSet.reps.last];

    context.read<ResistanceSessionBloc>().updateResistanceSet(
        resistanceExerciseId, resistanceSet.id, {'reps': updatedReps});
  }

  void _handleRemoveSet(
    BuildContext context,
    ResistanceSet resistanceSet,
  ) {
    final updatedReps =
        resistanceSet.reps.sublist(0, resistanceSet.reps.length - 1);

    context.read<ResistanceSessionBloc>().updateResistanceSet(
        resistanceExerciseId, resistanceSet.id, {'reps': updatedReps});
  }

  void _handleDuplicateMove(
    BuildContext context,
    ResistanceSet resistanceSet,
  ) {
    context
        .read<ResistanceSessionBloc>()
        .duplicateResistanceSet(resistanceExerciseId, resistanceSet);
  }

  void _handleDeleteMove(
    BuildContext context,
    ResistanceSet resistanceSet,
  ) {
    context.showConfirmDeleteDialog(
        itemType: 'Move',
        onConfirm: () {
          context
              .read<ResistanceSessionBloc>()
              .deleteResistanceSet(resistanceExerciseId, resistanceSet.id);
        });
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
              GrowIn(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          MyHeaderText('SUPERSET'),
                          SizedBox(height: 4),
                          MyText(
                            'Alternate between these moves.',
                            subtext: true,
                          ),
                        ],
                      ),
                    ],
                  ),
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
                    Column(
                      children: [
                        PopoverMenu(
                            button: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                CupertinoIcons.ellipsis,
                                size: 20,
                              ),
                            ),
                            items: [
                              PopoverMenuItem(
                                onTap: () => _handleAddSet(context, item),
                                text: 'Add Set',
                                iconData: CupertinoIcons.add,
                              ),
                              PopoverMenuItem(
                                onTap: () => _handleRemoveSet(context, item),
                                text: 'Remove Set',
                                iconData: CupertinoIcons.minus,
                              ),
                              PopoverMenuItem(
                                onTap: () =>
                                    _handleDuplicateMove(context, item),
                                text: 'Duplicate Move',
                                iconData: CupertinoIcons.doc_on_doc,
                              ),
                              PopoverMenuItem(
                                onTap: () => _handleDeleteMove(context, item),
                                text: 'Delete Move',
                                iconData: CupertinoIcons.delete_simple,
                              ),
                            ]),
                        if (sortedSets.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: ReorderableDragStartListener(
                                index: index,
                                child: const Icon(
                                  material.Icons.drag_indicator,
                                  size: 30,
                                )),
                          ),
                      ],
                    ),
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
              child: TertiaryButton(
                  backgroundColor: Styles.primaryAccent,
                  prefixIconData: CupertinoIcons.add,
                  text: 'Add Move',
                  onPressed: () => _handleAddMove(context)),
            ),
          ],
        ));
  }
}
