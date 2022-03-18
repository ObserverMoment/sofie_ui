import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class UploadcareFileUploadingProgress extends StatelessWidget {
  final bool isUploading;
  final bool isProcessing;
  final double progress;
  final double width;
  final CancelToken cancelToken;
  const UploadcareFileUploadingProgress(
      {Key? key,
      required this.isUploading,
      required this.isProcessing,
      required this.progress,
      required this.width,
      required this.cancelToken})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      borderRadius: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyText(
            isUploading ? 'UPLOADING' : 'PROCESSING',
            size: FONTSIZE.one,
          ),
          const SizedBox(
            width: 24,
          ),
          LinearProgressIndicator(
              progress: progress.clamp(0.0, 1.0), width: width),
          const SizedBox(
            width: 24,
          ),
          TextButton(
              padding: EdgeInsets.zero,
              text: 'Cancel',
              destructive: true,
              onPressed: () => cancelToken.cancel())
        ],
      ),
    );
  }
}
