import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/mic_audio_recorder.dart';
import 'package:sofie_ui/components/media/images/utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

class MediaPickers extends StatelessWidget {
  final FeedPostType feedPostType;
  final void Function(File? pickedAudio) onAudioFilePickedRemoved;
  final File? audio;
  final void Function(File? pickedImage) onImageFilePickedRemoved;
  final File? image;
  final void Function(File? pickedVideo) onVideoFilePickedRemoved;
  final File? video;
  const MediaPickers(
      {Key? key,
      required this.feedPostType,
      required this.onAudioFilePickedRemoved,
      this.audio,
      required this.onImageFilePickedRemoved,
      this.image,
      required this.onVideoFilePickedRemoved,
      this.video})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (image == null && video == null)
            _AudioPicker(
              onFilePickedRemoved: onAudioFilePickedRemoved,
              file: audio,
            ),
          if (audio == null && video == null)
            _ImagePicker(
              onFilePickedRemoved: onImageFilePickedRemoved,
              file: image,
            ),
          if (image == null && audio == null)
            _VideoPicker(
              onFilePickedRemoved: onVideoFilePickedRemoved,
              file: video,
            ),
        ],
      ),
    );
  }
}

class _AudioPicker extends StatelessWidget {
  /// Pass null to remove
  final void Function(File? picked) onFilePickedRemoved;
  final File? file;
  const _AudioPicker({Key? key, required this.onFilePickedRemoved, this.file})
      : super(key: key);

  void _selectAudioSource(BuildContext context) {
    final hasAudio = file != null;
    openBottomSheetMenu(
        context: context,
        child: BottomSheetMenu(items: [
          BottomSheetMenuItem(
            text: hasAudio ? 'Make new recording' : 'Make recording',
            onPressed: () => _recordAudioFromDevice(context),
          ),
          BottomSheetMenuItem(
            text: hasAudio ? 'Choose new from library' : 'Choose from library',
            onPressed: () => _pickAudioFromDevice(context),
          ),
          if (hasAudio)
            BottomSheetMenuItem(
              text: 'Remove Audio',
              isDestructive: true,
              onPressed: () => onFilePickedRemoved(null),
            ),
        ]));
  }

  Future<void> _pickAudioFromDevice(BuildContext context) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: kAudioAllowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        onFilePickedRemoved(File(result.files.single.path!));
      }
    } on PlatformException catch (e) {
      printLog(e.toString());
      context.showErrorAlert(e.toString());
    } on Exception catch (_) {
      context.showToast(message: 'Audio not selected');
    }
  }

  Future<void> _recordAudioFromDevice(BuildContext context) async {
    await openMicAudioRecorder(
        context: context,
        saveAudioRecording: (path) => onFilePickedRemoved(File(path)));
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: ContentBox(
        padding: EdgeInsets.zero,
        child: CupertinoButton(
            child: file != null
                ? const _MediaSelectedIndicator(text: 'AUDIO SELECTED')
                : const MyText('ADD AUDIO'),
            onPressed: () => _selectAudioSource(context)),
      ),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  /// Pass null to remove
  final void Function(File? picked) onFilePickedRemoved;
  final File? file;
  const _ImagePicker({Key? key, required this.onFilePickedRemoved, this.file})
      : super(key: key);

  void _selectImageSource(BuildContext context) {
    final hasImage = file != null;
    openBottomSheetMenu(
        context: context,
        child: BottomSheetMenu(items: [
          BottomSheetMenuItem(
              text: hasImage ? 'Take new photo' : 'Take photo',
              onPressed: () => _pickDeleteImage(context, ImageSource.camera)),
          BottomSheetMenuItem(
              text:
                  hasImage ? 'Choose new from library' : 'Choose from library',
              onPressed: () => _pickDeleteImage(context, ImageSource.gallery)),
          if (hasImage)
            BottomSheetMenuItem(
                text: 'Remove',
                isDestructive: true,
                onPressed: () => onFilePickedRemoved(null))
        ]));
  }

  Future<void> _pickDeleteImage(
      BuildContext context, ImageSource source) async {
    try {
      final File croppedFile = await ImageUtils.pickThenCropImage(source);
      onFilePickedRemoved(croppedFile);
    } on PlatformException catch (e) {
      printLog(e.toString());
      context.showErrorAlert(e.toString());
    } on Exception catch (e) {
      printLog(e.toString());
      context.showToast(message: 'Image not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: ContentBox(
          padding: EdgeInsets.zero,
          child: CupertinoButton(
            child: file != null
                ? const _MediaSelectedIndicator(text: 'IMAGE SELECTED')
                : const MyText('ADD IMAGE'),
            onPressed: () => _selectImageSource(context),
          )),
    );
  }
}

class _VideoPicker extends StatelessWidget {
  /// Pass null to remove
  final void Function(File? picked) onFilePickedRemoved;
  final File? file;
  const _VideoPicker({Key? key, required this.onFilePickedRemoved, this.file})
      : super(key: key);

  void _selectVideoSource(BuildContext context) {
    final hasVideo = file != null;
    openBottomSheetMenu(
        context: context,
        child: BottomSheetMenu(
          items: [
            BottomSheetMenuItem(
              text: hasVideo ? 'Take new video' : 'Take video',
              onPressed: () => _pickVideo(context, ImageSource.camera),
            ),
            BottomSheetMenuItem(
              text:
                  hasVideo ? 'Choose new from library' : 'Choose from library',
              onPressed: () => _pickVideo(context, ImageSource.gallery),
            ),
            if (hasVideo)
              BottomSheetMenuItem(
                text: 'Remove video',
                isDestructive: true,
                onPressed: () => onFilePickedRemoved(null),
              ),
          ],
        ));
  }

  Future<void> _pickVideo(BuildContext context, ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickVideo(source: source);

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        final double fileSize = file.lengthSync() / 1000000;

        if (fileSize > 20) {
          printLog('Max upload size is 20mb');
          context.showToast(message: 'Max file size is 20mb.');
        } else {
          onFilePickedRemoved(file);
        }
      }
    } on PlatformException catch (e) {
      printLog(e.toString());
      context.showErrorAlert(e.toString());
    } on Exception catch (e) {
      printLog(e.toString());
      context.showToast(message: 'Video not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: ContentBox(
          padding: EdgeInsets.zero,
          child: CupertinoButton(
            child: file != null
                ? const _MediaSelectedIndicator(text: 'VIDEO SELECTED')
                : const MyText('ADD VIDEO'),
            onPressed: () => _selectVideoSource(context),
          )),
    );
  }
}

class _MediaSelectedIndicator extends StatelessWidget {
  final String text;
  const _MediaSelectedIndicator({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          CupertinoIcons.checkmark_alt,
          color: Styles.primaryAccent,
        ),
        const SizedBox(width: 8),
        MyText(text),
      ],
    );
  }
}
