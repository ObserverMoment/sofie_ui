import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class CategoryLinkTile extends StatelessWidget {
  final String label;
  final String assetImagePath;
  final VoidCallback onTap;
  final double tileHeight;
  const CategoryLinkTile(
      {Key? key,
      required this.label,
      required this.assetImagePath,
      required this.onTap,
      required this.tileHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: tileHeight - 8,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: context.theme.cardBackground.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/category_icons/$assetImagePath',
                  height: tileHeight * 0.5,
                  color: context.theme.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: MyText(
                      label,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      lineHeight: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
