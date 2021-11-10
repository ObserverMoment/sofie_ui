import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/timers/timer_components.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

Future<void> openMicAudioRecorder(
    {required BuildContext context,
    required Function(String filePath) saveAudioRecording,
    bool autoStartRecord = false}) async {
  await context.push(
      fullscreenDialog: true,
      child: MicAudioRecorder(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        saveAudioRecording: saveAudioRecording,
      ));
}

class MicAudioRecorder extends StatefulWidget {
  final Function(String filePath) saveAudioRecording;
  const MicAudioRecorder({
    Key? key,
    required this.saveAudioRecording,
  }) : super(key: key);

  @override
  _MicAudioRecorderState createState() => _MicAudioRecorderState();
}

class _MicAudioRecorderState extends State<MicAudioRecorder> {
  bool _isStopped = true;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  String? _recordedFilePath;

  Future<void> _pauseStartOrResume() async {
    if (_isStopped) {
      await _start();
    } else if (_isPaused) {
      await _resume();
    } else {
      await _pause();
    }
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final Directory tempDir = await getTemporaryDirectory();

        final rand = DateTime.now().millisecondsSinceEpoch.toString();

        _recordedFilePath =
            '${tempDir.path}/${rand}journal_entry_voice_note_temp.aac';

        await _audioRecorder.start(path: _recordedFilePath);

        final bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isStopped = !isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  Future<void> _pause() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.pause();

    setState(() => _isPaused = true);
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();

    setState(() => _isPaused = false);
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  Future<void> _clearAndReset() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.stop();

    setState(() {
      _recordDuration = 0;
      _isStopped = true;
      _isPaused = false;
    });
  }

  Future<void> _saveRecording() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final path = await _audioRecorder.stop();

    widget.saveAudioRecording(path!);

    setState(() => _isStopped = true);
    context.pop();
  }

  Future<void> _handleCancelAndClose() async {
    context.pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(_handleCancelAndClose),
        middle: const NavBarTitle('Record Mic'),
      ),
      child: SizedBox.expand(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedSwitcher(
                duration: kStandardAnimationDuration,
                child: !_isPaused && !_isStopped
                    ? const SpinKitDoubleBounce(
                        color: Styles.primaryAccent,
                        size: 60,
                        duration: Duration(seconds: 4),
                      )
                    : Icon(
                        CupertinoIcons.circle_fill,
                        color: context.theme.primary.withOpacity(0.07),
                        size: 60,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TimerDisplayText(
                milliseconds: _recordDuration * 1000,
                fontSize: FONTSIZE.ten,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: CupertinoButton(
                  onPressed: _pauseStartOrResume,
                  child: AnimatedSwitcher(
                      duration: kStandardAnimationDuration,
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          AnimatedSwitcher(
                            duration: kStandardAnimationDuration,
                            child: _isPaused || _isStopped
                                ? const Icon(CupertinoIcons.mic, size: 60)
                                : const Icon(CupertinoIcons.pause_fill,
                                    size: 60),
                          ),
                          if (_isPaused || _isStopped)
                            AnimatedOpacity(
                                opacity: _recordDuration > 0 ? 1 : 0,
                                duration: kStandardAnimationDuration,
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: MyText(
                                    'continue..',
                                    lineHeight: 1,
                                    size: FONTSIZE.one,
                                  ),
                                )),
                        ],
                      ))),
            ),
            if (_isPaused && _recordDuration > 0)
              FadeIn(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    children: [
                      PrimaryButton(
                          text: 'Save Recording', onPressed: _saveRecording),
                      const SizedBox(height: 12),
                      DestructiveButton(
                          text: 'Clear', onPressed: _clearAndReset)
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
