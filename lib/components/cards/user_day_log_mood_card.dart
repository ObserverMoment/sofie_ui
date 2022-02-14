import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/user_day_logs/user_day_log_mood_creator_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class UserDayLogMoodCard extends StatelessWidget {
  final UserDayLogMood mood;
  final VoidCallback deleteMoodLog;
  const UserDayLogMoodCard({
    Key? key,
    required this.mood,
    required this.deleteMoodLog,
  }) : super(key: key);

  int get kMaxScore => 4;

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: MyText(
                  mood.createdAt.dateAndTime,
                ),
              ),
              TertiaryButton(
                text: 'Delete',
                onPressed: deleteMoodLog,
                textColor: Styles.errorRed,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ScoreMeter(
                label: 'Mood',
                score: mood.moodScore.toDouble(),
                gradient: Styles.primaryAccentGradientVertical,
              ),
              ScoreMeter(
                label: 'Energy',
                score: mood.energyScore.toDouble(),
                gradient: Styles.secondaryAccentGradientVertical,
              ),
            ],
          ),
          if (mood.tags.isNotEmpty)
            Column(
              children: [
                const HorizontalLine(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 4.0, top: 16, right: 4, bottom: 4),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 10,
                    runSpacing: 10,
                    children: mood.tags
                        .map((t) => kGoodFeelings.contains(t)
                            ? Tag(
                                textColor: Styles.white,
                                color: kGoodScoreColor.withOpacity(0.8),
                                tag: t,
                              )
                            : Tag(
                                tag: t,
                                color: kBadScoreColor.withOpacity(0.8),
                                textColor: Styles.white,
                              ))
                        .toList(),
                  ),
                ),
              ],
            ),
          if (Utils.textNotNull(mood.note))
            Column(
              children: [
                const HorizontalLine(
                  verticalPadding: 12,
                ),
                MyText(
                  mood.note!,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ),
              ],
            )
        ],
      ),
    );
  }
}

class ScoreMeter extends StatelessWidget {
  final double score;
  final String label;
  final Gradient gradient;
  final double displayWidth;
  const ScoreMeter(
      {Key? key,
      required this.score,
      required this.label,
      required this.gradient,
      this.displayWidth = 100.0})
      : super(key: key);

  double get _borderPadding => displayWidth / 10;
  double get _maxHeight => 140.0;
  double get _fullMeterHeight => _maxHeight - (_borderPadding * 2);

  @override
  Widget build(BuildContext context) {
    final percent = (score + 1) / 5;

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 32,
          padding: const EdgeInsets.all(4.0),
          child: Opacity(
            opacity: 0.8,
            child: score > 2
                ? const Icon(
                    CupertinoIcons.checkmark_alt,
                    color: Styles.infoBlue,
                  )
                : score == 2
                    ? null
                    : const Icon(
                        CupertinoIcons.exclamationmark_triangle_fill,
                        color: Styles.errorRed,
                      ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.all(_borderPadding),
          height: _maxHeight,
          width: displayWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: Styles.secondaryButtonGradient,
          ),
          child: ClipRect(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.theme.cardBackground.withOpacity(0.9),
              ),
              child: Stack(
                children: [
                  ClipRect(
                      clipBehavior: Clip.hardEdge,
                      child: OverflowBox(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GrowIn(
                              duration: 1000,
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(gradient: gradient),
                                height: percent * _fullMeterHeight,
                              )),
                        ),
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        4,
                        (index) => HorizontalLine(
                              color: context.theme.primary.withOpacity(0.05),
                            )),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyText(
            label.toUpperCase(),
            subtext: true,
            size: FONTSIZE.two,
          ),
        )
      ],
    );
  }
}
