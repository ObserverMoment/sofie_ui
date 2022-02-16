import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:just_audio/just_audio.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/media/audio/audio_player_controller.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

/// Displays a WhatsApp voice message style placeholder until play is tapped.
/// Then retrieves the audio file from Uploadcare and starts to play it.

class InlineAudioPlayer extends StatefulWidget {
  /// Full url - not uploadcare UID!
  final String audioUrl;
  final Axis layout;
  final double buttonSize;
  const InlineAudioPlayer({
    Key? key,
    required this.audioUrl,
    this.layout = Axis.horizontal,
    this.buttonSize = 30,
  }) : super(key: key);

  @override
  _InlineAudioPlayerState createState() => _InlineAudioPlayerState();
}

class _InlineAudioPlayerState extends State<InlineAudioPlayer> {
  bool _initialized = false;
  bool _loading = false;
  late AudioPlayer _player;
  Duration? _totalDuration;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  Future<void> _playerStateListener(PlayerState event) async {
    bool atEnd =
        _player.position.inMilliseconds >= _totalDuration!.inMilliseconds;
    if (atEnd) {
      await _player.pause();
      await _player.seek(Duration.zero);
    }
    if (mounted) setState(() {});
  }

  Future<void> _initialize() async {
    setState(() {
      _loading = true;
    });
    await AudioPlayerController.init(
        player: _player,
        audioUrl: widget.audioUrl,
        autoPlay: true,
        loopMode: LoopMode.off);

    _player.playerStateStream.listen(_playerStateListener);

    setState(() {
      _totalDuration = _player.duration;
      _loading = false;
      _initialized = true;
    });
  }

  void _handleScrubSeek(double position) {
    if (_totalDuration != null) {
      _player.seek(Duration(
          milliseconds: (_totalDuration!.inMilliseconds * position).round()));
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _player.playing;

    final List<Widget> children = [
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _loading
            ? null
            : isPlaying
                ? _player.pause
                : _initialized
                    ? _player.play
                    : _initialize,
        child: AnimatedSwitcher(
          duration: kStandardAnimationDuration,
          child: _loading
              ? const LoadingIndicator(size: 12)
              : isPlaying
                  ? Icon(CupertinoIcons.pause_fill, size: widget.buttonSize)
                  : Icon(CupertinoIcons.play_fill, size: widget.buttonSize),
        ),
      ),
      widget.layout == Axis.horizontal
          ? Expanded(
              child: _InlinePlayerProgressSlider(
                audioPlayer: _player,
                handleScrubSeek: _handleScrubSeek,
                totalDuration: _totalDuration,
              ),
            )
          : _InlinePlayerProgressSlider(
              audioPlayer: _player,
              handleScrubSeek: _handleScrubSeek,
              totalDuration: _totalDuration,
            ),
    ];

    return widget.layout == Axis.horizontal
        ? Row(
            children: children,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
  }
}

class _InlinePlayerProgressSlider extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final Duration? totalDuration;
  final void Function(double position) handleScrubSeek;
  const _InlinePlayerProgressSlider(
      {Key? key,
      required this.audioPlayer,
      required this.totalDuration,
      required this.handleScrubSeek})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
        stream: audioPlayer.positionStream,
        builder: (context, snapshot) {
          final bool loaded = snapshot.hasData && totalDuration != null;
          final position = snapshot.data;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 12,
                child: loaded
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(snapshot.data!.compactDisplay,
                              size: FONTSIZE.one),
                          MyText(totalDuration!.compactDisplay,
                              size: FONTSIZE.one),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: MyText(
                              '...',
                              size: FONTSIZE.one,
                              subtext: true,
                            ),
                          ),
                          Icon(CupertinoIcons.headphones, size: 12)
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: material.Material(
                  color: material.Colors.transparent,
                  child: material.SliderTheme(
                    data: material.SliderThemeData(
                      overlayShape: material.SliderComponentShape.noOverlay,
                      trackHeight: 3.0,
                      thumbShape: const material.RoundSliderThumbShape(
                          enabledThumbRadius: 4),
                    ),
                    child: material.Slider(
                      value: loaded
                          ? (position!.inMilliseconds /
                                  totalDuration!.inMilliseconds)
                              .clamp(0, 1.0)
                          : 0,
                      onChanged: handleScrubSeek,
                      activeColor: context.theme.primary,
                      inactiveColor: context.theme.primary.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
