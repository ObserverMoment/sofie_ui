import 'package:flutter/cupertino.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_move_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/lifting_set_creator.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_section_creator/workout_set_creator/workout_set_creator.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/default_object_factory.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class WorkoutSectionWorkoutSets extends StatelessWidget {
  final int sectionIndex;
  final List<WorkoutSet> sortedWorkoutSets;
  final WorkoutSectionType workoutSectionType;

  const WorkoutSectionWorkoutSets({
    Key? key,
    required this.sortedWorkoutSets,
    required this.sectionIndex,
    required this.workoutSectionType,
  }) : super(key: key);

  /// Creator specific for the Lifting workout section type.
  Future<void> _openLiftingSetCreator(
    BuildContext context,
  ) async {
    await context.push(
        child: LiftingSetCreator(
      saveWorkoutMoves: (List<WorkoutMove> workoutMoves) {},
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
      saveWorkoutMove: (workoutMove) =>
          _createSetAndAddWorkoutMove(context, workoutMove, duration: duration),
      sortPosition: 0,
      ignoreReps: ignoreReps,
    ));
  }

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
    await context.read<WorkoutCreatorBloc>().createWorkoutSet(sectionIndex,
        shouldNotifyListeners: false, duration: duration);
    await context
        .read<WorkoutCreatorBloc>()
        .createWorkoutMove(sectionIndex, sortedWorkoutSets.length, workoutMove);
  }

  @override
  Widget build(BuildContext context) {
    final creatingSet =
        context.select<WorkoutCreatorBloc, bool>((b) => b.creatingSet);

    return ListView(shrinkWrap: true, children: [
      ImplicitlyAnimatedList<WorkoutSet>(
        items: sortedWorkoutSets,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        areItemsTheSame: (a, b) => a.id == b.id,
        itemBuilder: (context, animation, item, index) {
          return SizeFadeTransition(
            sizeFraction: 0.7,
            curve: Curves.easeInOut,
            animation: animation,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: WorkoutSetCreator(
                  key: Key(
                      'WorkoutSectionWorkoutSets-$sectionIndex-${item.sortPosition}'),
                  sectionIndex: sectionIndex,
                  setIndex: item.sortPosition,
                  allowReorder: sortedWorkoutSets.length > 1),
            ),
          );
        },
      ),
      QueryObserver<StandardMoves$Query, json.JsonSerializable>(
          key: Key(
              'WorkoutSectionWorkoutSets - ${StandardMovesQuery().operationName}'),
          query: StandardMovesQuery(),
          fetchPolicy: QueryFetchPolicy.storeFirst,
          loadingIndicator: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: LoadingDots(),
          ),
          builder: (data) {
            /// Need to get the Move [Rest] for use when user taps [+ Add Rest]
            final restMove =
                data.standardMoves.firstWhere((m) => m.id == kRestMoveId);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (workoutSectionType.name == kLiftingName)
                    CreateTextIconButton(
                      text: 'Add Exercise',
                      loading: creatingSet,
                      onPressed: () => _openLiftingSetCreator(context),
                    ),
                  if ([kFreeSessionName, kAMRAPName, kForTimeName]
                      .contains(workoutSectionType.name))
                    CreateTextIconButton(
                      text: 'Add Set',
                      loading: creatingSet,
                      onPressed: () => _openWorkoutMoveCreator(context),
                    ),
                  if (kHIITCircuitName == workoutSectionType.name)
                    CreateTextIconButton(
                      text: 'Add Station',
                      loading: creatingSet,
                      onPressed: () => _openWorkoutMoveCreator(context,
                          duration: 60,
                          ignoreReps: true,
                          screenTitle: 'Add Station'),
                    ),
                  if (kHIITCircuitName == workoutSectionType.name)
                    CreateTextIconButton(
                      text: 'Add Rest',
                      loading: creatingSet,
                      onPressed: () => _addRestSet(
                        context,
                        restMove,
                        30,
                      ),
                    ),
                  if (kEMOMName == workoutSectionType.name)
                    CreateTextIconButton(
                      text: 'Add Period',
                      loading: creatingSet,
                      onPressed: () => _openWorkoutMoveCreator(context,
                          duration: 60, screenTitle: 'Add Period'),
                    ),
                  if (kTabataName == workoutSectionType.name)
                    CreateTextIconButton(
                      text: 'Add Set',
                      loading: creatingSet,
                      onPressed: () => _openWorkoutMoveCreator(context,
                          duration: 20, ignoreReps: true),
                    ),
                  if (kTabataName == workoutSectionType.name)
                    CreateTextIconButton(
                      text: 'Add Rest',
                      loading: creatingSet,
                      onPressed: () => _addRestSet(context, restMove, 10),
                    ),
                ],
              ),
            );
          })
    ]);
  }
}
