import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: contentOverlayColor),
              child: Column(
                children: [
                  MyText(
                    count.displayLong,
                  ),
                  const MyText(
                    'sessions',
                    size: FONTSIZE.one,
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
    final Color contentOverlayColor =
        Styles.black.withOpacity(kImageOverlayOpacity);

    /// The lower section seems to need to have a border radius of one lower than that of the whole card to avoid a small peak of the underlying image - why does the corner get cut by 1 px?
    const borderRadius = 8.0;
    const infoFontColor = Styles.white;

    return Card(
      elevation: 2,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(borderRadius),
      backgroundImage: DecorationImage(
          fit: BoxFit.cover,
          image: Utils.textNotNull(workout.coverImageUri)
              ? UploadcareImageProvider(workout.coverImageUri!,
                  transformations: [PreviewTransformation(dimensions)])
              : const AssetImage(
                  'assets/placeholder_images/workout.jpg',
                ) as ImageProvider),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 150,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLoggedSessionsCount(context,
                            workout.loggedSessionsCount, contentOverlayColor),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (workout.lengthMinutes != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: DurationTag(
                                  duration:
                                      Duration(minutes: workout.lengthMinutes!),
                                  backgroundColor: contentOverlayColor,
                                  textColor: infoFontColor,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Opacity(
                                opacity: 0.75,
                                child: DifficultyLevelDot(
                                  difficultyLevel: workout.difficultyLevel,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.end,
                      verticalDirection: VerticalDirection.up,
                      spacing: 4,
                      runSpacing: 4,
                      children: workout.equipments
                          .map(
                            (e) => Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: contentOverlayColor),
                                padding: const EdgeInsets.all(3),
                                width: 28,
                                height: 28,
                                child: Utils.getEquipmentIcon(context, e,
                                    color: infoFontColor)),
                          )
                          .toList(),
                    ),
                  ],
                ),
              )),
          Container(
            decoration: BoxDecoration(
                color: Styles.black.withOpacity(kImageOverlayOpacity),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius))),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyHeaderText(
                            workout.name,
                            lineHeight: 1.3,
                            color: infoFontColor,
                          ),
                          const SizedBox(height: 3),
                          MyText(
                            workout.user.displayName.toUpperCase(),
                            size: FONTSIZE.two,
                            lineHeight: 1.4,
                            color: infoFontColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (Utils.textNotNull(workout.description))
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: MyText(workout.description!, subtext: true),
                  ),
                if (workout.tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CommaSeparatedList(
                        workout.tags.where((t) => t != 'Custom').toList(),
                        textColor: Styles.secondaryAccent),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
