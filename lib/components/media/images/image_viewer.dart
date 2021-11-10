import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

/// Use for standard image viewing - no pan, scroll zoom.
class ImageViewer extends StatelessWidget {
  final String uri;
  final BoxFit fit;
  final Alignment alignment;
  final Size? displaySize;
  const ImageViewer(
      {Key? key,
      required this.uri,
      this.fit = BoxFit.contain,
      this.alignment = Alignment.center,
      this.displaySize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedUploadcareImage(
      uri,
      displaySize: displaySize ?? MediaQuery.of(context).size,
      fit: fit,
      alignment: alignment,
    );
  }
}

Future<void> openFullScreenImageViewer(
  BuildContext context,
  String uri, {
  Alignment alignment = Alignment.center,
  String? title,
}) async {
  await context.push(
    rootNavigator: true,
    child: FullScreenImageViewer(uri: uri, title: title),
    fullscreenDialog: true,
  );
}

/// Also has sharing button / functionality.
/// Hero animates the image from the previous route into place in the new one.
/// By default assumes file is coming from network.
/// Icludes pan, scroll, zoom functionality via [photo_view] package.
class FullScreenImageViewer extends StatelessWidget {
  final String uri;
  final String? title;
  const FullScreenImageViewer({
    Key? key,
    required this.uri,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: MyNavBar(
          middle: title != null ? NavBarTitle(title!) : null,
        ),
        child: PhotoView(
          loadingBuilder: (context, event) => Center(
            child: Opacity(
                opacity: 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      CupertinoIcons.photo,
                      size: 40,
                    ),
                    SizedBox(height: 12),
                    LoadingDots()
                  ],
                )),
          ),
          heroAttributes: const PhotoViewHeroAttributes(
            tag: kFullScreenImageViewerHeroTag,
          ),
          backgroundDecoration: BoxDecoration(color: context.theme.background),
          imageProvider: UploadcareImageProvider(uri),
        ));
  }
}
