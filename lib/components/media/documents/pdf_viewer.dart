import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Viewer for PDF files hosted on Uploadcare server.
class PDFViewer extends StatelessWidget {
  final String? title;
  final String documentUri;
  const PDFViewer({Key? key, required this.documentUri, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = UploadcareService.getFileUrl(documentUri);

    if (url == null) {
      return const CupertinoPageScaffold(
        navigationBar: MyNavBar(
          middle: NavBarTitle('Oops'),
        ),
        child: Center(
          child: MyText('Sorry, something went wrong!', color: Styles.errorRed),
        ),
      );
    }
    return CupertinoPageScaffold(
        navigationBar: MyNavBar(
          middle: NavBarTitle(title ?? 'View Document'),
        ),
        child: SfTheme(
            data: SfThemeData(
                pdfViewerThemeData: SfPdfViewerThemeData(
                    brightness: context.theme.brightness,
                    progressBarColor: Styles.primaryAccent,
                    backgroundColor: context.theme.background)),
            child: SfPdfViewer.network(url)));
  }
}
