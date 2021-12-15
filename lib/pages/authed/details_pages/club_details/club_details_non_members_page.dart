import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/media/audio/audio_thumbnail_player.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/media/video/video_thumbnail_player.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/social/users_group_summary.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class ClubDetailsNonMembersPage extends StatelessWidget {
  final Club club;
  final List<UserSummary> members;
  final VoidCallback joinClub;
  const ClubDetailsNonMembersPage(
      {Key? key,
      required this.club,
      required this.members,
      required this.joinClub})
      : super(key: key);

  double get size => 100.0;
  Size get thumbSize => Size.square(size);

  Widget _buildOwnerAvatar(Club club) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserAvatar(
            size: size,
            avatarUri: club.owner.avatarUri,
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: MyText(
              club.owner.displayName,
              size: FONTSIZE.one,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.background,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shrinkWrap: true,
        children: [
          MyHeaderText(
            club.name,
            size: FONTSIZE.six,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (Utils.textNotNull(club.location))
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.location,
                      size: 18, color: Styles.primaryAccent),
                  const SizedBox(width: 2),
                  MyText(club.location!, color: Styles.primaryAccent)
                ],
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOwnerAvatar(club),
              if (club.introVideoUri != null)
                Column(
                  children: [
                    ClipOval(
                      child: VideoThumbnailPlayer(
                        videoUri: club.introVideoUri,
                        videoThumbUri: club.introVideoThumbUri,
                        displaySize: thumbSize,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: MyText(
                        'Watch',
                        size: FONTSIZE.one,
                      ),
                    ),
                  ],
                ),
              if (club.introAudioUri != null)
                Column(
                  children: [
                    ClipOval(
                      child: AudioThumbnailPlayer(
                        audioUri: club.introAudioUri!,
                        displaySize: thumbSize,
                        playerTitle: '${club.name} - Intro',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: MyText(
                        'Listen',
                        size: FONTSIZE.one,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: club.contentAccessScope == ContentAccessScope.public
                      ? PrimaryButton(
                          text: 'Join the Club!',
                          prefixIconData: CupertinoIcons.checkmark_alt,
                          onPressed: joinClub)
                      : const MyHeaderText('This Club is Private'),
                ),
                if (Utils.textNotNull(club.description))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReadMoreTextBlock(
                      trimLines: 6,
                      text: club.description!,
                      title: 'Description',
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          if (members.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UsersGroupSummary(
                  users: members,
                  avatarSize: 60,
                  subtitle: '${members.length} members',
                ),
              ],
            )
        ],
      ),
    );
  }
}
