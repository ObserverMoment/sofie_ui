import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/future_builder_handler.dart';
import 'package:sofie_ui/components/media/documents/pdf_viewer.dart';
import 'package:sofie_ui/components/media/images/image_viewer.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

enum _MediaType { audio, video, image, pdf }

const kMediaTypeExtensionMap = <_MediaType, List<String>>{
  _MediaType.audio: ['wav', 'aiff', 'alac', 'flac', 'mp3', 'aac', 'wma', 'ogg'],
  _MediaType.video: ['mp4', 'm4v', 'mov', 'mpg', 'webm'],
  _MediaType.image: ['jpg', 'jpeg', 'png', 'hiec', 'avif'],
  _MediaType.pdf: ['pdf'],
};

/// Based on an Uploadcare [uri] it retrives the URL and parses to get file type.
/// Then it opens the correct media viewer based on the type.
/// Currently (09.12.21) non PDF types are already getting the url for themselves. Not all types have been implemented yet.
class MultiMediaViewer extends StatefulWidget {
  final String? title;
  final String uri;
  const MultiMediaViewer({Key? key, required this.uri, this.title})
      : super(key: key);

  @override
  State<MultiMediaViewer> createState() => _MultiMediaViewerState();
}

class _MultiMediaViewerState extends State<MultiMediaViewer> {
  /// https://stackoverflow.com/questions/57793479/flutter-futurebuilder-gets-constantly-called
  late Future<_MediaType> _getDocumentTypeFuture;

  Future<_MediaType> _getDocumentType() async {
    final info = await UploadcareService().getFileInfo(widget.uri);

    final suffix = p.extension(info.filename).replaceAll(".", "");

    //// Will throw error if cannot find the file type extension.
    final type = kMediaTypeExtensionMap.entries
        .firstWhere((e) => e.value.contains(suffix));

    return type.key;
  }

  @override
  void initState() {
    super.initState();
    _getDocumentTypeFuture = _getDocumentType();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderHandler<_MediaType>(
        future: _getDocumentTypeFuture,
        builder: (type) {
          switch (type) {
            case _MediaType.audio:
              throw Exception('MultiMediaViewer: No builder defined for $type');
            case _MediaType.video:
              throw Exception('MultiMediaViewer: No builder defined for $type');
            case _MediaType.image:
              return FullScreenImageViewer(
                uri: widget.uri,
                title: widget.title,
              );
            case _MediaType.pdf:
              return PDFViewer(documentUri: widget.uri, title: widget.title);
            default:
              throw Exception('MultiMediaViewer: No builder defined for $type');
          }
        });
  }
}
