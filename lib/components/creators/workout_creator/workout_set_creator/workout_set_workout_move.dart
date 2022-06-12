import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/workout/workout_move_display.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class WorkoutSetWorkoutMove extends StatelessWidget {
  @override
  final Key key;
  final double height;
  final WorkoutMove workoutMove;
  final void Function(WorkoutMove workoutMove) openEditWorkoutMove;
  final void Function(int index) duplicateWorkoutMove;
  final void Function(int index) deleteWorkoutMove;
  final bool isLast;
  final bool showReps;
  final bool isPartOfSuperSet;
  const WorkoutSetWorkoutMove(
      {required this.key,
      required this.workoutMove,
      required this.openEditWorkoutMove,
      required this.duplicateWorkoutMove,
      required this.deleteWorkoutMove,
      this.height = kWorkoutMoveListItemHeight,
      this.showReps = true,
      this.isLast = false,
      this.isPartOfSuperSet = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openEditWorkoutMove(workoutMove),

      // child: AnimatedSlidable(
      //   key: key,
      //   index: workoutMove.sortPosition,
      //   itemType: 'Move',
      //   removeItem: deleteWorkoutMove,
      //   secondaryActions: [
      //     SlidableAction(
      //       label: 'Duplicate',
      //       backgroundColor: Styles.primaryAccent,
      //       foregroundColor: Styles.white,
      //       icon: CupertinoIcons.plus_square_on_square,
      //       onPressed: (_) => duplicateWorkoutMove(workoutMove.sortPosition),
      //     ),
      //   ],
      //   child: Container(
      //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      //     decoration: BoxDecoration(
      //         border: isLast
      //             ? null
      //             : Border(
      //                 bottom: BorderSide(
      //                     color: context.theme.primary.withOpacity(0.1)))),
      //     child: WorkoutMoveDisplay(
      //       workoutMove,
      //       showReps: showReps,
      //     ),
      //   ),
      // ),
    );
  }
}
