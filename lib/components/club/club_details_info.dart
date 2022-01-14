import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/social/club_members_grid_list.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';

class ClubDetailsInfo extends StatelessWidget {
  final ClubSummary club;
  const ClubDetailsInfo({Key? key, required this.club}) : super(key: key);

  double get _introMediaIconSize => 40.0;

  Widget get _iconSpacer => const SizedBox(height: 8);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        child: NestedScrollView(
      headerSliverBuilder: (c, i) => [
        const MySliverNavbar(title: 'About Club'),
      ],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (Utils.textNotNull(club.location))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.location,
                    size: 18,
                  ),
                  const SizedBox(width: 2),
                  MyText(
                    club.location!,
                    size: FONTSIZE.four,
                  )
                ],
              ),
            ),
          if (Utils.anyNotNull([club.introAudioUri, club.introVideoUri]))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (Utils.textNotNull(club.introVideoUri))
                    CupertinoButton(
                      onPressed: () =>
                          VideoSetupManager.openFullScreenVideoPlayer(
                              context: context,
                              videoUri: club.introVideoUri!,
                              videoThumbUri: club.introVideoThumbUri,
                              autoPlay: true,
                              autoLoop: true),
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.tv, size: _introMediaIconSize),
                          _iconSpacer,
                          const MyText('INTRO VIDEO')
                        ],
                      ),
                    ),
                  if (Utils.textNotNull(club.introAudioUri))
                    CupertinoButton(
                      onPressed: () => AudioPlayerController.openAudioPlayer(
                          context: context,
                          audioUri: club.introAudioUri!,
                          audioTitle: 'Intro',
                          pageTitle: club.name,
                          autoPlay: true),
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.headphones,
                              size: _introMediaIconSize),
                          _iconSpacer,
                          const MyText('INTRO AUDIO')
                        ],
                      ),
                    ),
                ],
              ),
            ),
          if (Utils.textNotNull(club.description))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReadMoreTextBlock(
                text: club.description!,
                title: club.name,
                trimLines: 16,
              ),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Icon(CupertinoIcons.person_2),
                SizedBox(width: 8),
                H3('Admins')
              ],
            ),
          ),
          ClubMembersGridList(
              scrollPhysics: const NeverScrollableScrollPhysics(),
              admins: club.admins,
              members: const [],
              owner: club.owner,
              onTapAvatar: (userId, _) => context
                  .navigateTo(UserPublicProfileDetailsRoute(userId: userId))),
        ],
      ),
    ));
  }
}
