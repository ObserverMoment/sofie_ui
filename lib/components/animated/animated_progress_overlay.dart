import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';

/// Will expand to cover its child as progress is made.
/// Height is always covered. The overlay emerges from left to right.
class AnimatedProgressOverlay extends StatefulWidget {
  final Widget child;
  final double percent;
  const AnimatedProgressOverlay(
      {Key? key, required this.child, required this.percent})
      : assert(percent >= 0.0 && percent <= 1.0),
        super(key: key);

  @override
  State<AnimatedProgressOverlay> createState() =>
      _AnimatedProgressOverlayState();
}

class _AnimatedProgressOverlayState extends State<AnimatedProgressOverlay> {
  final _containerKey = GlobalKey();
  double _containerWidth = 300;
  double _containerHeight = 20.0;
  late double _percent;

  @override
  void initState() {
    super.initState();
    _percent = widget.percent;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _containerWidth = _containerKey.currentContext?.size?.width ?? 0.0;
          _containerHeight = _containerKey.currentContext?.size?.height ?? 0.0;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      _percent = widget.percent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(key: _containerKey, child: widget.child),
        Container(
            height: _containerHeight,
            width: _containerWidth * _percent,
            color: Styles.primaryAccent.withOpacity(0.2))
      ],
    );
  }
}
