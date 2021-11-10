import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/amrap_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/controllers/fortime_section_controller.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';

/// Will error if section at [sectionIndex] is not of the type ForTime or AMRAP!
class RepScoreDisplay extends StatelessWidget {
  final int sectionIndex;
  final FONTSIZE fontSize;
  const RepScoreDisplay(
      {Key? key, required this.sectionIndex, this.fontSize = FONTSIZE.four})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workoutSectionTypeName = context.select<DoWorkoutBloc, String>((b) =>
        b.activeWorkout.workoutSections[sectionIndex].workoutSectionType.name);

    int? score;
    int? total;

    if (workoutSectionTypeName == kForTimeName) {
      score = context.select<DoWorkoutBloc, int>((b) =>
          (b.getControllerForSection(sectionIndex) as ForTimeSectionController)
              .repsCompleted);
      total = context.select<DoWorkoutBloc, int>((b) =>
          (b.getControllerForSection(sectionIndex) as ForTimeSectionController)
              .totalRepsToComplete);
    } else {
      // Must be an AMRAP!
      score = context.select<DoWorkoutBloc, int>((b) =>
          (b.getControllerForSection(sectionIndex) as AMRAPSectionController)
              .repsCompleted);
    }

    return SizeFadeIn(
        key: Key(score.toString()),
        child: MyText(
          workoutSectionTypeName == kForTimeName
              ? '$score / $total'
              : '$score reps',
          size: fontSize,
          weight: FontWeight.bold,
        ));
  }
}
