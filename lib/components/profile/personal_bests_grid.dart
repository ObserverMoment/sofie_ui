import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:collection/collection.dart';

class PersonalBestsGrid extends StatelessWidget {
  final List<UserBenchmarkWithBestEntry> benchmarks;
  const PersonalBestsGrid({Key? key, required this.benchmarks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return benchmarks.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              YourContentEmptyPlaceholder(
                  message: 'No personal bests logged', actions: []),
            ],
          )
        : GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: benchmarks
                .sortedBy<DateTime>((b) => b.userBenchmarkSummary.lastEntryAt)
                .reversed
                .map(
                  (b) => _PersonalBestScoreIcon(userBenchmarkWithBestEntry: b),
                )
                .toList(),
          );
  }
}

class _PersonalBestScoreIcon extends StatelessWidget {
  final UserBenchmarkWithBestEntry userBenchmarkWithBestEntry;
  const _PersonalBestScoreIcon(
      {Key? key, required this.userBenchmarkWithBestEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final benchmark = userBenchmarkWithBestEntry.userBenchmarkSummary;
    final bestEntry = userBenchmarkWithBestEntry.bestEntry;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: bestEntry != null && Utils.textNotNull(bestEntry.videoUri)
          ? () => VideoSetupManager.openFullScreenVideoPlayer(
              context: context,
              title: benchmark.name,
              videoUri: bestEntry.videoUri!,
              autoLoop: true)
          : null,
      child: Container(
        decoration: BoxDecoration(color: context.theme.cardBackground),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset('assets/category_icons/events.svg',
                  color: Styles.primaryAccent.withOpacity(0.15)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                    benchmark.name,
                    maxLines: 3,
                    lineHeight: 1.3,
                    textAlign: TextAlign.center,
                    weight: FontWeight.bold,
                    size: FONTSIZE.two,
                  ),
                  MyText(
                    benchmark.benchmarkType.display,
                    size: FONTSIZE.one,
                    lineHeight: 1.3,
                    textAlign: TextAlign.center,
                    weight: FontWeight.bold,
                  ),
                  bestEntry != null && Utils.textNotNull(bestEntry.videoUri)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            MyText('Video',
                                size: FONTSIZE.one,
                                weight: FontWeight.bold,
                                color: Styles.primaryAccent),
                            SizedBox(width: 2),
                            Icon(CupertinoIcons.checkmark_alt,
                                size: 15, color: Styles.primaryAccent)
                          ],
                        )
                      : Container(),
                  bestEntry != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                              boxShadow: kElevation[2],
                              color: context.theme.background,
                              border: Border.all(
                                color: context.theme.primary,
                              ),
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyText(
                                DataUtils.buildBenchmarkEntryScoreText(
                                    benchmark.benchmarkType,
                                    benchmark.loadUnit,
                                    bestEntry),
                                size: FONTSIZE.two,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                        )
                      : const MyText(
                          'No scores',
                          subtext: true,
                          size: FONTSIZE.one,
                          textAlign: TextAlign.center,
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
