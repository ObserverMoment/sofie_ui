import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/body_areas/body_area_score_adjuster.dart';
import 'package:sofie_ui/components/body_areas/body_area_selector_score_indicator.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

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
  /// 0 = Front. 1 = Back.
  int _activePageIndex = 0;
  final double _kBodyAreaGraphicHeight = 500;

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
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.move.bodyAreaMoveScores.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 8.0),
              child: MyText(
                'Non specified. Tap Body Area to edit scores',
                color: Styles.primaryAccent,
                lineHeight: 1.3,
                size: FONTSIZE.two,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8.0),
              child: TargetedBodyAreasScoreList(
                widget.move.bodyAreaMoveScores,
                showNumericalScore: true,
              ),
            ),
          MySlidingSegmentedControl<int>(
              children: const {0: 'Front', 1: 'Back'},
              updateValue: (i) => setState(() => _activePageIndex = i),
              value: _activePageIndex),
          SizedBox(
            height: _kBodyAreaGraphicHeight,
            width: double.infinity,
            child: IndexedStack(
              alignment: Alignment.center,
              index: _activePageIndex,
              children: [
                BodyAreaSelectorScoreIndicator(
                  bodyAreaMoveScores: widget.move.bodyAreaMoveScores,
                  frontBack: BodyAreaFrontBack.front,
                  indicatePercentWithColor: true,
                  handleTapBodyArea: _handleTapBodyArea,
                  height: _kBodyAreaGraphicHeight,
                ),
                BodyAreaSelectorScoreIndicator(
                  bodyAreaMoveScores: widget.move.bodyAreaMoveScores,
                  frontBack: BodyAreaFrontBack.back,
                  indicatePercentWithColor: true,
                  handleTapBodyArea: _handleTapBodyArea,
                  height: _kBodyAreaGraphicHeight,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
