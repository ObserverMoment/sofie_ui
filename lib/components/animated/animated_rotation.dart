import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/constants.dart';

class MyAnimatedRotation extends StatefulWidget {
  final bool rotate;
  final Widget child;

  /// Rotates 180deg by default. (0.5 = 180deg)
  /// For anti-clockwise use -0.5.
  final double turns;
  const MyAnimatedRotation({
    Key? key,
    required this.rotate,
    required this.child,
    this.turns = 0.5,
  }) : super(key: key);
  @override
  State<MyAnimatedRotation> createState() => _MyAnimatedRotationState();
}

class _MyAnimatedRotationState extends State<MyAnimatedRotation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: kStandardAnimationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.turns).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut));
  }

  @override
  void didUpdateWidget(MyAnimatedRotation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rotate != oldWidget.rotate) {
      if (widget.rotate) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(turns: _animation, child: widget.child);
  }
}
