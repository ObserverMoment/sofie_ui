import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_svg/svg.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/body_areas/targeted_body_areas_graphics.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_lists.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

/// Graphical UI that highlights the areas of the body that are being targeted.
/// List of body area move scores will be folded to a list of bodyareas and then displayed.
/// Front and back on on separate pages, accessible via swipe.
class TargetedBodyAreasPageView extends StatelessWidget {
  final List<BodyAreaMoveScore> bodyAreaMoveScores;
  const TargetedBodyAreasPageView({
    Key? key,
    required this.bodyAreaMoveScores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color activeColor = context.theme.primary;

    final Set<BodyArea> bodyAreasThatHaveScore =
        bodyAreaMoveScores.map((bams) => bams.bodyArea).toSet();

    /// The percentages are not being used here but the grouping is...
    final percentagedBodyAreaMoveScores =
        DataUtils.percentageBodyAreaMoveScores(bodyAreaMoveScores);

    return QueryObserver<BodyAreas$Query, json.JsonSerializable>(
        key: Key('TargetedBodyAreasPageView-${BodyAreasQuery().operationName}'),
        query: BodyAreasQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final List<BodyArea> allBodyAreas = data.bodyAreas;

          return MyPageScaffold(
            navigationBar: MyNavBar(
                customLeading: NavBarChevronDownButton(context.pop),
                backgroundColor: context.theme.background,
                middle: const NavBarTitle('Targeted Body Areas')),
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: bodyAreaMoveScores.isEmpty
                    ? Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0),
                            child: MyText(
                              'Full Body Exercise',
                              weight: FontWeight.bold,
                              size: FONTSIZE.four,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    'assets/body_areas/full_front.svg',
                                    height: constraints.maxHeight * 0.4,
                                    color: activeColor.withOpacity(0.7)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    'assets/body_areas/full_back.svg',
                                    height: constraints.maxHeight * 0.4,
                                    color: activeColor.withOpacity(0.7)),
                              ),
                            ],
                          )
                        ],
                      )
                    : PageView(
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              const H2(
                                'Front',
                              ),
                              Positioned(
                                right: 12,
                                child: Column(
                                  children: const [
                                    MyText(
                                      'Back >',
                                    ),
                                    Icon(material.Icons.swipe),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12.0),
                                        child: TargetedBodyAreasScoreList(
                                            percentagedBodyAreaMoveScores
                                                .where((bams) =>
                                                    bams.bodyArea.frontBack ==
                                                        BodyAreaFrontBack
                                                            .front ||
                                                    bams.bodyArea.frontBack ==
                                                        BodyAreaFrontBack.both)
                                                .toList()),
                                      ),
                                      TargetedBodyAreasSelectedIndicator(
                                        frontBack: BodyAreaFrontBack.front,
                                        allBodyAreas: allBodyAreas,
                                        activeColor: activeColor,
                                        selectedBodyAreas:
                                            bodyAreasThatHaveScore.toList(),
                                        height: constraints.maxHeight * 0.7,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              const H2(
                                'Back',
                              ),
                              Positioned(
                                left: 12,
                                child: Column(
                                  children: const [
                                    MyText(
                                      '< Front',
                                    ),
                                    Icon(material.Icons.swipe),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12.0),
                                        child: TargetedBodyAreasScoreList(
                                            percentagedBodyAreaMoveScores
                                                .where((bams) =>
                                                    bams.bodyArea.frontBack ==
                                                        BodyAreaFrontBack
                                                            .back ||
                                                    bams.bodyArea.frontBack ==
                                                        BodyAreaFrontBack.both)
                                                .toList()),
                                      ),
                                      TargetedBodyAreasSelectedIndicator(
                                        frontBack: BodyAreaFrontBack.back,
                                        allBodyAreas: allBodyAreas,
                                        activeColor: activeColor,
                                        selectedBodyAreas:
                                            bodyAreasThatHaveScore.toList(),
                                        height: constraints.maxHeight * 0.7,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
              );
            }),
          );
        });
  }
}
