import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
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
                        ? const EdgeInsets.all(8.0)
                        : EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: widget.isPortrait
                              ? const EdgeInsets.only(
                                  left: 16, right: 8, top: 4, bottom: 4)
                              : const EdgeInsets.only(left: 80.0, right: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.title != null ||
                                  widget.subtitle != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (widget.title != null)
                                      MyHeaderText(
                                        widget.title!,
                                        color: Styles.white,
                                        textAlign: TextAlign.center,
                                        size: FONTSIZE.four,
                                        lineHeight: 1.2,
                                      ),
                                    if (widget.subtitle != null)
                                      MyHeaderText(
                                        widget.subtitle!,
                                        color: Styles.white.withOpacity(0.8),
                                        textAlign: TextAlign.center,
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
                                child: const Icon(
                                    CupertinoIcons.fullscreen_exit,
                                    size: 30,
                                    color: Styles.white),
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
                              : const EdgeInsets.symmetric(horizontal: 50.0),
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
                                            subtext: true),
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

/// The first returns widget must be a valid stack child.
/// This is what is required by [BetterPlayerControlsConfiguration][customControlsBuilder]
// class FullVideoControls extends StatefulWidget {
//   final VideoPlayerController controller;
//   final Duration duration;
//   final Widget? overlay;
//   final void Function()? exitFullScreen;
//   final void Function()? enterFullScreen;
//   final bool isFullScreen;
//   const FullVideoControls(
//       {Key? key,
//       required this.controller,
//       required this.duration,
//       this.isFullScreen = false,
//       this.enterFullScreen,
//       this.exitFullScreen,
//       this.overlay})
//       : super(key: key);

//   @override
//   _FullVideoControlsState createState() => _FullVideoControlsState();
// }

// class _FullVideoControlsState extends State<FullVideoControls> {
//   bool _isFinished = false;
//   bool _isPlaying = false;
//   // Between 0 and 1
//   double _progress = 0.0;
//   late Duration _duration;

//   final _animDuration = const Duration(milliseconds: 300);

//   Future<void> _eventListener(event) async {
//     if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
//       final _position = await widget.controller.videoPlayerController?.position;
//       if (_position != null) {
//         setState(() {
//           _progress =
//               (_position.inMilliseconds / _duration.inMilliseconds).clamp(0, 1);
//         });
//       }
//     }
//     if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
//       setState(() {
//         _isFinished = true;
//         _isPlaying = false;
//       });
//     } else if (event.betterPlayerEventType == BetterPlayerEventType.play) {
//       setState(() {
//         _isPlaying = true;
//         _isFinished = false;
//       });
//     } else if (event.betterPlayerEventType == BetterPlayerEventType.pause) {
//       setState(() {
//         _isPlaying = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _duration = widget.duration;

//     if (widget.controller.betterPlayerConfiguration.autoPlay) {
//       _isPlaying = true;
//     }
//     widget.controller.addEventsListener(_eventListener);
//   }

//   void _handleSeek(double progress) {
//     widget.controller.seekTo(_duration * progress);
//   }

//   @override
//   void dispose() {
//     widget.controller.removeEventsListener(_eventListener);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isPortrait = widget.controller.getAspectRatio()! < 1;
//     return Positioned.fill(
//       child: Stack(
//         children: [
//           if (widget.overlay != null)
//             Positioned(
//                 top: 0,
//                 left: 0,
//                 child: AnimatedSwitcher(
//                     duration: _animDuration,
//                     child: _isPlaying ? null : widget.overlay)),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   behavior: HitTestBehavior.opaque,
//                   onTap: () {
//                     if (_isPlaying) {
//                       widget.controller.pause();
//                     } else if (_isFinished) {
//                       widget.controller.pause();
//                       widget.controller.seekTo(Duration.zero);
//                       widget.controller.play();
//                     } else {
//                       widget.controller.play();
//                     }
//                   },
//                   child: Center(
//                     child: AnimatedSwitcher(
//                       duration: _animDuration,
//                       child: _isPlaying
//                           ? null
//                           : AnimatedSwitcher(
//                               duration: _animDuration,
//                               child: _isFinished
//                                   ? const Icon(
//                                       CupertinoIcons.restart,
//                                       color: Styles.white,
//                                       size: 50,
//                                     )
//                                   : const Icon(
//                                       CupertinoIcons.play_fill,
//                                       color: Styles.white,
//                                       size: 50,
//                                     ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//               AnimatedSwitcher(
//                 duration: _animDuration,
//                 child: !_isPlaying || _isFinished
//                     ? Container(
//                         padding: widget.isFullScreen && !isPortrait
//                             ? // Larger padding to avoid system overlay etc at top (left of the image as it is rotated)
//                             const EdgeInsets.only(left: 56, right: 42)
//                             // Less on left as there is some inbult padding in the slider.
//                             : const EdgeInsets.only(left: 4, right: 20),
//                         height: 40,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Material(
//                                 color: Colors.transparent,
//                                 child: SliderTheme(
//                                   data: const SliderThemeData(
//                                     trackHeight: 1.0,
//                                     thumbShape: RoundSliderThumbShape(
//                                         enabledThumbRadius: 7),
//                                   ),
//                                   child: Slider(
//                                     value: _progress,
//                                     onChanged: _handleSeek,
//                                     activeColor: Styles.white,
//                                     inactiveColor: Styles.greyTwo,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             MyText(
//                               (_duration * (1 - _progress)).compactDisplay(),
//                               color: Styles.white,
//                               weight: FontWeight.bold,
//                               size: FONTSIZE.two,
//                             )
//                           ],
//                         ),
//                       )
//                     : const SizedBox(height: 40, width: 0),
//               )
//             ],
//           ),
//           Positioned(
//               top: widget.isFullScreen ? 24 : 6,
//               right: widget.isFullScreen ? 16 : 8,
//               child: AnimatedSwitcher(
//                   duration: _animDuration,
//                   child: _isPlaying
//                       ? const SizedBox(height: 0, width: 0)
//                       : CupertinoButton(
//                           onPressed: widget.isFullScreen
//                               ? widget.exitFullScreen
//                               : widget.enterFullScreen,
//                           padding: EdgeInsets.zero,
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 color: Styles.black.withOpacity(0.1),
//                                 shape: BoxShape.circle),
//                             padding: const EdgeInsets.all(4),
//                             child: widget.isFullScreen
//                                 ? const Icon(
//                                     CupertinoIcons.clear,
//                                     size: 30,
//                                     color: Styles.white,
//                                   )
//                                 : const Icon(
//                                     CupertinoIcons.fullscreen,
//                                     size: 26,
//                                     color: Styles.white,
//                                   ),
//                           )))),
//         ],
//       ),
//     );
//   }
// }
