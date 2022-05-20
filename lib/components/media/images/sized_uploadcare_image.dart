import 'package:flutter/cupertino.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

/// Light wrapper around Uploadcare image provider to get resized images from the CDN.
/// Use for thumbs and previews.
class SizedUploadcareImage extends StatelessWidget {
  final String imageUri;
  final Size? displaySize;
  final BoxFit fit;
  final Alignment alignment;
  const SizedUploadcareImage(this.imageUri,
      {Key? key,
      this.displaySize,
      this.fit = BoxFit.cover,
      this.alignment = Alignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Making the raw requested image larger than the display space - otherwise it seems to appear blurred. More investigation required.
    final Size size = displaySize ?? MediaQuery.of(context).size;
    final Dimensions dimensions =
        Dimensions((size.width * 1.5).toInt(), (size.height * 1.5).toInt());
    return Image(
        fit: fit,
        alignment: alignment,
        width: size.width,
        height: size.height,
        image: UploadcareImageProvider(imageUri,
            transformations: [PreviewTransformation(dimensions)]));
  }
}
