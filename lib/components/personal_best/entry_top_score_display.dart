import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

/// Oval shape container with shadow that displays the score of the entry in the correct format for the type of entry it is (max reps, fgastest time etc).
class UserBenchmarkScoreDisplay extends StatelessWidget {
  final UserBenchmark benchmark;
  final UserBenchmarkEntry benchmarkEntry;
  final bool showDate;
  final FONTSIZE fontSize;
  const UserBenchmarkScoreDisplay(
      {Key? key,
      required this.benchmark,
      required this.benchmarkEntry,
      this.showDate = true,
      this.fontSize = FONTSIZE.four})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
              boxShadow: kElevation[2],
              color: context.theme.background,
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: [
              MyText(
                  DataUtils.buildBenchmarkEntryScoreText(
                      benchmark.benchmarkType,
                      benchmark.loadUnit,
                      benchmarkEntry),
                  size: fontSize,
                  color: Styles.primaryAccent),
              if (Utils.textNotNull(benchmarkEntry.videoUri))
                const Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Icon(CupertinoIcons.film,
                      color: Styles.primaryAccent, size: 18),
                )
            ],
          ),
        ),
        if (showDate)
          Column(
            children: [
              const SizedBox(height: 4),
              MyText(
                benchmarkEntry.completedOn.minimalDateStringYear,
                size: FONTSIZE.two,
                subtext: true,
              )
            ],
          )
      ],
    );
  }
}
