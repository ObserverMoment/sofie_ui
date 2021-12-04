import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class UserIntroVideoUploader extends StatefulWidget {
  final String? introVideoUri;
  final String? introVideoThumbUri;
  final Size displaySize;
  final Function(String uploadedVideoUri, String uploadedVideoThumbUri)?
      onUploadSuccess;
  const UserIntroVideoUploader(
      {Key? key,
      this.introVideoUri,
      this.introVideoThumbUri,
      this.displaySize = const Size(120, 120),
      this.onUploadSuccess})
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
      final XFile? _pickedFile = await ImagePicker().pickVideo(source: source);
      if (_pickedFile != null) {
        final _file = File(_pickedFile.path);

        final String _fileSize =
            '${(_file.lengthSync() / 1000000).toStringAsFixed(2)} MB';

        await context.showConfirmDialog(
          title: 'Upload video',
          message: 'This file is $_fileSize in size.',
          verb: 'Upload',
          onConfirm: () => _uploadFile(_file),
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

  Future<void> _uploadFile(File _file) async {
    try {
      setState(() => _uploading = true);
      await GetIt.I<UploadcareService>().uploadVideo(
          file: SharedFile(_file),
          onProgress: (progress) =>
              setState(() => _uploadProgress = progress.value),
          onUploaded: () => setState(() {
                _uploading = false;
                _processing = true;
              }),
          onComplete: (String videoUri, String videoThumbUri) =>
              _saveUrisToDB(videoUri, videoThumbUri),
          onFail: (e) => throw Exception(e));
    } catch (e) {
      printLog(e.toString());
      await context.showErrorAlert(e.toString());
      _resetState();
    }
  }

  Future<void> _saveUrisToDB(String? videoUri, String? videoThumbUri) async {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    try {
      final input = UpdateUserProfileInput()
        ..introVideoUri = videoUri
        ..introVideoThumbUri = videoThumbUri;
      final variables = UpdateUserProfileArguments(data: input);
      final Map<String, dynamic> varsMap = {
        'introVideoUri': videoUri,
        'introVideoThumbUri': videoThumbUri
      };

      await context.graphQLStore.mutate(
        mutation: UpdateUserProfileMutation(variables: variables),
        customVariablesMap: {'data': varsMap},

        /// TODO: Check user => profile changes have not broken this.
        broadcastQueryIds: [GQLVarParamKeys.userProfileByIdQuery(authedUserId)],
      );
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
                  ? LoadingCircle(
                      color: primary,
                    )
                  : Utils.textNotNull(widget.introVideoThumbUri)
                      ? SizedUploadcareImage(widget.introVideoThumbUri!)
                      : Icon(
                          CupertinoIcons.film,
                          size: widget.displaySize.width / 2.5,
                          color: primary.withOpacity(0.3),
                        ),
        ),
      ),
    );
  }
}
