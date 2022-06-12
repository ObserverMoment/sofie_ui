// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
// import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
// import 'package:sofie_ui/components/animated/custom_page_transitions.dart';
// import 'package:sofie_ui/components/do_workout/do_workout_section/components/timers/amrap_timer.dart';
// import 'package:sofie_ui/components/do_workout/do_workout_section/components/timers/fortime_timer.dart';
// import 'package:sofie_ui/components/do_workout/do_workout_section/components/timers/interval_timer.dart';
// import 'package:sofie_ui/components/do_workout/do_workout_section/components/video_overlays/main_video_overlay.dart';
// import 'package:sofie_ui/components/indicators.dart';
// import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
// import 'package:sofie_ui/components/timers/stopwatch_and_timer.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:video_player/video_player.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/extensions/data_type_extensions.dart';
// import 'package:provider/provider.dart';

// /// Used in the DoWorkout flow.
// class WorkoutSectionVideoPlayerWrapper extends StatefulWidget {
//   final String uri; // Uploadcare file ID.
//   final bool autoLoop;
//   final bool autoPlay;
//   final WorkoutSection workoutSection;
//   final WorkoutSectionProgressState state;
//   const WorkoutSectionVideoPlayerWrapper({
//     Key? key,
//     required this.uri,
//     required this.autoLoop,
//     required this.autoPlay,
//     required this.workoutSection,
//     required this.state,
//   }) : super(key: key);

//   @override
//   _WorkoutSectionVideoPlayerWrapperState createState() =>
//       _WorkoutSectionVideoPlayerWrapperState();
// }

// class _WorkoutSectionVideoPlayerWrapperState
//     extends State<WorkoutSectionVideoPlayerWrapper> {
//   VideoPlayerController? _controller;
//   double _aspectRatio = 16 / 9;

//   @override
//   void initState() {
//     super.initState();

//     VideoSetupManager.getVideoInfo(videoUri: widget.uri).then((videoInfo) {
//       _aspectRatio = videoInfo.width / videoInfo.height;
//       _controller = VideoPlayerController.network(videoInfo.url)
//         ..addListener(() => setState(() {}))
//         ..setLooping(widget.autoLoop)
//         ..initialize().then((_) {
//           if (widget.autoPlay) {
//             _controller!.play();
//           }
//         });
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
//         ? _aspectRatio >= 1
//             ? WorkoutSectionVideoPlayerLandscape(
//                 controller: _controller!,
//                 workoutSection: widget.workoutSection,
//                 state: widget.state,
//               )
//             : WorkoutSectionVideoPlayerPortrait(
//                 controller: _controller!,
//                 workoutSection: widget.workoutSection,
//                 state: widget.state,
//               )
//         : const Center(child: LoadingIndicator());
//   }
// }

// class WorkoutSectionVideoPlayerLandscape extends StatefulWidget {
//   final VideoPlayerController controller;
//   final WorkoutSection workoutSection;
//   final WorkoutSectionProgressState state;

//   /// When the section is scored the user needs a button to be able to enter reps.
//   /// We don't have this (Sept 2021) on the overlay so the temp solution is to just disable entering full screen for now.
//   final bool disableFullScreen;
//   const WorkoutSectionVideoPlayerLandscape({
//     Key? key,
//     required this.controller,
//     required this.workoutSection,
//     required this.state,
//     this.disableFullScreen = false,
//   }) : super(key: key);

//   @override
//   State<WorkoutSectionVideoPlayerLandscape> createState() =>
//       _WorkoutSectionVideoPlayerLandscapeState();
// }

// class _WorkoutSectionVideoPlayerLandscapeState
//     extends State<WorkoutSectionVideoPlayerLandscape> {
//   @override
//   void initState() {
//     super.initState();

//     /// TODO: launch / close on user rotation.
//     // NativeDeviceOrientationCommunicator()
//     //     .onOrientationChanged(useSensor: true)
//     //     .listen((event) {
//     //   final toPortrait = event == NativeDeviceOrientation.portraitUp;
//     //   final toLandscape = event == NativeDeviceOrientation.landscapeLeft ||
//     //       event == NativeDeviceOrientation.landscapeRight;
//     //   if (_isFullScreen && toPortrait) {
//     //     _exitFullScreen();
//     //   } else if (!_isFullScreen && toLandscape) {
//     //     _enterFullScreen();
//     //   }
//     // });
//   }

//   void _enterFullScreen() {
//     final bloc = context.read<DoWorkoutBloc>();

//     Navigator.of(context).push(LandscapeVideoRotatingPageRoute(
//         page: ChangeNotifierProvider.value(
//       value: bloc,
//       builder: (context, child) => FullScreenLandscapeVideo(
//           controller: widget.controller,
//           sectionIndex: widget.workoutSection.sortPosition,
//           exitFullScreen: _exitFullScreen),
//     )));
//   }

//   void _exitFullScreen() {
//     Navigator.of(context).pop();
//   }

