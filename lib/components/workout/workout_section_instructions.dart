import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Builds a sentence explaining if the section as a whole should be repeated, how many times, and for how long.
/// Based on [WorkoutSectionType], [Rounds], [Timecap]
/// E.g AMRAP: Repeat this as many times as you can for [timecap].
class WorkoutSectionInstructions extends StatelessWidget {
  final String typeName;
  final int rounds;
  final int? timecap;
  const WorkoutSectionInstructions(
      {Key? key, required this.typeName, required this.rounds, this.timecap})
      : assert(
            (typeName == kAMRAPName && timecap != null) ||
                typeName != kAMRAPName,
            'AMRAP requires a timecap, so it cannot be null.'),
        super(key: key);

  String _getRoundsText() => '$rounds time${rounds == 1 ? "" : "s"}';

  String _buildInstructionText() {
    switch (typeName) {
      case kCustomSessionName:
      case kEMOMName:
      case kHIITCircuitName:
      case kTabataName:
        return 'Complete all sets ${_getRoundsText()}.';
      case kForTimeName:
        return 'Complete all sets ${_getRoundsText()}, as fast as possible.';
      case kAMRAPName:
        return 'Complete as many reps as possible in ${timecap!.secondsToTimeDisplay}.';
      case kLiftingName:
        return '';
      default:
        throw Exception(
            'WorkoutSectionInstructions: $typeName is not a valid typename.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: MyText(
            _buildInstructionText(),
            maxLines: 3,
            textAlign: TextAlign.center,
            lineHeight: 1.4,
          ),
        )
      ],
    );
  }
}
