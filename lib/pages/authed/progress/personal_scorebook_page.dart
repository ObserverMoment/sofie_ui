import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/user_max_load_exercise_display_widget.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/user_fitness_benchmarks_list.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/core_data_repo.dart';

class PersonalScoresPage extends StatelessWidget {
  const PersonalScoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Personal Scorebook'),
      ),
      child: ListView(
        children: [
          _FitnessBenchmarksUI(),
          const SizedBox(height: 24),
          ChangeNotifierProvider(
            create: (c) => ExerciseTrackersBloc(c),
            builder: (context, child) {
              final initialized = context
                  .select<ExerciseTrackersBloc, bool>((b) => b.initialized);

              return !initialized
                  ? const CupertinoActivityIndicator()
                  : const _TrackersUI();
            },
          ),
        ],
      ),
    );
  }
}

class _FitnessBenchmarksUI extends StatelessWidget {
  const _FitnessBenchmarksUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fitnessBenchmarkCategories = CoreDataRepo.fitnessBenchmarkCategories;

    /// TODO: Get users 'active' benchmarks + top scores
    /// Display in a grid?

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(
                'Fitness Benchmarks',
                size: FONTSIZE.six,
                weight: FontWeight.bold,
              ),
              TertiaryButton(
                  text: 'View All',
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  onPressed: () =>
                      context.push(child: const UserFitnessBenchmarksList())),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyText('Active Benchmarks Display'),
        )
      ],
    );
  }
}

class _FitnessBenchmarkCategoryUI extends StatelessWidget {
  final FitnessBenchmarkCategory fitnessBenchmarkCategory;
  final List<FitnessBenchmark> fitnessBenchmarks;
  const _FitnessBenchmarkCategoryUI(
      {Key? key,
      required this.fitnessBenchmarkCategory,
      required this.fitnessBenchmarks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      child: Column(
        children: [
          MyText(fitnessBenchmarkCategory.name),
        ],
      ),
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(
                'Exercise Trackers',
                size: FONTSIZE.six,
                weight: FontWeight.bold,
              ),
              TertiaryButton(
                  prefixIconData: CupertinoIcons.plus,
                  text: 'Tracker',
                  onPressed: () => context
                      .navigateTo(const ExerciseLoadTrackerCreatorRoute())),
            ],
          ),
        ),
        userExerciseLoadTrackers.isEmpty
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
            : GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 4, bottom: 80),
                shrinkWrap: true,
                children: userExerciseLoadTrackers
                    .map((t) => MaxLoadExerciseDisplayWidget(tracker: t))
                    .toList())
      ],
    );
  }
}
