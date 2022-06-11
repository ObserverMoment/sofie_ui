import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';
import 'package:sofie_ui/services/utils.dart';

class TargetedBodyAreasDisplay extends StatelessWidget {
  final Color? activeColor;
  final Color? inactiveColor;

  final BodyAreaFrontBack frontBack;
  final List<BodyArea> selectedBodyAreas;
  final double height;

  const TargetedBodyAreasDisplay({
    Key? key,
    this.activeColor,
    this.inactiveColor,
    required this.selectedBodyAreas,
    required this.frontBack,
    this.height = 350,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allBodyAreas = CoreDataRepo.bodyAreas;
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
