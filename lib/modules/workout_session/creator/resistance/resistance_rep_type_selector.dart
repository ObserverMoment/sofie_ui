import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class ResistanceRepTypeSelector extends StatelessWidget {
  final ResistanceSetRepType? resistanceSetRepType;
  final void Function(ResistanceSetRepType repType) updateResistanceSetRepType;
  final double height;
  const ResistanceRepTypeSelector(
      {Key? key,
      this.resistanceSetRepType,
      required this.updateResistanceSetRepType,
      this.height = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopoverMenu(
        button: Card(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                resistanceSetRepType != null
                    ? resistanceSetRepType!.display.toUpperCase()
                    : 'select',
                subtext: resistanceSetRepType == null,
              ),
            ],
          ),
        ),
        items: ResistanceSetRepType.values
            .where((v) => v != ResistanceSetRepType.artemisUnknown)
            .map((v) => PopoverMenuItem(
                  isActive: resistanceSetRepType == v,
                  onTap: () => updateResistanceSetRepType(v),
                  text: v.display,
                ))
            .toList());
  }
}