//   Widget _buildTimer() {
//     switch (widget.workoutSection.workoutSectionType.name) {
//       case kForTimeName:
//         return ForTimeTimer(
//             workoutSection: widget.workoutSection, state: widget.state);
//       case kAMRAPName:
//         return AMRAPTimer(
//             workoutSection: widget.workoutSection, state: widget.state);
//       case kEMOMName:
//       case kTabataName:
//       case kHIITCircuitName:
//         return IntervalTimer(
//             workoutSection: widget.workoutSection, state: widget.state);
//       case kCustomSessionName:
//         return const StopwatchAndTimer();
//       default:
//         throw Exception(
//             'No moves list builder specified for ${widget.workoutSection.workoutSectionType.name}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: widget.controller.value.isInitialized
//           ? Column(
//               children: [
//                 Stack(
//                   children: [
//                     AspectRatio(
//                       aspectRatio: widget.controller.value.aspectRatio,
//                       child: VideoPlayer(widget.controller),
//                     ),
//                     if (!widget.disableFullScreen)
//                       Positioned(
//                           top: 0,
//                           right: 0,
//                           child: CupertinoButton(
//                               onPressed: _enterFullScreen,
//                               child: const Icon(CupertinoIcons.fullscreen)))
//                   ],
//                 ),
//                 if (!widget.workoutSection.isCustomSession)
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: _buildTimer(),
//                       ),
//                     ),
//                   )
//               ],
//             )
//           : const Center(child: LoadingIndicator()),
//     );
//   }
// }

// class FullScreenLandscapeVideo extends StatelessWidget {
//   final VideoPlayerController controller;
//   final int sectionIndex;
//   final VoidCallback exitFullScreen;
//   const FullScreenLandscapeVideo(
//       {Key? key,
//       required this.controller,
//       required this.sectionIndex,
//       required this.exitFullScreen})
//       : super(key: key);

//   void _play(BuildContext context) {
//     context.read<DoWorkoutBloc>().playSection(sectionIndex);
//   }

//   void _pause(BuildContext context) {
//     context.read<DoWorkoutBloc>().pauseSection(sectionIndex);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final workoutSection = context.select<DoWorkoutBloc, WorkoutSection>(
//         (b) => b.activeWorkout.workoutSections[sectionIndex]);

//     final initialState =
//         context.select<DoWorkoutBloc, WorkoutSectionProgressState>(
//             (b) => b.getProgressStateForSection(sectionIndex));

//     final isRunning = context.select<DoWorkoutBloc, bool>(
//         (b) => b.getStopWatchTimerForSection(sectionIndex).isRunning);

//     return RotatedBox(
//       quarterTurns: 1,
//       child: AspectRatio(
//         aspectRatio: controller.value.aspectRatio,
//         child: GestureDetector(
//           onTap: isRunning ? () => _pause(context) : () => _play(context),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               VideoPlayer(controller),
//               if (!workoutSection.isCustomSession)
//                 StreamBuilder<WorkoutSectionProgressState>(
//                     initialData: initialState,
//                     stream: context
//                         .read<DoWorkoutBloc>()
//                         .getProgressStreamForSection(sectionIndex),
//                     builder: (context, snapshot) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 16.0, horizontal: 70),
//                         child: MainVideoOverlay(
//                             workoutSection: workoutSection,
//                             state: snapshot.data!),
//                       );
//                     }),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: AnimatedSwitcher(
//                   duration: kStandardAnimationDuration,
//                   child: isRunning
//                       ? Container()
//                       : CupertinoButton(
//                           onPressed: exitFullScreen,
//                           child: const Icon(CupertinoIcons.fullscreen_exit)),
//                 ),
//               ),
//               AnimatedSwitcher(
//                 duration: kStandardAnimationDuration,
//                 child: isRunning
//                     ? Container()
//                     : CupertinoButton(
//                         child: const Icon(CupertinoIcons.play_fill, size: 40),
//                         onPressed: () => _play(context)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class WorkoutSectionVideoPlayerPortrait extends StatelessWidget {
//   final VideoPlayerController controller;
//   final WorkoutSection workoutSection;
//   final WorkoutSectionProgressState state;
//   const WorkoutSectionVideoPlayerPortrait(
//       {Key? key,
//       required this.controller,
//       required this.workoutSection,
//       required this.state})
//       : super(key: key);

//   void _play(BuildContext context) {
//     context.read<DoWorkoutBloc>().playSection(workoutSection.sortPosition);
//   }

//   void _pause(BuildContext context) {
//     context.read<DoWorkoutBloc>().pauseSection(workoutSection.sortPosition);
//   }

//   Widget buildVideoPlayer() => buildFullScreen(
//         child: AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: VideoPlayer(controller),
//         ),
//       );

//   Widget buildFullScreen({
//     required Widget child,
//   }) {
//     final size = controller.value.size;
//     final width = size.width;
//     final height = size.height;

//     return FittedBox(
//       fit: BoxFit.cover,
//       child: SizedBox(width: width, height: height, child: child),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isRunning = context.select<DoWorkoutBloc, bool>((b) =>
//         b.getStopWatchTimerForSection(workoutSection.sortPosition).isRunning);

//     return controller.value.isInitialized
//         ? Container(
//             alignment: Alignment.topCenter,
//             child: GestureDetector(
//               onTap: isRunning ? () => _pause(context) : () => _play(context),
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: <Widget>[
//                   buildVideoPlayer(),
//                   if (!workoutSection.isCustomSession)
//                     SafeArea(
//                         child: Padding(
//                       padding: const EdgeInsets.only(
//                           left: 10,
//                           right: 10,
//                           top: kDoWorkoutWorkoutSectionTopNavHeight),
//                       child: MainVideoOverlay(
//                           workoutSection: workoutSection, state: state),
//                     )),
//                   AnimatedSwitcher(
//                     duration: kStandardAnimationDuration,
//                     child: isRunning
//                         ? Container()
//                         : CupertinoButton(
//                             child:
//                                 const Icon(CupertinoIcons.play_fill, size: 40),
//                             onPressed: () => _play(context)),
//                   ),
//                 ],
//               ),
//             ))
//         : const Center(child: LoadingIndicator());
//   }
// }
