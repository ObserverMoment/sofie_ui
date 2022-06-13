import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_lists.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/video/video_players.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/modules/body_areas/display/targeted_body_areas_score_indicator.dart';
import 'package:sofie_ui/services/repos/move_data.repo.dart';
import 'package:sofie_ui/services/utils.dart';

/// Info about an exercise. Video and description + authed user's history with this move based on their logs.
class MoveDetailsPage extends StatelessWidget {
  final String id;
  final String? previousPageTitle;
  const MoveDetailsPage(
      {Key? key, @PathParam('id') required this.id, this.previousPageTitle})
      : super(key: key);

  double get kBodyGraphicHeight => 360.0;

  Widget _buildEquipmentLists(MoveData move) => Column(
        children: [
          if (move.requiredEquipments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const MyHeaderText('Required Equipment'),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    runAlignment: WrapAlignment.center,
                    children: move.requiredEquipments
                        .map(
                          (e) => SizedBox(
                            width: 88,
                            height: 88,
                            child: EquipmentTile(
                              equipment: e,
                              fontSize: FONTSIZE.two,
                              isSelected: true,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          if (move.selectableEquipments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const MyHeaderText('Equipment Variants'),
                  const SizedBox(height: 10),
                  const MyText(
                    'You can select one of these for completing the move. Generally, these will be different modes of load / resistance (free weights, bands, machines etc), or items needed for certain modifications.',
                    size: FONTSIZE.two,
                    textAlign: TextAlign.center,
                    maxLines: 8,
                    lineHeight: 1.25,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    runAlignment: WrapAlignment.center,
                    children: move.selectableEquipments
                        .map(
                          (e) => SizedBox(
                            width: 88,
                            height: 88,
                            child: EquipmentTile(
                              equipment: e,
                              fontSize: FONTSIZE.two,
                              isSelected: true,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            )
        ],
      );

  @override
  Widget build(BuildContext context) {
    final moveData = context.watch<MoveDataRepo>().moveDataById(id);

    if (moveData == null) {
      return const ObjectNotFoundIndicator();
    }

    final bool bodyWeightOnly = moveData.requiredEquipments.isEmpty &&
        moveData.selectableEquipments.isEmpty;

    return CupertinoPageScaffold(
        navigationBar: MyNavBar(
          previousPageTitle: previousPageTitle,
          middle: NavBarTitle(moveData.name),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (moveData.demoVideoUri != null)
                SizedBox(
                    height: 230,
                    child: LandscapeInlineVideoPlayer(
                      videoUri: moveData.demoVideoUri!,
                      title: moveData.name,
                    )),
              if (Utils.textNotNull(moveData.description))
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: MyText(
                      moveData.description!,
                      textAlign: TextAlign.center,
                      maxLines: 10,
                      lineHeight: 1.5,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: MyHeaderText(
                        'Targeted Body Areas',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TargetedBodyAreasScoreList(moveData.bodyAreaMoveScores),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Utils.notNullNotEmpty(moveData.bodyAreaMoveScores)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TargetedBodyAreasScoreIndicator(
                                    bodyAreaMoveScores:
                                        moveData.bodyAreaMoveScores,
                                    frontBack: BodyAreaFrontBack.front,
                                    height: kBodyGraphicHeight),
                                TargetedBodyAreasScoreIndicator(
                                    bodyAreaMoveScores:
                                        moveData.bodyAreaMoveScores,
                                    frontBack: BodyAreaFrontBack.back,
                                    height: kBodyGraphicHeight)
                              ],
                            )
                          : const MyText('Body areas not specified'),
                    ),
                  ],
                ),
              ),
              const HorizontalLine(),
              if (bodyWeightOnly)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const H3('Bodyweight Only'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        MyText('This move requires no equipment'),
                      ],
                    ),
                  ],
                )
              else
                _buildEquipmentLists(moveData),
              const HorizontalLine(),
            ],
          ),
        ));
  }
}
