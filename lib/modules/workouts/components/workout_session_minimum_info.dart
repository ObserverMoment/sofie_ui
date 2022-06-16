import 'package:flutter/material.dart';
import 'package:sofie_ui/components/text.dart';

class WorkoutSessionMinimumInfo extends StatelessWidget {
  final String name;
  final IconData iconData;
  final String type;
  const WorkoutSessionMinimumInfo(
      {Key? key,
      required this.name,
      required this.iconData,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              iconData,
              size: 22,
            ),
            const SizedBox(width: 4),
            MyText(
              name,
              size: FONTSIZE.six,
              weight: FontWeight.bold,
            ),
          ],
        ),
        const SizedBox(height: 3),
        MyText(
          type.toUpperCase(),
          subtext: true,
        )
      ],
    );
  }
}
