import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountdownAnimation extends StatefulWidget {
  final DoWorkoutBloc bloc;
  final VoidCallback onCountdownEnd;
  final int startFromSeconds;
  const CountdownAnimation(
      {Key? key,
      required this.onCountdownEnd,
      required this.startFromSeconds,
      required this.bloc})
      : super(key: key);

  @override
  State<CountdownAnimation> createState() => _CountdownAnimationState();
}

class _CountdownAnimationState extends State<CountdownAnimation> {
  late StopWatchTimer _timer;
  late int _currentSeconds;

  @override
  void initState() {
    super.initState();

    _currentSeconds = widget.startFromSeconds;
    _timer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: widget.startFromSeconds * 1000,
      onChangeRawSecond: _onChangeRawSeconds,
      onEnded: _onEnded,
    );

    _timer.onExecute.add(StopWatchExecute.start);
  }

  void _onChangeRawSeconds(int seconds) {
    if (seconds < 4) {
      widget.bloc.playBeepOne();
    }
    setState(() => _currentSeconds = seconds);
  }

  void _onEnded() {
    widget.bloc.playBeepTwo();
    widget.onCountdownEnd();
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const MyHeaderText(
                  'GET READY!',
                  size: FONTSIZE.six,
                  textAlign: TextAlign.center,
                  color: Styles.white,
                ),
                SizeFadeIn(
                    key: Key(_currentSeconds.toString()),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MyHeaderText(
                        (_currentSeconds + 1).toString(),
                        size: FONTSIZE.twelve,
                        color: Styles.white,
                      ),
                    ))
              ],
            ),
          )),
        ],
      ),
    );
  }
}
