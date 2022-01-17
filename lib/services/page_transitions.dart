import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';

class PageTransitions {
  static Widget sharedAxisHorizontalTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SharedAxisTransition(
      child: child,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
    );
  }
}
