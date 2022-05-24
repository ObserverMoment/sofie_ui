import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class SubSectionLinkTile extends StatelessWidget {
  final String label;
  final String assetImagePath;
  final VoidCallback onTap;
  const SubSectionLinkTile(
      {Key? key,
      required this.label,
      required this.assetImagePath,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: context.theme.cardBackground,
                borderRadius: BorderRadius.circular(12)),
            child: SvgPicture.asset(
              'assets/category_icons/$assetImagePath',
              height: 44,
              fit: BoxFit.cover,
              color: context.theme.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: MyText(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              size: FONTSIZE.one,
            ),
          ),
        ],
      ),
    );
  }
}
