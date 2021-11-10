import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_graphics.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_lists.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/video/better_player_video_player.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/utils.dart';

/// Info about and exercise. Video and description.
class MoveDetails extends StatelessWidget {
  final Move move;
  const MoveDetails(this.move, {Key? key}) : super(key: key);

  double get kBodyGraphicHeight => 380.0;

  Widget _buildEquipmentLists(Move move) => Column(
        children: [
          if (move.requiredEquipments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const H3('Required Equipment'),
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
                              withBorder: false,
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
                  const H3('Selectable Equipment'),
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
                              withBorder: false,
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
    final bool _bodyWeightOnly =
        move.requiredEquipments.isEmpty && move.selectableEquipments.isEmpty;

    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarChevronDownButton(context.pop),
        backgroundColor: context.theme.background,
        middle: NavBarTitle(move.name),
      ),
      child: QueryObserver<BodyAreas$Query, json.JsonSerializable>(
        key: Key('MoveDetails - ${BodyAreasQuery().operationName}'),
        query: BodyAreasQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        loadingIndicator: const ShimmerCardList(
          itemCount: 7,
        ),
        builder: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (move.demoVideoUri != null)
                  SizedBox(
                      height: 220,
                      child: BetterPlayerVideoPlayerWrapper(
                        uri: move.demoVideoUri!,
                        autoLoop: true,
                        autoPlay: false,
                      )),
                if (Utils.textNotNull(move.description))
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: MyText(
                        move.description!,
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
                        child: H3(
                          'Targeted Body Areas',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TargetedBodyAreasScoreList(move.bodyAreaMoveScores),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Utils.notNullNotEmpty(move.bodyAreaMoveScores)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TargetedBodyAreasScoreIndicator(
                                      bodyAreaMoveScores:
                                          move.bodyAreaMoveScores,
                                      frontBack: BodyAreaFrontBack.front,
                                      allBodyAreas: data.bodyAreas,
                                      height: kBodyGraphicHeight),
                                  TargetedBodyAreasScoreIndicator(
                                      bodyAreaMoveScores:
                                          move.bodyAreaMoveScores,
                                      frontBack: BodyAreaFrontBack.back,
                                      allBodyAreas: data.bodyAreas,
                                      height: kBodyGraphicHeight)
                                ],
                              )
                            : const MyText('Body areas not specified'),
                      ),
                    ],
                  ),
                ),
                const HorizontalLine(),
                if (_bodyWeightOnly)
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
                  _buildEquipmentLists(move),
                const HorizontalLine(),
              ],
            ),
          );
        },
      ),
    );
  }
}
