import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:just_audio/just_audio.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/audio_player_controller.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';

/// Playes an audio file from an uploadcare uri
class FullScreenAudioPlayer extends StatefulWidget {
  final String audioUri;
  final Widget? image;
  final String pageTitle;
  final String audioTitle;
  final String? audioSubtitle;
  final bool autoPlay;
  const FullScreenAudioPlayer(
      {Key? key,
      required this.audioUri,
      this.image,
      required this.pageTitle,
      required this.audioTitle,
      this.audioSubtitle,
      this.autoPlay = false})
      : super(key: key);

  @override
  _FullScreenAudioPlayerState createState() => _FullScreenAudioPlayerState();
}

class _FullScreenAudioPlayerState extends State<FullScreenAudioPlayer> {
  late AudioPlayer _player;
  Duration _totalDuration = Duration.zero;

  final double _playPauseButtonSize = 75;
  final double _jumpSeekButtonSize = 42;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await AudioPlayerController.init(
      player: _player,
      audioUrl: UploadcareService.getFileUrl(widget.audioUri)!,
      autoPlay: widget.autoPlay,
    );
    setState(() {
      _totalDuration = _player.duration!;
    });
  }

  void _handleScrubSeek(double position) {
    _player.seek(Duration(
        milliseconds: (_totalDuration.inMilliseconds * position).round()));
  }

  void _seekTo(Duration seekTo) {
    _player.seek(seekTo.clamp(Duration.zero, _totalDuration));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        middle: NavBarTitle(widget.pageTitle),
        customLeading: CupertinoButton(
            onPressed: context.pop,
            child: const Icon(CupertinoIcons.chevron_down)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: widget.image ??
                Icon(
                  CupertinoIcons.waveform,
                  size: 80,
                  color: context.theme.primary.withOpacity(0.85),
                ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            height: 120,
            child: StreamBuilder<Duration?>(
                stream: _player.positionStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: MyText('Sorry, there was a problem.'));
                  } else {
                    return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: (!snapshot.hasData ||
                                _totalDuration == Duration.zero)
                            ? const Center(
                                child: LoadingIndicator(
                                size: 12,
                              ))
                            : Column(
                                children: [
                                  material.Material(
                                    color: material.Colors.transparent,
                                    child: material.SliderTheme(
                                      data: const material.SliderThemeData(
                                        trackHeight: 2.0,
                                        thumbShape:
                                            material.RoundSliderThumbShape(
                                                enabledThumbRadius: 5),
                                      ),
                                      child: material.Slider(
                                        value: (snapshot.data!.inMilliseconds /
                                                _totalDuration.inMilliseconds)
                                            .clamp(0, 1.0),
                                        onChanged: _handleScrubSeek,
                                        activeColor: context.theme.primary,
                                        inactiveColor: context.theme.primary
                                            .withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(snapshot.data!.compactDisplay,
                                            size: FONTSIZE.two),
                                        MyText(
                                            '- ${(_totalDuration - snapshot.data!).compactDisplay}',
                                            size: FONTSIZE.two),
                                      ],
                                    ),
                                  )
                                ],
                              ));
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: H3(widget.audioTitle),
          ),
          if (Utils.textNotNull(widget.audioSubtitle))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(widget.audioSubtitle!),
            ),
          SizedBox(
            child: StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, stateSnapShot) {
                  if (stateSnapShot.hasError) {
                    return const Center(
                        child: MyText('Sorry, there was a problem.'));
                  } else {
                    if (!stateSnapShot.hasData) {
                      return const Center(
                          child: LoadingIndicator(
                        size: 12,
                      ));
                    } else {
                      return StreamBuilder<Duration?>(
                          stream: _player.positionStream,
                          builder: (context, durationSnapshot) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (durationSnapshot.hasData)
                                  FadeIn(
                                    child: CupertinoButton(
                                      onPressed: () => _seekTo(Duration(
                                          seconds:
                                              durationSnapshot.data!.inSeconds -
                                                  15)),
                                      child: JumpSeekIcon(
                                        forward: false,
                                        size: _jumpSeekButtonSize,
                                      ),
                                    ),
                                  ),
                                CupertinoButton(
                                  onPressed: () => stateSnapShot.data!.playing
                                      ? _player.pause()
                                      : _player.play(),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    child: stateSnapShot.data!.playing
                                        ? Icon(
                                            CupertinoIcons.pause_circle_fill,
                                            size: _playPauseButtonSize,
                                          )
                                        : Icon(
                                            CupertinoIcons.play_circle_fill,
                                            size: _playPauseButtonSize,
                                          ),
                                  ),
                                ),
                                if (durationSnapshot.hasData)
                                  CupertinoButton(
                                    onPressed: () => _seekTo(Duration(
                                        seconds:
                                            durationSnapshot.data!.inSeconds +
                                                15)),
                                    child: JumpSeekIcon(
                                      size: _jumpSeekButtonSize,
                                    ),
                                  ),
                              ],
                            );
                          });
                    }
                  }
                }),
          )
        ],
      ),
    );
  }
}
