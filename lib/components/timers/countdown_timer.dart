import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/timers/timer_components.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

enum CountdownState { reset, started }

/// Like the Timer tab in iOS clock.
/// Runs down to zero from a selected time. Pausable.
class CountdownTimer extends StatefulWidget {
  /// If false will display smaller to allow for nesting inside other pages.
  final bool fullScreenDisplay;
  const CountdownTimer({Key? key, this.fullScreenDisplay = false})
      : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late StopWatchTimer _stopWatchTimer;
  CountdownState _countdownState = CountdownState.reset;
  late double _buttonSize;
  Duration _countdownTime = Duration.zero;

  /// Hack around this: https://stackoverflow.com/questions/62835520/flutter-cupertinodatepicker-initialdatetime-updates-only-once
  late int _timepickerKey;

  @override
  void initState() {
    _timepickerKey = DateTime.now().millisecondsSinceEpoch;

    _stopWatchTimer =
        StopWatchTimer(mode: StopWatchMode.countDown, onEnded: _handleComplete);
    _stopWatchTimer.clearPresetTime();

    _buttonSize = widget.fullScreenDisplay ? 90.0 : 70.0;
    super.initState();
  }

  void _handleStart() {
    if (_countdownTime != Duration.zero &&
        _countdownState != CountdownState.started) {
      _stopWatchTimer.clearPresetTime();
      _stopWatchTimer.setPresetTime(mSec: _countdownTime.inMilliseconds);
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      setState(() => _countdownState = CountdownState.started);
    }
  }

  void _handlePause() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
  }

  void _handleResume() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  void _handleClear() {
    _stopWatchTimer.clearPresetTime();
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    setState(() {
      _countdownTime = Duration.zero;
      _countdownState = CountdownState.reset;
      _timepickerKey = DateTime.now().millisecondsSinceEpoch;
    });
  }

  void _handleComplete() {
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    setState(() {
      _countdownState = CountdownState.reset;
    });
    print('beep beep');
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => StreamBuilder<StopWatchExecute>(
            initialData: StopWatchExecute.stop,
            stream: _stopWatchTimer.execute,
            builder: (context, AsyncSnapshot<StopWatchExecute> stateSnapshot) {
              final stopWatchState = stateSnapshot.data!;

              final size = constraints.maxWidth *
                  (widget.fullScreenDisplay ? 0.9 : 0.65);

              return StreamBuilder<int>(
                  initialData: 0,
                  stream: _stopWatchTimer.rawTime,
                  builder: (context, AsyncSnapshot<int> msSnapshot) {
                    final milliseconds = msSnapshot.data!;

                    return Column(
                      children: [
                        SizedBox(
                          height: size,
                          child: AnimatedSwitcher(
                            duration: kStandardAnimationDuration,
                            child: _countdownState == CountdownState.reset
                                ? CupertinoTimerPicker(
                                    key: Key(_timepickerKey.toString()),
                                    initialTimerDuration: _countdownTime,
                                    onTimerDurationChanged: (d) =>
                                        setState(() => _countdownTime = d),
                                  )
                                : CircularPercentIndicator(
                                    reverse: true,
                                    center: TimerDisplayText(
                                      /// Display gets rounded down so when not displaying milliseconds it appears like you are one seocnd ahead of where you would expect to be.
                                      milliseconds: milliseconds + 1000,
                                      fontSize: widget.fullScreenDisplay
                                          ? FONTSIZE.twelve
                                          : FONTSIZE.eleven,
                                    ),
                                    backgroundColor:
                                        context.theme.primary.withOpacity(0.1),
                                    linearGradient:
                                        Styles.secondaryAccentGradient,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    percent: milliseconds /
                                        _countdownTime.inMilliseconds,
                                    radius: size),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AnimatedOpacity(
                              opacity:
                                  _countdownTime == Duration.zero ? 0.4 : 1,
                              duration: kStandardAnimationDuration,
                              child: StopwatchButton(
                                size: _buttonSize,
                                onPressed: () {
                                  if (_countdownTime != Duration.zero) {
                                    _handleClear();
                                  } else {
                                    return;
                                  }
                                },
                                label: 'Clear',
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: kStandardAnimationDuration,
                              child: _countdownState == CountdownState.reset
                                  ? AnimatedOpacity(
                                      opacity: _countdownTime == Duration.zero
                                          ? 0.4
                                          : 1,
                                      duration: kStandardAnimationDuration,
                                      child: StopwatchButton(
                                        size: _buttonSize,
                                        onPressed: () {
                                          if (_countdownTime != Duration.zero) {
                                            _handleStart();
                                          } else {
                                            return;
                                          }
                                        },
                                        label: 'Start',
                                      ),
                                    )
                                  : stopWatchState == StopWatchExecute.stop
                                      ? StopwatchButton(
                                          size: _buttonSize,
                                          onPressed: _handleResume,
                                          label: 'Resume',
                                        )
                                      : StopwatchButton(
                                          size: _buttonSize,
                                          onPressed: _handlePause,
                                          label: 'Pause',
                                        ),
                            ),
                          ],
                        )
                      ],
                    );
                  });
            }));
  }
}
