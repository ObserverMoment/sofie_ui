import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class DiscoverClubCard extends StatelessWidget {
  final ClubSummary club;
  const DiscoverClubCard({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calc the ideal image size based on the display size.
    // Cards usually take up the full width.
    // // Making the raw requested image larger than the display space - otherwise it seems to appear blurred. More investigation required.
    final double width = MediaQuery.of(context).size.width;
    final Dimensions dimensions = Dimensions.square((width * 1.5).toInt());
    final Color contentOverlayColor =
        Styles.black.withOpacity(kImageOverlayOpacity);
    const overlayContentPadding =
        EdgeInsets.symmetric(vertical: 4, horizontal: 8);

    /// The lower section seems to need to have a border radius of one lower than that of the whole card to avoid a small peak of the underlying image - why does the corner get cut by 1 px?
    const borderRadius = 8.0;

    return Column(
      children: [
        Expanded(
          child: Card(
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
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Stack(
                  children: [
                    if (Utils.textNotNull(club.location))
                      Positioned(
                        top: 0,
                        left: 0,
                        child: ContentBox(
                          backgroundColor: contentOverlayColor,
                          padding: overlayContentPadding,
                          borderRadius: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.location,
                                  size: 13, color: Styles.secondaryAccent),
                              const SizedBox(width: 2),
                              MyText(
                                club.location!,
                                color: Styles.secondaryAccent,
                                size: FONTSIZE.two,
                              )
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ContentBox(
                        backgroundColor: contentOverlayColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.person_2_fill,
                                    size: 12, color: Styles.white),
                                const SizedBox(width: 6),
                                MyText(
                                  club.memberCount.toString(),
                                  size: FONTSIZE.two,
                                  color: Styles.white,
                                )
                              ],
                            ),
                            const MyText('Members',
                                size: FONTSIZE.one, color: Styles.white)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
        const SizedBox(height: 8),
        ContentBox(
            backgroundColor: context.theme.cardBackground.withOpacity(0.5),
            child: MyText(
              club.name,
              size: FONTSIZE.two,
            )),
      ],
    );
  }
}
