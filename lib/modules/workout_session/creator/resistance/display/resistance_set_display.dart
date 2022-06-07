import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/creator/resistance/display/resistance_set_reps_display.dart';

class ResistanceSetDisplay extends StatelessWidget {
  final ResistanceSet resistanceSet;
  const ResistanceSetDisplay({Key? key, required this.resistanceSet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final equipment = resistanceSet.equipment ??
        (resistanceSet.move.requiredEquipments.isNotEmpty
            ? resistanceSet.move.requiredEquipments[0]
            : null);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    resistanceSet.move.name,
                  ),
                  if (equipment != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: MyText(
                        equipment.name.toUpperCase(),
                        size: FONTSIZE.two,
                        subtext: true,
                      ),
                    ),
                ],
              ),
            ],
          ),
          RepsDisplay(
            resistanceSet: resistanceSet,
          ),
        ],
      ),
    );
  }
}
