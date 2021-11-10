// import 'package:better_player/better_player.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/components/indicators.dart';
// import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
// import 'package:sofie_ui/components/media/video/video_controls_overlay.dart';
// import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
// import 'package:sofie_ui/services/uploadcare.dart';

// /// All the data needed to create a better player controller and to play a video.
// class VideoData {
//   final VideoInfoEntity info;
//   final double aspectRatio;
//   final BetterPlayerDataSource dataSource;
//   VideoData(this.info, this.aspectRatio, this.dataSource);
// }

// class BetterPlayerVideoPlayerWrapper extends StatefulWidget {
//   final String uri; // Uploadcare file ID.
//   // Display while page is animating into place instead of a black screen and loading circle.
//   final String? videoThumbUri;
//   final bool autoLoop;
//   final bool autoPlay;
//   final bool muted;
//   final Widget Function(BetterPlayerController, dynamic Function(bool)?)?
//       customControlsBuilder;
//   const BetterPlayerVideoPlayerWrapper(
//       {Key? key,
//       required this.uri,
//       this.autoLoop = false,
//       this.autoPlay = false,
//       this.videoThumbUri,
//       this.customControlsBuilder,
//       this.muted = false})
//       : super(key: key);

//   @override
//   _BetterPlayerVideoPlayerWrapperState createState() =>
//       _BetterPlayerVideoPlayerWrapperState();
// }

// class _BetterPlayerVideoPlayerWrapperState
//     extends State<BetterPlayerVideoPlayerWrapper> {
//   BetterPlayerController? _controller;

//   @override
//   void initState() {
//     super.initState();

//     VideoSetupManager.initializeBetterPlayer(
//             videoUri: widget.uri,
//             autoLoop: widget.autoLoop,
//             autoPlay: widget.autoPlay,
//             customControlsBuilder: widget.customControlsBuilder ??
//                 (controller, _) {
//                   return FullVideoControls(
//                     controller: controller,
//                     duration: Duration(
//                         milliseconds: controller.videoPlayerController?.value
//                                 .duration?.inMilliseconds ??
//                             0),
//                   );
//                 })
//         .then((controller) {
//       _controller = controller;

//       if (widget.muted) {
//         _controller!.setVolume(0.0);
//       }

//       _controller!.addEventsListener((_) {
//         setState(() {});
//       });
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller != null
//         ? BetterPlayerVideoPlayer(
//             controller: _controller!,
//             videoThumbUri: widget.videoThumbUri,
//           )
//         : widget.videoThumbUri != null
//             ? SizedUploadcareImage(widget.videoThumbUri!)
//             : const LoadingCircle();
//   }
// }

// class BetterPlayerVideoPlayer extends StatefulWidget {
//   final BetterPlayerController controller;
//   // Display while page is animating into place instead of a black screen and loading circle.
//   final String? videoThumbUri;
//   const BetterPlayerVideoPlayer(
//       {Key? key, required this.controller, this.videoThumbUri})
//       : super(key: key);

//   @override
//   State<BetterPlayerVideoPlayer> createState() =>
//       _BetterPlayerVideoPlayerState();
// }

// class _BetterPlayerVideoPlayerState extends State<BetterPlayerVideoPlayer> {
//   @override
//   void initState() {
//     super.initState();

//     widget.controller.addEventsListener((_) {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isVideoInitialized = widget.controller.isVideoInitialized();
//     return isVideoInitialized != null && isVideoInitialized
//         ? BetterPlayer(controller: widget.controller)
//         : widget.videoThumbUri != null
//             ? SizedUploadcareImage(widget.videoThumbUri!)
//             : const LoadingCircle();
//   }
// }
