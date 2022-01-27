import 'package:flutter/cupertino.dart';

/// Edited version of: https://www.youtube.com/watch?v=ojBSygkVaNo
/// https://github.com/Purvik/SwipeTo/blob/master/lib/src/SwipeTo.dart
/// SwipeToReply is a wrapper widget to other Widget that we can swipe right
/// to initiate a callback when animation gets end.
/// It is useful to develop WhatsApp kind of reply animation for a
/// component of ongoing chat.
class SwipeToReply extends StatefulWidget {
  /// Child widget for which you want to have horizontal swipe action
  /// @required parameter
  final Widget child;

  /// Duration value to define animation duration
  /// if not passed default Duration(milliseconds: 150) will be taken
  final Duration animationDuration;

  /// Icon that will be displayed beneath child widget when swipe right
  final IconData icon;

  /// double value defining size of displayed icon beneath child widget
  /// if not specified default size 26 will be taken
  final double iconSize;

  /// color value defining color of displayed icon beneath child widget
  ///if not specified primaryColor from theme will be taken
  final Color? iconColor;

  /// Double value till which position child widget will get animate when swipe left
  /// or swipe right
  /// if not specified 0.3 default will be taken for Right Swipe &
  /// it's negative -0.3 will bve taken for Left Swipe
  final double offsetDx;

  /// callback which will be initiated at the end of child widget animation
  /// when swiped right
  final VoidCallback onSwipe;

  const SwipeToReply({
    Key? key,
    required this.child,
    required this.onSwipe,
    this.icon = CupertinoIcons.reply,
    this.iconSize = 26.0,
    this.iconColor,
    this.animationDuration = const Duration(milliseconds: 150),
    this.offsetDx = 0.3,
  }) : super(key: key);

  @override
  _SwipeToReplyState createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _leftIconAnimation;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: _controller),
    );
    _leftIconAnimation = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.0),
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///Run animation for child widget
  ///[onRight] value defines animation Offset direction
  void _runAnimation() {
    //set child animation
    _animation = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(widget.offsetDx, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: _controller),
    );
    //set back left/right icon animation
    _leftIconAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: _controller),
    );

    //Forward animation
    _controller.forward().whenComplete(() {
      _controller.reverse().whenComplete(() {
        //keep left icon visibility to 0.0 until onRightSwipe triggers again
        _leftIconAnimation = _controller.drive(Tween(begin: 0.0, end: 0.0));
        widget.onSwipe();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 1) {
          _runAnimation();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _leftIconAnimation.value,
                duration: widget.animationDuration,
                curve: Curves.decelerate,
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: widget.iconColor,
                ),
              ),
            ],
          ),
          SlideTransition(
            position: _animation,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
