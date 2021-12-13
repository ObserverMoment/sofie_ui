import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/images/utils.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

/// Displays an image (if it exists).
/// On complete run [onUploadSuccess] so that we can save the uploaded file uri to the db.
class ImageUploader extends StatefulWidget {
  final String? imageUri;
  final Size displaySize;
  final double borderRadius;
  final void Function()? onUploadStart;
  final void Function(String uploadedUri) onUploadSuccess;
  final VoidCallback? onUploadFail;
  final void Function(String uri) removeImage;
  final IconData emptyThumbIcon;
  const ImageUploader(
      {Key? key,
      this.imageUri,
      this.displaySize = const Size(120, 120),
      required this.onUploadSuccess,
      this.onUploadStart,
      required this.removeImage,
      this.onUploadFail,
      this.emptyThumbIcon = CupertinoIcons.photo,
      this.borderRadius = 8})
      : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  bool _uploading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final File croppedFile = await ImageUtils.pickThenCropImage(source);
      setState(() => _uploading = true);
      await _uploadFile(croppedFile);
      setState(() => _uploading = false);
    } on PlatformException catch (e) {
      printLog(e.toString());
      context.showErrorAlert(e.toString());
    } on Exception catch (e) {
      printLog(e.toString());
      context.showToast(message: 'Image not selected');
    } finally {
      setState(() => _uploading = false);
    }
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

  void _resetState() => setState(() {
        _uploading = false;
      });

  @override
  Widget build(BuildContext context) {
    final Color primary = context.theme.primary;
    final Color cardBackground = context.theme.cardBackground;
    final bool hasImage = Utils.textNotNull(widget.imageUri);

    return GestureDetector(
      onTap: () => openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(items: [
            if (hasImage)
              BottomSheetMenuItem(
                  text: 'View image',
                  onPressed: () =>
                      openFullScreenImageViewer(context, widget.imageUri!)),
            BottomSheetMenuItem(
                text: hasImage ? 'Take new photo' : 'Take photo',
                onPressed: () => _pickImage(ImageSource.camera)),
            BottomSheetMenuItem(
                text: hasImage
                    ? 'Choose new from library'
                    : 'Choose from library',
                onPressed: () => _pickImage(ImageSource.gallery)),
            if (hasImage)
              BottomSheetMenuItem(
                  text: 'Remove',
                  isDestructive: true,
                  onPressed: () => context.showConfirmDeleteDialog(
                      itemType: 'Image',
                      verb: 'Remove',
                      onConfirm: () => widget.removeImage(widget.imageUri!)))
          ])),
      child: Container(
        width: widget.displaySize.width,
        height: widget.displaySize.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: cardBackground,
          boxShadow: kElevation[3],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _uploading
              ? LoadingCircle(
                  color: primary,
                )
              : hasImage
                  ? SizedUploadcareImage(widget.imageUri!)
                  : Icon(
                      widget.emptyThumbIcon,
                      size: widget.displaySize.width / 2.5,
                      color: primary.withOpacity(0.3),
                    ),
        ),
      ),
    );
  }
}
