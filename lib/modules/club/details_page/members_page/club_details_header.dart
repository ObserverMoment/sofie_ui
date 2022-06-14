import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/club/club_details_info.dart';
import 'package:sofie_ui/modules/club/club_details_people.dart';
import 'package:sofie_ui/modules/club/club_details_workout_plans.dart';
import 'package:sofie_ui/modules/club/club_details_workouts.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:flutter/material.dart' as material;

class Header extends StatelessWidget {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  final double maxHeaderSize;
  const Header({
    Key? key,
    required this.club,
    required this.authedUserMemberType,
    required this.maxHeaderSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradientBasisColor = context.theme.background;

    return SizedBox(
      height: maxHeaderSize,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          if (Utils.textNotNull(club.coverImageUri))
            SizedBox(
              height: maxHeaderSize,
              child: SizedUploadcareImage(
                club.coverImageUri!,
                fit: BoxFit.none,
                displaySize: Size.square(maxHeaderSize),
              ),
            ),
          if (Utils.textNotNull(club.coverImageUri))
            Container(
              height: maxHeaderSize,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    gradientBasisColor.withOpacity(0),
                    gradientBasisColor.withOpacity(0.7),
                    gradientBasisColor.withOpacity(0.9),
                    gradientBasisColor,
                  ],
                      stops: const [
                    0.4,
                    0.6,
                    0.9,
                    1.0,
                  ])),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyHeaderText(club.name, size: FONTSIZE.six),
                const SizedBox(height: 8),
                if (Utils.textNotNull(club.description))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ReadMoreTextBlock(
                      title: club.name,
                      text: club.description!,
                      trimLines: 2,
                    ),
                  ),
                _ClubSectionButtons(
                  club: club,
                  authedUserMemberType: authedUserMemberType,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubSectionButtons extends StatelessWidget {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  const _ClubSectionButtons(
      {Key? key, required this.club, required this.authedUserMemberType})
      : super(key: key);

  double get _iconSize => 26.0;

  @override
  Widget build(BuildContext context) {
    final userIsOwnerOrAdmin = [
      UserClubMemberStatus.owner,
      UserClubMemberStatus.admin,
    ].contains(authedUserMemberType);

    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 24,
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 24,
        children: [
          if (userIsOwnerOrAdmin || club.memberCount > 0)
            _ClubSectionButton(
              label: 'People',
              icon: Icon(
                CupertinoIcons.person_2,
                size: _iconSize,
              ),
              count: club.memberCount,
              onTap: () => context.push(
                  child: ClubDetailsPeople(
                authedUserMemberType: authedUserMemberType,
                clubId: club.id,
              )),
            ),
          if (userIsOwnerOrAdmin || club.workoutCount > 0)
            _ClubSectionButton(
              label: 'Workouts',
              icon: Icon(MyCustomIcons.dumbbell, size: _iconSize),
              count: club.workoutCount,
              onTap: () => context.push(
                  child: ClubDetailsWorkouts(
                isOwnerOrAdmin: userIsOwnerOrAdmin,
                clubId: club.id,
              )),
            ),
          if (userIsOwnerOrAdmin || club.planCount > 0)
            _ClubSectionButton(
                label: 'Plans',
                icon: Icon(MyCustomIcons.plansIcon, size: _iconSize),
                count: club.planCount,
                onTap: () => context.push(
                        child: ClubDetailsWorkoutPlans(
                      isOwnerOrAdmin: userIsOwnerOrAdmin,
                      clubId: club.id,
                    ))),
          if (userIsOwnerOrAdmin || 0 > 0)
            _ClubSectionButton(
              label: 'Events',
              icon: SvgPicture.asset('assets/graphics/medal.svg',
                  height: _iconSize,
                  fit: BoxFit.fitHeight,
                  color: context.theme.primary),
              count: 0,
              onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
            ),
          if (userIsOwnerOrAdmin || 0 > 0)
            _ClubSectionButton(
              label: 'Coaching',
              icon: Icon(
                material.Icons.stacked_line_chart_outlined,
                size: _iconSize,
              ),
              count: 0,
              onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
            ),
          if (userIsOwnerOrAdmin || 0 > 0)
            _ClubSectionButton(
              label: 'Gear',
              icon: Icon(
                CupertinoIcons.shopping_cart,
                size: _iconSize,
              ),
              count: 0,
              onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
            ),
          _ClubSectionButton(
            label: 'Chat',
            icon: Icon(
              CupertinoIcons.chat_bubble_text,
              size: _iconSize + 3,
            ),
            onTap: () =>
                context.navigateTo(ClubMembersChatRoute(clubId: club.id)),
          ),
          _ClubSectionButton(
              label: 'Club Info',
              icon: Icon(
                CupertinoIcons.info_circle,
                size: _iconSize + 3,
              ),
              onTap: () => context.push(
                      child: ClubDetailsInfo(
                    club: club,
                  ))),
        ],
      ),
    );
  }
}

class _ClubSectionButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final int? count;
  final VoidCallback onTap;
  const _ClubSectionButton(
      {Key? key,
      required this.label,
      required this.icon,
      this.count,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                if (count != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: MyText(
                      count.toString(),
                      size: FONTSIZE.six,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            MyText(label, maxLines: 2, size: FONTSIZE.one),
          ],
        ),
      ),
    );
  }
}
