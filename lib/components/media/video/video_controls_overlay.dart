import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:video_player/video_player.dart';

class VideoControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isPortrait;
  final void Function()? exitFullScreen;
  const VideoControlsOverlay(
      {Key? key,
      required this.controller,
      this.exitFullScreen,
      required this.isPortrait})
      : super(key: key);

  @override
  _VideoControlsOverlayState createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<VideoControlsOverlay> {
  _VideoControlsOverlayState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback listener;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listener);
  }

  @override
  void deactivate() {
    widget.controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = widget.controller.value.isPlaying;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedSwitcher(
                duration: kStandardAnimationDuration,
                child: GestureDetector(
                  onTap: widget.exitFullScreen?.call ?? context.pop,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: widget.isPortrait
                        ? const EdgeInsets.all(24)
                        : const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 32),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: isPlaying
                          ? null
                          : const Icon(CupertinoIcons.clear_circled_solid,
                              color: Styles.white, size: 40),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (isPlaying) {
                  widget.controller.pause();
                } else {
                  widget.controller.play();
                }
              },
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: AnimatedSwitcher(
                  duration: kStandardAnimationDuration,
                  child: isPlaying
                      ? null
                      : const Icon(
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
                ? const EdgeInsets.all(24.0)
                : const EdgeInsets.symmetric(vertical: 8, horizontal: 64),
            child: SizedBox(
              height: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: VideoProgressIndicator(
                  widget.controller,
                  padding: EdgeInsets.zero,
                  colors: const VideoProgressColors(playedColor: Styles.white),
                  allowScrubbing: true,
                ),
              ),
            ),
          ),
        ],
      ),
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
