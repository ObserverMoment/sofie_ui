import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class ClubCard extends StatelessWidget {
  final ClubSummary club;
  const ClubCard({Key? key, required this.club}) : super(key: key);

  double get _iconSize => 12.0;

  @override
  Widget build(BuildContext context) {
    // Calc the ideal image size based on the display size.
    // Cards usually take up the full width.
    // // Making the raw requested image larger than the display space - otherwise it seems to appear blurred. More investigation required.
    final double width = MediaQuery.of(context).size.width;
    final Dimensions dimensions = Dimensions.square((width * 1.5).toInt());
    final Color contentOverlayColor = Styles.black.withOpacity(0.85);

    /// The lower section seems to need to have a border radius of one lower than that of the whole card to avoid a small peak of the underlying image - why does the corner get cut by 1 px?
    const borderRadius = 8.0;
    const infoFontColor = Styles.white;

    return Card(
        elevation: 2,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(borderRadius),
        backgroundImage: DecorationImage(
            fit: BoxFit.cover,
            image: Utils.textNotNull(club.coverImageUri)
                ? UploadcareImageProvider(club.coverImageUri!,
                    transformations: [PreviewTransformation(dimensions)])
                : const AssetImage(
                    'assets/placeholder_images/workout.jpg',
                  ) as ImageProvider),
        child: Column(
          children: [
            SizedBox(
                height: 140,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _StatSummaryTag(
                        contentOverlayColor: contentOverlayColor,
                        count: club.memberCount,
                        icon: Icon(CupertinoIcons.person_2_fill,
                            size: _iconSize, color: infoFontColor),
                        infoFontColor: infoFontColor,
                        label: 'People',
                      ),
                      _StatSummaryTag(
                        contentOverlayColor: contentOverlayColor,
                        count: club.workoutCount,
                        icon: SvgPicture.asset(
                          'assets/graphics/dumbbell.svg',
                          height: 12,
                          fit: BoxFit.cover,
                          color: infoFontColor,
                        ),
                        infoFontColor: infoFontColor,
                        label: 'WODs',
                      ),
                      _StatSummaryTag(
                        contentOverlayColor: contentOverlayColor,
                        count: club.planCount,
                        icon: Icon(CupertinoIcons.calendar,
                            size: _iconSize, color: infoFontColor),
                        infoFontColor: infoFontColor,
                        label: 'Plans',
                      ),
                    ],
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                  color: contentOverlayColor,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius))),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyHeaderText(
                                  club.name,
                                  lineHeight: 1.3,
                                  color: infoFontColor,
                                  maxLines: 2,
                                  size: FONTSIZE.four,
                                  weight: FontWeight.bold,
                                ),
                                if (Utils.textNotNull(club.location))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          CupertinoIcons.location,
                                          size: 12,
                                          color: Styles.white,
                                        ),
                                        const SizedBox(width: 4),
                                        MyText(
                                          club.location!,
                                          size: FONTSIZE.two,
                                          color: Styles.white,
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            MyText(
                              club.owner.displayName.toUpperCase(),
                              color: infoFontColor,
                              size: FONTSIZE.one,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (Utils.textNotNull(club.description))
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: MyText(
                        club.description!,
                        maxLines: 2,
                        lineHeight: 1.3,
                        color: infoFontColor,
                        size: FONTSIZE.two,
                      ),
                    ),
                ],
              ),
            )
          ],
        ));
  }
}

class _StatSummaryTag extends StatelessWidget {
  final Color contentOverlayColor;
  final Color infoFontColor;
  final Widget icon;
  final int count;
  final String label;
  const _StatSummaryTag(
      {Key? key,
      required this.contentOverlayColor,
      required this.infoFontColor,
      required this.icon,
      required this.count,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ContentBox(
        backgroundColor: contentOverlayColor,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 6),
                MyText(count.toString(),
                    size: FONTSIZE.two, color: infoFontColor)
              ],
            ),
            MyText(label, size: FONTSIZE.one, color: infoFontColor)
          ],
        ),
      ),
    );
  }
}
