import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class WorkoutPlanEnrolmentProgressSummary extends StatelessWidget {
  final DateTime startedOn;
  final int total;
  final int completed;

  const WorkoutPlanEnrolmentProgressSummary(
      {Key? key,
      required this.total,
      required this.completed,
      required this.startedOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyText(
                'Started on',
                size: FONTSIZE.one,
                lineHeight: 1.5,
              ),
              MyText(
                startedOn.compactDateString,
                size: FONTSIZE.two,
              ),
            ],
          ),
        ),
        if (total > 0)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyText(
                        '$completed of $total workouts complete',
                        size: FONTSIZE.two,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  LinearPercentIndicator(
                    percent: (completed / total).clamp(0.0, 1.0),
                    lineHeight: 4,
                    padding: const EdgeInsets.only(left: 8),
                    backgroundColor: context.theme.primary.withOpacity(0.3),
                    progressColor: Styles.secondaryAccent,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
