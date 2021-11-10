import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/timers/stopwatch_and_timer.dart';
import 'package:wakelock/wakelock.dart';

class TimersPage extends StatefulWidget {
  const TimersPage({Key? key}) : super(key: key);

  @override
  State<TimersPage> createState() => _TimersPageState();
}

class _TimersPageState extends State<TimersPage> {
  /// User settings ////
  /// Wakelock settings.
  /// Revert to this once the user leaves the timer page.
  bool? _initialWakelockSetting;
  bool activeWakelockSetting = true;

  @override
  void initState() {
    super.initState();
    _initWakelock();
  }

  /// Constructor async helper ///
  Future<void> _initWakelock() async {
    // Save the original setting so we can revert to it on dispose.
    _initialWakelockSetting = await Wakelock.enabled;

    // set wakelock to true, which is the default.
    await Wakelock.enable();
  }

  @override
  void dispose() async {
    super.dispose();
    if (_initialWakelockSetting != null) {
      await Wakelock.toggle(enable: _initialWakelockSetting!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarTitle('Timers'),
      ),
      child: StopwatchAndTimer(),
    );
  }
}
