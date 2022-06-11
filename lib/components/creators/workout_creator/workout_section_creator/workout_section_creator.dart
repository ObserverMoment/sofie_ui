import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_section_creator/change_section_type.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_section_creator/workout_set_generator_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_move_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_set_creator/workout_set_creator_container.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/menus/nav_bar_ellipsis_menu.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/components/user_input/pickers/round_picker.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';
import 'package:sofie_ui/services/default_object_factory.dart';
import 'package:sofie_ui/services/repos/move_data.repo.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutSectionCreator extends StatefulWidget {
  @override
  final Key key;
  final int sectionIndex;
  const WorkoutSectionCreator({required this.key, required this.sectionIndex})
      : super(key: key);

  @override
  State<WorkoutSectionCreator> createState() => _WorkoutSectionCreatorState();
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

  /// When adding a new set the user selects the move etc first, then we create a set to be its parent once they are done.
  Future<void> _openWorkoutMoveCreator(BuildContext context,
      {bool ignoreReps = false,
      int? duration,
      String screenTitle = 'Add Set'}) async {
    await context.push(
        child: WorkoutMoveCreator(
      pageTitle: screenTitle,
      // If they have selected a the move as rest then this will become a 'rest set' (i.e. a set with only one move in it which is a resrt move.). The set will use set.duration as its length, so we take workoutMove and extract the time the user has entered, then set this as set.duration.
      saveWorkoutMove: (workoutMove) => workoutMove.move.id == kRestMoveId
          ? _createSetAndAddWorkoutMove(context, workoutMove,
              duration: workoutMove.moveTimeInSeconds)
          : _createSetAndAddWorkoutMove(context, workoutMove,
              duration: duration),
      sortPosition: 0,
      ignoreReps: ignoreReps,
    ));
  }

  // Future<void> _openWorkoutSetGeneratorCreator(BuildContext context) async {
  //   await context.push(
  //       child: WorkoutSetGeneratorCreator(
  //     handleGeneratedSet: (workoutSet) {
  //       context
  //           .read<WorkoutCreatorBloc>()
  //           .createWorkoutSetWithWorkoutMoves(widget.sectionIndex, workoutSet);
  //       context.pop();
  //     },
  //     newSetSortPosition: _sortedWorkoutSets.length,
  //   ));
  // }

  Future<void> _addRestSet(
      BuildContext context, Move restMove, int seconds) async {
    final restWorkoutMove = DefaultObjectfactory.defaultRestWorkoutMove(
        move: restMove,
        sortPosition: 0,
        timeAmount: seconds,
        timeUnit: TimeUnit.seconds);

    await _createSetAndAddWorkoutMove(context, restWorkoutMove,
        duration: seconds);
  }

  Future<void> _createSetAndAddWorkoutMove(
      BuildContext context, WorkoutMove workoutMove,
      {int? duration}) async {
    /// Only [shouldNotifyListeners] after creating the workoutMove so that the UI just updates once.
    await context.read<WorkoutCreatorBloc>().createWorkoutSet(
        widget.sectionIndex,
        shouldNotifyListeners: false,
        duration: duration);
    await context.read<WorkoutCreatorBloc>().createWorkoutMove(
        widget.sectionIndex, _sortedWorkoutSets.length, workoutMove);
  }

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
            showMediaIcons: false,
          ),
        ],
      ),
    );
  }

  Widget _floatingButton(
          {required String text,
          required VoidCallback onTap,
          required bool loading}) =>
      FloatingButton(
        text: text,
        iconSize: 19,
        icon: CupertinoIcons.add,
        loading: loading,
        onTap: onTap,
      );

  @override
  void dispose() {
    _bloc.removeListener(_checkForNewData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final creatingSet =
        context.select<WorkoutCreatorBloc, bool>((b) => b.creatingSet);

    final workoutSectionType = _workoutSection.workoutSectionType;

    /// Need to get the Move [Rest] for use when user taps [+ Add Rest]
    final restMove = context
        .watch<MoveDataRepo>()
        .standardMoves
        .firstWhere((m) => m.id == kRestMoveId);

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
          ],
        ),
      ),
      child: FABPage(
        rowButtonsAlignment: MainAxisAlignment.spaceEvenly,
        rowButtons: [
          if (_workoutSection.isLifting || _workoutSection.isCustomSession)
            _floatingButton(
              text: 'Add Exercise',
              loading: creatingSet,
              onTap: () => _openWorkoutMoveCreator(context),
            ),
          if ([kAMRAPName, kForTimeName].contains(workoutSectionType.name))
            _floatingButton(
              text: 'Add Set',
              loading: creatingSet,
              onTap: () => _openWorkoutMoveCreator(context),
            ),
          if (kHIITCircuitName == workoutSectionType.name)
            _floatingButton(
              text: 'Add Station',
              loading: creatingSet,
              onTap: () => _openWorkoutMoveCreator(context,
                  duration: 60, ignoreReps: true, screenTitle: 'Add Station'),
            ),
          if (kHIITCircuitName == workoutSectionType.name)
            _floatingButton(
              text: 'Add Rest',
              loading: creatingSet,
              onTap: () => _addRestSet(
                context,
                restMove,
                30,
              ),
            ),
          if (kEMOMName == workoutSectionType.name)
            _floatingButton(
              text: 'Add Period',
              loading: creatingSet,
              onTap: () => _openWorkoutMoveCreator(context,
                  duration: 60, screenTitle: 'Add Period'),
            ),
          if (kTabataName == workoutSectionType.name)
            _floatingButton(
              text: 'Add Set',
              loading: creatingSet,
              onTap: () => _openWorkoutMoveCreator(context,
                  duration: 20, ignoreReps: true),
            ),
          if (kTabataName == workoutSectionType.name)
            _floatingButton(
              text: 'Add Rest',
              loading: creatingSet,
              onTap: () => _addRestSet(context, restMove, 10),
            ),
          // if (!workoutSectionType.isTimed)
          //   _floatingButton(
          //     text: 'Set Generator',
          //     loading: creatingSet,
          //     onTap: () => _openWorkoutSetGeneratorCreator(context),
          //   ),
        ],
        child: ListView(
          padding: const EdgeInsets.only(bottom: 70),
          shrinkWrap: true,
          children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: MyText(
                  'Total Time: ${_workoutSection.timedSectionDuration.displayString}',
                  size: FONTSIZE.four,
                ),
              ),
            if (Utils.textNotNull(_workoutSection.note))
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_workoutSection.roundsInputAllowed)
                    RoundPicker(
                      rounds: _workoutSection.rounds,
                      saveValue: (value) =>
                          _updateWorkoutSection({'rounds': value}),
                    ),
                  if (_workoutSection.isAMRAP)
                    DurationPickerDisplay(
                      modalTitle: 'AMRAP Timecap',
                      duration: Duration(seconds: _workoutSection.timecap),
                      updateDuration: (duration) => _updateWorkoutSection(
                          {'timecap': duration.inSeconds}),
                    ),
                ],
              ),
            ),
            _sortedWorkoutSets.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: const [
                        Opacity(
                            opacity: 0.5,
                            child: Icon(
                              CupertinoIcons.square_list,
                              size: 50,
                            )),
                        SizedBox(height: 12),
                        MyText(
                          'No sets defined yet...',
                          subtext: true,
                        ),
                      ],
                    ),
                  )
                : ImplicitlyAnimatedList<WorkoutSet>(
                    items: _sortedWorkoutSets,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    areItemsTheSame: (a, b) => a.id == b.id,
                    itemBuilder: (context, animation, item, index) {
                      return SizeFadeTransition(
                        sizeFraction: 0.7,
                        curve: Curves.easeInOut,
                        animation: animation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: WorkoutSetCreatorContainer(
                              key: Key(
                                  'WorkoutSectionWorkoutSets-${widget.sectionIndex}-${item.sortPosition}'),
                              sectionIndex: widget.sectionIndex,
                              setIndex: item.sortPosition,
                              allowReorder: _sortedWorkoutSets.length > 1),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
