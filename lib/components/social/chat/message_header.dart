import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class MessageHeader extends StatelessWidget {
  final String rawTimeStamp;
  const MessageHeader({Key? key, required this.rawTimeStamp}) : super(key: key);

  Widget _buildHeaderText(String text) => ContentBox(
        borderRadius: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: MyText(
          text,
          subtext: true,
          size: FONTSIZE.one,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final receivedAt = DateTime.parse(rawTimeStamp);

    return receivedAt.isToday
        ? _buildHeaderText('Today')
        : receivedAt.isYesterday
            ? _buildHeaderText('Yesterday')
            : _buildHeaderText(
                receivedAt.compactDateString,
              );
  }
}
