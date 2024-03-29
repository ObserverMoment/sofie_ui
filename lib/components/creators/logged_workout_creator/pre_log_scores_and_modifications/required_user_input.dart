import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/workout_structure_modifications_bloc.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/pre_log_scores_and_modifications/score_inputs.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

/// Certain loggedWorkoutSection types require some input from the user before they can be created.
/// i.e. AMRAPs require a score and ForTime requires a time.
/// When we have these kinds of sections we direct the user here first so that they can enter the required data before proceeding.
class RequiredUserInput extends StatelessWidget {
  final WorkoutSectionInput workoutSectionWithInput;
  final void Function(String workoutSectionId, int input) updateSectionInput;
  const RequiredUserInput(
      {Key? key,
      required this.workoutSectionWithInput,
      required this.updateSectionInput})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTimedSection = workoutSectionWithInput.workoutSection.isTimed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (workoutSectionWithInput
                      .workoutSection.workoutSectionType.name ==
                  kAMRAPName)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const MyText(
                            'In a timecap of',
                            size: FONTSIZE.two,
                          ),
                          const SizedBox(width: 5),
                          MyText(
                            Duration(
                                    seconds: workoutSectionWithInput
                                        .workoutSection.timecap)
                                .displayString,
                            weight: FontWeight.bold,
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      RepScoreInput(
                        repScore: workoutSectionWithInput.input,
                        updateRepScore: (score) => updateSectionInput(
                            workoutSectionWithInput.workoutSection.id, score),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 24, top: 6.0, right: 24),
                        child: MyText(
                            'For distance and time based moves each set is worth 1 rep.',
                            maxLines: 3,
                            subtext: true,
                            textAlign: TextAlign.center,
                            size: FONTSIZE.two),
                      )
                    ],
                  ),
                )
              else if (isTimedSection)
                Row(
                  children: [
                    const MyText('You worked for'),
                    const SizedBox(width: 5),
                    MyText(
                      Duration(seconds: workoutSectionWithInput.input!)
                          .displayString,
                      size: FONTSIZE.four,
                      weight: FontWeight.bold,
                    )
                  ],
                )
              else
                TimeTakenInput(
                    duration: workoutSectionWithInput.input != null
                        ? Duration(seconds: workoutSectionWithInput.input!)
                        : null,
                    updateDuration: (duration) => updateSectionInput(
                        workoutSectionWithInput.workoutSection.id,
                        duration.inSeconds)),
            ],
          ),
        )
      ],
    );
  }
}
