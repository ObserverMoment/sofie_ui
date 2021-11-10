import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/material_elevation.dart';

/// Displays an icon which can be clicked to open the audio player.
/// Cannot display a placeholder...unlike the similar video player, as there is not image associated with these audio uploads.
class AudioThumbnailPlayer extends StatelessWidget {
  final String audioUri;
  final String playerTitle;
  final Size displaySize;
  final String? tag;
  final IconData iconData;

  const AudioThumbnailPlayer(
      {Key? key,
      required this.audioUri,
      this.playerTitle = 'Preview Audio',
      this.tag,
      this.iconData = CupertinoIcons.waveform,
      this.displaySize = const Size(120, 120)})
      : super(key: key);

  Future<void> _listenToAudio(BuildContext context) async {
    await AudioPlayerController.openAudioPlayer(
        context: context,
        audioUri: audioUri,
        pageTitle: playerTitle,
        audioTitle: playerTitle,
        autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _listenToAudio(context);
      },
      child: Stack(
        children: [
          Container(
            width: displaySize.width,
            height: displaySize.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: Styles.primaryAccentGradient,
              boxShadow: kElevation[3],
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(iconData,
                    color: Styles.white.withOpacity(0.3),
                    size: displaySize.width / 1.2),
                Icon(
                  CupertinoIcons.play_circle,
                  size: displaySize.width / 2.5,
                  color: Styles.white,
                ),
              ],
            ),
          ),
          if (tag != null)
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    decoration: const BoxDecoration(
                        color: Styles.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    child: MyText(
                      tag!,
                      size: FONTSIZE.one,
                      color: Styles.white,
                    ))),
        ],
      ),
    );
  }
}
