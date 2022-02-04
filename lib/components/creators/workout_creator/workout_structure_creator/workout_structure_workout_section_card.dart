import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_section_creator/change_section_type.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/menus/nav_bar_ellipsis_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutStructureWorkoutSectionCard extends StatelessWidget {
  @override
  final Key key;
  final int index;
  final WorkoutSection workoutSection;
  final bool canReorder;
  const WorkoutStructureWorkoutSectionCard(
      {required this.key,
      required this.index,
      required this.workoutSection,
      this.canReorder = false})
      : super(key: key);

  /// Creates a list of all move names and equipment names in the workout without any duplicates.
  _SectionMovesEquipmentsBodyAreas _getMovesAndEquipments() {
    final Set<String> allMoves = {};
    final Set<String> allEquipments = {};
    final Set<String> allBodyAreas = {};

    for (final workoutSet in workoutSection.workoutSets) {
      for (final workoutMove in workoutSet.workoutMoves) {
        allMoves.add(workoutMove.move.name);
        allBodyAreas.addAll(workoutMove.move.bodyAreaMoveScores
            .map((bams) => bams.bodyArea.name));
        if (workoutMove.equipment != null &&
            workoutMove.equipment!.id != kBodyweightEquipmentId) {
          allEquipments.add(workoutMove.equipment!.name);
        }
        if (workoutMove.move.requiredEquipments.isNotEmpty) {
          allEquipments
              .addAll(workoutMove.move.requiredEquipments.map((e) => e.name));
        }
      }
    }
    return _SectionMovesEquipmentsBodyAreas(
        allMoves, allEquipments, allBodyAreas);
  }

  void _updateSection(BuildContext context, Map<String, dynamic> data) {
    context
        .read<WorkoutCreatorBloc>()
        .updateWorkoutSection(workoutSection.sortPosition, data);
  }

  Future<void> _openChangeSectionType(
      BuildContext context, WorkoutSection currentSection) async {
    context.push(
        child: ChangeSectionType(
      previousSection: currentSection,
      updatedWorkoutSection: (updated) =>
          _updateSection(context, updated.toJson()),
    ));
  }

  void _deleteWorkoutSection(BuildContext context) {
    context.showConfirmDeleteDialog(
        itemType: 'Section',
        onConfirm: () =>
            context.read<WorkoutCreatorBloc>().deleteWorkoutSection(index));
  }

  void _moveWorkoutSectionUpOne(BuildContext context) {
    context.read<WorkoutCreatorBloc>().reorderWorkoutSections(index, index - 1);
  }

  void _moveWorkoutSectionDownOne(BuildContext context) {
    context.read<WorkoutCreatorBloc>().reorderWorkoutSections(index, index + 1);
  }

  @override
  Widget build(BuildContext context) {
    final data = _getMovesAndEquipments();

    return ContentBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WorkoutSectionTypeTag(
                withBackground: false,
                workoutSection: workoutSection,
                fontSize: FONTSIZE.four,
                showMediaIcons: false,
              ),
              NavBarEllipsisMenu(items: [
                ContextMenuItem(
                  text: Utils.textNotNull(workoutSection.name)
                      ? 'Edit name'
                      : 'Add name',
                  iconData: CupertinoIcons.pencil,
                  onTap: () => context.push(
                      child: FullScreenTextEditing(
                    title: 'Name',
                    inputValidation: (t) => t.isNotEmpty && t.length <= 40,
                    maxChars: 30,
                    validationMessage: 'Max 30 chars',
                    initialValue: workoutSection.name,
                    onSave: (text) => _updateSection(context, {'name': text}),
                  )),
                ),
                ContextMenuItem(
                  text: Utils.textNotNull(workoutSection.note)
                      ? 'Edit note'
                      : 'Add note',
                  iconData: CupertinoIcons.doc_text,
                  onTap: () => context.push(
                      child: FullScreenTextEditing(
                    title: 'Note',
                    inputValidation: (text) => true,
                    initialValue: workoutSection.note,
                    onSave: (note) => _updateSection(context, {'note': note}),
                  )),
                ),
                ContextMenuItem(
                  text: 'Change type',
                  iconData: CupertinoIcons.arrow_left_right,
                  onTap: () => _openChangeSectionType(context, workoutSection),
                ),
                if (canReorder)
                  ContextMenuItem(
                    text: 'Move up',
                    onTap: () => _moveWorkoutSectionUpOne(context),
                    iconData: CupertinoIcons.up_arrow,
                  ),
                if (canReorder)
                  ContextMenuItem(
                    text: 'Move down',
                    onTap: () => _moveWorkoutSectionDownOne(context),
                    iconData: CupertinoIcons.down_arrow,
                  ),
                ContextMenuItem(
                  text: 'Delete',
                  onTap: () => _deleteWorkoutSection(context),
                  iconData: CupertinoIcons.delete_simple,
                  destructive: true,
                ),
              ])
            ],
          ),
          const SizedBox(height: 4),
          if (Utils.textNotNull(workoutSection.name))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: H3(workoutSection.name!),
            ),
          if (Utils.textNotNull(workoutSection.note))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyText(
                      workoutSection.note!,
                      maxLines: 4,
                      textAlign: TextAlign.left,
                      lineHeight: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: data.moves
                  .map((m) => Tag(
                        tag: m,
                      ))
                  .toList(),
            ),
          ),
          if (data.bodyAreas.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: CommaSeparatedList(data.bodyAreas.toList()),
            ),
          if (data.equipments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ...data.equipments
                      .map((e) => Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: context.theme.background,
                              borderRadius: BorderRadius.circular(30)),
                          width: 40,
                          height: 40,
                          child: Utils.getEquipmentIcon(context, e,
                              color: context.theme.primary)))
                      .toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionMovesEquipmentsBodyAreas {
  final Set<String> moves;
  final Set<String> equipments;
  final Set<String> bodyAreas;
  _SectionMovesEquipmentsBodyAreas(this.moves, this.equipments, this.bodyAreas);
}
