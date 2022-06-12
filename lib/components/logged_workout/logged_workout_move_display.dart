import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/data_model_converters/workout_to_logged_workout.dart';
import 'package:sofie_ui/services/utils.dart';

class LoggedWorkoutMoveDisplay extends StatelessWidget {
  final WorkoutSectionType workoutSectionType;
  final LoggedWorkoutSet loggedWorkoutSet;
  final LoggedWorkoutMove loggedWorkoutMove;
  final bool displayEquipment;
  final bool displayLoad;
  const LoggedWorkoutMoveDisplay(
      {Key? key,
      required this.loggedWorkoutMove,
      required this.workoutSectionType,
      required this.loggedWorkoutSet,
      this.displayEquipment = true,
      this.displayLoad = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Don't need reps for timed sets with only one move in.
    final reps = '';

    final equipment = displayEquipment && loggedWorkoutMove.equipment != null
        ? loggedWorkoutMove.equipment!.name
        : '';

    final load = 'fff';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText('${loggedWorkoutMove.move.name} $reps'),
        if (Utils.textNotNull(equipment) || Utils.textNotNull(load))
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: MyText(
              '$load${load != "" ? " " : ""}$equipment',
              color: Styles.primaryAccent,
              size: FONTSIZE.two,
            ),
          ),
      ],
    );
  }
}
