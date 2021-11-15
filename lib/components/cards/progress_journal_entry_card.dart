import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/media/audio/audio_thumbnail_player.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class ProgressJournalEntryCard extends StatelessWidget {
  final ProgressJournal parentJournal;
  final ProgressJournalEntry progressJournalEntry;
  const ProgressJournalEntryCard(
      {Key? key,
      required this.progressJournalEntry,
      required this.parentJournal})
      : super(key: key);

  int get kMaxScore => 10;

  double _calcOverallAverage() {
    final scores = [
      for (final s in [
        progressJournalEntry.moodScore,
        progressJournalEntry.energyScore,
        progressJournalEntry.motivationScore,
        progressJournalEntry.confidenceScore,
      ])
        if (s != null) s
    ];
    return scores.average;
  }

  bool _hasSubmittedScores() => [
        progressJournalEntry.moodScore,
        progressJournalEntry.energyScore,
        progressJournalEntry.motivationScore,
        progressJournalEntry.confidenceScore
      ].any((s) => s != null);

  List<Widget> _buildScoreIndicators() {
    final tags = ['Mood', 'Energy', 'Motivation', 'Confidence'];

    return [
      for (final s in [
        progressJournalEntry.moodScore,
        progressJournalEntry.energyScore,
        progressJournalEntry.motivationScore,
        progressJournalEntry.confidenceScore,
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
                          progressJournalEntry.createdAt.compactDateString,
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (Utils.textNotNull(progressJournalEntry.note))
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0, left: 6, right: 8),
                    child: MyText(
                      progressJournalEntry.note!,
                      maxLines: 4,
                      size: FONTSIZE.two,
                      lineHeight: 1.3,
                    ),
                  ),
                ),
              if (Utils.textNotNull(progressJournalEntry.voiceNoteUri))
                AudioThumbnailPlayer(
                    displaySize: const Size(56, 56),
                    iconData: CupertinoIcons.mic_fill,
                    audioUri: progressJournalEntry.voiceNoteUri!),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
      ),
    );
  }
}

/// Not being used in this widget anymore after Progress Photos functionality was moved to another module.
/// Something like this https://dribbble.com/shots/794208-Photo-Stack-UI-Sketch
class PhotoStackDisplay extends StatelessWidget {
  final List<String> fileIds;
  final double width;
  final double height;
  const PhotoStackDisplay(
      {Key? key,
      required this.fileIds,
      required this.width,
      required this.height})
      : super(key: key);

  // Degree offset increases the deeper the stack.
  int get _degreeOffset => 5;
  double get _paddingPercent => 0.10;
  // Percent of total width - to scale the boxshadow
  double get _shadowConstant => 0.01;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * _paddingPercent,
            vertical: height * _paddingPercent),
        child: Stack(
          alignment: Alignment.center,
          children: fileIds
              .asMap()
              .map((index, String fileId) => MapEntry(
                  index,
                  Opacity(
                    opacity: max(0, 0.9 - (0.15 * index)),
                    child: Transform.rotate(
                        angle:
                            ((index.isEven ? index : -index) * _degreeOffset) *
                                pi /
                                180,
                        child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(width * _shadowConstant,
                                          width * _shadowConstant),
                                      blurRadius: width * _shadowConstant,
                                      color: Styles.black.withOpacity(0.5))
                                ]),
                            child: SizedUploadcareImage(
                              fileId,
                              displaySize: Size(width * 2, height * 2),
                            ))),
                  )))
              .values
              .toList()
              .reversed
              .toList(),
        ),
      ),
    );
  }
}
