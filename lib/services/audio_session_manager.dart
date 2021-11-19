import 'package:audio_session/audio_session.dart';

class AudioSessionManager {
  static Future<AudioSession> setupAudioSession() async {
    final session = await AudioSession.instance;

    /// https://pub.dev/packages/audio_session
    /// Set up the audio session. The beeps and FX should duck other sources, not stop them.
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.movie,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.game,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
      androidWillPauseWhenDucked: false,
    ));

    return session;
  }
}
