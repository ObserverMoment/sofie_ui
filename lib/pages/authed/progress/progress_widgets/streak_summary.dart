import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_picker_modal.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/profile/edit_profile_page.dart';
import 'package:sofie_ui/services/utils.dart';

class StreaksSummaryWidget extends StatelessWidget {
  final List<LoggedWorkout> loggedWorkouts;
  final UserProfile userProfile;
  const StreaksSummaryWidget(
      {Key? key, required this.loggedWorkouts, required this.userProfile})
      : super(key: key);

  Future<void> _openWeeklyTargetSelector(
      BuildContext context, int? prevTarget) async {
    context.showActionSheetPopup(
        child: NumberPickerModal(
      initialValue: prevTarget ?? 3,
      min: 1,
      max: 28,
      saveValue: (value) => _updateWeeklyWorkoutTarget(context, value),
      title: 'Workouts Per Week Target',
    ));
  }

  Future<void> _updateWeeklyWorkoutTarget(
      BuildContext context, int workoutsPerWeekTarget) async {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    await EditProfilePage.updateUserFields(context, authedUserId,
        {'workoutsPerWeekTarget': workoutsPerWeekTarget});
  }

  /// Get the date of the nearest past Monday of [date].
  DateTime _mondayBeforeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day - date.weekday + 1);

  int get _weekStreakCount {
    final perWeekTarget = userProfile.workoutsPerWeekTarget;

    if (perWeekTarget == null) {
      printLog(
          'Sorry, cannot calculate a week streak number without [perWeekTarget] value');
      return 0;
    }

    /// Group logs by week by assigning them to key of the nearest past Monday via [_mondayBeforeDate]
    final logsByWeek =
        loggedWorkouts.groupListsBy((l) => _mondayBeforeDate(l.completedOn));

    int weekStreakCount = 0;

    final now = DateTime.now();

    /// Start checking from the most recent Sunday (i.e. the first week to consider is "last" week) to the previous Monday and then move back both days one week at a time to check each preceeding week.
    DateTime mondayCursor =
        DateTime(now.year, now.month, now.day - 7 - (now.weekday - 1));

    while (true) {
      final logs = logsByWeek[mondayCursor];

      if (logs != null && logs.length >= perWeekTarget) {
        weekStreakCount++;
        mondayCursor = DateTime(
            mondayCursor.year, mondayCursor.month, mondayCursor.day - 7);
      } else {
        break;
      }
    }

    return weekStreakCount;
  }

  int get _dailyStreakCount {
    final now = DateTime.now();

    final logsByDate = loggedWorkouts.groupListsBy((l) =>
        DateTime(l.completedOn.year, l.completedOn.month, l.completedOn.day));

    final today = DateTime(now.year, now.month, now.day);

    final bool hasWorkedoutToday = logsByDate[today] != null;

    /// Start from yesterday.
    DateTime dateCursor = today.subtract(const Duration(days: 1));
    int dayStreakCount = hasWorkedoutToday ? 1 : 0;

    while (true) {
      final logs = logsByDate[dateCursor];

      if (logs != null && logs.isNotEmpty) {
        dayStreakCount++;
        dateCursor = dateCursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return dayStreakCount;
  }

  @override
  Widget build(BuildContext context) {
    final daily = _dailyStreakCount;
    final weekly = _weekStreakCount;
    final perWeekTarget = userProfile.workoutsPerWeekTarget;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatContainer(
              count: daily,
              label: 'Days in a Row',
            ),
            _StatContainer(
              count: weekly,
              label: 'Weeks On Target',
            ),
          ],
        ),
        const SizedBox(height: 8),
        TertiaryButton(
            backgroundColor: context.theme.background,
            prefixIconData: CupertinoIcons.scope,
            text: perWeekTarget != null
                ? '$perWeekTarget workouts / week'
                : 'Set Weekly Target',
            onPressed: () => _openWeeklyTargetSelector(
                  context,
                  perWeekTarget,
                ))
      ],
    );
  }
}

class _StatContainer extends StatelessWidget {
  final int count;
  final String label;
  const _StatContainer({
    Key? key,
    required this.count,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.background.withOpacity(0.45);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const SizedBox(height: 6),
          MyHeaderText(
            label,
            size: FONTSIZE.one,
            weight: FontWeight.normal,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyText(
              count == 0 ? '-' : count.toString(),
              size: FONTSIZE.eight,
              color: Styles.secondaryAccent,
            ),
          ),
        ],
      ),
    );
  }
}
