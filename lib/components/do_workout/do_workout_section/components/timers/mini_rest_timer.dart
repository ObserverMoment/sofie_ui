import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/timers/timer_components.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MiniRestTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback closeTimer;
  final VoidCallback closeTimerAndOpenSettings;
  const MiniRestTimer(
      {Key? key,
      required this.seconds,
      required this.closeTimer,
      required this.closeTimerAndOpenSettings})
      : super(key: key);

  @override
  State<MiniRestTimer> createState() => _MiniRestTimerState();
}

class _MiniRestTimerState extends State<MiniRestTimer> {
  late StopWatchTimer _timer;
  late int _currentSeconds;
  bool _hasEnded = false;
  bool _hasInit = false;

  @override
  void initState() {
    super.initState();

    _currentSeconds = widget.seconds;
    _timer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: widget.seconds * 1000,
      onChangeRawSecond: _onChangeRawSeconds,
      onEnded: _onEnded,
    );

    _timer.onExecute.add(StopWatchExecute.start);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _hasInit = true);
      }
    });
  }

  void _onChangeRawSeconds(int seconds) {
    if (seconds < 4) {
      Vibrate.feedback(FeedbackType.light);
    }
    setState(() => _currentSeconds = seconds);
  }

  void _onEnded() {
    setState(() {
      _hasEnded = true;
    });
    Vibrate.feedback(FeedbackType.success);
  }

  void _togglePauseTimer() {
    _timer.isRunning
        ? _timer.onExecute.add(StopWatchExecute.stop)
        : _timer.onExecute.add(StopWatchExecute.start);
    setState(() {});
  }

  void _repeatRestTimer() {
    _timer.onExecute.add(StopWatchExecute.reset);
    _timer.onExecute.add(StopWatchExecute.start);
    setState(() {
      _hasEnded = false;
    });
  }

  EdgeInsets get _iconButtonPadding =>
      const EdgeInsets.symmetric(horizontal: 10, vertical: 8);

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      backgroundColor: context.theme.background,
      elevation: 3,
      height: 126,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(CupertinoIcons.timer, size: 18),
                  SizedBox(width: 6),
                  MyHeaderText(
                    'Rest',
                    weight: FontWeight.normal,
                    size: FONTSIZE.four,
                    lineHeight: 1,
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      padding: _iconButtonPadding,
                      onPressed: widget.closeTimer,
                      iconData: CupertinoIcons.hand_thumbsup),
                  IconButton(
                      padding: _iconButtonPadding,
                      onPressed: _repeatRestTimer,
                      iconData: CupertinoIcons.repeat),
                  IconButton(
                      padding: _iconButtonPadding,
                      onPressed: widget.closeTimerAndOpenSettings,
                      iconData: CupertinoIcons.settings),
                ],
              )
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _hasEnded ? widget.closeTimer : _togglePauseTimer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: kStandardAnimationDuration,
                  child: _hasEnded
                      ? const MyText(
                          'Ok, back to work!',
                          size: FONTSIZE.five,
                        )
                      : TimerDisplayText(
                          milliseconds: (_currentSeconds + 1) * 1000,
                          fontSize: FONTSIZE.six,
                          showHours: false,
                        ),
                ),
                GrowInOut(
                    show: _hasInit && !_hasEnded && !_timer.isRunning,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          MyText(
                            'PAUSED',
                            size: FONTSIZE.one,
                            subtext: true,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
