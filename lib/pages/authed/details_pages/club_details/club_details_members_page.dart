import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/club/club_details_info.dart';
import 'package:sofie_ui/components/club/club_details_people.dart';
import 'package:sofie_ui/components/club/club_details_timeline.dart';
import 'package:sofie_ui/components/club/club_details_workout_plans.dart';
import 'package:sofie_ui/components/club/club_details_workouts.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:auto_route/auto_route.dart';

class ClubDetailsMembersPage extends StatefulWidget {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  final bool stopPollingFeed;
  const ClubDetailsMembersPage({
    Key? key,
    required this.club,
    required this.authedUserMemberType,
    required this.stopPollingFeed,
  }) : super(key: key);

  @override
  State<ClubDetailsMembersPage> createState() => _ClubDetailsMembersPageState();
}

class _ClubDetailsMembersPageState extends State<ClubDetailsMembersPage> {
  int _activeTabIndex = 0;

  bool get _userIsOwnerOrAdmin => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
      ].contains(widget.authedUserMemberType);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                if (Utils.textNotNull(widget.club.coverImageUri))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                      height: 180,
                      child: SizedUploadcareImage(widget.club.coverImageUri!,
                          fit: BoxFit.cover),
                    ),
                  ),
                _ClubSectionButtons(
                  club: widget.club,
                  authedUserMemberType: widget.authedUserMemberType,
                ),
              ]))
            ],
        body: Container(
          color: context.theme.background,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  width: double.infinity,
                  child: MySlidingSegmentedControl<int>(
                      children: const {0: 'Activity', 1: 'About'},
                      updateValue: (i) => setState(() => _activeTabIndex = i),
                      value: _activeTabIndex),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _activeTabIndex,
                    children: [
                      ClubDetailsTimeline(
                        club: widget.club,
                        isOwnerOrAdmin: _userIsOwnerOrAdmin,
                        stopPollingFeed: widget.stopPollingFeed,
                      ),
                      ClubDetailsInfo(
                        club: widget.club,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _ClubSectionButtons extends StatelessWidget {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  const _ClubSectionButtons(
      {Key? key, required this.club, required this.authedUserMemberType})
      : super(key: key);

  double get _iconSize => 32;

  bool get _userIsOwnerOrAdmin => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
      ].contains(authedUserMemberType);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      childAspectRatio: 1.2,
      crossAxisCount: 3,
      children: [
        _ClubSectionButton(
          label: 'People',
          icon: Icon(CupertinoIcons.person_2_alt, size: _iconSize),
          count: club.memberCount,
          onTap: () => context.push(
              child: ClubDetailsPeople(
            authedUserMemberType: authedUserMemberType,
            clubId: club.id,
          )),
        ),
        _ClubSectionButton(
          label: 'Workouts',
          icon: SvgPicture.asset(
            'assets/category_icons/workouts.svg',
            height: _iconSize,
            fit: BoxFit.cover,
            color: context.theme.primary,
          ),
          count: club.workoutCount,
          onTap: () => context.push(
              child: ClubDetailsWorkouts(
            isOwnerOrAdmin: _userIsOwnerOrAdmin,
            clubId: club.id,
          )),
        ),
        _ClubSectionButton(
            label: 'Plans',
            icon: SvgPicture.asset(
              'assets/category_icons/plans.svg',
              height: _iconSize,
              fit: BoxFit.cover,
              color: context.theme.primary,
            ),
            count: club.planCount,
            onTap: () => context.push(
                    child: ClubDetailsWorkoutPlans(
                  isOwnerOrAdmin: _userIsOwnerOrAdmin,
                  clubId: club.id,
                ))),
        _ClubSectionButton(
          label: 'Throwdowns',
          icon: SvgPicture.asset(
            'assets/category_icons/events.svg',
            height: _iconSize,
            fit: BoxFit.cover,
            color: context.theme.primary,
          ),
          count: 0,
          onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
        ),
        _ClubSectionButton(
          label: 'Shop',
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
            CupertinoIcons.chat_bubble_2_fill,
            size: _iconSize,
          ),
          count: 0,
          onTap: () =>
              context.navigateTo(ClubMembersChatRoute(clubId: club.id)),
        ),
      ],
    );
  }
}

class _ClubSectionButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final int count;
  final VoidCallback onTap;
  const _ClubSectionButton(
      {Key? key,
      required this.label,
      required this.icon,
      required this.count,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                label,
                weight: FontWeight.bold,
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyText(
                    count.toString(),
                  ),
                  icon
                ],
              )
            ],
          )),
    );
  }
}
