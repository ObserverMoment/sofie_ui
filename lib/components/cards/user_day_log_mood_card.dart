import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/creators/user_day_log_mood_creator_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:collection/collection.dart';
import 'package:sofie_ui/services/utils.dart';

class UserDayLogMoodCard extends StatelessWidget {
  final UserDayLogMood mood;
  const UserDayLogMoodCard({
    Key? key,
    required this.mood,
  }) : super(key: key);

  int get kMaxScore => 4;

  double get kScoreDisplayDiameter => 60.0;

  List<Widget> _buildScoreIndicators(BuildContext context) {
    final tags = ['Mood', 'Energy'];

    return [
      mood.moodScore,
      mood.energyScore,
    ]
        .mapIndexed((index, score) => Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3),
                  child: ClipOval(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: kScoreDisplayDiameter,
                          width: kScoreDisplayDiameter,
                          color: context.theme.background,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: kScoreDisplayDiameter * (score / kMaxScore),
                            width: kScoreDisplayDiameter,
                            color: Color.lerp(kBadScoreColor, kGoodScoreColor,
                                score / kMaxScore),
                          ),
                        ),
                        Opacity(
                          opacity: 0.6,
                          child: score > 2
                              ? const Icon(CupertinoIcons.checkmark_alt)
                              : score == 2
                                  ? null
                                  : const Icon(
                                      CupertinoIcons
                                          .exclamationmark_triangle_fill,
                                      color: Styles.errorRed,
                                    ),
                        )
                      ],
                    ),
                  ),
                ),
                MyText(
                  tags[index],
                ),
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                mood.createdAt.dateAndTime,
              ),
              TertiaryButton(
                text: 'Delete',
                onPressed: () => print('delete mood'),
                textColor: Styles.errorRed,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ScoreMeter(
                label: 'Mood',
                score: mood.moodScore,
                gradient: Styles.primaryAccentGradientVertical,
              ),
              _ScoreMeter(
                label: 'Energy',
                score: mood.energyScore,
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
                                color: kGoodScoreColor,
                                fontSize: FONTSIZE.three,
                                tag: t,
                              )
                            : Tag(
                                tag: t,
                                color: material.Colors.transparent,
                                textColor: context.theme.primary,
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

class _ScoreMeter extends StatelessWidget {
  final int score;
  final String label;
  final Gradient gradient;
  const _ScoreMeter(
      {Key? key,
      required this.score,
      required this.label,
      required this.gradient})
      : super(key: key);

  BorderRadius get _borderRadius => BorderRadius.circular(20);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: 0.6,
            child: score > 2
                ? const Icon(CupertinoIcons.hand_thumbsup_fill)
                : score == 2

                    /// TODO:
                    ? const Icon(CupertinoIcons.checkmark_alt)
                    : const Icon(
                        CupertinoIcons.exclamationmark_triangle_fill,
                        color: Styles.errorRed,
                      ),
          ),
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: _borderRadius, color: context.theme.background),
              height: 140,
              width: 80,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: _borderRadius,
                    color: context.theme.cardBackground),
              ),
            ),
            GrowIn(
                duration: 1000,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: _borderRadius, gradient: gradient),
                    height: 140,
                    width: 80,
                  ),
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyText(
            label.toUpperCase(),
            subtext: true,
          ),
        )
      ],
    );
  }
}
