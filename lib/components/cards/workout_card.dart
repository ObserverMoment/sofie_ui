import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/body_areas/targeted_body_areas_graphics.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutSummary workout;
  final int? elevation;
  final EdgeInsets padding;

  const WorkoutCard(
    this.workout, {
    Key? key,
    this.elevation,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  }) : super(key: key);

  Widget _buildLoggedSessionsCount(
          BuildContext context, int count, Color contentOverlayColor) =>
      count > 0
          ? Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: contentOverlayColor),
              child: Column(
                children: [
                  MyText(
                    count.displayLong,
                    color: Styles.white,
                  ),
                  const MyText(
                    'sessions',
                    size: FONTSIZE.one,
                    color: Styles.white,
                  ),
                ],
              ),
            )
          : Container();

  @override
  Widget build(BuildContext context) {
    // Calc the ideal image size based on the display size.
    // Cards usually take up the full width.
    // // Making the raw requested image larger than the display space - otherwise it seems to appear blurred. More investigation required.
    final double width = MediaQuery.of(context).size.width;
    final Dimensions dimensions = Dimensions.square((width * 1.5).toInt());

    const infoFontColor = Styles.white;

    /// Don't show 'Custom' as a tag.
    final sectionTagsToDisplay =
        workout.sectionTypes.where((t) => t != kCustomSessionName).toList();

    final allBodyAreas = CoreDataRepo.bodyAreas;
    final targetedBodyAreas =
        allBodyAreas.where((b) => workout.bodyAreas.contains(b.id)).toList();

    return Card(
        margin: const EdgeInsets.all(2),
        backgroundImage: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Styles.black.withOpacity(0.5), BlendMode.darken),
            image: Utils.textNotNull(workout.coverImageUri)
                ? UploadcareImageProvider(workout.coverImageUri!,
                    transformations: [PreviewTransformation(dimensions)])
                : const AssetImage(
                    'assets/placeholder_images/workout.jpg',
                  ) as ImageProvider),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              workout.name,
              lineHeight: 1.3,
              color: infoFontColor,
              size: FONTSIZE.four,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 2),
            MyText(
              workout.user.displayName.toUpperCase(),
              size: FONTSIZE.one,
              color: infoFontColor,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (workout.lengthMinutes != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.timer,
                                size: 17,
                                color: infoFontColor,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                Duration(minutes: workout.lengthMinutes!)
                                    .displayString,
                                color: infoFontColor,
                                weight: FontWeight.bold,
                              )
                            ],
                          ),
                        ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          ...sectionTagsToDisplay
                              .map((t) => _WorkoutCardTag(
                                    name: t,
                                    type: _WorkoutTagType.section,
                                  ))
                              .toList(),
                          ...workout.goals
                              .map((t) => _WorkoutCardTag(
                                    name: t,
                                    type: _WorkoutTagType.goal,
                                  ))
                              .toList(),
                          ...workout.tags
                              .map((t) => _WorkoutCardTag(
                                  name: t, type: _WorkoutTagType.tag))
                              .toList(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildLoggedSessionsCount(context,
                                workout.loggedSessionsCount, Styles.black),
                            ...workout.equipments
                                .map(
                                  (e) => SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Utils.getEquipmentIcon(context, e,
                                        color: infoFontColor),
                                  ),
                                )
                                .toList(),
                          ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (workout.difficultyLevel != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              DifficultyLevelDot(
                                difficultyLevel: workout.difficultyLevel!,
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              MyText(
                                workout.difficultyLevel!.display,
                                size: FONTSIZE.one,
                                color: infoFontColor,
                                weight: FontWeight.bold,
                              )
                            ],
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TargetedBodyAreasSelectedIndicator(
                              activeColor: infoFontColor,
                              inactiveColor: Styles.white.withOpacity(0.3),
                              frontBack: BodyAreaFrontBack.front,
                              allBodyAreas: allBodyAreas,
                              selectedBodyAreas: targetedBodyAreas,
                              height: 90),
                          TargetedBodyAreasSelectedIndicator(
                              inactiveColor: Styles.white.withOpacity(0.3),
                              activeColor: infoFontColor,
                              frontBack: BodyAreaFrontBack.back,
                              allBodyAreas: allBodyAreas,
                              selectedBodyAreas: targetedBodyAreas,
                              height: 90),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (Utils.textNotNull(workout.description))
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 4),
                child: MyText(
                  workout.description!,
                  color: infoFontColor,
                  maxLines: 3,
                  size: FONTSIZE.two,
                ),
              ),
          ],
        ));
  }
}

enum _WorkoutTagType { section, goal, tag }

class _WorkoutCardTag extends StatelessWidget {
  final String name;
  final _WorkoutTagType type;
  const _WorkoutCardTag({Key? key, required this.name, required this.type})
      : super(key: key);

  IconData get _icon {
    switch (type) {
      case _WorkoutTagType.section:
        return CupertinoIcons.circle_grid_3x3;
      case _WorkoutTagType.goal:
        return CupertinoIcons.scope;
      case _WorkoutTagType.tag:
        return CupertinoIcons.tag;
      default:
        throw Exception('No Icon has been defined for $type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      backgroundColor: context.theme.modalBackground,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(_icon, size: 12),
        const SizedBox(width: 4),
        MyText(
          name,
          size: FONTSIZE.two,
        ),
      ]),
    );
  }
}
