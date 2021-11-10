import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class EquipmentTile extends StatelessWidget {
  final Equipment equipment;
  final bool showIcon;
  final bool showText;
  final bool isSelected;
  final double iconSize;
  final FONTSIZE fontSize;
  final bool withBorder;
  const EquipmentTile(
      {Key? key,
      required this.equipment,
      this.isSelected = false,
      this.showIcon = true,
      this.showText = true,
      this.iconSize = 35,
      this.fontSize = FONTSIZE.three,
      this.withBorder = true})
      : assert(showIcon || showText),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primary = context.theme.primary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: isSelected ? Styles.primaryAccent : primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border:
              withBorder ? Border.all(color: primary.withOpacity(0.5)) : null),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (showIcon)
            SizedBox(
                width: iconSize,
                height: iconSize,
                child: Utils.getEquipmentIcon(context, equipment.name,
                    isSelected: isSelected,
                    color:
                        isSelected ? Styles.white : primary.withOpacity(0.8))),
          if (showText)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: MyText(
                  equipment.name,
                  size: fontSize,
                  color: isSelected ? Styles.white : primary.withOpacity(0.8),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  lineHeight: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Horizontal scrolling list - single row.
class EquipmentSelectorList extends StatelessWidget {
  final List<Equipment> selectedEquipments;
  final List<Equipment> equipments;
  final Function(Equipment) handleSelection;
  final bool showIcon;
  final bool tilesBorder;
  final FONTSIZE fontSize;
  final double tileSize;
  const EquipmentSelectorList({
    Key? key,
    required this.selectedEquipments,
    required this.equipments,
    this.showIcon = false,
    required this.handleSelection,
    this.fontSize = FONTSIZE.two,
    this.tilesBorder = false,
    this.tileSize = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tileSize,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: equipments.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => handleSelection(equipments[index]),
              child: Container(
                width: tileSize,
                height: tileSize,
                padding: const EdgeInsets.only(right: 8.0),
                child: EquipmentTile(
                    showIcon: showIcon,
                    equipment: equipments[index],
                    withBorder: tilesBorder,
                    fontSize: fontSize,
                    isSelected: selectedEquipments.contains(equipments[index])),
              ),
            );
          }),
    );
  }
}

class EquipmentMultiSelectorGrid extends StatelessWidget {
  final List<Equipment> selectedEquipments;
  final List<Equipment> equipments;
  final Function(Equipment) handleSelection;
  final bool showIcon;
  final int crossAxisCount;
  final bool tilesBorder;
  final FONTSIZE fontSize;
  const EquipmentMultiSelectorGrid({
    Key? key,
    required this.selectedEquipments,
    required this.equipments,
    this.showIcon = false,
    required this.handleSelection,
    this.crossAxisCount = 4,
    this.fontSize = FONTSIZE.three,
    this.tilesBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: equipments.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => handleSelection(equipments[index]),
            child: EquipmentTile(
                showIcon: showIcon,
                equipment: equipments[index],
                withBorder: tilesBorder,
                fontSize: fontSize,
                isSelected: selectedEquipments.contains(equipments[index])),
          );
        });
  }
}

class FullScreenEquipmentSelector extends StatefulWidget {
  final List<Equipment> selectedEquipments;
  final List<Equipment> allEquipments;
  final Function(List<Equipment>) handleSelection;
  final int crossAxisCount;
  final bool tilesBorder;
  final FONTSIZE fontSize;
  const FullScreenEquipmentSelector({
    Key? key,
    required this.selectedEquipments,
    required this.allEquipments,
    required this.handleSelection,
    this.crossAxisCount = 4,
    this.fontSize = FONTSIZE.two,
    this.tilesBorder = true,
  }) : super(key: key);

  @override
  _FullScreenEquipmentSelectorState createState() =>
      _FullScreenEquipmentSelectorState();
}

class _FullScreenEquipmentSelectorState
    extends State<FullScreenEquipmentSelector> {
  late List<Equipment> _activeSelectedEquipments;

  @override
  void initState() {
    super.initState();
    _activeSelectedEquipments = [...widget.selectedEquipments];
  }

  void _handleSelection(Equipment e) {
    setState(() =>
        _activeSelectedEquipments = _activeSelectedEquipments.toggleItem(e));
    widget.handleSelection(_activeSelectedEquipments);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: const NavBarTitle('Select Equipment'),
        trailing: NavBarSaveButton(
          context.pop,
          text: 'Done',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: EquipmentMultiSelectorGrid(
          showIcon: true,
          equipments: widget.allEquipments,
          handleSelection: _handleSelection,
          selectedEquipments: _activeSelectedEquipments,
          fontSize: widget.fontSize,
          tilesBorder: widget.tilesBorder,
        ),
      ),
    );
  }
}
