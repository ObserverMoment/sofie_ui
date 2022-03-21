import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/active_settings_and_benchmarks_container.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/fitness_benchmark_dashboard_display_widget.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/fitness_benchmark_actions_menu.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/user_fitness_benchmarks_list.dart';

/// Must be in [context] which has an active [ExerciseTrackersBloc] in scope.
class FitnessBenchmarksDashboard extends StatelessWidget {
  const FitnessBenchmarksDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActiveSettingsAndBenchmarksContainer(
      builder: (activeBenchmarkIds, benchmarks) {
        /// Handles the situation where a user deletes a CUSTOM fitness benchmark which is also active on their dashboard. The API will clean up the User.activeFitnessBenchmarks data but this will not automatically reflect in the UI. For now we fix like this pending a better solution.
        final activeAndPresentBenchmarkIds = activeBenchmarkIds
            .where((id) => benchmarks.any((b) => b.id == id))
            .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyText(
                    'Benchmark Scores',
                    size: FONTSIZE.five,
                    weight: FontWeight.bold,
                  ),
                  TertiaryButton(
                      text: 'View All',
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      onPressed: () => context.push(
                          child: const UserFitnessBenchmarksList())),
                ],
              ),
            ),
            activeAndPresentBenchmarkIds.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: const [
                        MyText('No Benchmarks Activated'),
                        MyText(
                          'Tap "View All" to select',
                          size: FONTSIZE.two,
                          subtext: true,
                        ),
                      ],
                    ),
                  )
                : GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    padding: const EdgeInsets.only(
                        left: 4, right: 4, top: 4, bottom: 16),
                    shrinkWrap: true,
                    children: activeAndPresentBenchmarkIds.map((id) {
                      final benchmark =
                          benchmarks.firstWhere((b) => b.id == id);

                      return FitnessBenchmarkActionsMenu(
                          benchmark: benchmark,
                          activeBenchmarkIds: activeBenchmarkIds,
                          showViewHistoryAction: true,
                          child: FitnessBenchmarkDashboardDisplayWidget(
                            benchmark: benchmark,
                          ));
                    }).toList())
          ],
        );
      },
    );
  }
}
