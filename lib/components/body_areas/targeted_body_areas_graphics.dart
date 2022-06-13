import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';
import 'package:sofie_ui/services/utils.dart';

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
    final inactive = inactiveColor ?? context.theme.primary.withOpacity(0.2);
    final active = activeColor ?? context.theme.primary;

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
              color: inactive),
          ...bodyAreasToDisplay
              .map(
                (bodyArea) => SvgPicture.asset(
                    'assets/body_areas/${isFront ? "front" : "back"}/${Utils.getSvgAssetUriFromBodyAreaName(bodyArea.name)}.svg',
                    height: height,
                    color: selectedBodyAreas.contains(bodyArea)
                        ? active
                        : inactive),
              )
              .toList()
        ],
      ),
    );
  }
}
