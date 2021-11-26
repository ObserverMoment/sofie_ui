import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/components/social/users_group_summary.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class ClubCard extends StatelessWidget {
  final ClubSummary club;
  const ClubCard({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<UserSummary> allMembers = [...club.admins, ...club.members];

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
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (Utils.textNotNull(club.location))
                        ContentBox(
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
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UsersGroupSummary(
                              users: allMembers,
                              showMax: 10,
                              avatarSize: 28,
                            ),
                          ],
                        ),
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
                            MyHeaderText(
                              club.name,
                              weight: FontWeight.bold,
                              color: infoFontColor,
                            ),
                            const SizedBox(height: 6),
                            MyText(
                              '${club.owner.displayName.toUpperCase()} (owner)',
                              size: FONTSIZE.two,
                              color: infoFontColor,
                            ),
                            if (club.admins.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: CommaSeparatedList(
                                  club.admins
                                      .map((a) =>
                                          '${a.displayName.toUpperCase()} (admin)')
                                      .toList(),
                                  fontSize: FONTSIZE.one,
                                  textColor: infoFontColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (Utils.textNotNull(club.description))
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
