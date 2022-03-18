import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofie_ui/services/utils.dart';

class ImageUtils {
  static Future<File> pickThenCropImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) {
        throw Exception('No file selected.');
      }

      final File? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
      );
      if (croppedFile == null) {
        throw Exception('Cropping did not work.');
      }
      return croppedFile;
    } on PlatformException catch (e) {
      printLog(e.toString());
      rethrow;
    }
  }
}
