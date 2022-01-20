import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:video_player/video_player.dart';

class VideoControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isPortrait;
  final String? title;
  final String? subtitle;
  final void Function()? exitFullScreen;
  const VideoControlsOverlay(
      {Key? key,
      required this.controller,
      this.exitFullScreen,
      required this.isPortrait,
      this.title,
      this.subtitle})
      : super(key: key);

  @override
  _VideoControlsOverlayState createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<VideoControlsOverlay> {
  _VideoControlsOverlayState() {
    _listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback _listener;
  late Duration _duration;

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _duration = widget.controller.value.duration;
    controller.addListener(_listener);
  }

  /// [value] must be 0 <-> 1
  void _handleScrub(double value) {
    controller.seekTo(_duration * value);
  }

  /// This is how [video_player] does it internally.
  @override
  void deactivate() {
    controller.removeListener(_listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = controller.value.isPlaying;
    final position = controller.value.position;
    return SafeArea(
      top: widget.isPortrait,
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: kStandardAnimationDuration,
            child: isPlaying
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: controller.pause,
                    child: const SizedBox.expand())
                : Padding(
                    padding: widget.isPortrait
                        ? const EdgeInsets.all(2.0)
                        : const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: widget.isPortrait
                              ? const EdgeInsets.only(
                                  left: 16, right: 4, bottom: 4)
                              : const EdgeInsets.only(
                                  left: 80.0, right: 40, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.title != null ||
                                  widget.subtitle != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.title != null)
                                      MyHeaderText(
                                        widget.title!,
                                        color: Styles.white,
                                        textAlign: TextAlign.left,
                                        size: FONTSIZE.four,
                                        lineHeight: 1.2,
                                      ),
                                    if (widget.subtitle != null)
                                      MyHeaderText(
                                        widget.subtitle!,
                                        color: Styles.white.withOpacity(0.8),
                                        textAlign: TextAlign.left,
                                        size: FONTSIZE.two,
                                        lineHeight: 1.4,
                                      )
                                  ],
                                )
                              else
                                Container(),
                              CupertinoButton(
                                onPressed:
                                    widget.exitFullScreen?.call ?? context.pop,
                                child: CircularBox(
                                  color: Styles.black.withOpacity(0.15),
                                  child: const Icon(CupertinoIcons.clear,
                                      size: 30, color: Styles.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              Vibrate.feedback(FeedbackType.light);
                              controller.play();
                            },
                            child: const SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: AnimatedSwitcher(
                                duration: kStandardAnimationDuration,
                                child: Icon(
                                  CupertinoIcons.play_fill,
                                  color: Styles.white,
                                  size: 60,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: widget.isPortrait
                              ? EdgeInsets.zero
                              : const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        MyText(
                                            controller
                                                .value.position.compactDisplay,
                                            color: Styles.white),
                                        const MyText(' / ',
                                            color: Styles.white),
                                        MyText(
                                          controller
                                              .value.duration.compactDisplay,
                                          color: Styles.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: SliderTheme(
                                  data: const SliderThemeData(
                                    trackHeight: 2,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 8),
                                  ),
                                  child: Slider(
                                    value: position.inMilliseconds /
                                        _duration.inMilliseconds,
                                    onChanged: _handleScrub,
                                    activeColor: Styles.white,
                                    inactiveColor: Styles.greyTwo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

/// Smaller more compact version of the [VideoControlsOverlay].
/// Always landscape (see YouTube), never full screen.
/// Requires [enterFullScreen]
class InlineVideoControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final String? title;
  final String? subtitle;
  final VoidCallback enterFullScreen;
  const InlineVideoControlsOverlay(
      {Key? key,
      required this.controller,
      this.title,
      this.subtitle,
      required this.enterFullScreen})
      : super(key: key);

  @override
  _InlineVideoControlsOverlayState createState() =>
      _InlineVideoControlsOverlayState();
}

class _InlineVideoControlsOverlayState
    extends State<InlineVideoControlsOverlay> {
  _InlineVideoControlsOverlayState() {
    _listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback _listener;
  late Duration _duration;

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _duration = widget.controller.value.duration;
    controller.addListener(_listener);
  }

  /// [value] must be 0 <-> 1
  void _handleScrub(double value) {
    controller.seekTo(_duration * value);
  }

  /// This is how [video_player] does it internally.
  @override
  void deactivate() {
    controller.removeListener(_listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = controller.value.isPlaying;
    final position = controller.value.position;
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: kStandardAnimationDuration,
          child: isPlaying
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: controller.pause,
                  child: const SizedBox.expand())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16, right: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              MyText(
                                controller.value.position.compactDisplay,
                                color: Styles.white,
                                size: FONTSIZE.two,
                                weight: FontWeight.bold,
                              ),
                              const MyText(
                                ' / ',
                                color: Styles.white,
                                size: FONTSIZE.two,
                              ),
                              MyText(
                                controller.value.duration.compactDisplay,
                                color: Styles.white,
                                subtext: true,
                                size: FONTSIZE.two,
                              ),
                            ],
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: widget.enterFullScreen,
                            child: const Icon(CupertinoIcons.fullscreen,
                                color: Styles.white),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Vibrate.feedback(FeedbackType.light);
                          controller.play();
                        },
                        child: const SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: AnimatedSwitcher(
                            duration: kStandardAnimationDuration,
                            child: Icon(
                              CupertinoIcons.play_fill,
                              color: Styles.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Material(
                        color: Colors.transparent,
                        child: SliderTheme(
                          data: const SliderThemeData(
                            trackHeight: 1.5,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 7),
                          ),
                          child: Slider(
                            value: position.inMilliseconds /
                                _duration.inMilliseconds,
                            onChanged: _handleScrub,
                            activeColor: Styles.white,
                            inactiveColor: Styles.greyTwo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        )
      ],
    );
  }
}
