import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/audio/audio_thumbnail_player.dart';
import 'package:sofie_ui/components/media/video/video_thumbnail_player.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/social/club_members_grid_list.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';

class ClubDetailsInfo extends StatelessWidget {
  final ClubSummary club;
  const ClubDetailsInfo({Key? key, required this.club}) : super(key: key);

  Size get _kthumbDisplaySize => const Size(120, 120);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (Utils.textNotNull(club.location))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.location,
                      size: 18, color: Styles.primaryAccent),
                  const SizedBox(width: 2),
                  MyText(
                    club.location!,
                    color: Styles.primaryAccent,
                    size: FONTSIZE.four,
                  )
                ],
              ),
            ),
          if (Utils.anyNotNull([club.introAudioUri, club.introVideoUri]))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (Utils.textNotNull(club.introVideoUri))
                    VideoThumbnailPlayer(
                      videoUri: club.introVideoUri,
                      videoThumbUri: club.introVideoThumbUri,
                      displaySize: _kthumbDisplaySize,
                    ),
                  if (Utils.textNotNull(club.introAudioUri))
                    AudioThumbnailPlayer(
                      audioUri: club.introAudioUri!,
                      displaySize: _kthumbDisplaySize,
                      playerTitle: '${club.name} - Intro',
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
              children: [
                const Icon(CupertinoIcons.person_2),
                const SizedBox(width: 8),
                H3('Admins (${club.admins.length + 1})')
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
    );
  }
}
