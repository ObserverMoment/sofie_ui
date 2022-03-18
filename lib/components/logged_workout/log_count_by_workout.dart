import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class LogCountByWorkoutOverlayDisplay extends StatelessWidget {
  final int count;
  final double opacity;
  const LogCountByWorkoutOverlayDisplay(
      {Key? key, required this.count, this.opacity = 0.85})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
        child: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: context.theme.background.withOpacity(opacity)),
      child: Column(
        children: [
          MyText(
            count.displayLong,
            size: FONTSIZE.four,
          ),
          const MyText(
            'sessions',
            size: FONTSIZE.one,
          ),
        ],
      ),
    ));
  }
}

class LogCountByWorkoutTextDisplay extends StatelessWidget {
  final int count;
  const LogCountByWorkoutTextDisplay({Key? key, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.theme.background.withOpacity(0.2)),
      child: Column(
        children: [
          MyText(
            'Logged ${count.displayLong} times',
            size: FONTSIZE.four,
          ),
          const MyText(
            'worldwide',
            size: FONTSIZE.one,
          ),
        ],
      ),
    );
  }
}
