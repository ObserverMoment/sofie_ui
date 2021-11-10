import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              boxShadow: kElevation[3],
              gradient: Styles.secondaryButtonGradient,
              borderRadius: BorderRadius.circular(30)),
          child: MyText(
              DataUtils.buildBenchmarkEntryScoreText(benchmark, benchmarkEntry),
              size: fontSize,
              color: Styles.white),
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
