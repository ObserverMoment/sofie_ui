import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class LogAnalysisWidgetHeader extends StatelessWidget {
  final String heading;
  const LogAnalysisWidgetHeader({Key? key, required this.heading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 10, right: 8, top: 24),
      child: MyText(
        heading,
        size: FONTSIZE.four,
        weight: FontWeight.bold,
      ),
    );
  }
}
