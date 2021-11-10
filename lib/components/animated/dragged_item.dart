import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class DraggedItem extends StatelessWidget {
  final Widget child;
  const DraggedItem({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: context.theme.background,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: context.theme.background.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(1, 3), // changes position of shadow
              ),
            ]),
        child: child);
  }
}
