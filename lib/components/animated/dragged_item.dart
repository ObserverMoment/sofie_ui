import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class DraggedItem extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  const DraggedItem({Key? key, required this.child, this.borderRadius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.015,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: context.theme.primary.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ]),
          child: child),
    );
  }
}
