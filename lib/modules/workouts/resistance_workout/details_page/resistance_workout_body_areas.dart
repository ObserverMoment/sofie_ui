import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/body_areas/display/targeted_body_areas.dart';
import 'package:sofie_ui/services/repos/move_data.repo.dart';
import 'package:sofie_ui/extensions/graphql_type_extensions.dart';

class ResistanceWorkoutBodyAreas extends StatelessWidget {
  final ResistanceWorkout resistanceWorkout;
  const ResistanceWorkoutBodyAreas({Key? key, required this.resistanceWorkout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moveDataRepo = context.watch<MoveDataRepo>();
    final moves = resistanceWorkout.uniqueMovesInWorkout(moveDataRepo);
    final bodyAreas = resistanceWorkout.uniqueBodyAreas(moves);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TargetedBodyAreas(
                height: 380,
                frontBack: BodyAreaFrontBack.front,
                selectedBodyAreas: bodyAreas
                    .where((ba) => ba.frontBack == BodyAreaFrontBack.front)
                    .toList(),
              ),
              const SizedBox(width: 8),
              TargetedBodyAreas(
                height: 380,
                frontBack: BodyAreaFrontBack.back,
                selectedBodyAreas: bodyAreas
                    .where((ba) => ba.frontBack == BodyAreaFrontBack.back)
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
