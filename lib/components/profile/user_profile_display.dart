import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/cards/discover_club_card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/country.dart';
import 'package:sofie_ui/pages/authed/progress/components/lifetime_log_stats_summary.dart';
import 'package:sofie_ui/services/stream.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileDisplay extends StatelessWidget {
  final UserPublicProfile profile;
  const UserProfileDisplay({Key? key, required this.profile}) : super(key: key);

  double get _avatarSize => 100.0;

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final bool isAuthedUserProfile = authedUserId == profile.id;

    return profile.userProfileScope == UserProfileScope.private
        ? PrivateProfilePlaceholder(profile: profile)
        : ListView(
            padding: const EdgeInsets.only(top: 16),
            children: [
              Container(
                padding: const EdgeInsets.only(left: 2, right: 2, bottom: 6),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    _HeaderContent(
                      userPublicProfile: profile,
                      avatarSize: _avatarSize,
                      isAuthedUserProfile: isAuthedUserProfile,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
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
                        if (Utils.textNotNull(profile.introVideoThumbUri))
                          GestureDetector(
                            onTap: () =>
                                VideoSetupManager.openFullScreenVideoPlayer(
                                    context: context,
                                    videoUri: profile.introVideoUri!,
                                    videoThumbUri: profile.introVideoThumbUri,
                                    autoPlay: true,
                                    autoLoop: true),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                UserAvatar(
                                  avatarUri: profile.introVideoThumbUri,
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
              if (profile.clubs.isNotEmpty)
                _ClubSummariesSlider(
                  clubs: profile.clubs,
                )
            ],
          );
  }
}

class _HeaderContent extends StatelessWidget {
  final UserPublicProfile userPublicProfile;
  final double avatarSize;
  final bool isAuthedUserProfile;
  const _HeaderContent(
      {Key? key,
      required this.userPublicProfile,
      this.avatarSize = 100,
      required this.isAuthedUserProfile})
      : super(key: key);

  EdgeInsets get verticalPadding => const EdgeInsets.symmetric(vertical: 8.0);

  @override
  Widget build(BuildContext context) {
    final hasSocialLinks = [
      userPublicProfile.youtubeHandle,
      userPublicProfile.instagramHandle,
      userPublicProfile.tiktokHandle,
      userPublicProfile.linkedinHandle,
    ].any((l) => l != null);

    return Padding(
      padding: EdgeInsets.only(top: avatarSize / 2),
      child: Card(
          padding: EdgeInsets.only(
              top: avatarSize / 2, left: 10, right: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 10),
              if (Utils.textNotNull(userPublicProfile.countryCode) ||
                  Utils.textNotNull(userPublicProfile.townCity))
                Padding(
                  padding: verticalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.location,
                        size: 20,
                      ),
                      if (Utils.textNotNull(userPublicProfile.countryCode))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: MyText(Country.fromIsoCode(
                                  userPublicProfile.countryCode!)
                              .name),
                        ),
                      if (Utils.textNotNull(userPublicProfile.countryCode) &&
                          Utils.textNotNull(userPublicProfile.townCity))
                        Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.theme.primary.withOpacity(0.6),
                            )),
                      if (Utils.textNotNull(userPublicProfile.townCity))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: MyText(
                            userPublicProfile.townCity!,
                          ),
                        ),
                    ],
                  ),
                ),
              if (!isAuthedUserProfile)
                Padding(
                  padding: verticalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserFeedConnectionButton(
                        otherUserId: userPublicProfile.id,
                      ),
                      const SizedBox(width: 8),
                      BorderButton(
                        text: 'Message',
                        prefix: const Icon(
                          CupertinoIcons.chat_bubble_2,
                          size: 15,
                        ),
                        onPressed: () => context.navigateTo(OneToOneChatRoute(
                          otherUserId: userPublicProfile.id,
                        )),
                      ),
                    ],
                  ),
                ),
              if (Utils.textNotNull(userPublicProfile.tagline))
                Padding(
                  padding: verticalPadding,
                  child: MyText(
                    userPublicProfile.tagline!,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (Utils.textNotNull(userPublicProfile.bio))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReadMoreTextBlock(
                      text: userPublicProfile.bio!, title: 'Bio'),
                ),
              const HorizontalLine(),
              if (userPublicProfile.lifetimeLogStatsSummary != null)
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: LifetimeLogStatsSummaryDisplay(
                    minutesWorked: userPublicProfile
                        .lifetimeLogStatsSummary!.minutesWorked,
                    sessionsLogged: userPublicProfile
                        .lifetimeLogStatsSummary!.sessionsLogged,
                  ),
                ),
              if (hasSocialLinks) const HorizontalLine(),
              if (hasSocialLinks)
                Padding(
                  padding: verticalPadding,
                  child: _SocialMediaLinks(
                    userPublicProfile: userPublicProfile,
                  ),
                ),
            ],
          )),
    );
  }
}

class _SocialMediaLinks extends StatelessWidget {
  final UserPublicProfile userPublicProfile;
  const _SocialMediaLinks({Key? key, required this.userPublicProfile})
      : super(key: key);

  Future<void> _handleOpenSocialUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        if (Utils.textNotNull(userPublicProfile.instagramHandle))
          _SocialLink(
              url: userPublicProfile.instagramHandle!,
              onPressed: () =>
                  _handleOpenSocialUrl(userPublicProfile.instagramHandle!)),
        if (Utils.textNotNull(userPublicProfile.tiktokHandle))
          _SocialLink(
              url: userPublicProfile.tiktokHandle!,
              onPressed: () =>
                  _handleOpenSocialUrl(userPublicProfile.tiktokHandle!)),
        if (Utils.textNotNull(userPublicProfile.linkedinHandle))
          _SocialLink(
              url: userPublicProfile.linkedinHandle!,
              onPressed: () =>
                  _handleOpenSocialUrl(userPublicProfile.linkedinHandle!)),
        if (Utils.textNotNull(userPublicProfile.youtubeHandle))
          _SocialLink(
              url: userPublicProfile.youtubeHandle!,
              onPressed: () =>
                  _handleOpenSocialUrl(userPublicProfile.youtubeHandle!)),
      ],
    );
  }
}

class _SocialLink extends StatelessWidget {
  final String url;
  final VoidCallback onPressed;
  const _SocialLink({Key? key, required this.url, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.link, size: 16),
          const SizedBox(width: 6),
          MyText(
            url,
            size: FONTSIZE.two,
            weight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}

class _ClubSummariesSlider extends StatelessWidget {
  final List<ClubSummary> clubs;
  const _ClubSummariesSlider({Key? key, required this.clubs}) : super(key: key);

  double get cardHeight => 170.0;
  double cardWidth(BoxConstraints constraints) => constraints.maxWidth / 2.1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      MyHeaderText('Clubs'),
                    ],
                  ),
                ),
                Container(
                  height: cardHeight,
                  padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                  child: ListView.builder(
                    itemCount: clubs.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (c, i) => GestureDetector(
                      onTap: () =>
                          context.navigateTo(ClubDetailsRoute(id: clubs[i].id)),
                      child: SizedBox(
                        width: cardWidth(constraints),
                        child: DiscoverClubCard(
                          club: clubs[i],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }
}

class PrivateProfilePlaceholder extends StatelessWidget {
  final UserPublicProfile profile;
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
