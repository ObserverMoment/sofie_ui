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
      angle: 0.01,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: context.theme.primary.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(1, 2), // changes position of shadow
                ),
              ]),
          child: child),
    );
  }
}
