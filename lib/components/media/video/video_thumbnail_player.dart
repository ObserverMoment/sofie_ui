import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/services/utils.dart';

/// Displays a square thumb of the video.
/// Onclick opens the video in full screen at the correct aspect ratio.
class VideoThumbnailPlayer extends StatelessWidget {
  final String? videoUri;
  final String? videoThumbUri;
  final Size displaySize;
  final String? tag;
  const VideoThumbnailPlayer(
      {Key? key,
      this.videoUri,
      this.videoThumbUri,
      this.tag,
      this.displaySize = const Size(120, 120)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color _primary = context.theme.primary;
    final Color _background = context.theme.background;
    final bool hasVideo = Utils.textNotNull(videoUri);

    return GestureDetector(
      onTap: () async {
        if (videoUri == null) {
          return;
        } else {
          await VideoSetupManager.openFullScreenBetterPlayer(
              context: context,
              videoUri: videoUri!,
              videoThumbUri: videoThumbUri,
              autoPlay: true,
              autoLoop: true);
        }
      },
      child: Stack(
        children: [
          Container(
            width: displaySize.width,
            height: displaySize.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _primary.withOpacity(0.4),
              boxShadow: kElevation[3],
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: hasVideo
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedUploadcareImage(videoThumbUri!),
                      Icon(
                        CupertinoIcons.play_circle,
                        size: displaySize.width / 2.5,
                        color: Styles.white,
                      ),
                    ],
                  )
                : Icon(
                    CupertinoIcons.film,
                    size: displaySize.width / 2.5,
                    color: _background.withOpacity(0.4),
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
