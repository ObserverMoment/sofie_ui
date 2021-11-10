import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/do_workout/do_workout_section/components/rep_score_display.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class NameAndRepScore extends StatelessWidget {
  final WorkoutSection workoutSection;
  const NameAndRepScore({Key? key, required this.workoutSection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          workoutSection.workoutSectionType.name.toUpperCase(),
          size: workoutSection.isScored ? FONTSIZE.three : FONTSIZE.four,
        ),
        if (workoutSection.isScored)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: RepScoreDisplay(
              sectionIndex: workoutSection.sortPosition,
              fontSize: FONTSIZE.five,
            ),
          ),
      ],
    );
  }
}
