import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/club/club_details_info.dart';
import 'package:sofie_ui/components/club/club_details_people.dart';
import 'package:sofie_ui/components/club/club_details_timeline.dart';
import 'package:sofie_ui/components/club/club_details_workout_plans.dart';
import 'package:sofie_ui/components/club/club_details_workouts.dart';
import 'package:sofie_ui/components/layout.dart';
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
  final ScrollController _scrollController = ScrollController();

  final _maxHeaderSize = 500.0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      print(_scrollController.offset);
      setState(() {
        _progress = (_scrollController.offset / _maxHeaderSize).clamp(0.0, 1.0);
      });
    });
  }

  bool get _userIsOwnerOrAdmin => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
      ].contains(widget.authedUserMemberType);

  @override
  Widget build(BuildContext context) {
    // ListView(children: [],),
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          controller: _scrollController,
          children: [
            // SliverPersistentHeader(delegate: MyHeaderDelegate()),
            Header(
              authedUserMemberType: widget.authedUserMemberType,
              club: widget.club,
            ),
            ClubDetailsTimeline(
              club: widget.club,
              isOwnerOrAdmin: _userIsOwnerOrAdmin,
              stopPollingFeed: widget.stopPollingFeed,
            ),
          ],
        ),
        AnimatedNavBar(progress: _progress),
      ],
    );
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
        SliverPersistentHeader(
            pinned: true,
            delegate: MyHeaderDelegate(
                authedUserMemberType: widget.authedUserMemberType,
                club: widget.club)),
        // SliverList(
        //     delegate: SliverChildListDelegate([
        //   if (Utils.textNotNull(widget.club.coverImageUri))
        //     SizedBox(
        //       height: 400,
        //       child: _ClubSectionButtons(
        //         club: widget.club,
        //         authedUserMemberType: widget.authedUserMemberType,
        //       ),
        //     ),
        // ]))
      ],
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ClubDetailsTimeline(
          club: widget.club,
          isOwnerOrAdmin: _userIsOwnerOrAdmin,
          stopPollingFeed: widget.stopPollingFeed,
        ),
      ),
      // body: SafeArea(
      //   child: Container(
      //     color: context.theme.background,
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Column(
      //         children: [
      //           Container(
      //             padding: const EdgeInsets.only(top: 4, bottom: 12),
      //             width: double.infinity,
      //             child: MySlidingSegmentedControl<int>(
      //                 children: const {0: 'Activity', 1: 'About'},
      //                 updateValue: (i) => setState(() => _activeTabIndex = i),
      //                 value: _activeTabIndex),
      //           ),
      //           Expanded(
      //             child: IndexedStack(
      //               index: _activeTabIndex,
      //               children: [
      //                 ClubDetailsTimeline(
      //                   club: widget.club,
      //                   isOwnerOrAdmin: _userIsOwnerOrAdmin,
      //                   stopPollingFeed: widget.stopPollingFeed,
      //                 ),
      //                 ClubDetailsInfo(
      //                   club: widget.club,
      //                 ),
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // )
    );
  }
}

class AnimatedNavBar extends StatelessWidget {
  final double progress;
  const AnimatedNavBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// TODO: Get the correct size based on the SafeArea padding required.
        Opacity(
            opacity: progress,
            child:
                Container(color: context.theme.modalBackground, height: 100)),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavBarBackButton(),
                Opacity(opacity: progress, child: MyHeaderText('CLUB NAME')),
                Icon(CupertinoIcons.ellipsis),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  const Header(
      {Key? key, required this.club, required this.authedUserMemberType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (Utils.textNotNull(club.coverImageUri))
          ImageFiltered(
            imageFilter: ImageFilter.blur(),
            child: SizedBox(
              height: 500,
              child: SizedUploadcareImage(
                club.coverImageUri!,
                fit: BoxFit.none,
                displaySize: Size.square(500),
              ),
            ),
          ),
      ],
    );
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  const MyHeaderDelegate(
      {required this.club, required this.authedUserMemberType});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;
    print(shrinkOffset);
    print(progress);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (progress < 0.99 && Utils.textNotNull(club.coverImageUri))
          ImageFiltered(
            imageFilter: ImageFilter.blur(),
            child: SizedBox(
              height: maxExtent,
              child: SizedUploadcareImage(
                club.coverImageUri!,
                fit: BoxFit.none,
                displaySize: Size.square(maxExtent),
              ),
            ),
          ),
        // SizedBox(
        //   height: maxExtent,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       _ClubSectionButtons(
        //         club: club,
        //         authedUserMemberType: authedUserMemberType,
        //       ),
        //     ],
        //   ),
        // ),
        Opacity(
            opacity: progress,
            child: Container(
              height: minExtent,
              color: context.theme.modalBackground,
            )),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(CupertinoIcons.back),
                Opacity(opacity: progress, child: MyHeaderText('CLUB NAME')),
                Icon(CupertinoIcons.ellipsis),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 500;

  @override

  /// TODO: Get the correct size based on the SafeArea padding required.
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _ClubSectionButtons extends StatelessWidget {
  final ClubSummary club;
  final UserClubMemberStatus authedUserMemberType;
  const _ClubSectionButtons(
      {Key? key, required this.club, required this.authedUserMemberType})
      : super(key: key);

  double get _iconSize => 26;

  bool get _userIsOwnerOrAdmin => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
      ].contains(authedUserMemberType);

  @override
  Widget build(BuildContext context) {
    final iconColor = context.theme.primary.withOpacity(0.9);
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      childAspectRatio: 1.8,
      crossAxisCount: 3,
      children: [
        _ClubSectionButton(
          label: 'People',
          icon: Icon(
            CupertinoIcons.person_2_fill,
            size: _iconSize,
            color: iconColor,
          ),
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
            'assets/graphics/dumbbell.svg',
            height: _iconSize,
            fit: BoxFit.fitHeight,
            color: iconColor,
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
            icon: Icon(CupertinoIcons.calendar,
                size: _iconSize, color: iconColor),
            count: club.planCount,
            onTap: () => context.push(
                    child: ClubDetailsWorkoutPlans(
                  isOwnerOrAdmin: _userIsOwnerOrAdmin,
                  clubId: club.id,
                ))),
        _ClubSectionButton(
          label: 'Throwdowns',
          icon: SvgPicture.asset(
            'assets/graphics/medal.svg',
            height: _iconSize,
            fit: BoxFit.fitHeight,
            color: iconColor,
          ),
          count: 0,
          onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
        ),
        _ClubSectionButton(
          label: 'Shop',
          icon: Icon(
            CupertinoIcons.shopping_cart,
            size: _iconSize,
            color: iconColor,
          ),
          count: 0,
          onTap: () => context.showAlertDialog(title: 'Coming Soon!'),
        ),
        _ClubSectionButton(
          label: 'Chat',
          icon: Icon(
            CupertinoIcons.chat_bubble_text_fill,
            size: _iconSize,
            color: iconColor,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                count.toString(),
                size: FONTSIZE.five,
              ),
              icon
            ],
          ),
          MyText(
            label,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
