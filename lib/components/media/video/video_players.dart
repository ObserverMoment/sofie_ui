import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/custom_page_transitions.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/media/video/video_controls_overlay.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:video_player/video_player.dart';

class PortraitFullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String? title;
  final String? subitle;
  const PortraitFullScreenVideoPlayer(
      {Key? key, required this.controller, this.title, this.subitle})
      : super(key: key);

  @override
  State<PortraitFullScreenVideoPlayer> createState() =>
      _PortraitFullScreenVideoPlayerState();
}

class _PortraitFullScreenVideoPlayerState
    extends State<PortraitFullScreenVideoPlayer> {
  _PortraitFullScreenVideoPlayerState() {
    _listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  /// This is how [video_player] does it internally.
  @override
  void deactivate() {
    widget.controller.removeListener(_listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          VideoPlayer(widget.controller),
          VideoControlsOverlay(
            controller: widget.controller,
            isPortrait: true,
            title: widget.title,
            subtitle: widget.subitle,
          ),
        ],
      ),
    );
  }
}

/// Youtube style landscape video player where the user can move to full screen and back.
class LandscapeInlineVideoPlayer extends StatefulWidget {
  final String videoUri;
  final String? title;
  final String? subtitle;

  const LandscapeInlineVideoPlayer({
    Key? key,
    required this.videoUri,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  State<LandscapeInlineVideoPlayer> createState() =>
      _LandscapeInlineVideoPlayerState();
}

class _LandscapeInlineVideoPlayerState
    extends State<LandscapeInlineVideoPlayer> {
  _LandscapeInlineVideoPlayerState() {
    _listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback _listener;

  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    VideoSetupManager.initializeVideoPlayer(
            uri: widget.videoUri, autoLoop: true)
        .then((c) {
      setState(() {
        _controller = c;
      });
      _controller!.addListener(_listener);
    });

    /// TODO: launch / close on user rotation.
  }

  @override
  void dispose() async {
    _controller?.removeListener(_listener);
    super.dispose();
    await _controller?.dispose();
  }

  void _enterFullScreen() {
    if (_controller != null) {
      Navigator.of(context).push(LandscapeVideoRotatingPageRoute(
          page: LandscapeFullScreenVideoPlayer(
        controller: _controller!,
        title: widget.title,
        subitle: widget.subtitle,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null && _controller!.value.isInitialized
        ? FadeIn(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller!),
                  InlineVideoControlsOverlay(
                    controller: _controller!,
                    title: widget.title,
                    subtitle: widget.subtitle,
                    enterFullScreen: _enterFullScreen,
                  ),
                ],
              ),
            ),
          )
        : const Center(
            child: LoadingCircle(),
          );
  }
}

class LandscapeFullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String? title;
  final String? subitle;
  const LandscapeFullScreenVideoPlayer(
      {Key? key, required this.controller, this.title, this.subitle})
      : super(key: key);

  @override
  State<LandscapeFullScreenVideoPlayer> createState() =>
      _LandscapeFullScreenVideoPlayerState();
}

class _LandscapeFullScreenVideoPlayerState
    extends State<LandscapeFullScreenVideoPlayer> {
  _LandscapeFullScreenVideoPlayerState() {
    _listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  /// This is how [video_player] does it internally.
  @override
  void deactivate() {
    widget.controller.removeListener(_listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(widget.controller),
            VideoControlsOverlay(
              controller: widget.controller,
              isPortrait: false,
              title: widget.title,
              subtitle: widget.subitle,
            ),
          ],
        ),
      ),
    );
  }
}
