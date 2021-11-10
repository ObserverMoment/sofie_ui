import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/change_section_type.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/workout_section_workout_sets.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/menus/nav_bar_ellipsis_menu.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/components/user_input/pickers/round_picker.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutSectionCreator extends StatefulWidget {
  @override
  final Key key;
  final int sectionIndex;
  const WorkoutSectionCreator({required this.key, required this.sectionIndex})
      : super(key: key);

  @override
  _WorkoutSectionCreatorState createState() => _WorkoutSectionCreatorState();
}

class _WorkoutSectionCreatorState extends State<WorkoutSectionCreator> {
  late WorkoutCreatorBloc _bloc;
  late WorkoutSection _workoutSection;
  late List<WorkoutSet> _sortedWorkoutSets;

  void _checkForNewData() {
    if (_bloc.workout.workoutSections.length > widget.sectionIndex) {
      final updatedWorkoutSection =
          _bloc.workout.workoutSections[widget.sectionIndex];

      if (_workoutSection != updatedWorkoutSection) {
        setState(() {
          _workoutSection =
              WorkoutSection.fromJson(updatedWorkoutSection.toJson());
        });
      }

      final updatedWorkoutSets =
          _bloc.workout.workoutSections[widget.sectionIndex].workoutSets;

      if (!_sortedWorkoutSets.equals(updatedWorkoutSets)) {
        setState(() {
          _sortedWorkoutSets =
              updatedWorkoutSets.sortedBy<num>((ws) => ws.sortPosition);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WorkoutCreatorBloc>();

    _workoutSection = WorkoutSection.fromJson(
        _bloc.workout.workoutSections[widget.sectionIndex].toJson());

    _sortedWorkoutSets = _bloc
        .workout.workoutSections[widget.sectionIndex].workoutSets
        .sortedBy<num>((ws) => ws.sortPosition);

    _bloc.addListener(_checkForNewData);
  }

  Future<void> _openChangeSectionType(WorkoutSection currentSection) async {
    context.push(
        child: ChangeSectionType(
      previousSection: currentSection,
      updatedWorkoutSection: (updated) =>
          _updateWorkoutSection(updated.toJson()),
    ));
  }

  void _updateWorkoutSection(Map<String, dynamic> data) {
    _bloc.updateWorkoutSection(widget.sectionIndex, data);
  }

  void _openNoteEditor() {
    context.push(
        child: FullScreenTextEditing(
      title: 'Note',
      inputValidation: (text) => true,
      initialValue: _workoutSection.note,
      onSave: (note) => _updateWorkoutSection({'note': note}),
    ));
  }

  void toggleShowFullSetInfo() => _bloc.toggleShowFullSetInfo();

  Widget _buildTitle() {
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WorkoutSectionTypeTag(
            workoutSection: _workoutSection,
            uppercase: true,
            withBackground: false,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bloc.removeListener(_checkForNewData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _showFullSetInfo =
        context.select<WorkoutCreatorBloc, bool>((b) => b.showFullSetInfo);

    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: _buildTitle(),
        trailing: NavBarEllipsisMenu(
          items: [
            ContextMenuItem(
              text: Utils.textNotNull(_workoutSection.name)
                  ? 'Edit name'
                  : 'Add name',
              iconData: CupertinoIcons.pencil,
              onTap: () => context.push(
                  child: FullScreenTextEditing(
                title: 'Name',
                inputValidation: (text) => true,
                maxChars: 25,
                initialValue: _workoutSection.name,
                onSave: (name) => _updateWorkoutSection({'name': name}),
              )),
            ),
            ContextMenuItem(
              text: Utils.textNotNull(_workoutSection.note)
                  ? 'Edit note'
                  : 'Add note',
              iconData: CupertinoIcons.doc_text,
              onTap: _openNoteEditor,
            ),
            ContextMenuItem(
              text: 'Change type',
              iconData: CupertinoIcons.arrow_left_right,
              onTap: () => _openChangeSectionType(_workoutSection),
            ),
            ContextMenuItem(
              text: _showFullSetInfo ? 'Compact Display' : 'Full Display',
              iconData: _showFullSetInfo
                  ? CupertinoIcons.fullscreen_exit
                  : CupertinoIcons.fullscreen,
              onTap: () =>
                  context.read<WorkoutCreatorBloc>().toggleShowFullSetInfo(),
            ),
          ],
        ),
      ),
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverList(
                  delegate: SliverChildListDelegate([
                if (_workoutSection.name != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyHeaderText(
                      _workoutSection.name!,
                      size: FONTSIZE.four,
                    ),
                  ),
                if (_workoutSection.isTimed)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: MyText(
                      'Total Time: ${_workoutSection.timedSectionDuration.displayString}',
                      size: FONTSIZE.four,
                    ),
                  ),
                if (Utils.textNotNull(_workoutSection.note))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: GestureDetector(
                      onTap: _openNoteEditor,
                      child: MyText(
                        _workoutSection.note!,
                        maxLines: 3,
                        textAlign: TextAlign.left,
                        lineHeight: 1.2,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_workoutSection.roundsInputAllowed)
                        ContentBox(
                          child: RoundPicker(
                            rounds: _workoutSection.rounds,
                            saveValue: (value) =>
                                _updateWorkoutSection({'rounds': value}),
                          ),
                        ),
                      if (_workoutSection.isAMRAP)
                        ContentBox(
                          child: DurationPickerDisplay(
                            modalTitle: 'AMRAP Timecap',
                            duration:
                                Duration(seconds: _workoutSection.timecap),
                            updateDuration: (duration) => _updateWorkoutSection(
                                {'timecap': duration.inSeconds}),
                          ),
                        ),
                    ],
                  ),
                ),
              ]))
            ];
          },
          body: WorkoutSectionWorkoutSets(
            sectionIndex: widget.sectionIndex,
            sortedWorkoutSets: _sortedWorkoutSets,
            workoutSectionType: _workoutSection.workoutSectionType,
          )),
    );
  }
}
