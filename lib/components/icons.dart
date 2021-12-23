import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class AwardIcon extends StatelessWidget {
  final double size;
  final Color color;
  const AwardIcon({Key? key, this.size = 24, this.color = Styles.primaryAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/graphics/award_icon.svg',
        width: size, color: color);
  }
}

class CompactTimerIcon extends StatelessWidget {
  final Duration? duration;

  /// Compact display = 03:56 for three mins 56 secs.
  /// Standard display would be 3 mins 56 seconds.
  final bool compactDisplay;
  const CompactTimerIcon(
      {Key? key, required this.duration, this.compactDisplay = false})
      : super(key: key);

  List<Widget> _buildChildren(String display) => [
        const Icon(
          CupertinoIcons.timer,
          size: 16,
        ),
        const SizedBox(width: 4),
        MyText(
          duration?.compactDisplay ?? '---',
          size: FONTSIZE.four,
        )
      ];

  @override
  Widget build(BuildContext context) {
    final display = duration == null
        ? '---'
        : compactDisplay
            ? duration!.compactDisplay
            : duration!.displayString;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(display),
    );
  }
}

class NumberRoundsIcon extends StatelessWidget {
  final int rounds;
  final Axis alignment;
  const NumberRoundsIcon(
      {Key? key, required this.rounds, this.alignment = Axis.horizontal})
      : super(key: key);

  List<Widget> _buildChildren() => [
        MyText(
          '$rounds',
          size: FONTSIZE.five,
        ),
        const SizedBox(
          width: 4,
        ),
        MyText(
          rounds == 1 ? 'round' : 'rounds',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(),
    );
  }
}

class NotesIcon extends StatelessWidget {
  final double? size;
  const NotesIcon({Key? key, this.size = 20}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Icon(
      CupertinoIcons.doc_text,
      size: size,
    );
  }
}

/// As used at the top of modal bottom sheet popups to indicate drag to dismiss.
class DragBarHandle extends StatelessWidget {
  const DragBarHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 6,
      decoration: BoxDecoration(
          color: context.theme.primary.withOpacity(0.23),
          borderRadius: BorderRadius.circular(18)),
    );
  }
}

enum JumpAmount { fifteen, thirty, fortyfive }

class JumpSeekIcon extends StatelessWidget {
  final bool forward;
  final JumpAmount amount;
  final double size;
  const JumpSeekIcon(
      {Key? key,
      this.forward = true,
      this.amount = JumpAmount.fifteen,
      this.size = 34})
      : super(key: key);

  Widget _forwardIcon() {
    switch (amount) {
      case JumpAmount.fifteen:
        return Icon(
          CupertinoIcons.goforward_15,
          size: size,
        );
      case JumpAmount.thirty:
        return Icon(
          CupertinoIcons.goforward_30,
          size: size,
        );
      case JumpAmount.fortyfive:
        return Icon(
          CupertinoIcons.goforward_45,
          size: size,
        );
      default:
        throw Exception('Invalid JumpAmount value');
    }
  }

  Widget _backwardIcon() {
    switch (amount) {
      case JumpAmount.fifteen:
        return Icon(
          CupertinoIcons.gobackward_15,
          size: size,
        );
      case JumpAmount.thirty:
        return Icon(
          CupertinoIcons.gobackward_30,
          size: size,
        );
      case JumpAmount.fortyfive:
        return Icon(
          CupertinoIcons.gobackward_45,
          size: size,
        );
      default:
        throw Exception('Invalid JumpAmount value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return forward ? _forwardIcon() : _backwardIcon();
  }
}

class NoResultsToDisplay extends StatelessWidget {
  final String message;
  const NoResultsToDisplay({Key? key, this.message = 'No results to display'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/placeholder_images/no-results-icon.svg',
          width: 90,
          color: context.theme.primary.withOpacity(0.3),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
          child: MyText(
            message,
            color: context.theme.primary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
