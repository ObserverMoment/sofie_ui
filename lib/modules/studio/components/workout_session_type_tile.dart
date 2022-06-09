import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class WorkoutSessionTypeTile extends StatelessWidget {
  final String label;
  final String assetImagePath;
  final VoidCallback onTap;
  final double tileHeight;
  const WorkoutSessionTypeTile(
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
      child: Container(
        decoration: BoxDecoration(
            color: context.theme.background,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/workout_session_icons/$assetImagePath',
              height: tileHeight - 75,
              color: context.theme.primary,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: MyText(
                label,
                textAlign: TextAlign.center,
                size: FONTSIZE.four,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
