import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/components/creators/fitness_benchmarks/fitness_benchmark_creator.dart';
import 'package:sofie_ui/components/creators/fitness_benchmarks/fitness_benchmark_score_creator.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/user_fitness_benchmark_details.dart';
import 'package:sofie_ui/pages/authed/progress/fitness_benchmark_components/utils.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

/// Logic to handle the necessary actions is also contained within this widget.
class FitnessBenchmarkActionsMenu extends StatelessWidget {
  final Widget child;
  final FitnessBenchmark benchmark;
  final List<String> activeBenchmarkIds;

  /// No need to show this when already on the history page.
  final bool showViewHistoryAction;
  final VoidCallback? onBenchmarkDelete;

  const FitnessBenchmarkActionsMenu(
      {Key? key,
      required this.benchmark,
      required this.activeBenchmarkIds,
      required this.showViewHistoryAction,
      required this.child,
      this.onBenchmarkDelete})
      : super(key: key);

  Future<void> confirmDeleteCustomBenchmark(
      BuildContext context, FitnessBenchmark benchmark) async {
    context.showConfirmDeleteDialog(
        itemType: 'Fitness Benchmark',
        message:
            'All benchmark info and data, including submitted scores, will be deleted. OK?',
        onConfirm: () async {
          final result = await GraphQLStore.store.delete(
            mutation: DeleteFitnessBenchmarkMutation(
                variables: DeleteFitnessBenchmarkArguments(id: benchmark.id)),
            objectId: benchmark.id,
            typename: kFitnessBenchmarkTypename,
          );

          checkOperationResult(result, onSuccess: onBenchmarkDelete);
        });
  }

  @override
  Widget build(BuildContext context) {
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
                      icon: material.Icons.score,
                      text: 'Submit a Score',
                      onPressed: () => context.push(
                              child: FitnessBenchmarkScoreCreator(
                            fitnessBenchmark: benchmark,
                          ))),
                  if (showViewHistoryAction)
                    BottomSheetMenuItem(
                        icon: material.Icons.history,
                        text: 'View History',
                        onPressed: () => context.push(
                            child:
                                UserFitnessBenchmarkDetails(id: benchmark.id))),
                  BottomSheetMenuItem(
                    icon: material.Icons.dashboard,
                    text: activeBenchmarkIds.contains(benchmark.id)
                        ? 'Remove from Dashboard'
                        : 'Add to Dashboard',
                    onPressed: () =>
                        FitnessBenchmarkUtils.toggleActivateBenchmark(
                            context, activeBenchmarkIds, benchmark.id),
                  ),
                  if (Utils.textNotNull(benchmark.instructionalVideoUri))
                    BottomSheetMenuItem(
                        icon: CupertinoIcons.info,
                        text: 'Watch Instructional Video',
                        onPressed: () =>
                            VideoSetupManager.openFullScreenVideoPlayer(
                                context: context,
                                videoUri: benchmark.instructionalVideoUri!)),
                  if (Utils.textNotNull(benchmark.description))
                    BottomSheetMenuItem(
                        icon: CupertinoIcons.info,
                        text: 'Read Description',
                        onPressed: () => context.push(
                            child: TextViewer(
                                benchmark.description!, benchmark.name))),
                  if (Utils.textNotNull(benchmark.instructions))
                    BottomSheetMenuItem(
                        icon: CupertinoIcons.info,
                        text: 'Read Instructions',
                        onPressed: () => context.push(
                            child: TextViewer(
                                benchmark.instructions!, benchmark.name))),
                  if (benchmark.scope == FitnessBenchmarkScope.custom)
                    BottomSheetMenuItem(
                        icon: CupertinoIcons.pen,
                        text: 'Edit Custom Benchmark',
                        onPressed: () => context.push(
                                child: FitnessBenchmarkCreator(
                              fitnessBenchmark: benchmark,
                            ))),
                  if (benchmark.scope == FitnessBenchmarkScope.custom)
                    BottomSheetMenuItem(
                        icon: CupertinoIcons.delete,
                        isDestructive: true,
                        text: 'Delete Custom Benchmark',
                        onPressed: () =>
                            confirmDeleteCustomBenchmark(context, benchmark)),
                ])),
        child: child);
  }
}
