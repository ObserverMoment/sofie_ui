import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/main.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/user_max_load_exercise_display_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    final userExerciseLoadTrackers =
        context.select<ExerciseTrackersBloc, List<UserExerciseLoadTracker>>(
            (b) => b.userExerciseLoadTrackers);

    return MyPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  const MySliverNavbar(
                    title: 'Personal Scorebook',
                  ),
                ],
            body: userExerciseLoadTrackers.isEmpty
                ? Center(
                    child: YourContentEmptyPlaceholder(
                        message: 'Track lifting progress over time.',
                        explainer:
                            'Define your trackers here and then your scores will auto update when you log workouts.',
                        actions: [
                          EmptyPlaceholderAction(
                              action: () => context.navigateTo(
                                  const ExerciseLoadTrackerCreatorRoute()),
                              buttonIcon: CupertinoIcons.add,
                              buttonText: 'Create Exercise Load Tracker'),
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
                          onTap: () => context.navigateTo(
                              const ExerciseLoadTrackerCreatorRoute()))
                    ],
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 80),
                        shrinkWrap: true,
                        children: userExerciseLoadTrackers
                            .map(
                                (t) => MaxLoadExerciseDisplayWidget(tracker: t))
                            .toList()),
                  )));
  }
}
