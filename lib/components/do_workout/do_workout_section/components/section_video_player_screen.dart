// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
// import 'package:sofie_ui/blocs/do_workout_bloc/workout_progress_state.dart';
// import 'package:sofie_ui/components/media/video/workout_section_video_players.dart.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:video_player/video_player.dart';

// class SectionVideoPlayerScreen extends StatefulWidget {
//   final WorkoutSection workoutSection;
//   final WorkoutSectionProgressState state;
//   const SectionVideoPlayerScreen({
//     Key? key,
//     required this.workoutSection,
//     required this.state,
//   }) : super(key: key);

//   @override
//   _SectionVideoPlayerScreenState createState() =>
//       _SectionVideoPlayerScreenState();
// }

// class _SectionVideoPlayerScreenState extends State<SectionVideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late bool _isPortrait;

//   @override
//   void initState() {
//     super.initState();

//     /// Controller should never be null for this section when this page is being displayed.
//     _controller = context
//         .read<DoWorkoutBloc>()
//         .getVideoControllerForSection(widget.workoutSection.sortPosition)!;

//     _isPortrait = _controller.value.aspectRatio < 1;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isPortrait
//         ? WorkoutSectionVideoPlayerPortrait(
//             controller: _controller,
//             workoutSection: widget.workoutSection,
//             state: widget.state)
//         : SafeArea(
//             child: Padding(
//             padding: const EdgeInsets.only(
//                 top: kDoWorkoutWorkoutSectionTopNavHeight),
//             child: WorkoutSectionVideoPlayerLandscape(
//                 controller: _controller,
//                 disableFullScreen: widget.workoutSection.isScored,
//                 workoutSection: widget.workoutSection,
//                 state: widget.state),
//           ));
//   }
// }
