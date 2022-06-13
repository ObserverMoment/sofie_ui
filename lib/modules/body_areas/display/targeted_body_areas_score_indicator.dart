import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';
import 'package:sofie_ui/services/utils.dart';

/// Display for either the front or back of the body, with targeted areas highlighted.
/// Each body area should only have one corresponding bodyAreaMoveScore in this list.
/// Score amounts can be indicated by increasing opacity as the score increases.
/// Percentages do not really work very well for any object more complicated than a move.
/// As it is very hard to take into consideration how difficult each move is in relation to the other.
/// For example: a two move workout which consists of 100 pull ups and then 10 squats.
/// Would show around 50 / 50 back vs legs split - when in actual fact it should be much more heavily weighted towards back as there are more pull ups and they are harder.

class TargetedBodyAreasScoreIndicator extends StatelessWidget {
  final Color? activeColor;
  final double basisOpacity;
  final BodyAreaFrontBack frontBack;
  final List<BodyAreaMoveScore> bodyAreaMoveScores;
  final double height;

  const TargetedBodyAreasScoreIndicator({
    Key? key,
    this.activeColor,
    this.basisOpacity = 0.09,
    required this.bodyAreaMoveScores,
    required this.frontBack,
    required this.height,
  }) : super(key: key);

  Color calculateColorBasedOnScore(
      {required BuildContext context,
      required BodyArea bodyArea,
      required Color activeColor,
      required int highestScore,
      required int lowestScore}) {
    final BodyAreaMoveScore bams =
        bodyAreaMoveScores.firstWhere((bams) => bams.bodyArea == bodyArea,
            orElse: () => BodyAreaMoveScore()
              ..score = 0
              ..bodyArea = bodyArea);

    if (bams.score == 0) {
      return activeColor.withOpacity(basisOpacity);
    } else {
      final double opacity = 1 - ((highestScore - bams.score) / highestScore);
      return activeColor
          .withOpacity((opacity + basisOpacity).clamp(basisOpacity, 1.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final highestScore = bodyAreaMoveScores.map((bams) => bams.score).max;
    final lowestScore = bodyAreaMoveScores.map((bams) => bams.score).min;

    final activeColor = context.theme.primary;
    final inActiveColor = context.theme.primary.withOpacity(0.05);

    final List<BodyArea> bodyAreasToDisplay = CoreDataRepo.bodyAreas
        .where((ba) =>
            ba.frontBack == frontBack || ba.frontBack == BodyAreaFrontBack.both)
        .toList();

    final bool isFront = frontBack == BodyAreaFrontBack.front;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          SvgPicture.asset(
              isFront
                  ? 'assets/body_areas/front/background_front.svg'
                  : 'assets/body_areas/back/background_back.svg',
              height: height,
              color: inActiveColor),
          ...bodyAreasToDisplay
              .map(
                (bodyArea) => SvgPicture.asset(
                    'assets/body_areas/${isFront ? "front" : "back"}/${Utils.getSvgAssetUriFromBodyAreaName(bodyArea.name)}.svg',
                    height: height,
                    color: calculateColorBasedOnScore(
                        context: context,
                        bodyArea: bodyArea,
                        activeColor: activeColor,
                        highestScore: highestScore,
                        lowestScore: lowestScore)),
              )
              .toList()
        ],
      ),
    );
  }
}
