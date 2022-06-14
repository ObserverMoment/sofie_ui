import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/workout_type_icons.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/body_areas/display/targeted_body_areas.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/services/repos/move_data.repo.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/graphql_type_extensions.dart';

class ResistanceWorkoutCard extends StatelessWidget {
  final ResistanceWorkout resistanceWorkout;
  final bool showUserAvatar;
  final bool showWorkoutTypeIndicator;
  const ResistanceWorkoutCard(
      {Key? key,
      required this.resistanceWorkout,
      this.showUserAvatar = false,
      this.showWorkoutTypeIndicator = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moveDataRepo = context.watch<MoveDataRepo>();
    final moves = resistanceWorkout.uniqueMovesInWorkout(moveDataRepo);
    final bodyAreas = resistanceWorkout.uniqueBodyAreas(moves);

    return Card(
        child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      resistanceWorkout.name,
                      size: FONTSIZE.four,
                      maxLines: 2,
                    ),
                    if (Utils.textNotNull(resistanceWorkout.note))
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: MyText(
                          resistanceWorkout.note!,
                          subtext: true,
                          maxLines: 4,
                          lineHeight: 1.4,
                        ),
                      ),
                    if (showUserAvatar || showWorkoutTypeIndicator)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            if (showUserAvatar)
                              Row(
                                children: [
                                  UserAvatar(
                                    avatarUri: resistanceWorkout.user.avatarUri,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 8),
                                  MyText(
                                    resistanceWorkout.user.displayName,
                                    size: FONTSIZE.one,
                                    subtext: true,
                                  ),
                                ],
                              ),
                            if (showWorkoutTypeIndicator)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: const [
                                    Icon(
                                      WorkoutType.resistance,
                                      size: 22,
                                    ),
                                    SizedBox(width: 8),
                                    MyText(
                                      'Resistance',
                                      size: FONTSIZE.one,
                                      subtext: true,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  TargetedBodyAreas(
                    height: 90,
                    frontBack: BodyAreaFrontBack.front,
                    selectedBodyAreas: bodyAreas
                        .where((ba) => ba.frontBack == BodyAreaFrontBack.front)
                        .toList(),
                  ),
                  const SizedBox(width: 8),
                  TargetedBodyAreas(
                    height: 90,
                    frontBack: BodyAreaFrontBack.back,
                    selectedBodyAreas: bodyAreas
                        .where((ba) => ba.frontBack == BodyAreaFrontBack.back)
                        .toList(),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ));
  }
}
