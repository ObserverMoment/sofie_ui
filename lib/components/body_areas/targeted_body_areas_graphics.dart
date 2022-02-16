import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/utils.dart';

/// Display for either the front or back of the body, with targeted areas highlighted.
/// Each body area should only have one corresponding bodyAreaMoveScore in this list.
/// Score amounts can be indicated by increasing opacity as the score increases.
class TargetedBodyAreasScoreIndicator extends StatelessWidget {
  final Color? activeColor;
  final double basisOpacity;
  final BodyAreaFrontBack frontBack;
  final List<BodyAreaMoveScore> bodyAreaMoveScores;
  final double height;
  final List<BodyArea> allBodyAreas;

  /// Percentages do not really work very well for any object more complicated than a move.
  /// As it is very hard to take into consideration how difficult each move is in relation to the other.
  /// For example: a two move workout which consists of 100 pull ups and then 10 squats.
  /// Would show around 50 / 50 back vs legs split - when in actual fact it should be much more heavily weighted towards back as there are more pull ups and they are harder.
  final bool indicatePercentWithColor;

  const TargetedBodyAreasScoreIndicator(
      {Key? key,
      this.activeColor,
      this.basisOpacity = 0.09,
      required this.bodyAreaMoveScores,
      required this.frontBack,
      required this.allBodyAreas,
      required this.height,
      this.indicatePercentWithColor = false})
      : super(key: key);

  Color calculateColorBasedOnScore(BuildContext context, BodyArea bodyArea) {
    final _activeColor = activeColor ?? context.watch<ThemeBloc>().primary;

    final BodyAreaMoveScore bams =
        bodyAreaMoveScores.firstWhere((bams) => bams.bodyArea == bodyArea,
            orElse: () => BodyAreaMoveScore()
              ..score = 0
              ..bodyArea = bodyArea);

    if (indicatePercentWithColor) {
      final opacity =
          bams.score == 0 ? basisOpacity : min(1.0, (bams.score / 100) + 0.4);
      return _activeColor.withOpacity(opacity);
    } else {
      return bams.score == 0
          ? _activeColor.withOpacity(basisOpacity)
          : _activeColor.withOpacity(0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nonActiveColor = Styles.greyOne.withOpacity(0.05);

    final List<BodyArea> bodyAreasToDisplay = allBodyAreas
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
              color: nonActiveColor),
          ...bodyAreasToDisplay
              .map(
                (bodyArea) => SvgPicture.asset(
                    'assets/body_areas/${isFront ? "front" : "back"}/${Utils.getSvgAssetUriFromBodyAreaName(bodyArea.name)}.svg',
                    height: height,
                    color: calculateColorBasedOnScore(context, bodyArea)),
              )
              .toList()
        ],
      ),
    );
  }
}

/// Display for either the front or back of the body, with targeted areas highlighted.
/// Boolean - on or off for each body area.
class TargetedBodyAreasSelectedIndicator extends StatelessWidget {
  final Color? activeColor;
  final Color? inactiveColor;

  final BodyAreaFrontBack frontBack;
  final List<BodyArea> selectedBodyAreas;
  final double height;
  final List<BodyArea> allBodyAreas;

  const TargetedBodyAreasSelectedIndicator({
    Key? key,
    this.activeColor,
    this.inactiveColor,
    required this.selectedBodyAreas,
    required this.frontBack,
    required this.allBodyAreas,
    this.height = 350,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _inactiveColor =
        inactiveColor ?? context.theme.primary.withOpacity(0.2);
    final _activeColor = activeColor ?? context.watch<ThemeBloc>().primary;

    final List<BodyArea> bodyAreasToDisplay = allBodyAreas
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
              color: _inactiveColor),
          ...bodyAreasToDisplay
              .map(
                (bodyArea) => SvgPicture.asset(
                    'assets/body_areas/${isFront ? "front" : "back"}/${Utils.getSvgAssetUriFromBodyAreaName(bodyArea.name)}.svg',
                    height: height,
                    color: selectedBodyAreas.contains(bodyArea)
                        ? _activeColor
                        : _inactiveColor),
              )
              .toList()
        ],
      ),
    );
  }
}
