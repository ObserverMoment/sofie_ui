import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/body_areas/body_area_selector_overlay.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_graphics.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Consists of two components. The graphic displaying the scores for each body area (with optional opacity gradient). And a selector overlay with a gesture detector + clip path for each body area.
class BodyAreaSelectorScoreIndicator extends StatelessWidget {
  final void Function(BodyArea bodyArea) handleTapBodyArea;
  final BodyAreaFrontBack frontBack;
  final List<BodyArea> allBodyAreas;
  final List<BodyAreaMoveScore> bodyAreaMoveScores;
  final bool indicatePercentWithColor;
  final double height;

  const BodyAreaSelectorScoreIndicator(
      {Key? key,
      required this.handleTapBodyArea,
      required this.bodyAreaMoveScores,
      required this.frontBack,
      required this.allBodyAreas,
      required this.indicatePercentWithColor,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        TargetedBodyAreasScoreIndicator(
            bodyAreaMoveScores: bodyAreaMoveScores,
            frontBack: frontBack,
            allBodyAreas: allBodyAreas,
            indicatePercentWithColor: indicatePercentWithColor,
            height: height),
        BodyAreaSelectorOverlay(
            frontBack: frontBack,
            allBodyAreas: allBodyAreas,
            onTapBodyArea: handleTapBodyArea,
            height: height)
      ],
    );
  }
}
