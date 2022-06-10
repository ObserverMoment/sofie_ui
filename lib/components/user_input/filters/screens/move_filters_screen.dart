import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/body_areas/body_area_selectors.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/move_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/screens/filters_screen_footer.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';
import 'package:sofie_ui/services/utils.dart';

/// Screen for inputting MoveFilter settings.
/// Also handles persisting the selected settings to Hive box on the device and retrieving them on initial build.
class MoveFiltersScreen extends StatefulWidget {
  const MoveFiltersScreen({Key? key}) : super(key: key);

  @override
  _MoveFiltersScreenState createState() => _MoveFiltersScreenState();
}

class _MoveFiltersScreenState extends State<MoveFiltersScreen> {
  int _activeTabIndex = 0;
  late MoveFilters _activeMoveFilters;

  @override
  void initState() {
    super.initState();
    _activeMoveFilters = context.read<MoveFiltersBloc>().filters;
  }

  Future<void> _saveAndClose() async {
    await context.read<MoveFiltersBloc>().updateFilters(_activeMoveFilters);
    context.pop();
  }

  void _changeTab(int index) {
    Utils.hideKeyboard(context);
    setState(() => _activeTabIndex = index);
  }

  void _updateMoveTypes(List<MoveType> moveTypes) =>
      setState(() => _activeMoveFilters.moveTypes = moveTypes);

  void _toggleBodyweightOnly(bool b) =>
      setState(() => _activeMoveFilters.bodyWeightOnly = b);

  void _updateEquipments(List<Equipment> equipments) =>
      setState(() => _activeMoveFilters.equipments = equipments);

  void _updateBodyAreas(List<BodyArea> bodyAreas) =>
      setState(() => _activeMoveFilters.bodyAreas = bodyAreas);

  void _clearAllFilters() {
    setState(() {
      _activeMoveFilters.moveTypes = [];
      _activeMoveFilters.bodyWeightOnly = false;
      _activeMoveFilters.equipments = [];
      _activeMoveFilters.bodyAreas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: MySlidingSegmentedControl(
                  value: _activeTabIndex,
                  children: const {
                    0: 'Types',
                    1: 'Equipment',
                    2: 'Body',
                  },
                  updateValue: _changeTab),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _activeTabIndex,
              children: [
                MoveFiltersTypes(
                  selectedMoveTypes: _activeMoveFilters.moveTypes,
                  updateSelected: _updateMoveTypes,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MoveFiltersEquipment(
                    bodyweightOnly: _activeMoveFilters.bodyWeightOnly,
                    toggleBodyweight: _toggleBodyweightOnly,
                    handleSelection: (e) => _updateEquipments(
                        _activeMoveFilters.equipments.toggleItem<Equipment>(e)),
                    selectedEquipments: _activeMoveFilters.equipments,
                  ),
                ),
                MoveFiltersBody(
                    selectedBodyAreas: _activeMoveFilters.bodyAreas,
                    handleTapBodyArea: (ba) => _updateBodyAreas(
                        _activeMoveFilters.bodyAreas.toggleItem<BodyArea>(ba))),
              ],
            ),
          ),
          FiltersScreenFooter(
            numActiveFilters: _activeMoveFilters.numActiveFilters,
            clearFilters: _clearAllFilters,
            showResults: _saveAndClose,
          )
        ],
      ),
    ));
  }
}

class MoveFiltersTypes extends StatelessWidget {
  final List<MoveType> selectedMoveTypes;
  final void Function(List<MoveType> updated) updateSelected;

  const MoveFiltersTypes({
    Key? key,
    required this.selectedMoveTypes,
    required this.updateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allMoveTypes = CoreDataRepo.moveTypes;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              Expanded(
                child: SelectableBoxExpanded(
                    isSelected: selectedMoveTypes.isEmpty,
                    onPressed: () {
                      if (selectedMoveTypes.isEmpty) {
                        updateSelected([...allMoveTypes]);
                      } else {
                        updateSelected([]);
                      }
                    },
                    text: 'ALL'),
              ),
            ],
          ),
        ),
        ...allMoveTypes
            .map((type) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SelectableBoxExpanded(
                    text: type.name,
                    isSelected: selectedMoveTypes.contains(type),
                    onPressed: () => updateSelected(
                        selectedMoveTypes.toggleItem<MoveType>(type)),
                  ),
                ))
            .toList(),
      ]),
    );
  }
}

class MoveFiltersEquipment extends StatelessWidget {
  final bool bodyweightOnly;
  final void Function(bool b) toggleBodyweight;
  final List<Equipment> selectedEquipments;
  final void Function(Equipment e) handleSelection;
  const MoveFiltersEquipment(
      {Key? key,
      required this.selectedEquipments,
      required this.handleSelection,
      required this.toggleBodyweight,
      required this.bodyweightOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoSwitchRow(
            title: 'Bodyweight Moves Only',
            updateValue: toggleBodyweight,
            value: bodyweightOnly),
        if (!bodyweightOnly)
          Expanded(
            child: FadeIn(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: EquipmentMultiSelectorGrid(
                      selectedEquipments: selectedEquipments,
                      equipments: CoreDataRepo.equipment,
                      fontSize: FONTSIZE.two,
                      showIcon: true,
                      handleSelection: handleSelection)),
            ),
          ),
      ],
    );
  }
}

class MoveFiltersBody extends StatelessWidget {
  final List<BodyArea> selectedBodyAreas;
  final void Function(BodyArea bodyArea) handleTapBodyArea;
  const MoveFiltersBody({
    Key? key,
    required this.selectedBodyAreas,
    required this.handleTapBodyArea,
  }) : super(key: key);

  final double kBodyGraphicHeight = 420;

  @override
  Widget build(BuildContext context) {
    return BodyAreaSelectorFrontBackPaged(
      bodyGraphicHeight: kBodyGraphicHeight,
      handleTapBodyArea: handleTapBodyArea,
      selectedBodyAreas: selectedBodyAreas,
    );
  }
}
