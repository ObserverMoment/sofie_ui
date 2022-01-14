import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/components/lifetime_log_stats_summary.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class StreakAndStatsSummary extends StatelessWidget {
  const StreakAndStatsSummary({Key? key}) : super(key: key);

  double get _cardHeight => 230.0;

  @override
  Widget build(BuildContext context) {
    final query =
        UserLoggedWorkoutsQuery(variables: UserLoggedWorkoutsArguments());

    return QueryObserver<UserLoggedWorkouts$Query, json.JsonSerializable>(
        key: Key('StreakAndStatsSummary - ${query.operationName}'),
        query: query,
        loadingIndicator: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ShimmerCard(height: _cardHeight),
        ),
        builder: (data) {
          final sessionsLogged = data.userLoggedWorkouts.length;

          final minutesWorked =
              data.userLoggedWorkouts.fold<int>(0, (acum, nextLog) {
                    return acum +
                        nextLog.loggedWorkoutSections.fold<int>(0,
                            (acum, nextSection) {
                          return acum + nextSection.timeTakenSeconds;
                        });
                  }) ~/
                  60;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ContentBox(
                    backgroundColor: context.theme.background,
                    child: Column(
                      children: [
                        const MyText(
                          'All Time',
                          size: FONTSIZE.one,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SummaryStatDisplay(
                              label: 'sessions',
                              number: sessionsLogged,
                            ),
                            const SizedBox(width: 16),
                            SummaryStatDisplay(
                              label: 'minutes',
                              number: minutesWorked,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ContentBox(
                    backgroundColor: context.theme.background,
                    child: Column(
                      children: [
                        const MyText(
                          'Streak',
                          size: FONTSIZE.one,
                        ),
                        const SizedBox(height: 6),
                        StreakDisplay(
                          loggedWorkouts: data.userLoggedWorkouts,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              RecentLogDots(
                loggedWorkouts: data.userLoggedWorkouts,
              ),
            ],
          );
        });
  }
}

/// For the last [numDays] days - is there a loggedWorkout on that day. If there is then fill the dot.
class RecentLogDots extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const RecentLogDots({Key? key, required this.loggedWorkouts})
      : super(key: key);

  final numDays = 28;

  DateTime _getDateXDaysAgo(DateTime now, int days) {
    return DateTime(now.year, now.month, now.day - days);
  }

  Widget _buildRow(
      BuildContext context,
      double dotSize,
      Map<DateTime, List<LoggedWorkout>> logsByDay,
      DateTime now,
      int startDaysAgo) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(7, (i) {
          final hasLogOnDay =
              logsByDay[_getDateXDaysAgo(now, startDaysAgo - i - 1)] != null;
          return Container(
            height: dotSize * 0.6,
            width: dotSize * 0.6,
            margin:
                EdgeInsets.symmetric(horizontal: dotSize * 0.3, vertical: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  hasLogOnDay ? null : context.theme.primary.withOpacity(0.1),
              gradient: hasLogOnDay ? Styles.primaryAccentGradient : null,
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = (MediaQuery.of(context).size.width - 24) / (numDays / 3);

    final now = DateTime.now();
    final startDay = DateTime(now.year, now.month, now.day - numDays);

    final logsByDay = loggedWorkouts
        .where((l) => l.completedOn.isAfter(startDay))
        .groupListsBy((l) => DateTime(
            l.completedOn.year, l.completedOn.month, l.completedOn.day));

    final totalSessions =
        loggedWorkouts.where((l) => l.completedOn.isAfter(startDay)).length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MyText(
            '$totalSessions sessions in the last $numDays days',
          ),
        ),
        _buildRow(context, dotSize, logsByDay, now, 28),
        _buildRow(context, dotSize, logsByDay, now, 21),
        _buildRow(context, dotSize, logsByDay, now, 14),
        _buildRow(context, dotSize, logsByDay, now, 7),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _StreakCalcData {
  // used during the calculation. Increments while counting then resets to zero.
  int streak = 0;
  int current = 0;
  int longest = 0;
  // Once the initial streak - starting yesterday - is completed, mark this as true.
  bool currentDone = false;
}

class StreakDisplay extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  const StreakDisplay({Key? key, required this.loggedWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final logsByDay = loggedWorkouts.groupListsBy((l) =>
        DateTime(l.completedOn.year, l.completedOn.month, l.completedOn.day));

    final bool hasWorkedoutToday =
        logsByDay[DateTime(now.year, now.month, now.day)] != null;

    /// Sometimes the user will have no logs at all...
    final sortedLogDates = logsByDay.keys.sortedBy<DateTime>((k) => k);

    final earliestLogDate =
        sortedLogDates.isEmpty ? null : sortedLogDates.first;

    /// Select a date to work back to to check for streaks.
    /// Use two days before earliest log to allow final loop of the [while] clause below.
    final beforeEarlistLogDate = earliestLogDate != null
        ? DateTime(earliestLogDate.year, earliestLogDate.month,
            earliestLogDate.day - 2)
        : DateTime.now();

    final _StreakCalcData streakData = _StreakCalcData();

    int daysPast = hasWorkedoutToday
        ? 0
        : -1; // Start at yesterday and work backwards, unless they have logged a workout today, in which case start today.

    DateTime day = DateTime(now.year, now.month, now.day + daysPast);

    while (day.isAfter(beforeEarlistLogDate)) {
      if (logsByDay[day] != null) {
        streakData.streak++;
      } else {
        // The streak has ended.
        // Check if this is the end of the most recent streak.
        if (!streakData.currentDone) {
          streakData.current = streakData.streak;
          streakData.currentDone = true;
        }
        // Check if this is the longest streak we have found so far.
        if (streakData.streak > streakData.longest) {
          streakData.longest = streakData.streak;
        }

        // Reset the streak counter.
        streakData.streak = 0;
      }

      /// Move another day into the past.
      daysPast--;
      day = DateTime(now.year, now.month, now.day + daysPast);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        SummaryStatDisplay(
          label: 'current',
          number: streakData.current,
        ),
        const SizedBox(width: 16),
        SummaryStatDisplay(
          label: 'longest',
          number: streakData.longest,
        ),
      ],
    );
  }
}
