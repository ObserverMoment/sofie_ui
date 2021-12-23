import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/add_workout_section.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_structure_workout_section.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class WorkoutCreatorStructure extends StatefulWidget {
  const WorkoutCreatorStructure({Key? key}) : super(key: key);

  @override
  _WorkoutCreatorStructureState createState() =>
      _WorkoutCreatorStructureState();
}

class _WorkoutCreatorStructureState extends State<WorkoutCreatorStructure> {
  late WorkoutCreatorBloc _bloc;
  late List<WorkoutSection> _sortedworkoutSections;

  void _checkForNewData() {
    final updated = _bloc.workout.workoutSections;

    if (!_sortedworkoutSections.equals(updated)) {
      setState(() {
        _sortedworkoutSections = [
          ...updated.sortedBy<num>((ws) => ws.sortPosition)
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WorkoutCreatorBloc>();

    _sortedworkoutSections = [
      ..._bloc.workout.workoutSections.sortedBy<num>((ws) => ws.sortPosition)
    ];
    _bloc.addListener(_checkForNewData);
  }

  Future<void> _openCreateSection() async {
    await context.push(
        fullscreenDialog: true,
        child: AddWorkoutSection(
          sortPosition: _sortedworkoutSections.length,
          addWorkoutSection: _bloc.createWorkoutSection,
        ));
  }

  void _openEditSection(int sectionIndex) {
    // https://stackoverflow.com/questions/57598029/how-to-pass-provider-with-navigator
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ChangeNotifierProvider<WorkoutCreatorBloc>.value(
          value: _bloc,
          child: WorkoutSectionCreator(
              key: Key(sectionIndex.toString()), sectionIndex: sectionIndex),
        ),
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
    return FABPage(
      rowButtons: [
        FloatingButton(
            gradient: Styles.primaryAccentGradient,
            contentColor: Styles.white,
            text: 'Add Section',
            icon: CupertinoIcons.add,
            onTap: _openCreateSection)
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: ImplicitlyAnimatedList<WorkoutSection>(
          padding: const EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 60),
          items: _sortedworkoutSections,
          shrinkWrap: true,
          areItemsTheSame: (a, b) => a.id == b.id,
          itemBuilder: (context, animation, item, index) {
            return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: animation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: () => _openEditSection(index),
                  child: WorkoutStructureWorkoutSection(
                    key: Key(item.id),
                    workoutSection: item,
                    index: index,
                    canReorder: _sortedworkoutSections.length > 1,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
