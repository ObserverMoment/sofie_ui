import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class CategoryLinkTile extends StatelessWidget {
  final String label;
  final String assetImagePath;
  final VoidCallback onTap;
  const CategoryLinkTile(
      {Key? key,
      required this.label,
      required this.assetImagePath,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: context.theme.cardBackground.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/category_icons/$assetImagePath',
              height: 44,
              fit: BoxFit.cover,
              color: context.theme.primary,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
              child: MyHeaderText(
                label,
                weight: FontWeight.normal,
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
