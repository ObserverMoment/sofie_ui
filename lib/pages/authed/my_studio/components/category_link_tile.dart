import 'dart:ui';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: context.theme.cardBackground.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/category_icons/$assetImagePath',
                  height: 40,
                  fit: BoxFit.cover,
                  color: context.theme.primary,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: MyText(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    size: FONTSIZE.two,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
