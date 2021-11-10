import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_lists.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/score_input_slider.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Update the score being assigned to a specific body area and once done return the score.
/// Also displays a list of already assigned scores and the total points remaining to assign.
/// Assumes that there are [100 points] to be distributed across all the body areas.
class BodyAreaScoreAdjuster extends StatefulWidget {
  final BodyArea bodyArea;
  final List<BodyAreaMoveScore> bodyAreaMoveScores;
  final void Function(List<BodyAreaMoveScore> scores) updateBodyAreaMoveScores;
  const BodyAreaScoreAdjuster(
      {Key? key,
      required this.bodyArea,
      required this.bodyAreaMoveScores,
      required this.updateBodyAreaMoveScores})
      : super(key: key);
  @override
  _BodyAreaScoreAdjusterState createState() => _BodyAreaScoreAdjusterState();
}

class _BodyAreaScoreAdjusterState extends State<BodyAreaScoreAdjuster> {
  /// The total remaining points when the component is first opened.
  late int _maxPointsForThisBodyArea;
  late int _remainingPoints;
  late int _activeBodyAreaScore;
  late List<BodyAreaMoveScore> _activeBodyAreaMoveScores;

  @override
  void initState() {
    super.initState();

    /// If the body area does not yet have an entry in [bodyAreaMoveScores] then create one and add it.
    if (widget.bodyAreaMoveScores.any((b) => b.bodyArea == widget.bodyArea)) {
      _activeBodyAreaMoveScores = [...widget.bodyAreaMoveScores];
    } else {
      final initialBodyAreaMoveScore = BodyAreaMoveScore()
        ..bodyArea = widget.bodyArea
        ..score = 0;

      _activeBodyAreaMoveScores = [
        ...widget.bodyAreaMoveScores,
        initialBodyAreaMoveScore
      ];
    }

    _activeBodyAreaScore = _activeBodyAreaMoveScores
        .firstWhere((b) => b.bodyArea == widget.bodyArea)
        .score;

    _remainingPoints = _calcRemainingPoints();

    _maxPointsForThisBodyArea = _remainingPoints + _activeBodyAreaScore;
  }

  int _calcRemainingPoints() =>
      100 - _activeBodyAreaMoveScores.sumBy((b) => b.score);

  void _updatePoints(double d) {
    final int clampedPoints = d.toInt().clamp(0, _maxPointsForThisBodyArea);
    final updated = BodyAreaMoveScore()
      ..bodyArea = widget.bodyArea
      ..score = clampedPoints;

    setState(() {
      _activeBodyAreaScore = clampedPoints;
      _activeBodyAreaMoveScores = _activeBodyAreaMoveScores
          .map((bams) => bams.bodyArea == widget.bodyArea ? updated : bams)
          .toList();
      _remainingPoints = _calcRemainingPoints();
    });
  }

  void _updateBodyAreaMoveScores() {
    widget.updateBodyAreaMoveScores(
        _activeBodyAreaMoveScores.where((b) => b.score != 0).toList());
  }

  @override
  Widget build(BuildContext context) {
    return ModalPageScaffold(
      title: widget.bodyArea.name,
      save: _updateBodyAreaMoveScores,
      cancel: context.pop,
      validToSave: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MyText('Points Remaining:'),
              const SizedBox(width: 10),
              MyText(
                _remainingPoints.toString(),
                color: _remainingPoints == 0 ? Styles.errorRed : null,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: _maxPointsForThisBodyArea == 0
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: MyText(
                      'No points remaining, remove from some other body areas if needed.',
                      textAlign: TextAlign.center,
                      maxLines: 4,
                    ),
                  )
                : ScoreInputSlider(
                    name: 'Points',
                    value: _activeBodyAreaScore.toDouble(),
                    max: 100,
                    saveValue: _updatePoints,
                  ),
          ),
          const SizedBox(height: 12),
          const H3('Other Body Areas'),
          Padding(
            padding: const EdgeInsets.all(16),
            child: widget.bodyAreaMoveScores.isNotEmpty
                ? TargetedBodyAreasScoreList(
                    widget.bodyAreaMoveScores,
                    showNumericalScore: true,
                  )
                : const MyText(
                    'No other areas targeted...',
                    subtext: true,
                  ),
          )
        ],
      ),
    );
  }
}
