import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/navigation.dart';
import 'package:sofie_ui/components/profile/club_summaries_list.dart';
import 'package:sofie_ui/components/profile/header_content.dart';
import 'package:sofie_ui/components/profile/personal_bests_grid.dart';
import 'package:sofie_ui/components/profile/skills_list.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/progress/components/lifetime_log_stats_summary.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:auto_route/auto_route.dart';

class UserProfileDisplay extends StatefulWidget {
  final UserProfile profile;
  const UserProfileDisplay({Key? key, required this.profile}) : super(key: key);

  @override
  State<UserProfileDisplay> createState() => _UserProfileDisplayState();
}

class _UserProfileDisplayState extends State<UserProfileDisplay> {
  int _activeTabIndex = 0;

  double get _avatarSize => 100.0;

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final bool isAuthedUserProfile = authedUserId == widget.profile.id;

    final int workoutCount = widget.profile.workoutCount ?? 0;
    final int planCount = widget.profile.planCount ?? 0;

    return widget.profile.userProfileScope == UserProfileScope.private
        ? PrivateProfilePlaceholder(profile: widget.profile)
        : ListView(
            padding: EdgeInsets.only(
                top: 8, bottom: EnvironmentConfig.bottomNavBarHeight),
            children: [
              Container(
                padding: const EdgeInsets.only(left: 2, right: 2, bottom: 6),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    HeaderContent(
                      profile: widget.profile,
                      avatarSize: _avatarSize,
                      isAuthedUserProfile: isAuthedUserProfile,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: Utils.textNotNull(widget.profile.avatarUri)
                              ? () => openFullScreenImageViewer(
                                  context, widget.profile.avatarUri!)
                              : null,
                          child: Hero(
                            tag: kFullScreenImageViewerHeroTag,
                            child: UserAvatar(
                              avatarUri: widget.profile.avatarUri,
                              size: _avatarSize,
                              border: true,
                              borderWidth: 2,
                            ),
                          ),
                        ),
                        if (Utils.textNotNull(
                            widget.profile.introVideoThumbUri))
                          GestureDetector(
                            onTap: () =>
                                VideoSetupManager.openFullScreenVideoPlayer(
                                    context: context,
                                    videoUri: widget.profile.introVideoUri!,
                                    videoThumbUri:
                                        widget.profile.introVideoThumbUri,
                                    autoPlay: true,
                                    autoLoop: true),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                UserAvatar(
                                  avatarUri: widget.profile.introVideoThumbUri,
                                  size: _avatarSize,
                                  border: true,
                                  borderWidth: 2,
                                ),
                                Icon(
                                  CupertinoIcons.play_circle,
                                  size: 40,
                                  color: Styles.white.withOpacity(0.7),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.profile.lifetimeLogStatsSummary != null)
                      SummaryStatDisplay(
                        label: 'SESSIONS',
                        number: widget
                            .profile.lifetimeLogStatsSummary!.sessionsLogged,
                      ),
                    if (widget.profile.lifetimeLogStatsSummary != null)
                      SummaryStatDisplay(
                        label: 'MINUTES',
                        number: widget
                            .profile.lifetimeLogStatsSummary!.minutesWorked,
                      ),
                    SummaryStatDisplay(
                      label: 'WORKOUTS',
                      number: workoutCount,
                    ),
                    SummaryStatDisplay(
                      label: 'PLANS',
                      number: planCount,
                    ),
                  ],
                )),
              ),
              if (!isAuthedUserProfile && (workoutCount > 0 || planCount > 0))
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      if (workoutCount > 0)
                        PageLink(
                            linkText: 'View Workouts',
                            onPress: () => context.navigateTo(
                                ProfilePublicWorkoutsRoute(
                                    userId: widget.profile.id,
                                    userDisplayName:
                                        widget.profile.displayName))),
                      if (planCount > 0)
                        PageLink(
                            linkText: 'View Plans',
                            onPress: () => context.navigateTo(
                                ProfilePublicWorkoutPlansRoute(
                                    userId: widget.profile.id,
                                    userDisplayName:
                                        widget.profile.displayName))),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              MyTabBarNav(
                  titles: const ['Bests', 'Skills', 'Clubs'],
                  handleTabChange: (i) => setState(() => _activeTabIndex = i),
                  activeTabIndex: _activeTabIndex),
              const SizedBox(height: 12),
              IndexedStack(
                index: _activeTabIndex,
                children: [
                  PersonalBestsGrid(
                    benchmarks: widget.profile.benchmarksWithBestEntries,
                  ),
                  SkillsList(skills: widget.profile.skills),
                  ClubSummariesList(
                    clubs: widget.profile.clubs,
                  ),
                ],
              ),
            ],
          );
  }
}

class PrivateProfilePlaceholder extends StatelessWidget {
  final UserProfile profile;
  const PrivateProfilePlaceholder({Key? key, required this.profile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(
                avatarUri: profile.avatarUri,
                size: 160,
                border: true,
                borderWidth: 2,
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: MyText(
                  "This person's profile is private",
                  subtext: true,
                ),
              ),
              Icon(CupertinoIcons.lock_shield_fill,
                  size: 200, color: context.theme.primary.withOpacity(0.05)),
            ],
          ),
        ],
      ),
    );
  }
}
