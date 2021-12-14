import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/club/club_details_info.dart';
import 'package:sofie_ui/components/club/club_details_timeline.dart';
import 'package:sofie_ui/components/club/club_details_workout_plans.dart';
import 'package:sofie_ui/components/club/club_details_workouts.dart';
import 'package:sofie_ui/components/navigation.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class ClubDetailsMembersPage extends StatefulWidget {
  final Club club;
  final bool isOwnerOrAdmin;
  final bool stopPollingFeed;
  const ClubDetailsMembersPage({
    Key? key,
    required this.club,
    required this.isOwnerOrAdmin,
    required this.stopPollingFeed,
  }) : super(key: key);

  @override
  State<ClubDetailsMembersPage> createState() => _ClubDetailsMembersPageState();
}

class _ClubDetailsMembersPageState extends State<ClubDetailsMembersPage> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.background,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyTabBarNav(
                titles: const [
                  'Activity',
                  'About',
                  'Workouts',
                  'Plans',
                ],
                superscriptIcons: [
                  null,
                  null,
                  MyText(
                    widget.club.workouts!.length.toString(),
                    size: FONTSIZE.two,
                  ),
                  MyText(
                    widget.club.workoutPlans!.length.toString(),
                    size: FONTSIZE.two,
                  )
                ],
                handleTabChange: (i) => setState(() => _activeTabIndex = i),
                activeTabIndex: _activeTabIndex),
            Expanded(
              child: IndexedStack(
                index: _activeTabIndex,
                children: [
                  ClubDetailsTimeline(
                    club: widget.club,
                    isOwnerOrAdmin: widget.isOwnerOrAdmin,
                    stopPollingFeed: widget.stopPollingFeed,
                  ),
                  ClubDetailsInfo(
                    club: widget.club,
                  ),
                  ClubDetailsWorkouts(
                      club: widget.club,
                      workouts: widget.club.workouts!.reversed.toList(),
                      isOwnerOrAdmin: widget.isOwnerOrAdmin),
                  ClubDetailsWorkoutPlans(
                      club: widget.club,
                      workoutPlans: widget.club.workoutPlans!.reversed.toList(),
                      isOwnerOrAdmin: widget.isOwnerOrAdmin),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
