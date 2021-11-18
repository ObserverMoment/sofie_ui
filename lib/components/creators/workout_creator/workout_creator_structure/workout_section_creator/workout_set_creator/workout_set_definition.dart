import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// [set], [superset], [giantset] etc.
class WorkoutSetDefinition extends StatelessWidget {
  final WorkoutSet workoutSet;
  const WorkoutSetDefinition({Key? key, required this.workoutSet})
      : super(key: key);

  Widget _supersetText(String text) => MyText(
        text,
        subtext: true,
        size: FONTSIZE.one,
        weight: FontWeight.bold,
        lineHeight: 1,
      );

  @override
  Widget build(BuildContext context) {
    final int length = workoutSet.workoutMoves.length;

    return length == 1
        ? workoutSet.isRestSet
            ? const MyText(
                'REST',
                lineHeight: 1,
                size: FONTSIZE.four,
              )
            : Container()
        : length > 3
            ? _supersetText(
                'GIANTSET',
              )
            : length == 3
                ? _supersetText(
                    'TRISET',
                  )
                : length == 2
                    ? _supersetText(
                        'SUPERSET',
                      )
                    : Container();
  }
}
