import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';

class JournalMoodCard extends StatelessWidget {
  final JournalMood journalMood;
  const JournalMoodCard({
    Key? key,
    required this.journalMood,
  }) : super(key: key);

  int get kMaxScore => 5;

  double _calcOverallAverage() {
    final scores = [
      for (final s in [
        journalMood.moodScore,
        journalMood.energyScore,
      ])
        if (s != null) s
    ];
    return scores.average;
  }

  bool _hasSubmittedScores() => [
        journalMood.moodScore,
        journalMood.energyScore,
      ].any((s) => s != null);

  List<Widget> _buildScoreIndicators() {
    final tags = ['Mood', 'Energy'];

    return [
      for (final s in [
        journalMood.moodScore,
        journalMood.energyScore,
      ])
        if (s != null) s
    ]
        .mapIndexed((i, s) => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3),
                  child: CircularPercentIndicator(
                    startAngle: 180,
                    backgroundColor: Styles.primaryAccent.withOpacity(0.35),
                    circularStrokeCap: CircularStrokeCap.round,
                    arcType: ArcType.HALF,
                    radius: 40.0,
                    lineWidth: 3.0,
                    percent: s / kMaxScore,
                    center: MyText(
                      s.toInt().toString(),
                      lineHeight: 1,
                      weight: FontWeight.bold,
                      size: FONTSIZE.two,
                    ),
                    progressColor: Color.lerp(
                        kBadScoreColor, kGoodScoreColor, s / kMaxScore),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: MyText(
                    tags[i],
                    size: FONTSIZE.one,
                  ),
                ),
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        MyText(
                          journalMood.createdAt.compactDateString,
                          weight: FontWeight.bold,
                          subtext: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildScoreIndicators(),
                  )
                ],
              ),
              if (_hasSubmittedScores())
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: CircularPercentIndicator(
                    startAngle: 180,
                    backgroundColor: Styles.primaryAccent.withOpacity(0.35),
                    circularStrokeCap: CircularStrokeCap.round,
                    radius: 60.0,
                    lineWidth: 9.0,
                    percent: _calcOverallAverage() / kMaxScore,
                    center: MyText(
                      _calcOverallAverage().toInt().toString(),
                      lineHeight: 1,
                      weight: FontWeight.bold,
                    ),
                    progressColor: Color.lerp(kBadScoreColor, kGoodScoreColor,
                        _calcOverallAverage() / kMaxScore),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
