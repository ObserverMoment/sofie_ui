import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

/// Displays the next 5 (max) scheduled workouts and events horizontally.
/// Scrollable forward / backward in time.
class ComingUpList extends StatelessWidget {
  const ComingUpList({Key? key}) : super(key: key);

  double get _cardHeight => 124.0;

  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserScheduledWorkouts$Query, json.JsonSerializable>(
        key:
            Key('ComingUpList - ${UserScheduledWorkoutsQuery().operationName}'),
        query: UserScheduledWorkoutsQuery(),
        loadingIndicator: Container(),
        builder: (data) {
          final comingUp = data.userScheduledWorkouts
              .sortedBy<DateTime>((s) => s.scheduledAt)
              .where((s) =>
                  s.workout != null &&
                  // Don't show scheduled workouts the user has already done.
                  s.loggedWorkoutId == null &&
                  s.scheduledAt.isAfter(DateTime.now()))
              .take(5)
              .toList();

          if (comingUp.isEmpty) return Container();

          return GrowIn(
            child: SizedBox(
              height: _cardHeight + 8,
              child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: comingUp.length,
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      onTap: () => context.navigateTo(WorkoutDetailsRoute(
                          id: comingUp[i].workout!.id,
                          scheduledWorkout: comingUp[i],
                          workoutPlanDayWorkoutId:
                              comingUp[i].workoutPlanDayWorkoutId,
                          workoutPlanEnrolmentId:
                              comingUp[i].workoutPlanEnrolmentId)),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: _ScheduledWorkoutReminderCard(
                          scheduledWorkout: comingUp[i],
                          cardHeight: _cardHeight,
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }
}

class _ScheduledWorkoutReminderCard extends StatelessWidget {
  final ScheduledWorkout scheduledWorkout;
  final double cardHeight;
  const _ScheduledWorkoutReminderCard(
      {Key? key, required this.scheduledWorkout, required this.cardHeight})
      : super(key: key);

  String get _dateString => scheduledWorkout.scheduledAt.isToday
      ? 'Today'
      : scheduledWorkout.scheduledAt.isTomorrow
          ? 'Tomorrow'
          : scheduledWorkout.scheduledAt.minimalDateString;

  BorderRadius get borderRadius => BorderRadius.circular(12);
  Radius get radius => const Radius.circular(12);
  Dimensions get dimensions => Dimensions.square((400).toInt());

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 230),
      child: Card(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            scheduledWorkout.workout?.name ?? 'Workout',
            maxLines: 2,
            lineHeight: 1.3,
          ),
          const SizedBox(height: 5),
          if (scheduledWorkout.gymProfile != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: MyText(
                scheduledWorkout.gymProfile!.name,
                size: FONTSIZE.two,
                subtext: true,
              ),
            ),
          MyText(
            '$_dateString ${scheduledWorkout.scheduledAt.timeString}',
            lineHeight: 1.3,
            size: FONTSIZE.two,
            color: Styles.primaryAccent,
          )
        ],
      )),
    );
  }
}
