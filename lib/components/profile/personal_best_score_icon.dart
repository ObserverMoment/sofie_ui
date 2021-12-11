import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

class PersonalBestScoreIcon extends StatelessWidget {
  final UserBenchmarkWithBestEntry userBenchmarkWithBestEntry;
  const PersonalBestScoreIcon(
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
              subtitle: GetIt.I<AuthBloc>().authedUser?.displayName ?? '',
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
                  color: Styles.secondaryAccent.withOpacity(0.15)),
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
                                color: Styles.secondaryAccent),
                            SizedBox(width: 2),
                            Icon(CupertinoIcons.checkmark_alt,
                                size: 15, color: Styles.secondaryAccent)
                          ],
                        )
                      : Container(),
                  bestEntry != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                              boxShadow: kElevation[2],
                              color: Styles.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyText(
                                DataUtils.buildBenchmarkEntryScoreText(
                                    benchmark.benchmarkType,
                                    benchmark.loadUnit,
                                    bestEntry),
                                color: Styles.secondaryAccent,
                                size: FONTSIZE.two,
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
