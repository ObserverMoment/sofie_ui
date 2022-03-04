import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/main.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/fastest_time_trackers/user_fastest_time_exercise_display_widget.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/max_load_tracker/user_max_load_exercise_display_widget.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/max_unbroken_trackers/user_max_unbroken_exercise_display_widget.dart';
import 'package:sofie_ui/router.gr.dart';

class PersonalScoresPage extends StatelessWidget {
  const PersonalScoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => ExerciseTrackersBloc(c),
      builder: (context, child) {
        final initialized =
            context.select<ExerciseTrackersBloc, bool>((b) => b.initialized);

        return !initialized ? const GlobalLoadingPage() : const _TrackersUI();
      },
    );
  }
}

class _TrackersUI extends StatelessWidget {
  const _TrackersUI({Key? key}) : super(key: key);

  void _openCreateTrackerSelectType(BuildContext context) {
    openBottomSheetMenu(
        context: context,
        child: BottomSheetMenu(items: [
          BottomSheetMenuItem(
              text: 'Max Lift / Max Load',
              onPressed: () => _openMaxLoadExerciseTrackerCreator(context)),
          BottomSheetMenuItem(
              text: 'Fastest Time',
              onPressed: () => _openFastestExerciseTrackerCreator(context)),
          BottomSheetMenuItem(
              text: 'Max Unbroken',
              onPressed: () => _openMaxUnbrokenExerciseTrackerCreator(context)),
        ]));
  }

  void _openMaxLoadExerciseTrackerCreator(BuildContext context) {
    context.navigateTo(const MaxLoadTrackerCreatorRoute());
  }

  void _openFastestExerciseTrackerCreator(BuildContext context) {
    context.navigateTo(const FastestTimeTrackerCreatorRoute());
  }

  void _openMaxUnbrokenExerciseTrackerCreator(BuildContext context) {
    context.navigateTo(const MaxUnbrokenTrackerCreatorRoute());
  }

  @override
  Widget build(BuildContext context) {
    final userMaxLoadExerciseTrackers =
        context.select<ExerciseTrackersBloc, List<UserMaxLoadExerciseTracker>>(
            (b) => b.userMaxLoadExerciseTrackers);

    final userFastestTimeExerciseTrackers = context
        .select<ExerciseTrackersBloc, List<UserFastestTimeExerciseTracker>>(
            (b) => b.userFastestTimeExerciseTrackers);

    final userMaxUnbrokenExerciseTrackers = context
        .select<ExerciseTrackersBloc, List<UserMaxUnbrokenExerciseTracker>>(
            (b) => b.userMaxUnbrokenExerciseTrackers);

    final noTrackers = userMaxLoadExerciseTrackers.isEmpty &&
        userFastestTimeExerciseTrackers.isEmpty &&
        userMaxUnbrokenExerciseTrackers.isEmpty;

    return MyPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  const MySliverNavbar(
                    title: 'Personal Scorebook',
                  ),
                ],
            body: noTrackers
                ? Center(
                    child: YourContentEmptyPlaceholder(
                        message: 'Create widgets to track your scores!',
                        explainer:
                            'You can track things like scored workouts, max lifts, fastest times and max unbroken movements. Define your trackers here and then your scores will auto update when you log workouts, or you can add manual score entries complete with videos.',
                        actions: [
                          EmptyPlaceholderAction(
                              action: () =>
                                  _openCreateTrackerSelectType(context),
                              buttonIcon: CupertinoIcons.add,
                              buttonText: 'Create Score Tracker'),
                        ]),
                  )
                : FABPage(
                    rowButtons: [
                      FloatingButton(
                          text: 'Create New Tracker',
                          icon: CupertinoIcons.plus,
                          iconSize: 20,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                          onTap: () => _openCreateTrackerSelectType(context))
                    ],
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 80),
                        shrinkWrap: true,
                        children: [
                          ...userMaxLoadExerciseTrackers.map(
                              (t) => MaxLoadExerciseDisplayWidget(tracker: t)),
                          ...userFastestTimeExerciseTrackers.map((t) =>
                              FastestTimeExerciseDisplayWidget(tracker: t)),
                          ...userMaxUnbrokenExerciseTrackers.map((t) =>
                              MaxUnbrokenExerciseDisplayWidget(tracker: t)),
                        ]),
                  )));
  }
}
