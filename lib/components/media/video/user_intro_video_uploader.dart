import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class UserIntroVideoUploader extends StatefulWidget {
  final String? introVideoUri;
  final String? introVideoThumbUri;
  final Size displaySize;

  /// Pass null and the api will delete from the DB.
  final Function(String? uploadedVideoUri, String? uploadedVideoThumbUri)
      onUploadSuccess;
  const UserIntroVideoUploader(
      {Key? key,
      this.introVideoUri,
      this.introVideoThumbUri,
      this.displaySize = const Size(120, 120),
      required this.onUploadSuccess})
      : super(key: key);

  @override
  _UserIntroVideoUploaderState createState() => _UserIntroVideoUploaderState();
}

class _UserIntroVideoUploaderState extends State<UserIntroVideoUploader> {
  bool _uploading = false;
  bool _processing = false;
  double _uploadProgress = 0;

  Future<void> _pickVideo(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickVideo(source: source);
      if (pickedFile != null) {
        final file = File(pickedFile.path);

        final String fileSize =
            '${(file.lengthSync() / 1000000).toStringAsFixed(2)} MB';

        await context.showConfirmDialog(
          title: 'Upload video',
          message: 'This file is $fileSize in size.',
          verb: 'Upload',
          onConfirm: () => _uploadFile(file),
        );
      }
    } on PlatformException catch (e) {
      printLog(e.toString());
      context.showErrorAlert(e.toString());
    } on Exception catch (e) {
      printLog(e.toString());
      context.showToast(message: 'Video not selected');
    } finally {
      setState(() => _uploading = false);
    }
  }

  Future<void> _uploadFile(File file) async {
    try {
      setState(() => _uploading = true);
      await GetIt.I<UploadcareService>().uploadVideo(
          file: SharedFile(file),
          onProgress: (progress) =>
              setState(() => _uploadProgress = progress.value),
          onUploaded: () => setState(() {
                _uploading = false;
                _processing = true;
              }),
          onComplete: _saveUrisToDB,
          onFail: (e) => throw Exception(e));
    } catch (e) {
      printLog(e.toString());
      await context.showErrorAlert(e.toString());
      _resetState();
    }
  }

  Future<void> _saveUrisToDB(String? videoUri, String? videoThumbUri) async {
    try {
      widget.onUploadSuccess(videoUri, videoThumbUri);
    } catch (e) {
      printLog(e.toString());
      await context.showErrorAlert(e.toString());
    } finally {
      _resetState();
    }
  }

  void _resetState() => setState(() {
        _uploading = false;
        _processing = false;
        _uploadProgress = 0;
      });

  @override
  Widget build(BuildContext context) {
    final Color primary = context.theme.primary;
    final Color cardBackground = context.theme.cardBackground;
    final bool hasVideo = Utils.textNotNull(widget.introVideoUri);

    return GestureDetector(
      onTap: () => openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(items: [
            if (hasVideo)
              BottomSheetMenuItem(
                text: 'Watch video',
                onPressed: () => VideoSetupManager.openFullScreenVideoPlayer(
                    context: context,
                    videoUri: widget.introVideoUri!,
                    videoThumbUri: widget.introVideoThumbUri,
                    autoPlay: true,
                    autoLoop: true),
              ),
            BottomSheetMenuItem(
              text: 'Take video',
              onPressed: () => _pickVideo(ImageSource.camera),
            ),
            BottomSheetMenuItem(
              text: 'Choose from library',
              onPressed: () => _pickVideo(ImageSource.gallery),
            ),
            if (hasVideo)
              BottomSheetMenuItem(
                text: 'Remove video',
                isDestructive: true,
                onPressed: () => context.showConfirmDeleteDialog(
                    itemType: 'Video',
                    onConfirm: () => _saveUrisToDB(null, null)),
              ),
          ])),
      child: Container(
        width: widget.displaySize.width,
        height: widget.displaySize.height,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cardBackground,
            boxShadow: kElevation[3]),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _uploading
              ? LinearProgressIndicator(
                  width: widget.displaySize.width * 0.8,
                  height: 3,
                  progress: _uploadProgress,
                )
              : _processing
                  ? LoadingIndicator(
                      color: primary,
                    )
                  : Utils.textNotNull(widget.introVideoThumbUri)
                      ? SizedUploadcareImage(widget.introVideoThumbUri!)
                      : Icon(
                          CupertinoIcons.tv,
                          size: widget.displaySize.width / 2.5,
                          color: primary.withOpacity(0.3),
                        ),
        ),
      ),
    );
  }
}
