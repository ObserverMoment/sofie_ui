import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class CircleSummaryCard extends StatelessWidget {
  final ClubSummary club;
  final bool isOwner;
  final bool isAdmin;
  const CircleSummaryCard(
      {Key? key,
      required this.club,
      this.isOwner = false,
      this.isAdmin = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.navigateTo(ClubDetailsRoute(id: club.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        boxShadow: kElevation[2],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Utils.textNotNull(club.coverImageUri)
                                ? UploadcareImageProvider(club.coverImageUri!,
                                    transformations: [
                                        PreviewTransformation(
                                            Dimensions.square(width.toInt()))
                                      ])
                                : const AssetImage(
                                    'assets/placeholder_images/workout.jpg',
                                  ) as ImageProvider)),
                    child: Container()),
                if (isOwner || isAdmin)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _OwnerTag(
                          label: isOwner ? 'Owner' : 'Admin',
                          iconData: isOwner
                              ? CupertinoIcons.star_fill
                              : CupertinoIcons.star_lefthalf_fill),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _MemberCount(
                      club: club,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                MyHeaderText(
                  club.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  size: FONTSIZE.two,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _OwnerTag extends StatelessWidget {
  final String label;
  final IconData iconData;
  const _OwnerTag({Key? key, required this.label, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: Styles.gold,
            size: 18,
          ),
          const SizedBox(width: 4),
          MyText(
            label,
            size: FONTSIZE.two,
            weight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}

class _MemberCount extends StatelessWidget {
  final ClubSummary club;
  const _MemberCount({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.group_solid),
          const SizedBox(width: 4),
          MyText(
            club.memberCount.toString(),
            size: FONTSIZE.two,
            weight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}
