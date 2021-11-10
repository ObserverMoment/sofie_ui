import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class ShareObjectTypeSelectorButton extends StatelessWidget {
  final String title;
  final String description;
  final String assetImageUri;
  final VoidCallback onPressed;
  const ShareObjectTypeSelectorButton(
      {Key? key,
      required this.title,
      required this.description,
      required this.assetImageUri,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: 0.9,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: context.theme.cardBackground,
            borderRadius: BorderRadius.circular(80)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset(
                  assetImageUri,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyHeaderText(
                    title,
                    size: FONTSIZE.four,
                    lineHeight: 1.4,
                  ),
                  MyText(
                    description,
                    lineHeight: 1.4,
                    maxLines: 3,
                    size: FONTSIZE.two,
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(
                CupertinoIcons.chevron_right,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
