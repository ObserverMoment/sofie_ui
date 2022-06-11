import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/body_areas/targeted_body_areas_display.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/services/repos/move_data.repo.dart';
import 'package:sofie_ui/services/utils.dart';

class ResistanceSessionCard extends StatelessWidget {
  final UserResistanceSessionSummary resistanceSession;
  final bool showUserAvatar;
  const ResistanceSessionCard(
      {Key? key, required this.resistanceSession, required this.showUserAvatar})
      : super(key: key);

  List<Move> _uniqueMovesInSession(MoveDataRepo moveDataRepo) {
    Set<String> moveIds = {};
    for (final e in resistanceSession.resistanceExerciseSummary) {
      for (final s in e.resistanceSetSummary) {
        moveIds.add(s.moveSummary.id);
      }
    }

    return moveIds.map((id) => moveDataRepo.moveById(id)).toList();
  }

  List<BodyArea> _uniqueBodyAreas(List<Move> moves) {
    return moves.fold<Set<BodyArea>>({}, (acum, next) {
      final bodyAreas =
          moves.map((m) => m.bodyAreaMoveScores.map((bams) => bams.bodyArea));
      acum.addAll(bodyAreas.expand((b) => b));
      return acum;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final moveDataRepo = context.watch<MoveDataRepo>();
    final moves = _uniqueMovesInSession(moveDataRepo);
    final bodyAreas = _uniqueBodyAreas(moves);

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
                      resistanceSession.name,
                      size: FONTSIZE.four,
                      maxLines: 2,
                    ),
                    if (Utils.textNotNull(resistanceSession.note))
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: MyText(
                          resistanceSession.note!,
                          subtext: true,
                          maxLines: 4,
                          lineHeight: 1.4,
                        ),
                      ),
                    if (true)
                      // if (showUserAvatar)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            UserAvatar(
                              avatarUri: resistanceSession.user.avatarUri,
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            MyText(
                              resistanceSession.user.displayName,
                              size: FONTSIZE.one,
                              subtext: true,
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
                  TargetedBodyAreasDisplay(
                    height: 90,
                    frontBack: BodyAreaFrontBack.front,
                    selectedBodyAreas: bodyAreas
                        .where((ba) => ba.frontBack == BodyAreaFrontBack.front)
                        .toList(),
                  ),
                  const SizedBox(width: 8),
                  TargetedBodyAreasDisplay(
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
