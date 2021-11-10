import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/body_areas/body_area_score_adjuster.dart';
import 'package:sofie_ui/components/body_areas/body_area_selector_score_indicator.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class CustomMoveCreatorBody extends StatefulWidget {
  final Move move;
  final void Function(Map<String, dynamic> data) updateMove;
  const CustomMoveCreatorBody(
      {Key? key, required this.move, required this.updateMove})
      : super(key: key);

  @override
  _CustomMoveCreatorBodyState createState() => _CustomMoveCreatorBodyState();
}

class _CustomMoveCreatorBodyState extends State<CustomMoveCreatorBody> {
  final PageController _pageController = PageController();
  final Duration _animDuration = const Duration(milliseconds: 250);
  final Curve _animCurve = Curves.fastOutSlowIn;
  final double _kBodyAreaGraphicHeight = 550;

  void _animateToPage(int page) => _pageController.animateToPage(page,
      duration: _animDuration, curve: _animCurve);

  Future<void> _handleTapBodyArea(BodyArea bodyArea) async {
    await context.showBottomSheet(
        useRootNavigator: false,
        child: BodyAreaScoreAdjuster(
          bodyArea: bodyArea,
          bodyAreaMoveScores: widget.move.bodyAreaMoveScores,
          updateBodyAreaMoveScores: (updatedScores) {
            widget.updateMove({
              'BodyAreaMoveScores':
                  updatedScores.map((s) => s.toJson()).toList()
            });
            context.pop();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<BodyAreas$Query, json.JsonSerializable>(
        key: Key('CustomMoveCreatorBody - ${BodyAreasQuery().operationName}'),
        query: BodyAreasQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final allBodyAreas = data.bodyAreas;

          return SingleChildScrollView(
            child: Column(
              children: [
                if (widget.move.bodyAreaMoveScores.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: const [
                        MyText(
                          'Targeted areas not yet specified',
                          subtext: true,
                          lineHeight: 1.3,
                        ),
                        MyText(
                          '(Click body area to add / edit scores)',
                          subtext: true,
                          size: FONTSIZE.two,
                          lineHeight: 1.3,
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 4.0),
                    child: TargetedBodyAreasScoreList(
                      widget.move.bodyAreaMoveScores,
                      showNumericalScore: true,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: _kBodyAreaGraphicHeight,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        Stack(alignment: Alignment.topCenter, children: [
                          const Positioned(child: H3('Front')),
                          Positioned(
                              right: 0,
                              child: CupertinoButton(
                                  child: const MyText('Back >'),
                                  onPressed: () => _animateToPage(1))),
                          BodyAreaSelectorScoreIndicator(
                            bodyAreaMoveScores: widget.move.bodyAreaMoveScores,
                            frontBack: BodyAreaFrontBack.front,
                            allBodyAreas: allBodyAreas,
                            indicatePercentWithColor: true,
                            handleTapBodyArea: _handleTapBodyArea,
                            height: _kBodyAreaGraphicHeight,
                          ),
                        ]),
                        Stack(alignment: Alignment.topCenter, children: [
                          const Positioned(child: H3('Back')),
                          Positioned(
                              left: 0,
                              child: CupertinoButton(
                                  child: const MyText('< Front'),
                                  onPressed: () => _animateToPage(0))),
                          BodyAreaSelectorScoreIndicator(
                            bodyAreaMoveScores: widget.move.bodyAreaMoveScores,
                            frontBack: BodyAreaFrontBack.back,
                            allBodyAreas: allBodyAreas,
                            indicatePercentWithColor: true,
                            handleTapBodyArea: _handleTapBodyArea,
                            height: _kBodyAreaGraphicHeight,
                          ),
                        ]),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
