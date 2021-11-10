import 'package:flutter/cupertino.dart';

class LandscapeVideoRotatingPageRoute extends PageRouteBuilder {
  final Widget page;

  /// Defaults to a bit above center - where most landscape videos are by default.
  /// i.e. at the top of the screen.
  final Offset slideOffset;
  LandscapeVideoRotatingPageRoute({
    required this.page,
    this.slideOffset = const Offset(0, -0.21),
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(begin: slideOffset, end: const Offset(0, 0))
                .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.5,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                ),
                child: RotationTransition(
                  turns: Tween<double>(
                    begin: -0.25,
                    end: 0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: child,
                )),
          ),
        );
}

class PortraitVideoEmergingPageRoute extends PageRouteBuilder {
  final Widget page;
  final Offset slideOffset;
  PortraitVideoEmergingPageRoute({
    required this.page,
    this.slideOffset = const Offset(0, 0),
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(begin: slideOffset, end: const Offset(0, 0))
                .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.2,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                ),
                child: FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.3,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: child,
                )),
          ),
        );
}
