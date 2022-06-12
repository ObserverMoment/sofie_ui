import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class InfoSection extends StatelessWidget {
  final String header;
  final IconData icon;
  final Widget content;
  const InfoSection(
      {Key? key,
      required this.header,
      required this.icon,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: context.theme.primary.withOpacity(0.2)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyHeaderText(
                  header,
                  weight: FontWeight.normal,
                  size: FONTSIZE.two,
                ),
                const SizedBox(width: 4),
                Icon(icon, size: 12),
              ],
            ),
          ),
          const SizedBox(height: 8),
          content,
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
