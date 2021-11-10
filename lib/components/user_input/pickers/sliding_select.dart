import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class SlidingSelect<T> extends StatelessWidget {
  final T? value;
  final void Function(T value) updateValue;
  final Map<T, Widget> children;
  final EdgeInsets itemPadding;
  const SlidingSelect(
      {Key? key,
      required this.value,
      required this.updateValue,
      required this.children,
      this.itemPadding = const EdgeInsets.symmetric(vertical: 8)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedChildren =
        children.entries.fold<Map<T, Widget>>(<T, Widget>{}, (acum, next) {
      acum[next.key] = Padding(
        padding: itemPadding,
        child: next.value,
      );
      return acum;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: CupertinoSlidingSegmentedControl<T>(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          backgroundColor: context.theme.cardBackground,
          thumbColor: context.theme.background,
          groupValue: value,
          children: formattedChildren,
          onValueChanged: (v) {
            if (v != null) {
              updateValue(v);
            }
          }),
    );
  }
}
