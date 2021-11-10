import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/display_utils.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

/// Displays the next 5 (max) scheduled workouts and events horizontally.
/// Scrollable forward / backward in time.
class ComingUpList extends StatelessWidget {
  double get kListHeight => 100.0;

  const ComingUpList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return QueryObserver<UserScheduledWorkouts$Query, json.JsonSerializable>(
        key:
            Key('ComingUpList - ${UserScheduledWorkoutsQuery().operationName}'),
        query: UserScheduledWorkoutsQuery(),
        loadingIndicator: ShimmerCard(
          height: kListHeight,
        ),
        builder: (data) {
          final comingUp = data.userScheduledWorkouts
              .sortedBy<DateTime>((s) => s.scheduledAt)
              .where((s) => s.scheduledAt.isAfter(DateTime.now()))
              .where((s) => s.workout != null)
              .take(5)
              .toList();

          final cardWidth = DisplayUtils.horizontalListItemWidth(
              context: context, targetWidth: 150, idealOverhang: 60);

          final bool noPlans = comingUp.isEmpty;

          return SizedBox(
            height: kListHeight,
            child: noPlans
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: SecondaryButton(
                          prefixIconData: CupertinoIcons.calendar_badge_plus,
                          text: 'Plan Something',
                          onPressed: () => context.navigateTo(
                              YourScheduleRoute(openAtDate: DateTime.now())),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: comingUp.length,
                    itemBuilder: (c, i) {
                      return GestureDetector(
                        onTap: () => context.navigateTo(YourScheduleRoute(
                            openAtDate: comingUp[i].scheduledAt)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: ScheduledWorkoutReminderCard(
                            scheduledWorkout: comingUp[i],
                            cardWidth: cardWidth,
                          ),
                        ),
                      );
                    }),
          );
        });
  }
}

class ScheduledWorkoutReminderCard extends StatelessWidget {
  final ScheduledWorkout scheduledWorkout;
  final double cardWidth;
  const ScheduledWorkoutReminderCard(
      {Key? key, required this.scheduledWorkout, required this.cardWidth})
      : super(key: key);

  BorderRadius get borderRadius => BorderRadius.circular(12);
  Radius get radius => const Radius.circular(12);
  Dimensions get dimensions => Dimensions.square((400).toInt());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Card(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.primary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(kCardBorderRadiusValue),
                    topRight: Radius.circular(kCardBorderRadiusValue)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                      scheduledWorkout.scheduledAt.isToday
                          ? 'Today at '
                          : scheduledWorkout.scheduledAt.isTomorrow
                              ? 'Tomorrow at '
                              : '${scheduledWorkout.scheduledAt.minimalDateString} at ',
                      color: context.theme.background),
                  MyText(scheduledWorkout.scheduledAt.timeString,
                      color: context.theme.background),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(kCardBorderRadiusValue),
                        bottomRight: Radius.circular(kCardBorderRadiusValue)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Utils.textNotNull(
                                scheduledWorkout.workout?.coverImageUri)
                            ? UploadcareImageProvider(
                                scheduledWorkout.workout!.coverImageUri!,
                                transformations: [
                                    PreviewTransformation(dimensions)
                                  ])
                            : const AssetImage(
                                'assets/placeholder_images/workout.jpg',
                              ) as ImageProvider)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContentBox(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 16),
                      backgroundColor: Styles.black.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MyText(
                              scheduledWorkout.workout!.name,
                              textAlign: TextAlign.center,
                              lineHeight: 1.3,
                              maxLines: 2,
                              color: Styles.white,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (scheduledWorkout.gymProfile != null)
                      ContentBox(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 12),
                        backgroundColor: Styles.black.withOpacity(0.65),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              scheduledWorkout.gymProfile!.name,
                              textAlign: TextAlign.center,
                              color: Styles.secondaryAccent,
                              size: FONTSIZE.two,
                              lineHeight: 1.3,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
