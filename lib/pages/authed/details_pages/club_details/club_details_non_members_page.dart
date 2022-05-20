import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/audio_thumbnail_player.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/images/user_avatar.dart';
import 'package:sofie_ui/components/media/video/video_thumbnail_player.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page_components/summary_stat_display.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:auto_route/auto_route.dart';

class ClubDetailsNonMembersPage extends StatelessWidget {
  final ClubSummary club;
  final VoidCallback joinClub;
  const ClubDetailsNonMembersPage(
      {Key? key, required this.club, required this.joinClub})
      : super(key: key);

  double get size => 100.0;
  Size get thumbSize => Size.square(size);

  Widget _buildOwnerAvatar(ClubSummary club) => Column(
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
    double topSafeArea = MediaQuery.of(context).padding.top;
    double navBarHeight = const CupertinoNavigationBar().preferredSize.height;
    double headerHeight = Utils.textNotNull(club.coverImageUri)
        ? 280.0
        : navBarHeight + topSafeArea;

    return Stack(
      children: [
        Container(
          color: context.theme.background,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              SizedBox(
                  height: headerHeight,
                  child: Utils.textNotNull(club.coverImageUri)
                      ? SizedUploadcareImage(club.coverImageUri!,
                          fit: BoxFit.cover)
                      : null),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24, top: 12),
                    child: club.contentAccessScope == ContentAccessScope.public
                        ? PrimaryButton(
                            text: 'Join the Club!',
                            prefixIconData: CupertinoIcons.checkmark_alt,
                            onPressed: joinClub)
                        : BorderBox(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            borderRadius: BorderRadius.circular(30),
                            child: const MyText(
                              'This Club is Private',
                            ),
                          ),
                  ),
                ],
              ),
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
                      const Icon(
                        CupertinoIcons.location,
                        size: 18,
                      ),
                      const SizedBox(width: 2),
                      MyText(club.location!, size: FONTSIZE.four)
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () => context.navigateTo(
                          UserPublicProfileDetailsRoute(userId: club.owner.id)),
                      child: _buildOwnerAvatar(club)),
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Card(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SummaryStatDisplay(
                          label: 'MEMBERS',
                          number: club.memberCount,
                        ),
                        const SizedBox(width: 16),
                        SummaryStatDisplay(
                          label: 'WORKOUTS',
                          number: club.workoutCount,
                        ),
                        const SizedBox(width: 16),
                        SummaryStatDisplay(
                          label: 'PLANS',
                          number: club.planCount,
                        ),
                      ],
                    )),
                    if (Utils.textNotNull(club.description))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16),
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
            ],
          ),
        ),
        _NavBar(
          club: club,
          navBarHeight: navBarHeight,
          topSafeArea: topSafeArea,
        ),
      ],
    );
  }
}

class _NavBar extends StatelessWidget {
  final ClubSummary club;
  final double navBarHeight;
  final double topSafeArea;
  const _NavBar(
      {Key? key,
      required this.club,
      required this.navBarHeight,
      required this.topSafeArea})
      : super(key: key);

  Future<void> _shareClub(ClubSummary club) async {
    await SharingAndLinking.shareLink(
        'club/${club.id}', 'Check out this club!');
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.background.withOpacity(0.6);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              onPressed: context.pop,
              padding: EdgeInsets.zero,
              child: CircularBox(
                  color: backgroundColor,
                  child: const Icon(
                    CupertinoIcons.arrow_left,
                  )),
            ),
            if (club.contentAccessScope == ContentAccessScope.public)
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: CircularBox(
                      color: backgroundColor,
                      child: const Icon(
                        CupertinoIcons.paperplane,
                      )),
                  onPressed: () => _shareClub(club)),
          ],
        ),
      ),
    );
  }
}
