import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/components/streak_summary_display.dart';
import 'package:sofie_ui/pages/authed/progress/components/summary_stat_display.dart';
import 'package:stream_feed/stream_feed.dart';

class AllTimeStatsSummary extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const AllTimeStatsSummary({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionsLogged = loggedWorkouts.length;

    final minutesWorked = loggedWorkouts.fold<int>(0, (acum, nextLog) {
          return acum +
              nextLog.loggedWorkoutSections.fold<int>(0, (acum, nextSection) {
                return acum + nextSection.timeTakenSeconds;
              });
        }) ~/
        60;

    final backgroundColor = context.theme.background.withOpacity(0.7);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              const MyText(
                'All Time',
                size: FONTSIZE.one,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SummaryStatDisplay(
                    backgroundColor: backgroundColor,
                    label: 'sessions',
                    number: sessionsLogged,
                  ),
                  const SizedBox(width: 16),
                  SummaryStatDisplay(
                    backgroundColor: backgroundColor,
                    label: 'minutes',
                    number: minutesWorked,
                  ),
                ],
              ),
            ],
          ),
        ),
        Card(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              const MyText(
                'Streak',
                size: FONTSIZE.one,
              ),
              const SizedBox(height: 4),
              StreakDisplay(
                backgroundColor: backgroundColor,
                loggedWorkouts: loggedWorkouts,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
