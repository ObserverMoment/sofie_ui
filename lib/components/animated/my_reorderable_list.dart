import 'package:flutter/material.dart';
import 'package:sofie_ui/components/animated/dragged_item.dart';

class MyReorderableList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final Widget Function(Widget child, int index, Animation<double> animation)?
      proxyDecoratorBuilder;
  final void Function(int from, int to, List<T> reordered, T movedItem)
      reorderItems;
  final ScrollPhysics? physics;
  final BorderRadius? proxyDecoratorBorderRadius;
  final EdgeInsets listPadding;
  final EdgeInsets itemPadding;
  const MyReorderableList(
      {Key? key,
      required this.items,
      required this.itemBuilder,
      required this.reorderItems,
      this.physics = const AlwaysScrollableScrollPhysics(),
      this.proxyDecoratorBorderRadius,
      this.proxyDecoratorBuilder,
      this.itemPadding = const EdgeInsets.symmetric(vertical: 4),
      this.listPadding = EdgeInsets.zero})
      : super(key: key);

  @override
  State<MyReorderableList<T>> createState() => _MyReorderableListState<T>();
}

class _MyReorderableListState<T> extends State<MyReorderableList<T>> {
  late List<T> _items;

  @override
  void initState() {
    _items = List.from(widget.items);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyReorderableList<T> oldWidget) {
    _items = List.from(widget.items);
    super.didUpdateWidget(oldWidget);
  }

  void _handleReorder(int from, int to) {
    // https://api.flutter.dev/flutter/material/ReorderableListView-class.html
    // // Necessary because of how flutters reorderable list calculates drop position...I think.
    final moveTo = from < to ? to - 1 : to;
    final i = _items.removeAt(from);

    setState(() {
      _items.insert(moveTo, i);
    });

    widget.reorderItems(from, moveTo, _items, i);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        padding: widget.listPadding,
        physics: widget.physics,
        proxyDecorator: widget.proxyDecoratorBuilder ??
            (child, index, animation) => DraggedItem(
                  borderRadius: widget.proxyDecoratorBorderRadius,
                  child: child,
                ),
        shrinkWrap: true,
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final child = widget.itemBuilder(context, index, _items[index]);

          return Padding(
            key: child.key,
            padding: widget.itemPadding,
            child: child,
          );
        },
        onReorder: _handleReorder);
  }
}
