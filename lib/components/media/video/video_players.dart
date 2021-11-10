import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/media/video/video_controls_overlay.dart';
import 'package:video_player/video_player.dart';

class PortraitFullScreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;
  const PortraitFullScreenVideoPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          VideoPlayer(controller),
          VideoControlsOverlay(
            controller: controller,
            isPortrait: true,
          ),
        ],
      ),
    );
  }
}

class LandscapeFullScreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;
  const LandscapeFullScreenVideoPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller),
            VideoControlsOverlay(
              controller: controller,
              isPortrait: false,
            ),
          ],
        ),
      ),
    );
  }
}
