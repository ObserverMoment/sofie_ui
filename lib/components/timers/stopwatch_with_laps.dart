import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/timers/timer_components.dart';
import 'package:sofie_ui/constants.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

/// Like the Stopwatch tab in iOS clock.
/// Does lap timing.
class StopwatchWithLaps extends StatefulWidget {
  /// Increases the text size when true
  final bool fullScreenDisplay;
  const StopwatchWithLaps({Key? key, this.fullScreenDisplay = false})
      : super(key: key);

  @override
  _StopwatchWithLapsState createState() => _StopwatchWithLapsState();
}

class _StopwatchWithLapsState extends State<StopwatchWithLaps> {
  late StopWatchTimer _stopWatchTimer;

  @override
  void initState() {
    _stopWatchTimer = StopWatchTimer(isLapHours: false);
    super.initState();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<int>(
              initialData: 0,
              stream: _stopWatchTimer.rawTime,
              builder: (context, AsyncSnapshot<int> msSnapshot) {
                return TimerDisplayText(
                  milliseconds: msSnapshot.data!,
                  fontSize: widget.fullScreenDisplay
                      ? FONTSIZE.twelve
                      : FONTSIZE.eleven,
                  showMilliseconds: true,
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<StopWatchExecute>(
              initialData: StopWatchExecute.stop,
              stream: _stopWatchTimer.execute,
              builder:
                  (context, AsyncSnapshot<StopWatchExecute> stateSnapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedSwitcher(
                        duration: kStandardAnimationDuration,
                        child: stateSnapshot.data! == StopWatchExecute.stop
                            ? StopwatchButton(
                                onPressed: () {
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.reset);
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.stop);
                                },
                                label: 'Reset')
                            : StopwatchButton(
                                onPressed: () => _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.lap),
                                label: 'Lap',
                              )),
                    AnimatedSwitcher(
                        duration: kStandardAnimationDuration,
                        child: stateSnapshot.data! == StopWatchExecute.stop
                            ? StopwatchButton(
                                onPressed: () => _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.start),
                                label: 'Start',
                              )
                            : StopwatchButton(
                                onPressed: () => _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.stop),
                                label: 'Stop',
                              )),
                  ],
                );
              }),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<StopWatchRecord>>(
                initialData: const <StopWatchRecord>[],
                stream: _stopWatchTimer.records,
                builder:
                    (context, AsyncSnapshot<List<StopWatchRecord>> snapshot) {
                  final records = snapshot.data!;

                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (c, i) => SizeFadeIn(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: MyText('Lap ${i + 1}'),
                          ),
                          if (records[i].displayTime != null)
                            if (i == 0)
                              MyText(records[i].displayTime!)
                            else
                              MyText(StopWatchTimer.getDisplayTime(
                                  (records[i].rawValue ?? 0) -
                                      (records[i - 1].rawValue ?? 0),
                                  hours: StopWatchTimer.getRawHours(
                                          records[i].rawValue ?? 0) >
                                      0)),
                        ],
                      ),
                    ),
                    itemCount: records.length,
                    separatorBuilder: (c, i) => const HorizontalLine(),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
