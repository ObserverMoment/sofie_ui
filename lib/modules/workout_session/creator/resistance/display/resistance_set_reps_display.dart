import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class RepsDisplay extends StatelessWidget {
  final ResistanceSet resistanceSet;
  final FONTSIZE fontSize;
  const RepsDisplay(
      {Key? key, required this.resistanceSet, this.fontSize = FONTSIZE.three})
      : super(key: key);

  String get _buildCombinedRepsString => resistanceSet.reps.join(' | ');

  @override
  Widget build(BuildContext context) {
    final reps = resistanceSet.reps;
    final equalReps = reps.every((r) => r == reps[0]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        equalReps
            ? MyText(
                '${reps.length} x ${reps[0]}',
                size: fontSize,
              )
            : MyText(
                _buildCombinedRepsString,
                maxLines: 2,
                size: fontSize,
                lineHeight: 1.2,
              ),
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: MyText(
            resistanceSet.repType.display.toUpperCase(),
            subtext: true,
            size: FONTSIZE.two,
          ),
        )
      ],
    );
  }
}
