import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/body_areas/body_area_selector_overlay.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_graphics.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_lists.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/core_data_repo.dart';

class BodyAreaSelectorFrontBackPaged extends StatefulWidget {
  final List<BodyArea> selectedBodyAreas;
  final void Function(BodyArea bodyArea) handleTapBodyArea;
  final double bodyGraphicHeight;
  const BodyAreaSelectorFrontBackPaged(
      {Key? key,
      required this.selectedBodyAreas,
      required this.handleTapBodyArea,
      required this.bodyGraphicHeight})
      : super(key: key);

  @override
  _BodyAreaSelectorFrontBackPagedState createState() =>
      _BodyAreaSelectorFrontBackPagedState();
}

class _BodyAreaSelectorFrontBackPagedState
    extends State<BodyAreaSelectorFrontBackPaged> {
  late int _activePageIndex;

  @override
  void initState() {
    super.initState();
    _activePageIndex = 0;
  }

  void _updatePage(int page) {
    setState(() => _activePageIndex = page);
  }

  @override
  Widget build(BuildContext context) {
    final allBodyAreas = CoreDataRepo.bodyAreas;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: MySlidingSegmentedControl<int>(
            updateValue: _updatePage,
            value: _activePageIndex,
            children: const {
              0: 'Front',
              1: 'Back',
            },
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              height: widget.bodyGraphicHeight,
              width: double.infinity,
              child: IndexedStack(
                index: _activePageIndex,
                children: [
                  BodyAreaSelectorIndicator(
                      selectedBodyAreas: widget.selectedBodyAreas,
                      frontBack: BodyAreaFrontBack.front,
                      allBodyAreas: allBodyAreas,
                      handleTapBodyArea: widget.handleTapBodyArea,
                      height: widget.bodyGraphicHeight),
                  BodyAreaSelectorIndicator(
                      selectedBodyAreas: widget.selectedBodyAreas,
                      frontBack: BodyAreaFrontBack.back,
                      allBodyAreas: allBodyAreas,
                      handleTapBodyArea: widget.handleTapBodyArea,
                      height: widget.bodyGraphicHeight),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BodyAreaNamesList(
            bodyAreas: widget.selectedBodyAreas,
          ),
        ),
      ],
    );
  }
}

/// Consists of two components. The graphic displaying if each body area is selected or not - boolean - no opacity gradient or score amount indication. And a selector overlay with a gesture detector + clip path for each body area.
class BodyAreaSelectorIndicator extends StatelessWidget {
  final void Function(BodyArea bodyArea) handleTapBodyArea;
  final BodyAreaFrontBack frontBack;
  final List<BodyArea> allBodyAreas;
  final List<BodyArea> selectedBodyAreas;
  final double height;

  const BodyAreaSelectorIndicator(
      {Key? key,
      required this.handleTapBodyArea,
      required this.selectedBodyAreas,
      required this.frontBack,
      required this.allBodyAreas,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        TargetedBodyAreasSelectedIndicator(
            frontBack: frontBack,
            allBodyAreas: allBodyAreas,
            selectedBodyAreas: selectedBodyAreas,
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
