import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

String? getWorkoutSetDefinitionText(int length) {
  return length == 1
      ? 'SET'
      : length == 2
          ? 'SUPERSET'
          : length == 3
              ? 'TRISET'
              : length >= 4
                  ? 'GIANTSET'
                  : null;
}

/// [set], [superset], [giantset] etc.
class WorkoutSetDefinition extends StatelessWidget {
  final WorkoutSet workoutSet;
  const WorkoutSetDefinition({Key? key, required this.workoutSet})
      : super(key: key);

  Widget _supersetText(String text) => MyText(
        text,
        size: FONTSIZE.one,
        weight: FontWeight.bold,
        color: Styles.primaryAccent,
        lineHeight: 1,
      );

  @override
  Widget build(BuildContext context) {
    final int length = 4;

    return length == 1
        ? false
            ? const MyText(
                'REST',
                lineHeight: 1,
                size: FONTSIZE.four,
              )
            : _supersetText(
                'SET',
              )
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
