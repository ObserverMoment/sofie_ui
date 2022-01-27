import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

class AudioPlayerController {
  static Future<AudioPlayer> init({
    required AudioPlayer player,
    AudioSessionConfiguration? sessionType,
    required String audioUrl,
    LoopMode loopMode = LoopMode.one,
    bool autoPlay = false,
  }) async {
    final session = await AudioSession.instance;
    await session
        .configure(sessionType ?? const AudioSessionConfiguration.speech());

    try {
      if (Utils.textNotNull(audioUrl)) {
        await player.setUrl(audioUrl);
        await player.setLoopMode(loopMode);

        // Listen to errors during playback.
        player.playbackEventStream.listen(null,
            onError: (Object e, StackTrace stackTrace) {
          printLog('A stream error occurred: $e');
        });

        if (autoPlay) {
          player.play();
        }
      } else {
        throw Exception('Could not retrieve a valid url for this file.');
      }
    } on PlayerException catch (e) {
      printLog("Error code: ${e.code}");
      printLog("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      printLog("Connection aborted: ${e.message}");
    } catch (e) {
      // Fallback for all errors
      printLog(e.toString());
    }
    return player;
  }

  /// Assumes that [audioUri] is a uploadcare UID.
  static Future<void> openAudioPlayer(
      {required BuildContext context,
      required String audioUri,
      required String audioTitle,
      String? audioSubtitle,
      required String pageTitle,
      bool autoPlay = false}) async {
    await context.push(
        fullscreenDialog: true,
        child: FullScreenAudioPlayer(
          audioUri: audioUri,
          pageTitle: pageTitle,
          audioTitle: audioTitle,
          audioSubtitle: audioSubtitle,
          autoPlay: autoPlay,
        ));
  }
}
