import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/profile/bio.dart';
import 'package:sofie_ui/components/profile/club_summaries_list.dart';
import 'package:sofie_ui/components/profile/skills_list.dart';
import 'package:sofie_ui/components/profile/social_media_links.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/country.dart';
import 'package:sofie_ui/pages/authed/progress/components/summary_stat_display.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/stream.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:auto_route/auto_route.dart';

class UserProfileDisplay extends StatelessWidget {
  final UserProfile profile;
  const UserProfileDisplay({Key? key, required this.profile}) : super(key: key);

  double get _avatarSize => 160.0;

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final bool isAuthedUserProfile = authedUserId == profile.id;

    final int workoutCount = profile.workoutCount ?? 0;
    final int planCount = profile.planCount ?? 0;

    final hasSocialLinks = [
      profile.youtubeHandle,
      profile.instagramHandle,
      profile.tiktokHandle,
      profile.linkedinHandle,
    ].any((l) => l != null);

    final followerCount = profile.followerCount ?? 0;

    final hasCountry = Utils.textNotNull(profile.countryCode);
    final hasTown = Utils.textNotNull(profile.townCity);

    return !isAuthedUserProfile &&
            profile.userProfileScope == UserProfileScope.private
        ? _PrivateProfilePlaceholder(profile: profile)
        : ListView(cacheExtent: 3000, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: Utils.textNotNull(profile.avatarUri)
                          ? () => openFullScreenImageViewer(
                              context, profile.avatarUri!)
                          : null,
                      child: Hero(
                        tag: kFullScreenImageViewerHeroTag,
                        child: UserAvatar(
                          avatarUri: profile.avatarUri,
                          size: _avatarSize,
                          border: true,
                          borderWidth: 2,
                        ),
                      ),
                    ),
                  ),
                  if (!isAuthedUserProfile || followerCount > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!isAuthedUserProfile)
                          _ProfileButtons(
                            profile: profile,
                          ),
                        if (followerCount > 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText('$followerCount',
                                    size: FONTSIZE.one,
                                    weight: FontWeight.bold),
                                const SizedBox(width: 3),
                                const MyText(
                                  'FOLLOWERS',
                                  size: FONTSIZE.one,
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (Utils.textNotNull(profile.tagline))
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: MyText(
                  profile.tagline!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            if (hasCountry || hasTown)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _Location(
                  profile: profile,
                ),
              ),
            if (hasSocialLinks)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SocialMediaLinks(
                  profile: profile,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (profile.lifetimeLogStatsSummary != null)
                    SummaryStatDisplay(
                      label: 'SESSIONS',
                      number: profile.lifetimeLogStatsSummary!.sessionsLogged,
                    ),
                  if (profile.lifetimeLogStatsSummary != null)
                    SummaryStatDisplay(
                      label: 'MINUTES',
                      number: profile.lifetimeLogStatsSummary!.minutesWorked,
                    ),
                  if (isAuthedUserProfile || workoutCount > 0)
                    SummaryStatDisplay(
                      label: 'WORKOUTS',
                      number: workoutCount,
                    ),
                  if (isAuthedUserProfile || workoutCount > 0)
                    SummaryStatDisplay(
                      label: 'PLANS',
                      number: planCount,
                    ),
                ],
              )),
            ),
            if (!isAuthedUserProfile && (workoutCount > 0 || planCount > 0))
              Padding(
                padding: const EdgeInsets.only(
                    left: 4, top: 16, right: 4, bottom: 4),
                child: Column(
                  children: [
                    if (workoutCount > 0)
                      PageLink(
                          linkText: 'View Workouts ($workoutCount)',
                          onPress: () => context.navigateTo(
                              ProfilePublicWorkoutsRoute(
                                  userId: profile.id,
                                  userDisplayName: profile.displayName))),
                    if (planCount > 0)
                      PageLink(
                          linkText: 'View Plans ($planCount)',
                          onPress: () => context.navigateTo(
                              ProfilePublicWorkoutPlansRoute(
                                  userId: profile.id,
                                  userDisplayName: profile.displayName))),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            if (Utils.textNotNull(profile.bio))
              _InfoSection(
                  header: 'Bio',
                  icon: CupertinoIcons.person,
                  content: ProfileBio(bio: profile.bio!)),
            if (profile.clubs.isNotEmpty)
              _InfoSection(
                header: 'Clubs',
                icon: MyCustomIcons.clubsIcon,
                content: ClubSummariesList(
                  clubs: profile.clubs,
                ),
              ),
            if (profile.skills.isNotEmpty)
              _InfoSection(
                  header: 'Skills',
                  icon: MyCustomIcons.certificateIcon,
                  content: SkillsList(skills: profile.skills)),
          ]);
  }
}

class _InfoSection extends StatelessWidget {
  final String header;
  final IconData icon;
  final Widget content;
  const _InfoSection(
      {Key? key,
      required this.header,
      required this.icon,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: context.theme.primary.withOpacity(0.2)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyHeaderText(
                  header,
                  weight: FontWeight.normal,
                  size: FONTSIZE.two,
                ),
                const SizedBox(width: 6),
                Icon(icon, size: 14),
              ],
            ),
          ),
          const SizedBox(height: 12),
          content
        ],
      ),
    );
  }
}

class _Location extends StatelessWidget {
  final UserProfile profile;
  const _Location({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasCountry = Utils.textNotNull(profile.countryCode);
    final hasTown = Utils.textNotNull(profile.townCity);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(CupertinoIcons.location, size: 12),
        const SizedBox(width: 4),
        if (hasCountry)
          MyText(
            Country.fromIsoCode(profile.countryCode!).name,
            size: FONTSIZE.two,
            subtext: true,
          ),
        if (hasCountry && hasTown)
          const MyText(
            ' | ',
            size: FONTSIZE.two,
            subtext: true,
          ),
        if (hasTown)
          MyText(
            profile.townCity!,
            size: FONTSIZE.two,
            subtext: true,
          ),
      ],
    );
  }
}

class _ProfileButtons extends StatelessWidget {
  final UserProfile profile;
  const _ProfileButtons({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Utils.textNotNull(profile.introVideoThumbUri))
          TertiaryButton(
            onPressed: () => VideoSetupManager.openFullScreenVideoPlayer(
                context: context,
                videoUri: profile.introVideoUri!,
                videoThumbUri: profile.introVideoThumbUri,
                autoPlay: true,
                autoLoop: true),
            prefixIconData: CupertinoIcons.film,
            iconSize: 20,
            fontSize: FONTSIZE.three,
            text: 'Watch Video',
          ),
        TertiaryButton(
          text: 'Chat',
          prefixIconData: CupertinoIcons.chat_bubble_2,
          iconSize: 20,
          fontSize: FONTSIZE.three,
          onPressed: () => context.navigateTo(OneToOneChatRoute(
            otherUserId: profile.id,
          )),
        ),
        SizedBox(
          width: 150,
          child: UserFeedConnectionButton(
            otherUserId: profile.id,
          ),
        ),
      ],
    );
  }
}

class _PrivateProfilePlaceholder extends StatelessWidget {
  final UserProfile profile;
  const _PrivateProfilePlaceholder({Key? key, required this.profile})
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
