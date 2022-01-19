import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/constants.dart';
import 'package:video_player/video_player.dart';

class PlayPauseVideoControlOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  const PlayPauseVideoControlOverlay({Key? key, required this.controller})
      : super(key: key);

  @override
  State<PlayPauseVideoControlOverlay> createState() =>
      _PlayPauseVideoControlOverlayState();
}

class _PlayPauseVideoControlOverlayState
    extends State<PlayPauseVideoControlOverlay> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kStandardAnimationDuration,
      child: widget.controller.value.isPlaying
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.controller.pause,
              child: const SizedBox.expand())
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Vibrate.feedback(FeedbackType.light);
                widget.controller.play();
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
    );
  }
}
