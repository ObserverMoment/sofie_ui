import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/media/images/utils.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

/// Displays an image (if it exists) - across the full width of the screen.
/// Vs the [ImageUploader] which displays the image and picker as a thumbnail.
/// Vs the [ImageUploader] there is no option to 'view' this image in the bottom sheet menu that opens on click.
/// On complete run [onUploadSuccess] so that we can save the uploaded file uri to the db.
class CoverImageUploader extends StatefulWidget {
  final String? imageUri;
  final double displayHeight;
  final void Function()? onUploadStart;
  final void Function(String uploadedUri) onUploadSuccess;
  final void Function(String uri) removeImage;
  const CoverImageUploader(
      {Key? key,
      this.imageUri,
      this.displayHeight = 160.0,
      required this.onUploadSuccess,
      this.onUploadStart,
      required this.removeImage})
      : super(key: key);

  @override
  _CoverImageUploaderState createState() => _CoverImageUploaderState();
}

class _CoverImageUploaderState extends State<CoverImageUploader> {
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
        onFail: (e) => throw Exception(e));
  }

  void _resetState() => setState(() {
        _uploading = false;
      });

  @override
  Widget build(BuildContext context) {
    final Color primary = context.theme.primary;
    final bool hasImage = Utils.textNotNull(widget.imageUri);

    return GestureDetector(
      onTap: () => openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(items: [
            BottomSheetMenuItem(
              text: hasImage ? 'Take new photo' : 'Take photo',
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            BottomSheetMenuItem(
              text:
                  hasImage ? 'Choose new from library' : 'Choose from library',
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            if (hasImage)
              BottomSheetMenuItem(
                text: 'Remove image',
                isDestructive: true,
                onPressed: () {
                  context.showConfirmDeleteDialog(
                      itemType: 'Image',
                      onConfirm: () => widget.removeImage(widget.imageUri!));
                },
              ),
          ])),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: widget.displayHeight,
            child: ContentBox(
              padding: EdgeInsets.zero,
              child: AnimatedSwitcher(
                duration: kStandardAnimationDuration,
                child: _uploading
                    ? Center(child: LoadingCircle(color: primary))
                    : hasImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedUploadcareImage(widget.imageUri!))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.photo,
                                    size: 40,
                                    color: primary.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 8),
                                  const MyText(
                                    'Add cover image',
                                    size: FONTSIZE.two,
                                    subtext: true,
                                  )
                                ],
                              ),
                            ],
                          ),
              ),
            ),
          ),
          if (hasImage)
            const Positioned(
                top: 8,
                right: 8,
                child: ContentBox(child: Icon(CupertinoIcons.pencil)))
        ],
      ),
    );
  }
}
