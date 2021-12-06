import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/profile/club_summaries_slider.dart';
import 'package:sofie_ui/components/profile/created_content.dart';
import 'package:sofie_ui/components/profile/header_content.dart';
import 'package:sofie_ui/components/profile/personal_best_slider.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

class UserProfileDisplay extends StatelessWidget {
  final UserProfile profile;
  const UserProfileDisplay({Key? key, required this.profile}) : super(key: key);

  double get _avatarSize => 100.0;

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final bool isAuthedUserProfile = authedUserId == profile.id;

    final int workoutCount = profile.workoutCount ?? 0;
    final int planCount = profile.planCount ?? 0;

    return profile.userProfileScope == UserProfileScope.private
        ? PrivateProfilePlaceholder(profile: profile)
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
                      profile: profile,
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
              if (workoutCount > 0 || planCount > 0)
                CreatedContent(
                  planCount: planCount,
                  isAuthedUserProfile: isAuthedUserProfile,
                  profileId: profile.id,
                  userDisplayName: profile.displayName,
                  workoutCount: workoutCount,
                ),
              if (profile.benchmarksWithBestEntries.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 16),
                  child: PersonalBestsSlider(
                    benchmarks: profile.benchmarksWithBestEntries,
                  ),
                ),
              if (profile.clubs.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 16),
                  child: ClubSummariesSlider(
                    clubs: profile.clubs,
                  ),
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
