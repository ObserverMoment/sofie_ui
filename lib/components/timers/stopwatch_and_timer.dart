import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/timers/countdown_timer.dart';
import 'package:sofie_ui/components/timers/stopwatch_with_laps.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/env_config.dart';

/// Indexed stack widget with bottom navigation bar.
/// Navigate between [StopwatchWithLaps] and [CountdownTimer]
class StopwatchAndTimer extends StatefulWidget {
  const StopwatchAndTimer({Key? key}) : super(key: key);

  @override
  _StopwatchAndTimerState createState() => _StopwatchAndTimerState();
}

class _StopwatchAndTimerState extends State<StopwatchAndTimer> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
              bottom: EnvironmentConfig.bottomNavBarHeight),
          child: IndexedStack(
            index: _activeTabIndex,
            children: const [
              StopwatchWithLaps(
                fullScreenDisplay: true,
              ),
              CountdownTimer(
                fullScreenDisplay: true,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MySlidingSegmentedControl<int>(
              value: _activeTabIndex,
              updateValue: (i) => setState(() => _activeTabIndex = i),
              children: const {
                0: 'Stopwatch',
                1: 'Timer',
              },
            ),
          ),
        ),
      ],
    );
  }
}
