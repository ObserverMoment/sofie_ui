import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/custom_page_transitions.dart';
import 'package:sofie_ui/components/media/video/better_player_video_player.dart';
import 'package:sofie_ui/components/media/video/video_controls_overlay.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:video_player/video_player.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class VideoSetupManager {
  static Future<VideoInfoEntity> getVideoInfo(
      {required String videoUri}) async {
    final VideoInfoEntity videoInfo =
        await UploadcareService.getVideoInfoRaw(videoUri);
    return videoInfo;
  }

  static Future<double> getAspectRatio(String videoUri) async {
    final info = await UploadcareService.getVideoInfoRaw(videoUri);
    return info.width / info.height;
  }

  /// VideoData includes [BetterPlayerDataSource].
  static Future<VideoData> getVideoData({required String videoUri}) async {
    final VideoInfoEntity videoInfo = await getVideoInfo(videoUri: videoUri);

    final BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, videoInfo.url,
        cacheConfiguration:
            const BetterPlayerCacheConfiguration(useCache: true));

    final double aspectRatio = videoInfo.width / videoInfo.height;

    return VideoData(videoInfo, aspectRatio, dataSource);
  }

  /// For standard [video_player plugin].
  static Future<VideoPlayerController> initializeVideoPlayer(
      {required String uri, // Uploadcare file ID.
      bool mixWithOthers = false,
      bool autoLoop = false,
      bool muted = false,
      Duration? startAt}) async {
    final videoInfo = await getVideoInfo(videoUri: uri);
    final controller = VideoPlayerController.network(videoInfo.url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: mixWithOthers));
    await controller.setLooping(autoLoop);

    if (muted) {
      await controller.setVolume(0.0);
    }

    if (startAt != null) {
      await controller.seekTo(startAt);
    }

    await controller.initialize();

    return controller;
  }

  /// For [BetterPlayer] plugin.
  static Future<BetterPlayerController> initializeBetterPlayer(
      {required String videoUri,
      Widget Function(BetterPlayerController, dynamic Function(bool))?
          customControlsBuilder,
      bool autoPlay = false,
      bool autoLoop = false,
      bool autoDispose = true,
      Duration? startAt}) async {
    final videoData = await getVideoData(videoUri: videoUri);

    return BetterPlayerController(
        BetterPlayerConfiguration(
          autoDispose: autoDispose,
          aspectRatio: videoData.aspectRatio,
          autoPlay: autoPlay,
          looping: autoLoop,
          startAt: startAt,
          fit: BoxFit.cover,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            playerTheme: BetterPlayerTheme.custom,
            customControlsBuilder: customControlsBuilder,
          ),
        ),
        betterPlayerDataSource: videoData.dataSource);
  }

  static Future<Duration> openFullScreenBetterPlayer({
    required BuildContext context,
    required String videoUri,
    // Display while page is animating into place instead of a black screen and loading circle.
    final String? videoThumbUri,
    void Function(Duration positionOnExit)? onExitFullScreen,
    bool autoPlay = false,
    bool autoLoop = false,
    Duration? startAt,
  }) async {
    final controller = await initializeBetterPlayer(
        videoUri: videoUri,
        autoPlay: autoPlay,
        autoLoop: autoLoop,
        customControlsBuilder: (controller, _) {
          return FullVideoControls(
            controller: controller,
            isFullScreen: true,
            exitFullScreen: () async {
              final position = await controller.videoPlayerController!.position;
              if (onExitFullScreen != null) {
                onExitFullScreen(position ?? Duration.zero);
              }
              context.pop();
            },
            duration: Duration(
                milliseconds: controller.videoPlayerController?.value.duration
                        ?.inMilliseconds ??
                    0),
          );
        });

    final aspectRatio = controller.getAspectRatio() ?? (16 / 9);
    final isPortrait = aspectRatio < 1;

    Duration? positionOnExit = Duration.zero;
    if (isPortrait) {
      positionOnExit = await Navigator.of(context).push(
          PortraitVideoEmergingPageRoute(
              page: BetterPlayerVideoPlayer(
                  controller: controller, videoThumbUri: videoThumbUri)));
    } else {
      positionOnExit =
          await Navigator.of(context).push(LandscapeVideoRotatingPageRoute(
              page: RotatedBox(
        quarterTurns: 1,
        child: BetterPlayerVideoPlayer(
            controller: controller, videoThumbUri: videoThumbUri),
      )));
    }

    return positionOnExit ?? Duration.zero;
  }
}
