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
import 'package:sofie_ui/generated/api/graphql_api.dart';

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
                      child: RequiredUserInput(
                        updateSectionInput: _updateSectionInput,
                        workoutSectionWithInput: w,
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}

class RequiredUserInput extends StatelessWidget {
  final WorkoutSectionWithInput workoutSectionWithInput;
  final void Function(String workoutSectionId, int input) updateSectionInput;
  const RequiredUserInput(
      {Key? key,
      required this.workoutSectionWithInput,
      required this.updateSectionInput})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyHeaderText(
          workoutSectionWithInput.workoutSection.name ??
              'Section ${workoutSectionWithInput.workoutSection.sortPosition + 1}',
          lineHeight: 1.5,
        ),
        MyText(
          workoutSectionWithInput.workoutSection.workoutSectionType.name,
          color: Styles.primaryAccent,
          lineHeight: 1.5,
        ),
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
                      RepScoreInput(
                        repScore: workoutSectionWithInput.input,
                        updateRepScore: (score) => updateSectionInput(
                            workoutSectionWithInput.workoutSection.id, score),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 24, top: 6.0, right: 24),
                        child: MyText(
                          'For distance and time based moves each move in the set is worth 1 rep.',
                          maxLines: 3,
                          subtext: true,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              else
                TimeTakenInput(
                    showSeconds: workoutSectionWithInput
                            .workoutSection.workoutSectionType.name ==
                        kForTimeName,
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
    ));
  }
}
