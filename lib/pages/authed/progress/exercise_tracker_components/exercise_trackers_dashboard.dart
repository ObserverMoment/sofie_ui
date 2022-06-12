import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/user_max_load_exercise_display_widget.dart';
import 'package:sofie_ui/router.gr.dart';

class ExerciseTrackersDashboard extends StatelessWidget {
  const ExerciseTrackersDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userExerciseLoadTrackers =
        context.select<ExerciseTrackersBloc, List<UserExerciseLoadTracker>>(
            (b) => b.userExerciseLoadTrackers);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(
                'Exercise Trackers',
                size: FONTSIZE.five,
                weight: FontWeight.bold,
              ),
              // TertiaryButton(
              //     prefixIconData: CupertinoIcons.plus,
              //     text: 'Tracker',
              //     onPressed: () => context
              //         .navigateTo(const ExerciseLoadTrackerCreatorRoute())),
            ],
          ),
        ),
        userExerciseLoadTrackers.isEmpty
            ? Center(
                child: ContentEmptyPlaceholder(
                    message: 'Track lifting progress over time.',
                    explainer:
                        'Define your trackers here and then your scores will auto update when you log workouts.',
                    actions: [
                      // EmptyPlaceholderAction(
                      //     action: () => context.navigateTo(
                      //         const ExerciseLoadTrackerCreatorRoute()),
                      //     buttonIcon: CupertinoIcons.add,
                      //     buttonText: 'Create Exercise Load Tracker'),
                    ]),
              )
            : GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                padding: const EdgeInsets.only(
                    left: 4, right: 4, top: 4, bottom: 24),
                shrinkWrap: true,
                children: userExerciseLoadTrackers
                    .map((t) => MaxLoadExerciseDisplayWidget(tracker: t))
                    .toList())
      ],
    );
  }
}
