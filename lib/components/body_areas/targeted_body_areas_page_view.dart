import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_graphics.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_lists.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:sofie_ui/services/data_utils.dart';

/// Graphical UI that highlights the areas of the body that are being targeted.
/// List of body area move scores will be folded to a list of bodyareas and then displayed.
/// Front and back on on separate pages, accessible via swipe.
class TargetedBodyAreasPageView extends StatefulWidget {
  final List<BodyAreaMoveScore> bodyAreaMoveScores;
  const TargetedBodyAreasPageView({
    Key? key,
    required this.bodyAreaMoveScores,
  }) : super(key: key);

  @override
  State<TargetedBodyAreasPageView> createState() =>
      _TargetedBodyAreasPageViewState();
}

class _TargetedBodyAreasPageViewState extends State<TargetedBodyAreasPageView> {
  int _activePageIndex = 0;
  final PageController _pageController = PageController();

  void _updatePageIndex(int i) {
    _pageController.toPage(i);
    setState(() => _activePageIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = context.theme.primary;

    final Set<BodyArea> bodyAreasThatHaveScore =
        widget.bodyAreaMoveScores.map((bams) => bams.bodyArea).toSet();

    /// The percentages are not being used here but the grouping is...
    final percentagedBodyAreaMoveScores =
        DataUtils.percentageBodyAreaMoveScores(widget.bodyAreaMoveScores);

    final allBodyAreas = CoreDataRepo.bodyAreas;

    return MyPageScaffold(
      navigationBar: MyNavBar(
          customLeading: NavBarChevronDownButton(context.pop),
          backgroundColor: context.theme.background,
          middle: const NavBarTitle('Targeted Body Areas')),
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: widget.bodyAreaMoveScores.isEmpty
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
              : Column(
                  children: [
                    MySlidingSegmentedControl(
                        children: const {0: 'Front', 1: 'Back'},
                        updateValue: _updatePageIndex,
                        value: _activePageIndex),
                    Expanded(
                      child: PageView(
                        onPageChanged: _updatePageIndex,
                        controller: _pageController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
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
                                                    BodyAreaFrontBack.front ||
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
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
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
                                                    BodyAreaFrontBack.back ||
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
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
