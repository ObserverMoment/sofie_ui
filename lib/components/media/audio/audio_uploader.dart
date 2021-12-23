import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/components/media/audio/mic_audio_recorder.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

/// On complete run [onUploadSuccess] so that we can save the uploaded file uri to the db.
class AudioUploader extends StatefulWidget {
  final String? audioUri;
  final Size displaySize;
  final void Function()? onUploadStart;
  final void Function(String uploadedUri) onUploadSuccess;
  final VoidCallback? onUploadFail;
  final void Function() removeAudio;
  final IconData iconData;
  const AudioUploader(
      {Key? key,
      this.audioUri,
      this.displaySize = const Size(120, 120),
      required this.onUploadSuccess,
      this.onUploadStart,
      this.iconData = CupertinoIcons.waveform,
      required this.removeAudio,
      this.onUploadFail})
      : super(key: key);

  @override
  _AudioUploaderState createState() => _AudioUploaderState();
}

class _AudioUploaderState extends State<AudioUploader> {
  bool _uploading = false;

  Future<void> _pickAudioFromDevice() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'wav',
          'aiff',
          'alac',
          'flac',
          'mp3',
          'aac',
          'wma',
          'ogg'
        ],
      );

      if (result != null && result.files.single.path != null) {
        setState(() => _uploading = true);
        await _uploadFile(File(result.files.single.path!));
        setState(() => _uploading = false);
      }
    } on PlatformException catch (e) {
      context.showErrorAlert(e.toString());
    } on Exception catch (_) {
      context.showToast(message: 'Audio not selected');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _recordAudioFromDevice() async {
    await openMicAudioRecorder(
        context: context,
        saveAudioRecording: (path) => _uploadFile(File(path)));
  }

  Future<void> _uploadFile(File file) async {
    widget.onUploadStart?.call();

    await GetIt.I<UploadcareService>().uploadFile(
        file: SharedFile(file),
        onComplete: (uri) {
          _resetState();
          widget.onUploadSuccess(uri);
        },
        onFail: (e) {
          widget.onUploadFail?.call();
          throw Exception(e);
        });
  }

  Future<void> _listenToAudio() async {
    if (widget.audioUri != null) {
      await AudioPlayerController.openAudioPlayer(
        context: context,
        audioUri: widget.audioUri!,
        pageTitle: 'Preview Audio',
        audioTitle: 'Preview Audio',
      );
    }
  }

  void _resetState() => setState(() {
        _uploading = false;
      });

  @override
  Widget build(BuildContext context) {
    final Color primary = context.theme.primary;
    final Color cardBackground = context.theme.cardBackground;
    final bool hasAudio = Utils.textNotNull(widget.audioUri);
    return GestureDetector(
      onTap: () => openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(items: [
            if (hasAudio)
              BottomSheetMenuItem(
                  text: 'Listen to audio', onPressed: _listenToAudio),
            BottomSheetMenuItem(
              text: hasAudio ? 'Make new recording' : 'Make recording',
              onPressed: _recordAudioFromDevice,
            ),
            BottomSheetMenuItem(
              text:
                  hasAudio ? 'Choose new from library' : 'Choose from library',
              onPressed: _pickAudioFromDevice,
            ),
            if (hasAudio)
              BottomSheetMenuItem(
                text: 'Remove Audio',
                isDestructive: true,
                onPressed: () => context.showConfirmDeleteDialog(
                    itemType: 'Audio', onConfirm: widget.removeAudio),
              ),
          ])),
      child: Stack(
        children: [
          Container(
            width: widget.displaySize.width,
            height: widget.displaySize.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: hasAudio ? Styles.primaryAccent : cardBackground,
              boxShadow: kElevation[3],
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _uploading
                  ? LoadingCircle(color: primary)
                  : Icon(
                      widget.iconData,
                      color: hasAudio ? Styles.white : primary.withOpacity(0.3),
                      size: widget.displaySize.width / 1.5,
                    ),
            ),
          ),
          if (hasAudio)
            const Positioned(
                bottom: 3,
                right: 3,
                child: FadeIn(
                    child: Icon(
                  CupertinoIcons.checkmark_alt_circle,
                  size: 16,
                  color: Styles.white,
                )))
        ],
      ),
    );
  }
}
