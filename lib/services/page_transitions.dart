import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';

//// Route Builders ////
class BottomSheetAnimateInPageRoute extends PageRouteBuilder {
  final Widget page;
  BottomSheetAnimateInPageRoute({
    required this.page,
  }) : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: PageTransitions.bottomSheetFadeSlideUp);
}

//// Page Transitions ////
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

  static Widget bottomSheetFadeSlideUp(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCirc),
        ),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInCirc)),
          child: child,
        ),
      );
}
