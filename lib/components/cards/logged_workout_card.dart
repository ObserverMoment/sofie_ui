import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class LoggedWorkoutCard extends StatelessWidget {
  final LoggedWorkout loggedWorkout;

  const LoggedWorkoutCard({Key? key, required this.loggedWorkout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedSections = loggedWorkout.loggedWorkoutSections
        .sortedBy<num>((s) => s.sortPosition);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                loggedWorkout.completedOn.compactDateString,
              ),
              CompactTimerIcon(duration: loggedWorkout.totalSessionTime),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MyHeaderText(
                  loggedWorkout.name,
                  weight: FontWeight.normal,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (Utils.textNotNull(loggedWorkout.note))
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MyText(
                loggedWorkout.note!,
                size: FONTSIZE.two,
                maxLines: 3,
                lineHeight: 1.3,
              ),
            ),
          if (sortedSections.isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CommaSeparatedList(
                  sortedSections
                      .map((wSection) => wSection.nameOrType)
                      .toList(),
                )),
          if (loggedWorkout.workoutGoals.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CommaSeparatedList(
                loggedWorkout.workoutGoals.map((g) => g.name).toList(),
                textColor: Styles.primaryAccent,
              ),
            ),
          const HorizontalLine(),
        ],
      ),
    );
  }
}
