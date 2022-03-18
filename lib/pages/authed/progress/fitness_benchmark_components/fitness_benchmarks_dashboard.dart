import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/fitness_benchmarks/fitness_benchmark_score_creator.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/active_settings_and_benchmarks_container.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/fitness_benchmark_dashboard_display_widget.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/user_fitness_benchmark_details.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/user_fitness_benchmarks_list.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/utils.dart';

/// Must be in [context] which has an active [ExerciseTrackersBloc] in scope.
class FitnessBenchmarksDashboard extends StatelessWidget {
  const FitnessBenchmarksDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActiveSettingsAndBenchmarksContainer(
      builder: (activeBenchmarkIds, benchmarks) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyText(
                    'Dashboard',
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
            activeBenchmarkIds.isEmpty
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
                    children: activeBenchmarkIds.map((id) {
                      final benchmark =
                          benchmarks.firstWhere((b) => b.id == id);

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => openBottomSheetMenu(
                            context: context,
                            child: BottomSheetMenu(
                                header: BottomSheetMenuHeader(
                                  name: benchmark.name,
                                  subtitle: benchmark.type.display,
                                ),
                                items: [
                                  BottomSheetMenuItem(
                                      icon: material.Icons.history,
                                      text: 'View History',
                                      onPressed: () => context.push(
                                          child: UserFitnessBenchmarkDetails(
                                              id: benchmark.id))),
                                  BottomSheetMenuItem(
                                      icon: material.Icons.score,
                                      text: 'Submit a Score',
                                      onPressed: () => context.push(
                                              child:
                                                  FitnessBenchmarkScoreCreator(
                                            fitnessBenchmark: benchmark,
                                          ))),
                                  BottomSheetMenuItem(
                                      icon: material.Icons.dashboard,
                                      text: 'Remove from Dashboard',
                                      onPressed: () => FitnessBenchmarkUtils
                                          .toggleActivateBenchmark(
                                              context, activeBenchmarkIds, id)),
                                  if (benchmark.scope ==
                                      FitnessBenchmarkScope.custom)
                                    BottomSheetMenuItem(
                                        icon: CupertinoIcons.delete,
                                        isDestructive: true,
                                        text: 'Delete Custom Benchmark',
                                        onPressed: () => print('TODO'))
                                ])),
                        child: FitnessBenchmarkDashboardDisplayWidget(
                          benchmark: benchmark,
                        ),
                      );
                    }).toList())
          ],
        );
      },
    );
  }
}
