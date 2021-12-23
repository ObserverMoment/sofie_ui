import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/score_inputs.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';

/// Certain loggedWorkoutSection types require some input from the user before they can be created.
/// i.e. AMRAPs require a score and ForTime requires a time.
/// When we have these kinds of sections we direct the user here first so that they can enter the required data before proceeding.
class RequiredUserInputs extends StatefulWidget {
  const RequiredUserInputs({Key? key}) : super(key: key);

  @override
  _RequiredUserInputsState createState() => _RequiredUserInputsState();
}

class _RequiredUserInputsState extends State<RequiredUserInputs> {
  late LoggedWorkoutCreatorBloc _bloc;

  /// Sorted by sort order.
  late List<WorkoutSectionWithInput> _sectionsRequiringInput;

  @override
  void initState() {
    _bloc = context.read<LoggedWorkoutCreatorBloc>();

    /// RequiredUserInput flow is only for creating a log, so [workout] must be non null.
    ///
    _sectionsRequiringInput = _bloc.workout!.workoutSections
        .where(
            (w) => _bloc.typesInputRequired.contains(w.workoutSectionType.name))
        .sortedBy<num>((ws) => ws.sortPosition)
        .map((ws) => WorkoutSectionWithInput(workoutSection: ws))
        .toList();

    super.initState();
  }

  void _updateSectionInput(String workoutSectionId, int input) {
    setState(() {
      _sectionsRequiringInput = _sectionsRequiringInput
          .map((original) => original.workoutSection.id == workoutSectionId
              ? WorkoutSectionWithInput(
                  workoutSection: original.workoutSection, input: input)
              : original)
          .toList();
    });
  }

  bool get _validToProceed =>
      _sectionsRequiringInput.every((s) => s.input != null && s.input != 0);

  void _generateLoggedWorkoutSections() {
    _bloc.generateLoggedWorkoutSections(_sectionsRequiringInput);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserInputContainer(
          child: SizedBox(
            height: 26,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MyText(
                  'Submit Scores / Times',
                  size: FONTSIZE.five,
                ),
                if (_validToProceed)
                  FadeIn(
                      child: TextButton(
                          onPressed: _generateLoggedWorkoutSections,
                          text: 'Next',
                          underline: false,
                          padding: const EdgeInsets.symmetric(horizontal: 16)))
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: _sectionsRequiringInput
                .map((w) => Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ContentBox(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyHeaderText(
                            w.workoutSection.name ??
                                'Section ${w.workoutSection.sortPosition + 1}',
                            lineHeight: 1.5,
                          ),
                          MyText(
                            w.workoutSection.workoutSectionType.name,
                            color: Styles.primaryAccent,
                            lineHeight: 1.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (w.workoutSection.workoutSectionType.name ==
                                    kAMRAPName)
                                  RepScoreInput(
                                    repScore: w.input,
                                    updateRepScore: (score) =>
                                        _updateSectionInput(
                                            w.workoutSection.id, score),
                                  )
                                else
                                  TimeTakenInput(
                                      showSeconds: w.workoutSection
                                              .workoutSectionType.name ==
                                          kForTimeName,
                                      duration: w.input != null
                                          ? Duration(seconds: w.input!)
                                          : null,
                                      updateDuration: (duration) =>
                                          _updateSectionInput(
                                              w.workoutSection.id,
                                              duration.inSeconds)),
                              ],
                            ),
                          )
                        ],
                      )),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
