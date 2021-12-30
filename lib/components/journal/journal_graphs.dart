import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:collection/collection.dart';

class JournalGraphs extends StatelessWidget {
  const JournalGraphs({Key? key}) : super(key: key);

  Widget _heading(double width, String text) => Container(
        alignment: Alignment.center,
        width: width,
        child: MyText(
          text,
          size: FONTSIZE.four,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return QueryObserver<JournalMoods$Query, json.JsonSerializable>(
        key: Key('JournalGraphs - ${JournalMoodsQuery().operationName}'),
        query: JournalMoodsQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final moods = data.journalMoods
              .sortedBy<DateTime>((mood) => mood.createdAt)
              .reversed
              .toList();

          return MyPageScaffold(
            navigationBar: const MyNavBar(
              middle: NavBarLargeTitle('History'),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              final width = constraints.biggest.width;
              final dateWidth = width * 0.14;
              final scoreWidth = width * 0.24;
              final dotWidth = width * 0.24;
              final iconWidth = width * 0.14;

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: dateWidth,
                        ),
                        _heading(
                          scoreWidth,
                          'Score',
                        ),
                        _heading(
                          dotWidth,
                          'Mood',
                        ),
                        _heading(
                          dotWidth,
                          'Energy',
                        ),
                        _heading(
                          iconWidth,
                          'Note',
                        ),
                      ],
                    ),
                  ),
                  const HorizontalLine(),
                  moods.length == 1
                      ? _TimelineCard(
                          mood: moods[0],
                          dateWidth: dateWidth,
                          scoreWidth: scoreWidth,
                          dotWidth: dotWidth,
                          iconWidth: iconWidth,
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: moods.length * 2,

                          /// In between each date input you will want to draw a dotted line, by the dotted line it should state the number of days passed since the last input.
                          itemBuilder: (c, i) {
                            if (i == 1) {
                              return _DottedLine(
                                prev: moods[0].createdAt,
                                next: moods[1].createdAt,
                                dateWidth: dateWidth,
                              );
                            } else if (i == (moods.length * 2) - 1) {
                              return const HorizontalLine();
                            } else if (i % 2 == 0) {
                              return _TimelineCard(
                                mood: moods[i ~/ 2],
                                dateWidth: dateWidth,
                                scoreWidth: scoreWidth,
                                dotWidth: dotWidth,
                                iconWidth: iconWidth,
                              );
                            } else {
                              return _DottedLine(
                                prev: moods[(i ~/ 2) - 1].createdAt,
                                next: moods[(i ~/ 2) + 1].createdAt,
                                dateWidth: dateWidth,
                              );
                            }
                          }),
                ],
              );
            }),
          );
        });
  }
}

class _TimelineCard extends StatelessWidget {
  final JournalMood mood;
  final double dateWidth;
  final double scoreWidth;
  final double dotWidth;
  final double iconWidth;
  const _TimelineCard(
      {Key? key,
      required this.mood,
      required this.dateWidth,
      required this.scoreWidth,
      required this.dotWidth,
      required this.iconWidth})
      : super(key: key);

  double _dotScaledDiameter(int score) => 10 * ((score + 1) / 2);

  Color? _calcColor(int score, int max) =>
      Color.lerp(kBadScoreColor, kGoodScoreColor, score / max);

  int get _totalScore => mood.moodScore + mood.energyScore + 2;

  @override
  Widget build(BuildContext context) {
    final hasNote = Utils.textNotNull(mood.textNote);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration:
          BoxDecoration(color: context.theme.cardBackground.withOpacity(0.5)),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: dateWidth,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: context.theme.primary.withOpacity(0.2)))),
            child: Column(
              children: [
                MyText(
                  mood.createdAt.monthAbbrev,
                ),
                MyText(
                  mood.createdAt.day.toString(),
                  size: FONTSIZE.four,
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.center,
              width: scoreWidth,
              child: MyText(
                _totalScore.toString(),
                color: _calcColor(_totalScore, 10),
                size: FONTSIZE.five,
                weight: FontWeight.bold,
              )),
          Container(
            alignment: Alignment.center,
            width: dotWidth,
            child: Dot(
                diameter: _dotScaledDiameter(mood.moodScore),
                color: _calcColor(mood.moodScore, 4) ??
                    context.theme.primary.withOpacity(0.1)),
          ),
          Container(
            alignment: Alignment.center,
            width: dotWidth,
            child: Dot(
                diameter: _dotScaledDiameter(mood.energyScore),
                color: _calcColor(mood.energyScore, 4) ??
                    context.theme.primary.withOpacity(0.1)),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: hasNote
                ? () => context.showBottomSheet(
                    child: TextViewer(mood.textNote!,
                        'On ${mood.createdAt.compactDateString}'))
                : null,
            child: Container(
              alignment: Alignment.center,
              width: iconWidth,
              child: Utils.textNotNull(mood.textNote)
                  ? const Icon(CupertinoIcons.doc_text)
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DottedLine extends StatelessWidget {
  final DateTime prev;
  final DateTime next;
  final double dateWidth;
  const _DottedLine(
      {Key? key,
      required this.prev,
      required this.next,
      required this.dateWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return prev.isSameDate(next)
        ? Container()
        : Row(
            children: [
              SizedBox(
                width: dateWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedLine(
                      direction: Axis.vertical,
                      lineLength: 20,
                      lineThickness: 3.0,
                      dashLength: 3.0,
                      dashRadius: 3.0,
                      dashGapLength: 2.0,
                      dashGapRadius: 3.0,
                      dashColor: context.theme.primary.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
