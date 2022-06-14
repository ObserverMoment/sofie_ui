import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/display/resistance_set_reps_display.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/repos/move_data.repo.dart';

class ResistanceSetDisplay extends StatelessWidget {
  final ResistanceSet resistanceSet;
  final bool openMoveInfoPageOnTap;
  const ResistanceSetDisplay(
      {Key? key,
      required this.resistanceSet,
      this.openMoveInfoPageOnTap = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moveData =
        context.watch<MoveDataRepo>().moveDataById(resistanceSet.move.id);

    if (moveData == null) {
      /// TODO: Get data from API for custom move which is not in the repo?
    }

    final equipment = resistanceSet.equipment ??
        (moveData!.requiredEquipments.isNotEmpty
            ? moveData.requiredEquipments[0]
            : null);

    return GestureDetector(
      onTap: openMoveInfoPageOnTap
          ? () =>
              context.navigateTo(MoveDetailsRoute(id: resistanceSet.move.id))
          : null,
      behavior: openMoveInfoPageOnTap
          ? HitTestBehavior.opaque
          : HitTestBehavior.translucent,
      child: Padding(
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
      ),
    );
  }
}
