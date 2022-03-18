import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';

class SummaryStatDisplay extends StatelessWidget {
  final String label;
  final int number;
  final Color? backgroundColor;
  const SummaryStatDisplay(
      {Key? key,
      required this.label,
      required this.number,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      backgroundColor: backgroundColor,
      child: Column(
        children: [
          MyText(
            number.toString(),
            size: FONTSIZE.five,
          ),
          MyText(
            label,
            size: FONTSIZE.one,
            subtext: true,
            lineHeight: 1.4,
          ),
        ],
      ),
    );
  }
}
